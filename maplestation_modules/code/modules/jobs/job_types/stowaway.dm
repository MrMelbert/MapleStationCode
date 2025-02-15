/datum/job/stowaway
	title = "Stowaway"
	description = "You've snuck on board, and now you're stuck here. \
		You spawn randomly in the maintenance tunnels, with no radio, no PDA, \
		no bank account, and no records in the crew database."
	rpg_title = "Stowaway" // TES4: Oblivion
	paycheck = PAYCHECK_ZERO
	total_positions = 0
	spawn_positions = 1
	supervisors = "no one"
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "STOWAWAY"
	faction = FACTION_STATION

	outfit = /datum/outfit/job/stowaway
	plasmaman_outfit = /datum/outfit/job/stowaway/plasmaman

	paycheck = PAYCHECK_ZERO

	display_order = JOB_DISPLAY_ORDER_PRISONER + 0.1

	department_for_prefs = /datum/job_department/assistant

	job_flags = JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_ASSIGN_QUIRKS | JOB_NEW_PLAYER_JOINABLE | JOB_CANNOT_OPEN_SLOTS
	allow_bureaucratic_error = FALSE
	random_spawns_possible = FALSE

/datum/job/stowaway/get_default_roundstart_spawn_point()
	return find_maintenance_spawn(atmos_sensitive = TRUE, require_darkness = FALSE)

/datum/job/stowaway/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/datum/status_effect/backstory/backstory = spawned.apply_status_effect(/datum/status_effect/backstory)
	var/backstory_ref = "<a href='?src=[REF(backstory)];backstory=1'>click here</a>"
	to_chat(player_client, examine_block("\
		[span_boldnotice("You find yourself stown away in [get_area_name(spawned)] on [station_name()].")]\n\
		[span_notice("All you have to your name is the clothes on your back, some tools, and a small amount of cash.")]\n\
		[span_notice("The crew has no record of your existence.")]\n\
		[span_notice("(If you would like to be provided an optional, random backstory, with more or less equipment: [backstory_ref].)")]\
	"))

// Applied to fresh stowaways to give them an option of getting a random backstory
/datum/status_effect/backstory
	id = "stowaway_backstory"
	alert_type = /atom/movable/screen/alert/status_effect/backstory
	duration = 5 MINUTES
	tick_interval = -1

/datum/status_effect/backstory/Topic(href, list/href_list)
	. = ..()
	if(href_list["backstory"])
		give_backstory()

/datum/status_effect/backstory/proc/give_backstory()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		return

	var/backstory_gist
	var/backstory_suggested_goal
	var/backstory_equipment
	var/list/backstory_equipment_items

	var/mob/living/carbon/human/stowaway = owner
	switch(rand(1, 7))
		if(1)
			backstory_gist = "You are a stowaway, who snuck on board to escape your old life. \
				You're not sure what to do now, but you're sure you'll think of something."
			backstory_suggested_goal = "Find a new life on board the station."

		if(2)
			backstory_gist = "You are a station reclamation agent, working for Nanotrasen, left behind mistakenly after the last crew departed. \
				All you want is to get back off this station."
			backstory_suggested_goal = "Get off the station, preferably without being detained."
			backstory_equipment_items = list(
				/obj/item/storage/belt/utility = ITEM_SLOT_BELT,
				/obj/item/clothing/gloves/color/yellow = ITEM_SLOT_BACKPACK,
			)
			backstory_equipment = "A toolbelt and some insulated gloves."

		if(3)
			var/old_boss = pick_list(COMPANY_FILE, "bad_companies")
			backstory_gist = "You are an ex-syndicate agent, employed by the [old_boss], who failed your last task and ended up marooned on this station. \
				You're not sure what to do now, but you're sure you'll think of something."
			backstory_suggested_goal = "Finish your last objective, or give up your old life and start anew - maybe on the station itself."
			backstory_equipment_items = list(
				/obj/item/clothing/gloves/combat = ITEM_SLOT_BACKPACK,
				/obj/item/clothing/mask/gas/syndicate = ITEM_SLOT_BACKPACK,
				(stowaway.jumpsuit_style == PREF_SKIRT ? /obj/item/clothing/under/syndicate/skirt : /obj/item/clothing/under/syndicate) = ITEM_SLOT_BACKPACK,
			)
			backstory_equipment = "A syndicate turtleneck and mask, and some insulated combat gloves."

		if(4)
			var/old_boss = pick_list(COMPANY_FILE, "good_companies")
			backstory_gist = "You used to work for [old_boss], but you were fired on the job, and have ended up marooned on this station. \
				You're not sure what to do now, but you're sure you'll think of something."
			backstory_suggested_goal = "Give up your old life and start anew - maybe on the station itself, or attempt to reconcile with [old_boss]."

		if(5)
			var/datum/job/old_job = pick(SSjob.joinable_occupations)
			var/reasons = pick("who was fired", "who had their station decomissioned")
			backstory_gist = "You are a former [old_job.title], [reasons]. You've snuck on board to get your old position back."
			backstory_suggested_goal = "Get your job as [old_job.title] back, and prove yourself - or find a new calling."

			var/datum/outfit/job/job_outfit = old_job.outfit
			backstory_equipment_items = list(
				initial(job_outfit.uniform) = ITEM_SLOT_BACKPACK,
				initial(job_outfit.head) = ITEM_SLOT_BACKPACK,
				initial(job_outfit.shoes) = ITEM_SLOT_BACKPACK,
			)
			list_clear_nulls(backstory_equipment_items) // if the job doesn't have a head/shoes/whatever, don't spawn it
			backstory_equipment = "Your old uniform."

		if(6)
			backstory_gist = "You woke up randomly in the maintenance tunnels, with no memory of who you are or how you got here."
			backstory_suggested_goal = "Figure out who you are, and why you're here... or start anew."

		if(7)
			backstory_gist = "You got in trouble with [pick("the law", "the criminal underworld", "the syndicate", "the corporation you worked for", "the corporation you worked against")], and had to flee. \
				You've snuck on board to escape your old life."
			backstory_suggested_goal = "Find a new life on board the station."


	var/final_info = "<b>[backstory_gist]</b>\n\n[backstory_suggested_goal]"
	if(length(backstory_equipment_items) && backstory_equipment)
		final_info += span_notice("\n\nAdditional equipment: [backstory_equipment]")

	to_chat(owner, examine_block(span_infoplain(final_info)))

	for(var/thing in backstory_equipment_items)
		owner.equip_to_slot_if_possible(new thing(owner.loc), backstory_equipment_items[thing], disable_warning = TRUE, redraw_mob = FALSE, initial = TRUE)

	qdel(src)

