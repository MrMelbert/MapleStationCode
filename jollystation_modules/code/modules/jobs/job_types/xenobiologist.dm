// -- Xenobiologist job & outfit datum --
/datum/job/xenobiologist
	title = "Xenobiologist"
	description = "Feed slimes all shift, never exit xenobiology for any reason. \
		Leave after two hours as an unkillable god with an army of monsters."
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/scientist/xenobiologist
	plasmaman_outfit = /datum/outfit/plasmaman/science

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_XENOBIOLOGIST
	bounty_types = CIV_JOB_SCI

	family_heirlooms = list(/obj/item/toy/plush/slimeplushie)

	mail_goodies = list(
		/obj/item/toy/plush/slimeplushie = 25,
		/obj/item/reagent_containers/glass/beaker/bluespace = 20,
		/obj/item/slimepotion/slime/sentience = 15,
		/obj/item/slimepotion/slime/docility = 15,
		/obj/item/slimepotion/slime/steroid = 10,
		/obj/item/slime_extract/yellow = 10,
		/obj/item/slime_extract/darkblue = 10,
		/obj/item/reagent_containers/syringe/bluespace = 5,
		/obj/item/slime_extract/green = 5,
		/obj/item/slime_extract/bluespace = 1,
		/obj/item/slime_extract/adamantine = 1,
		/obj/item/slime_extract/oil = 1
	)

	departments_list = list(
		/datum/job_department/science,
		)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Beast Tamer"

/datum/outfit/job/scientist/xenobiologist
	name = "Xenobiologist"
	suit = /obj/item/clothing/suit/toggle/labcoat/xenobio
	uniform = /obj/item/clothing/under/rank/rnd/xenobiologist
	belt = /obj/item/pda/science/xenobiologist
	jobtype = /datum/job/xenobiologist
	id_trim = /datum/id_trim/job/xenobiologist
