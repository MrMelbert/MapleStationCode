// -- Bridge Officer job & outfit datum --
/datum/job/asset_protection
	title = "Asset Protection"
	auto_deadmin_role_flags = DEADMIN_POSITION_HEAD
	department_head = list("Captain")
	faction = FACTION_STATION
	total_positions = 1
	spawn_positions = 1
	supervisors = "the heads of staff and the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	minimal_player_age = 10
	exp_requirements = 180
	exp_type = EXP_TYPE_CREW
	exp_type_department = EXP_TYPE_COMMAND

	outfit = /datum/outfit/job/asset_protection
	plasmaman_outfit = /datum/outfit/plasmaman/head_of_security

	paycheck = PAYCHECK_COMMAND
	paycheck_department = ACCOUNT_SEC
	bounty_types = CIV_JOB_SEC

	liver_traits = list(TRAIT_PRETENDER_ROYAL_METABOLISM) // QM normally has this, but since they're a head of staff now I put it here. C'est la vie.

	display_order = JOB_DISPLAY_ORDER_ASSET_PROTECTION
	departments = DEPARTMENT_COMMAND

	family_heirlooms = list(/obj/item/book/manual/wiki/security_space_law)

	mail_goodies = list(
		/obj/item/food/donut/choco = 10,
		/obj/item/food/donut/apple = 10,
		/obj/item/food/donut/blumpkin = 5,
		/obj/item/food/donut/caramel = 5,
		/obj/item/food/donut/berry = 5,
		/obj/item/food/donut/matcha = 5,
		/obj/item/storage/fancy/donut_box = 1,
		/obj/item/melee/baton/boomerang/loaded = 1
	)

	job_flags = JOB_ANNOUNCE_ARRIVAL | JOB_CREW_MANIFEST | JOB_EQUIP_RANK | JOB_CREW_MEMBER | JOB_NEW_PLAYER_JOINABLE
	voice_of_god_power = 1.1 // Not quite command staff.

/datum/outfit/job/asset_protection
	name = "Asset Protection"
	jobtype = /datum/job/asset_protection

	id = /obj/item/card/id/advanced/silver
	belt = /obj/item/pda/heads/asset_protection
	ears = /obj/item/radio/headset/heads/asset_protection/alt
	glasses = /obj/item/clothing/glasses/hud/security/sunglasses
	neck = /obj/item/clothing/neck/tie/black
	gloves = /obj/item/clothing/gloves/color/black
	uniform = /obj/item/clothing/under/rank/security/officer/blueshirt/asset_protection
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/armor/vest/asset_protection
	suit_store = /obj/item/gun/energy/disabler
	id_trim = /datum/id_trim/job/asset_protection
	box = /obj/item/storage/box/survival/security

	implants = list(/obj/item/implant/mindshield)

/datum/outfit/job/asset_protection/pre_equip(mob/living/carbon/human/H)
	..()
	// If the map we're on doesn't have a brige officer locker, add in a way to get one
	if(!GLOB.asset_protection_lockers.len)
		LAZYADD(backpack_contents, /obj/item/asset_protection_locker_spawner)

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
