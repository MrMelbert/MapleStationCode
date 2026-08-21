/datum/loadout_category/back
	category_name = "Back"
	type_to_generate = /datum/loadout_item/back
	tab_order = 10

/datum/loadout_item/back
	abstract_type = /datum/loadout_item/back

/datum/loadout_item/back/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	if(!outfit.replace_backpack_keep_old(item_path))
		to_chat(equipper, span_notice("Your loadout back was not equipped to preserve your job's equipment."))

/datum/loadout_item/back/pack
	abstract_type = /datum/loadout_item/back/pack

/datum/loadout_item/back/pack/get_item_information()
	. = ..()
	.[FA_ICON_BOXES_PACKING] = "Main storage"

/datum/loadout_item/back/pack/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	// If we have a backpack, we can replace it with our own backpack
	if(outfit.is_wearing_backpack() || outfit.replace_backpack_keep_old(item_path))
		outfit.back = get_backpack(outfit)
		return
	// Otherwise if there was something in the way, let them know
	if(outfit.back)
		to_chat(equipper, span_notice("Your loadout backpack was not equipped to preserve your job's equipment."))

/datum/loadout_item/back/pack/proc/get_backpack(datum/outfit/outfit)
	return item_path

/datum/loadout_item/back/pack/grey_backpack
	name = "Grey Backpack"
	item_path = /obj/item/storage/backpack

/datum/loadout_item/back/pack/grey_satchel
	name = "Grey Satchel"
	item_path = /obj/item/storage/backpack/satchel

/datum/loadout_item/back/pack/grey_duffelbag
	name = "Grey Duffelbag"
	item_path = /obj/item/storage/backpack/duffelbag

/datum/loadout_item/back/pack/grey_messengerbag
	name = "Grey Messenger Bag"
	item_path = /obj/item/storage/backpack/messenger

/datum/loadout_item/back/pack/leather_satchel
	name = "Leather Satchel"
	item_path = /obj/item/storage/backpack/satchel/leather

/datum/loadout_item/back/pack/department_backpack
	name = "Department Backpack"
	item_path = /obj/item/storage/backpack/medic

/datum/loadout_item/back/pack/department_backpack/get_backpack(datum/outfit/outfit)
	return astype(outfit, /datum/outfit/job)?.backpack || /datum/outfit/job::backpack

/datum/loadout_item/back/pack/department_satchel
	name = "Department Satchel"
	item_path = /obj/item/storage/backpack/satchel/med

/datum/loadout_item/back/pack/department_satchel/get_backpack(datum/outfit/outfit)
	return astype(outfit, /datum/outfit/job)?.satchel || /datum/outfit/job::satchel

/datum/loadout_item/back/pack/department_duffelbag
	name = "Department Duffelbag"
	item_path = /obj/item/storage/backpack/duffelbag/med

/datum/loadout_item/back/pack/department_duffelbag/get_backpack(datum/outfit/outfit)
	return astype(outfit, /datum/outfit/job)?.duffelbag || /datum/outfit/job::duffelbag

/datum/loadout_item/back/pack/department_messengerbag
	name = "Department Messenger Bag"
	item_path = /obj/item/storage/backpack/messenger/med

/datum/loadout_item/back/pack/department_messengerbag/get_backpack(datum/outfit/outfit)
	return astype(outfit, /datum/outfit/job)?.messenger || /datum/outfit/job::messenger

/datum/loadout_item/back/pack/alt
	name = "Tan Backpack"
	item_path = /obj/item/storage/backpack/alt

/datum/loadout_item/back/pack/alt/white
	name = "White Backpack"
	item_path = /obj/item/storage/backpack/alt/white

/datum/loadout_item/back/pack/alt/black
	name = "Black Backpack"
	item_path = /obj/item/storage/backpack/alt/black
