/obj/structure/desk_bell/ringer
	name = "pager"
	desc = "A bell that messages all members of a department when rung."
	icon = 'maplestation_modules/icons/obj/machines/bureaucracy.dmi'
	icon_state = "pager_bell"
	ring_cooldown_length = 1 SECONDS
	ring_sound = 'sound/machines/ding_short.ogg'
	verb_say = "beeps"
	anchored = TRUE
	can_deconstruct = FALSE
	can_tie_to_chair = FALSE
	/// Prefix for the name of the ringer
	var/dept_name = "some"
	/// What department we are pinging
	var/target_department
	/// List of job names that we ping
	var/list/target_job_names = list()
	/// Whether we are actively paging
	VAR_FINAL/actively_paging = FALSE
	/// REF to the last mob who notified us
	VAR_FINAL/last_notified
	/// How long is the paging window
	var/page_length = 30 SECONDS
	/// Tracks what area we were spawned in
	/// Used so people can't unanchor a pager to hide it somewhere to annoy everyone
	var/area/spawn_area

/obj/structure/desk_bell/ringer/Initialize(mapload)
	. = ..()
	name = "[dept_name] [name]"
	if(isnull(target_department))
		return
	for(var/datum/job/job_type as anything in SSjob.joinable_occupations)
		if(job_type.departments_list?[1] == target_department)
			target_job_names += job_type.title

	if(mapload)
		var/area/my_area = get_area(src)
		spawn_area = my_area?.type

/obj/structure/desk_bell/ringer/wrench_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE
	switch(default_unfasten_wrench(user, tool, 0.5 SECONDS))
		if(SUCCESSFUL_UNFASTEN)
			pixel_x = 0
			pixel_y = 0
			return ITEM_INTERACT_SUCCESS
		if(CANT_UNFASTEN, FAILED_UNFASTEN)
			return ITEM_INTERACT_BLOCKING
	return NONE

/obj/structure/desk_bell/ringer/mouse_drop_dragged(atom/over_object, mob/user)
	if(!isliving(user) || anchored)
		return
	if(iswallturf(over_object))
		var/new_x = 0
		var/new_y = 0
		var/dir_to_drag = get_dir(src, over_object)
		if(dir_to_drag & NORTH)
			new_y = 32
		if(dir_to_drag & SOUTH)
			new_y = -32
		if(dir_to_drag & EAST)
			new_x = 32
		if(dir_to_drag & WEST)
			new_x = -32
		pixel_x = new_x
		pixel_y = new_y
		playsound(src, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		loc.balloon_alert(usr, "attached to wall")
		set_anchored(TRUE)
		return

	if(istype(over_object, /obj/structure/table))
		forceMove(get_turf(over_object))
		return

/obj/structure/desk_bell/ringer/proc/get_department_messengers()
	var/list/department_pdas = list()
	for(var/messenger_ref in GLOB.pda_messengers)
		var/datum/computer_file/program/messenger/message_app = GLOB.pda_messengers[messenger_ref]
		if(!message_app || message_app.invisible || !message_app.sending_and_receiving)
			continue
		if(message_app.computer?.saved_job in target_job_names)
			department_pdas += message_app
	return department_pdas

/obj/structure/desk_bell/ringer/check_clapper(mob/living/user)
	return

/obj/structure/desk_bell/ringer/attack_ai(mob/user)
	page(user)

/obj/structure/desk_bell/ringer/ring_bell(mob/living/user)
	. = ..()
	if(!.)
		return

	page(user)

/obj/structure/desk_bell/ringer/proc/page(mob/living/user)
	if(actively_paging || !anchored)
		return

	if(spawn_area)
		var/area/my_area = get_area(src)
		if(my_area?.type != spawn_area)
			say("Out of range.")
			playsound(src, 'sound/machines/buzz-sigh.ogg', 33, FALSE)
			return

	actively_paging = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_page)), page_length, TIMER_DELETE_ME)

	var/list/department_pdas = get_department_messengers()
	if(!length(department_pdas))
		say("No employees available.")
		playsound(src, 'sound/machines/buzz-sigh.ogg', 33, FALSE)
		return

	var/notify_href = "(<a href='byond://?src=[REF(src)];notify=1;request_time=[world.time]'>Notify</a>)"

	var/datum/signal/subspace/messaging/tablet_message/signal = new(src, list(
		"fakename" = "Pager Alert",
		"fakejob" = "Desk",
		"automated" = TRUE,
		"message" = "Someone's presence is requested at the front desk. [notify_href]",
		"targets" = department_pdas,
	))
	signal.send_to_receivers()
	say("Paging [dept_name]...")
	playsound(src, 'sound/machines/ping.ogg', 33, FALSE)

/obj/structure/desk_bell/ringer/proc/reset_page()
	if(!last_notified)
		say("No response.")

	actively_paging = FALSE
	last_notified = null
	// Put the ring on a slightly longer cooldown to prevent pda spam
	COOLDOWN_START(src, ring_cooldown, ring_cooldown_length * 2)

