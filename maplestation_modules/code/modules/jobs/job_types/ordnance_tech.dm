// -- Ordnance Tech job & outfit datum --
/datum/job/ordnance_tech
	title = "Ordnance Technician"
	description = "Complete your bomb in the first half hour of the \
		shift, make the station shake repeatedly as you refine cores, \
		then sit around as you have nothing else to do."
	department_head = list(JOB_RESEARCH_DIRECTOR)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

//most likely can be subtyped later

	outfit = /datum/outfit/job/scientist/ordnance_tech
	plasmaman_outfit = /datum/outfit/plasmaman/science

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_ORDNANCE_TECH
	bounty_types = CIV_JOB_SCI

	family_heirlooms = list(/obj/item/toy/nuke)

	mail_goodies = list(
		/obj/item/analyzer = 50,
		/obj/item/raw_anomaly_core/random = 15,
		/obj/item/hot_potato/harmless/toy = 10,
		/obj/item/tank/internals/plasma = 5,
		/obj/item/tank/internals/oxygen = 5,
		/obj/item/toy/nuke = 5,
		/obj/item/transfer_valve = 1,
	)

	departments_list = list(
		/datum/job_department/science,
		)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Dwarven Miner"

/datum/outfit/job/scientist/ordnance_tech
	name = "Ordnance Technician"
	suit = /obj/item/clothing/suit/toggle/labcoat/toxic
	uniform = /obj/item/clothing/under/rank/rnd/ordnance_tech
	belt = /obj/item/pda/science/toxocologist
	jobtype = /datum/job/ordnance_tech
	id_trim = /datum/id_trim/job/ordnance_tech
