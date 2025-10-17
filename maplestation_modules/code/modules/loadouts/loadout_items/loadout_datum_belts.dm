// --- Loadout item datums for belts ---

/// Belt Slot Items (Moves overrided items to backpack)
/datum/loadout_category/belts
	category_name = "Belt"
	type_to_generate = /datum/loadout_item/belts
	tab_order = 10

/datum/loadout_item/belts
	abstract_type = /datum/loadout_item/belts

/datum/loadout_item/belts/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	if(!outfit.belt)
		outfit.belt = item_path
		return
	// try to move the existing belt to the backpack
	var/obj/item/move_belt = outfit.belt
	if(outfit.l_hand && outfit.r_hand && initial(move_belt.w_class) <= WEIGHT_CLASS_NORMAL)
		LAZYADD(outfit.backpack_contents, outfit.belt)
		outfit.belt = item_path
		return
	// try to carry the existing belt in a hand
	if(!outfit.l_hand)
		outfit.l_hand = outfit.belt
		outfit.belt = item_path
		return
	if(!outfit.r_hand)
		outfit.r_hand = outfit.belt
		outfit.belt = item_path
		return
	// failed to put it on, put it in the backpack
	if(initial(item_path.w_class) <= WEIGHT_CLASS_NORMAL)
		LAZYADD(outfit.backpack_contents, item_path)
		return
	to_chat(equipper, span_notice("Your loadout belt was not equipped to preserve your job's equipment."))

/datum/loadout_item/belts/fanny_pack_black
	name = "Fannypack (Black)"
	item_path = /obj/item/storage/belt/fannypack/black

/datum/loadout_item/belts/fanny_pack_blue
	name = "Fannypack (Blue)"
	item_path = /obj/item/storage/belt/fannypack/blue

/datum/loadout_item/belts/fanny_pack_brown
	name = "Fannypack (Brown)"
	item_path = /obj/item/storage/belt/fannypack

/datum/loadout_item/belts/fanny_pack_cyan
	name = "Fannypack (Cyan)"
	item_path = /obj/item/storage/belt/fannypack/cyan

/datum/loadout_item/belts/fanny_pack_green
	name = "Fannypack (Green)"
	item_path = /obj/item/storage/belt/fannypack/green

/datum/loadout_item/belts/fanny_pack_orange
	name = "Fannypack (Orange)"
	item_path = /obj/item/storage/belt/fannypack/orange

/datum/loadout_item/belts/fanny_pack_pink
	name = "Fannypack (Pink)"
	item_path = /obj/item/storage/belt/fannypack/pink

/datum/loadout_item/belts/fanny_pack_purple
	name = "Fannypack (Purple)"
	item_path = /obj/item/storage/belt/fannypack/purple

/datum/loadout_item/belts/fanny_pack_red
	name = "Fannypack (Red)"
	item_path = /obj/item/storage/belt/fannypack/red

/datum/loadout_item/belts/fanny_pack_yellow
	name = "Fannypack (Yellow)"
	item_path = /obj/item/storage/belt/fannypack/yellow

/datum/loadout_item/belts/fanny_pack_white
	name = "Fannypack (White)"
	item_path = /obj/item/storage/belt/fannypack/white

/datum/loadout_item/belts/lantern
	name = "Lantern"
	item_path = /obj/item/flashlight/lantern

/datum/loadout_item/belts/candle_box
	name = "Candle Box"
	item_path = /obj/item/storage/fancy/candle_box
