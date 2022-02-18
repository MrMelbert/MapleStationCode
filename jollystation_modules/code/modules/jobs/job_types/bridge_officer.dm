// -- Bridge Officer job & outfit datum --
/datum/job/bridge_officer
	title = "Bridge Officer"
	description = "File paperwork to Central Command via your fax machine. \
		Pretend to be a head of staff. Fetch coffee for the real heads of staff instead."
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list(JOB_CAPTAIN)
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the heads of staff and the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_required_type = EXP_TYPE_CREW
	exp_required_type_department = EXP_TYPE_COMMAND
	exp_granted_type = EXP_TYPE_CREW

	outfit = /datum/outfit/job/bridge_officer
	plasmaman_outfit = /datum/outfit/plasmaman/head_of_personnel

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SRV
	bounty_types = CIV_JOB_RANDOM

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM) // QM normally has this, but since they're a head of staff now I put it here. C'est la vie.

	display_order = JOB_DISPLAY_ORDER_BRIDGE_OFFICER
	departments_list = list(
		/datum/job_department/command,
		)

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)

	mail_goodies = list(
		/obj/item/food/donut/choco = 10,
		/obj/item/food/donut/apple = 10,
		/obj/item/reagent_containers/food/drinks/coffee = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/food/donut/caramel = 5,
		/obj/item/food/donut/berry = 5,
		/obj/item/food/donut/matcha = 5,
		/obj/item/storage/fancy/cigarettes/cigars/havana = 5,
		/obj/item/clothing/mask/whistle = 5,
		/obj/item/reagent_containers/food/drinks/mug/tea = 5,
		/obj/item/reagent_containers/food/drinks/mug/coco = 1,
		/obj/item/storage/box/office_supplies = 1,
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE | JOB_REOPEN_ON_ROUNDSTART_LOSS | JOB_ASSIGN_QUIRKS | JOB_CAN_BE_INTERN
	rpg_title = "Guildperson"

/datum/outfit/job/bridge_officer
	name = "Bridge Officer"
	jobtype = /datum/job/bridge_officer

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/pda/heads/bridge_officer
	ears = /obj/item/radio/headset/heads/bridge_officer
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/color/white
	uniform = /obj/item/clothing/under/rank/security/bridge_officer/black
	shoes = /obj/item/clothing/shoes/laceup
	head = /obj/item/clothing/head/beret/black/bridge_officer
	id_trim = /datum/id_trim/job/bridge_officer
	box = /obj/item/storage/box/survival

	backpack_contents = list(/obj/item/melee/baton/telescopic = 1, /obj/item/modular_computer/tablet/preset/advanced/command = 1, /obj/item/gun/energy/disabler = 1)

/datum/outfit/job/bridge_officer/pre_equip(mob/living/carbon/human/H)
	..()
	// If the map we're on doesn't have a brige officer locker, add in a way to get one
	if(!(locate(/obj/effect/landmark/locker_spawner/bridge_officer_equipment) in GLOB.locker_landmarks))
		LAZYADD(backpack_contents, /obj/item/locker_spawner/bridge_officer)


	// 0.1% chance on spawn to be given a meme flash in place of a real one.
	if(r_pocket)
		if(prob(0.1))
			backpack_contents += /obj/item/assembly/flash/memorizer
		else
			backpack_contents += /obj/item/assembly/flash
	else
		if(prob(0.1))
			r_pocket = /obj/item/assembly/flash/memorizer
		else
			r_pocket = /obj/item/assembly/flash
