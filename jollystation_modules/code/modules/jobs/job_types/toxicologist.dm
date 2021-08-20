// -- Toxicologist job & outfit datum --
/datum/job/toxicologist
	title = "Toxicologist"
	department_head = list("Research Director")
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#ffeeff"
	exp_requirements = 60
	exp_required_type = EXP_TYPE_CREW
	exp_granted_type = EXP_TYPE_CREW

//most likely can be subtyped later

	outfit = /datum/outfit/job/scientist/toxicologist
	plasmaman_outfit = /datum/outfit/plasmaman/science

	paycheck = PAYCHECK_MEDIUM
	paycheck_department = ACCOUNT_SCI

	display_order = JOB_DISPLAY_ORDER_SCIENTIST
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

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS

/datum/outfit/job/scientist/toxicologist
	name = "Toxicologist"
	suit = /obj/item/clothing/suit/toggle/labcoat/toxic
	uniform = /obj/item/clothing/under/rank/rnd/toxicologist
	belt = /obj/item/pda/toxins/toxocologist
	jobtype = /datum/job/toxicologist
	id_trim = /datum/id_trim/job/toxicologist
