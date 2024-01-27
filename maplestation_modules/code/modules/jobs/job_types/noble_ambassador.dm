//The noble ambassador!
/datum/job/noble_ambassador
	title = "Noble Ambassador"
	description = "Represent the interests of the Aristocracy of Mu on the station. \
		Ensure the wellbeing of the crew, and make sure they're being treated well by their superiors."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_CAPTAIN)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain and the Aristocracy"
	// selection_color = "#ddddff"
	req_admin_notify = TRUE
	minimal_player_age = 10
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW
	config_tag = "NOBLE_AMBASSADOR"

	outfit = /datum/outfit/job/noble_ambassador
	plasmaman_outfit = /datum/outfit/plasmaman // no outfit yet

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC
	bounty_types = CIV_JOB_SEC

	liver_traits = list(TRAIT_ROYAL_METABOLISM) // The most royal of all metabolism!

	display_order = JOB_DISPLAY_ORDER_NOBLE_AMBASSADOR
	departments_list = list(
		/datum/job_department/command,
		/datum/job_department/service,
		)

	family_heirlooms = list(/obj/item/toy/plush/finster_fumo)

	mail_goodies = list(
		/obj/item/toy/plush/finster_fumo,
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_BOLD_SELECT_TEXT | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	voice_of_god_power = 1.4 // Captain-level VoG.
	rpg_title = "Noble"

/datum/outfit/job/noble_ambassador
	name = "Noble Ambassador"
	jobtype = /datum/job/noble_ambassador

	id = /obj/item/card/id/advanced/silver/mu
	belt = /obj/item/modular_computer/pda/heads/noble_ambassador
	ears = /obj/item/radio/headset/heads/noble_ambassador
	gloves = /obj/item/clothing/gloves/noble
	uniform = /obj/item/clothing/under/rank/noble
	suit = /obj/item/clothing/suit/toggle/noble
	head = /obj/item/clothing/head/costume/crown/noble
	shoes = /obj/item/clothing/shoes/noble
	id_trim = /datum/id_trim/job/noble_ambassador

/datum/outfit/job/noble_ambassador/pre_equip(mob/living/carbon/human/H)
	..()
	// If there's no ambassador locker, give a spawner for one
	if(!(locate(/obj/effect/landmark/locker_spawner/noble_ambassador_equipment) in GLOB.locker_landmarks)) //todo: add in the mapped-in wardrobe version
		LAZYADD(backpack_contents, /obj/item/locker_spawner/noble_ambassador)
