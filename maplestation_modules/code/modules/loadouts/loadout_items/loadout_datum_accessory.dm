// --- Loadout item datums for accessories ---

#define ADJUSTABLE_TOOLTIP "LAYER ADJUSTABLE - You can opt to have accessory above or below your suit."

/// Accessory Items (Moves overrided items to backpack)
GLOBAL_LIST_INIT(loadout_accessory, generate_loadout_items(/datum/loadout_item/accessory))

/datum/loadout_item/accessory
	category = LOADOUT_ITEM_ACCESSORY
	// Can we adjust this accessory to be above or below suits?
	var/can_be_layer_adjusted = FALSE

/datum/loadout_item/accessory/New()
	. = ..()
	var/obj/item/clothing/accessory/accessory = item_path
	if(!ispath(accessory))
		return

	can_be_layer_adjusted = TRUE
	add_tooltip(ADJUSTABLE_TOOLTIP, inverse_order = TRUE)

/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.accessory)
		LAZYADD(outfit.backpack_contents, outfit.accessory)
	outfit.accessory = item_path

/datum/loadout_item/accessory/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only = FALSE)
	. = ..()
	var/obj/item/clothing/accessory/equipped_item = .
	var/obj/item/clothing/under/suit = equipper.w_uniform
	if(!istype(equipped_item))
		return

	var/list/our_loadout = preference_source.read_preference(/datum/preference/loadout)
	if(can_be_layer_adjusted && (INFO_LAYER in our_loadout[item_path]))
		equipped_item.above_suit = our_loadout[item_path][INFO_LAYER]

	if(!istype(suit))
		return

	// Hacky, but accessory will ONLY update when attached or detached.
	equipped_item.detach(suit)
	suit.attach_accessory(equipped_item)

/datum/loadout_item/accessory/maid_apron
	name = "Maid Apron"
	item_path = /obj/item/clothing/accessory/maidapron

/datum/loadout_item/accessory/waistcoat
	name = "Waistcoat"
	item_path = /obj/item/clothing/accessory/waistcoat

/datum/loadout_item/accessory/pocket_protector
	name = "Pocket Protector"
	item_path = /obj/item/clothing/accessory/pocketprotector

/datum/loadout_item/accessory/full_pocket_protector
	name = "Pocket Protector (Filled)"
	item_path = /obj/item/clothing/accessory/pocketprotector/full
	additional_tooltip_contents = list("CONTAINS PENS - This item contains multiple pens on spawn.")

/datum/loadout_item/accessory/ribbon
	name = "Ribbon"
	item_path = /obj/item/clothing/accessory/medal/ribbon

/datum/loadout_item/accessory/blue_green_armband
	name = "Blue and Green Armband"
	item_path = /obj/item/clothing/accessory/armband/hydro_cosmetic

/datum/loadout_item/accessory/brown_armband
	name = "Brown Armband"
	item_path = /obj/item/clothing/accessory/armband/cargo_cosmetic

/datum/loadout_item/accessory/green_armband
	name = "Green Armband"
	item_path = /obj/item/clothing/accessory/armband/service_cosmetic

/datum/loadout_item/accessory/purple_armband
	name = "Purple Armband"
	item_path = /obj/item/clothing/accessory/armband/science_cosmetic

/datum/loadout_item/accessory/red_armband
	name = "Red Armband"
	item_path = /obj/item/clothing/accessory/armband/deputy_cosmetic

/datum/loadout_item/accessory/yellow_armband
	name = "Yellow Reflective Armband"
	item_path = /obj/item/clothing/accessory/armband/engine_cosmetic

/datum/loadout_item/accessory/white_armband
	name = "White Armband"
	item_path = /obj/item/clothing/accessory/armband/med_cosmetic

/datum/loadout_item/accessory/white_blue_armband
	name = "White and Blue Armband"
	item_path = /obj/item/clothing/accessory/armband/medblue_cosmetic

/datum/loadout_item/accessory/dogtags
	name = "Name-Inscribed Dogtags"
	item_path = /obj/item/clothing/accessory/cosmetic_dogtag
	additional_tooltip_contents = list("MATCHES NAME - The name inscribed on this item matches your character's name on spawn.")

/datum/loadout_item/accessory/bone_charm
	name = "Heirloom Bone Talismin"
	item_path = /obj/item/clothing/accessory/armorless_talisman
	additional_tooltip_contents = list(TOOLTIP_NO_ARMOR)

/datum/loadout_item/accessory/bone_codpiece
	name = "Heirloom Skull Codpiece"
	item_path = /obj/item/clothing/accessory/armorless_skullcodpiece
	additional_tooltip_contents = list(TOOLTIP_NO_ARMOR)

/datum/loadout_item/accessory/pride
	name = "Pride Pin"
	item_path = /obj/item/clothing/accessory/pride
	can_be_reskinned = TRUE

#undef ADJUSTABLE_TOOLTIP
