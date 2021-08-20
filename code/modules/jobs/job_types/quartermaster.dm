/datum/job/quartermaster
	title = "Quartermaster"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD // NON-MODULE CHANGE
	department_head = list("Captain") // NON-MODULE CHANGE
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	req_admin_notify = TRUE // NON-MODULE CHANGE
	supervisors = "the captain" // NON-MODULE CHANGE
	selection_color = "#d7b088"
	exp_type_department = EXP_TYPE_SUPPLY // This is so the jobs menu can work properly
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/quartermaster
	plasmaman_outfit = /datum/outfit/plasmaman/cargo

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_CAR

	liver_traits = list(TRAIT_ROYAL_METABOLISM) // NON-MODULE CHANGE

	display_order = JOB_DISPLAY_ORDER_QUARTERMASTER
	bounty_types = CIV_JOB_RANDOM
	departments_list = list(
		/datum/job_department/cargo,
		/datum/job_department/command,
		)
	family_heirlooms = list(/obj/item/stamp, /obj/item/stamp/denied)
	mail_goodies = list(
		/obj/item/circuitboard/machine/emitter = 3
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_REOPEN_ON_ROUNDSTART_LOSS

	voice_of_god_power = 1.4 // NON-MODULE CHANGE: Command staff


/datum/job/quartermaster/get_captaincy_announcement(mob/living/captain) // NON-MODULE CHANGE
	return "Due to staffing shortages, newly promoted Acting Captain [captain.real_name] on deck!"

/datum/outfit/job/quartermaster
	name = "Quartermaster"
	jobtype = /datum/job/quartermaster

	id = /obj/item/card/id/advanced/silver // NON-MODULE CHANGE
	belt = /obj/item/pda/quartermaster
	ears = /obj/item/radio/headset/heads/headset_qm // NON-MODULE CHANGE
	uniform = /obj/item/clothing/under/rank/cargo/qm
	shoes = /obj/item/clothing/shoes/sneakers/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/clipboard
	backpack_contents = list(/obj/item/modular_computer/tablet/preset/advanced/command/cargo=1, /obj/item/melee/classic_baton/telescopic=1) // NON-MODULE CHANGE

	chameleon_extras = /obj/item/stamp/qm

	id_trim = /datum/id_trim/job/quartermaster
