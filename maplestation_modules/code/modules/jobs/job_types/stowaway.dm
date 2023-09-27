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
	departments_list = list(/datum/job_department/assistant)

	job_flags = JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_ASSIGN_QUIRKS | JOB_NEW_PLAYER_JOINABLE
	allow_bureaucratic_error = FALSE
	random_spawns_possible = FALSE

/datum/job/stowaway/get_default_roundstart_spawn_point()
	return find_maintenance_spawn(atmos_sensitive = TRUE)

/datum/job/stowaway/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	to_chat(player_client, examine_block("\
		[span_boldnotice("You find stown away in [get_area_name(spawned, TRUE)] on [station_name()].")]\n\
		[span_notice("All you have to your name is the clothes on your back, some tools, and a small amount of cash.")]\n\
		[span_notice("The crew has no record of your existence.")]\
	"))

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

/obj/item/card/id/maint_tech
	name = "Maintenance Technician ID"
	desc = "An old ID card once given to poorly paid technicians."
	trim = /datum/id_trim/maintenance_technician
	icon_state = "retro"

/datum/id_trim/maintenance_technician
	access = list(ACCESS_EXTERNAL_AIRLOCKS, ACCESS_MAINT_TUNNELS)
	assignment = "Maintenance Technician"
	trim_state = "trim_stationengineer" // for posterity, doesn't show anyways
	department_color = COLOR_ASSISTANT_GRAY

/obj/item/storage/toolbox/mechanical/old/multitool

/obj/item/storage/toolbox/mechanical/old/multitool/PopulateContents()
	. = ..()
	new /obj/item/multitool(src)