/obj/structure/desk_bell/ringer/Topic(href, list/href_list)
	. = ..()
	if(href_list["notify"])
		var/time_diff = world.time - text2num(href_list["request_time"])
		if(time_diff > page_length || !actively_paging)
			return
		var/mob/living/notifier = usr
		var/obj/item/modular_computer/pda/their_pda = locate() in notifier // Just check for pockets and ID slot
		if(isnull(their_pda) || notifier.incapacitated() || !notifier.can_perform_action(their_pda))
			return
		var/datum/computer_file/program/messenger/their_app = locate() in their_pda.stored_files
		var/list/department_pdas = get_department_messengers()
		if(isnull(their_app) || !(their_app in department_pdas))
			return
		var/notifier_ref = REF(notifier)
		if(last_notified)
			to_chat(notifier, span_warning("[notifier_ref == last_notified ? "You" : "Someone else"] already responded to that page."))
			return
		last_notified = notifier_ref

		var/first_responder = their_pda.saved_identification || "Someone"
		department_pdas -= their_app
		if(length(department_pdas))
			var/datum/signal/subspace/messaging/tablet_message/signal = new(src, list(
				"fakename" = "Pager Alert",
				"fakejob" = "Desk",
				"automated" = TRUE,
				"message" = "[first_responder] is responding to the front desk.",
				"targets" = department_pdas,
			))
			signal.send_to_receivers()

		say("[first_responder]'s on their way!") // no p_their i guess
		to_chat(notifier, span_notice("You respond to the page, relaying to whomever sent it and your coworkers that you're on your way."))
		playsound(their_pda, 'sound/machines/terminal_success.ogg', 33, TRUE)
		playsound(src, 'sound/machines/terminal_success.ogg', 33, TRUE)

/obj/structure/desk_bell/ringer/botany
	dept_name = "hydroponics department"
	target_job_names = list(JOB_HEAD_OF_PERSONNEL, JOB_BOTANIST)

/obj/structure/desk_bell/ringer/chemistry
	dept_name = "pharmacy"
	target_job_names = list(JOB_CHIEF_MEDICAL_OFFICER, JOB_CHEMIST)

/obj/structure/desk_bell/ringer/coroner
	dept_name = "coroner"
	target_job_names = list(JOB_CHIEF_MEDICAL_OFFICER, JOB_CORONER)

/obj/structure/desk_bell/ringer/psych
	dept_name = "psychologist"
	target_job_names = list(JOB_CHIEF_MEDICAL_OFFICER, JOB_HEAD_OF_PERSONNEL, JOB_PSYCHOLOGIST)

/obj/structure/desk_bell/ringer/chapel
	dept_name = "chaplain"
	target_job_names = list(JOB_HEAD_OF_PERSONNEL, JOB_CHAPLAIN)

/obj/structure/desk_bell/ringer/medical
	dept_name = "medical department"
	target_department = /datum/job_department/medical

/obj/structure/desk_bell/ringer/atmospherics
	dept_name = "atmospherics department"
	target_job_names = list(JOB_CHIEF_ENGINEER, JOB_ATMOSPHERIC_TECHNICIAN)

/obj/structure/desk_bell/ringer/engineering
	dept_name = "engineering department"
	target_department = /datum/job_department/engineering

/obj/structure/desk_bell/ringer/robotics
	dept_name = "robotics department"
	target_job_names = list(JOB_RESEARCH_DIRECTOR, JOB_ROBOTICIST)

/obj/structure/desk_bell/ringer/genetics
	dept_name = "genetics department"
	target_job_names = list(JOB_RESEARCH_DIRECTOR, JOB_GENETICIST)

/obj/structure/desk_bell/ringer/xenobio
	dept_name = "xenobiology department"
	target_job_names = list(JOB_RESEARCH_DIRECTOR, "Xenobiologist")

/obj/structure/desk_bell/ringer/science
	dept_name = "science department"
	target_department = /datum/job_department/science

/obj/structure/desk_bell/ringer/warden
	dept_name = "warden"
	target_job_names = list(JOB_HEAD_OF_SECURITY, JOB_WARDEN)

/obj/structure/desk_bell/ringer/detective
	dept_name = "detective"
	target_job_names = list(JOB_HEAD_OF_SECURITY, JOB_DETECTIVE)

/obj/structure/desk_bell/ringer/security
	dept_name = "security department"
	target_job_names = list(JOB_CAPTAIN)
	target_department = /datum/job_department/security

/obj/structure/desk_bell/ringer/hop
	dept_name = "head of personnel"
	target_job_names = list(JOB_HEAD_OF_PERSONNEL)

/obj/structure/desk_bell/ringer/mining
	dept_name = "mining department"
	target_job_names = list(JOB_QUARTERMASTER, JOB_SHAFT_MINER, JOB_BITRUNNER)

/obj/structure/desk_bell/ringer/cargo
	dept_name = "cargo department"
	target_department = /datum/job_department/cargo

/obj/structure/desk_bell/ringer/bartender
	dept_name = "bartender"
	target_job_names = list(JOB_BARTENDER)

/obj/structure/desk_bell/ringer/chef
	dept_name = "chef"
	target_job_names = list(JOB_CHEF)

// In the off-chance that there's an actual, accessible service counter where the protolathe is
/obj/structure/desk_bell/ringer/service
	dept_name = "service department"
	target_department = /datum/job_department/service
