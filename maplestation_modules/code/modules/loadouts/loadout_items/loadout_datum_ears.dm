// --- Loadout item datums for ears ---

/// Ear Slot Items (Moves overrided items to backpack)
/datum/loadout_category/ears
	category_name = "Ears"
	type_to_generate = /datum/loadout_item/ears
	tab_order = 2

/datum/loadout_item/ears
	abstract_type = /datum/loadout_item/ears

/datum/loadout_item/ears/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	if(outfit.ears)
		LAZYADD(outfit.backpack_contents, outfit.ears)
	outfit.ears = item_path

/datum/loadout_item/ears/headphones
	name = "Headphones"
	item_path = /obj/item/instrument/piano_synth/headphones

/datum/loadout_item/ears/earmuffs
	name = "Earmuffs"
	item_path = /obj/item/clothing/ears/earmuffs
