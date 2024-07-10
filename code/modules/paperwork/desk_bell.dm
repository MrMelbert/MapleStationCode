// A receptionist's bell

/obj/structure/desk_bell
	name = "desk bell"
	desc = "The cornerstone of any customer service job. You feel an unending urge to ring it."
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "desk_bell"
	layer = OBJ_LAYER
	anchored = FALSE
	pass_flags = PASSTABLE // Able to place on tables
	max_integrity = 5000 // To make attacking it not instantly break it
	/// The amount of times this bell has been rang, used to check the chance it breaks
	var/times_rang = 0
	/// Is this bell broken?
	var/broken_ringer = FALSE
	/// The cooldown for ringing the bell
	COOLDOWN_DECLARE(ring_cooldown)
	/// The length of the cooldown. Setting it to 0 will skip all cooldowns alltogether.
	var/ring_cooldown_length = 0.3 SECONDS // This is here to protect against tinnitus.
	/// The sound the bell makes
	var/ring_sound = 'sound/machines/microwave/microwave-end.ogg'

/obj/structure/desk_bell/Initialize(mapload)
	. = ..()
	register_context()

/obj/structure/desk_bell/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = ..()

	if(held_item?.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_RMB] = "Disassemble"
		return CONTEXTUAL_SCREENTIP_SET

	if(broken_ringer)
		if(held_item?.tool_behaviour == TOOL_SCREWDRIVER)
			context[SCREENTIP_CONTEXT_LMB] = "Fix"
	else
		var/click_context = "Ring"
		if(prob(1))
			click_context = "Annoy"
		context[SCREENTIP_CONTEXT_LMB] = click_context
	return CONTEXTUAL_SCREENTIP_SET

/obj/structure/desk_bell/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(!COOLDOWN_FINISHED(src, ring_cooldown) && ring_cooldown_length)
		return TRUE
	if(!ring_bell(user))
		to_chat(user, span_notice("[src] is silent. Some idiot broke it."))
	if(ring_cooldown_length)
		COOLDOWN_START(src, ring_cooldown, ring_cooldown_length)
	return TRUE

/obj/structure/desk_bell/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/desk_bell/attackby(obj/item/weapon, mob/living/user, params)
	. = ..()
	times_rang += weapon.force
	ring_bell(user)

// Fix the clapper
/obj/structure/desk_bell/screwdriver_act(mob/living/user, obj/item/tool)
	if(broken_ringer)
		balloon_alert(user, "repairing...")
		tool.play_tool_sound(src)
		if(tool.use_tool(src, user, 5 SECONDS))
			balloon_alert_to_viewers("repaired")
			playsound(user, 'sound/items/change_drill.ogg', 50, vary = TRUE)
			broken_ringer = FALSE
			times_rang = 0
			return ITEM_INTERACT_SUCCESS
		return FALSE
	return ..()

// Deconstruct
/obj/structure/desk_bell/wrench_act_secondary(mob/living/user, obj/item/tool)
	balloon_alert(user, "taking apart...")
	tool.play_tool_sound(src)
	if(tool.use_tool(src, user, 5 SECONDS))
		balloon_alert(user, "disassembled")
		playsound(user, 'sound/items/deconstruct.ogg', 50, vary = TRUE)
		if(!broken_ringer) // Drop 2 if it's not broken.
			new/obj/item/stack/sheet/iron(drop_location())
		new/obj/item/stack/sheet/iron(drop_location())
		qdel(src)
		return ITEM_INTERACT_SUCCESS
	return ..()

/// Check if the clapper breaks, and if it does, break it
/obj/structure/desk_bell/proc/check_clapper(mob/living/user)
	if(((times_rang >= 10000) || prob(times_rang/100)) && ring_cooldown_length)
		to_chat(user, span_notice("You hear [src]'s clapper fall off of its hinge. Nice job, you broke it."))
		broken_ringer = TRUE

/// Ring the bell
/obj/structure/desk_bell/proc/ring_bell(mob/living/user)
	if(broken_ringer)
		return FALSE
	check_clapper(user)
	// The lack of varying is intentional. The only variance occurs on the strike the bell breaks.
	playsound(src, ring_sound, 70, vary = broken_ringer, extrarange = SHORT_RANGE_SOUND_EXTRARANGE)
	flick("desk_bell_ring", src)
	times_rang++
	return TRUE

// A warning to all who enter; the ringing sound STACKS. It won't be deafening because it only goes every decisecond,
// but I did feel like my ears were going to start bleeding when I tested it with my autoclicker.
/obj/structure/desk_bell/speed_demon
	desc = "The cornerstone of any customer service job. This one's been modified for hyper-performance."
	ring_cooldown_length = 0

/obj/structure/desk_bell/MouseDrop(obj/over_object, src_location, over_location)
	if(!istype(over_object, /obj/vehicle/ridden/wheelchair))
		return
	if(!Adjacent(over_object) || !Adjacent(usr))
		return
	var/obj/vehicle/ridden/wheelchair/target = over_object
	if(target.bell_attached)
		usr.balloon_alert(usr, "already has a bell!")
		return
	usr.balloon_alert(usr, "attaching bell...")
	if(!do_after(usr, 0.5 SECONDS))
		return
	target.attach_bell(src)
	return ..()

/obj/structure/desk_bell/ringer
	name = "pager"
	desc = "A bell that messages all members of a department when rung."
	ring_cooldown_length = 1 SECONDS
	ring_sound = 'sound/machines/ding_short.ogg'
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

/obj/structure/desk_bell/ringer/Initialize(mapload)
	. = ..()
	name = "[dept_name] [name]"
	if(isnull(target_department))
		return
	for(var/datum/job/job_type as anything in SSjob.joinable_occupations)
		if(job_type.departments_list?[1] == target_department)
			target_job_names += job_type.title

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

/obj/structure/desk_bell/ringer/ring_bell(mob/living/user)
	. = ..()
	if(!.)
		return

	if(actively_paging)
		return

	actively_paging = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_page)), page_length, TIMER_DELETE_ME)

	var/list/department_pdas = get_department_messengers()
	if(!length(department_pdas))
		say("No employees to ring.")
		return

	var/notify_href = "(<a href='byond://?src=[REF(src)];notify=1;request_time=[world.time]'>Notify</a>)"

	var/datum/signal/subspace/messaging/tablet_message/signal = new(src, list(
		"fakename" = "Pager Alert",
		"automated" = TRUE,
		"message" = "Someone's pressence is requested at the front desk. [notify_href]",
		"targets" = department_pdas,
	))
	signal.send_to_receivers()
	say("Paging [dept_name]...")

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
			to_chat(notifier, span_warning("[notifier_ref == last_notified ? "You" : "Someone else"] already responded to the page."))
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

		say("[first_responder]'s on their way!")
		to_chat(notifier, span_notice("You respond to the page, letting whomever sent it and your coworkers know you're on your way."))

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