// Screen alert for the above effect
/atom/movable/screen/alert/status_effect/backstory
	name = "Optional: Stowaway Backstory"
	desc = "Not sure what to do? Click here for a random backstory and some extra equipment. \
		This will go away shortly, so don't worry if you don't want it."
	icon_state = "surrender"
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/alert/status_effect/backstory/Click(location, control, params)
	. = ..()
	if(!.)
		return
	var/datum/status_effect/backstory/backstory = attached_effect
	backstory.give_backstory()

// The stowaway outfit, assistant but poorer
/datum/outfit/job/stowaway
	name = "Stowaway"
	jobtype = /datum/job/stowaway

	id = /obj/item/card/id/maint_tech
	uniform = /obj/item/clothing/under/color/black
	l_hand = /obj/item/storage/toolbox/mechanical/old/multitool
	ears = null
	belt = null

	backpack_contents = list(
		/obj/item/flashlight = 1,
		/obj/item/radio = 1,
		/obj/item/stack/spacecash/c100 = 1,
	)

/datum/outfit/job/stowaway/post_equip(mob/living/carbon/human/equipped, visualsOnly)
	. = ..()
	if(visualsOnly)
		return
	var/obj/item/card/id/id = equipped.wear_id?.GetID()
	if(istype(id))
		id.registered_age = rand(25, 65)
		id.registered_name = ""
		id.update_label()

	var/obj/item/clothing/under/clothes = equipped.w_uniform
	if(istype(clothes))
		clothes.sensor_mode = SENSOR_OFF
		clothes.has_sensor = BROKEN_SENSORS
		equipped.update_suit_sensors()

/datum/outfit/job/stowaway/plasmaman
	uniform = /obj/item/clothing/under/plasmaman
	gloves = /obj/item/clothing/gloves/color/plasmaman
	head = /obj/item/clothing/head/helmet/space/plasmaman
	r_hand = /obj/item/tank/internals/plasmaman/belt/full
	internals_slot = ITEM_SLOT_HANDS

// ID card stowaways spawn with
/obj/item/card/id/maint_tech
	name = "Maintenance Technician ID"
	desc = "An old ID card once given to poorly paid technicians."
	trim = /datum/id_trim/maintenance_technician
	icon_state = "retro"

// ID trim for the stolen ID card
/datum/id_trim/maintenance_technician
	access = list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS)
	assignment = "Maintenance Technician"
	trim_state = "trim_stationengineer" // for posterity, doesn't show anyways
	department_color = COLOR_ASSISTANT_GRAY

// Old toolbox subtype that spawns with a multitool
/obj/item/storage/toolbox/mechanical/old/multitool

/obj/item/storage/toolbox/mechanical/old/multitool/PopulateContents()
	. = ..()
	new /obj/item/multitool(src)
