/// Accessory Items (Moves overrided items to backpack)
/datum/loadout_category/accessories
	category_name = "Accessory"
	type_to_generate = /datum/loadout_item/accessory
	tab_order = 9

/datum/loadout_item/accessory
	abstract_type = /datum/loadout_item/accessory
	group = "Other"
	/// Can we adjust this accessory to be above or below suits?
	VAR_FINAL/can_be_layer_adjusted = FALSE

/datum/loadout_item/accessory/New()
	. = ..()
	if(ispath(item_path, /obj/item/clothing/accessory))
		can_be_layer_adjusted = TRUE

/datum/loadout_item/accessory/get_ui_buttons()
	if(!can_be_layer_adjusted)
		return ..()

	var/list/buttons = ..()

	UNTYPED_LIST_ADD(buttons, list(
		"label" = "Layer",
		"act_key" = "set_layer",
		"active_key" = INFO_LAYER,
		"active_text" = "Above Suit",
		"inactive_text" = "Below Suit",
	))

	return buttons

/datum/loadout_item/accessory/handle_loadout_action(datum/preference_middleware/loadout/manager, mob/user, action, params)
	if(action == "set_layer")
		return set_accessory_layer(manager, user)

	return ..()

/datum/loadout_item/accessory/proc/set_accessory_layer(datum/preference_middleware/loadout/manager, mob/user)
	if(!can_be_layer_adjusted)
		return FALSE

	var/list/loadout = get_active_loadout(manager.preferences)
	if(!loadout?[item_path])
		return FALSE

	if(isnull(loadout[item_path][INFO_LAYER]))
		loadout[item_path][INFO_LAYER] = FALSE

	loadout[item_path][INFO_LAYER] = !loadout[item_path][INFO_LAYER]
	update_loadout(manager.preferences, loadout)
	return TRUE // Update UI

/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	if(outfit.accessory)
		LAZYADD(outfit.backpack_contents, outfit.accessory)
	outfit.accessory = item_path

/datum/loadout_item/accessory/on_equip_item(obj/item/equipped_item, list/item_details, mob/living/carbon/human/equipper, datum/outfit/job/outfit, visuals_only = FALSE)
	. = ..()
	if(isnull(equipped_item))
		return .
	var/obj/item/clothing/accessory/accessory_item = equipped_item
	accessory_item.above_suit = !!item_details[INFO_LAYER]
	return . | ITEM_SLOT_OCLOTHING | ITEM_SLOT_ICLOTHING


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

/datum/loadout_item/accessory/ribbon
	name = "Ribbon"
	item_path = /obj/item/clothing/accessory/medal/ribbon

/datum/loadout_item/accessory/armband
	abstract_type = /datum/loadout_item/accessory/armband
	group = "Armbands"

/datum/loadout_item/accessory/armband/blue_green
	name = "Armband (Blue and Green)"
	item_path = /obj/item/clothing/accessory/armband/hydro_cosmetic

/datum/loadout_item/accessory/armband/brown
	name = "Armband (Brown)"
	item_path = /obj/item/clothing/accessory/armband/cargo_cosmetic

/datum/loadout_item/accessory/armband/green
	name = "Armband (Green)"
	item_path = /obj/item/clothing/accessory/armband/service_cosmetic

/datum/loadout_item/accessory/armband/purple
	name = "Armband (Purple)"
	item_path = /obj/item/clothing/accessory/armband/science_cosmetic

/datum/loadout_item/accessory/armband/red
	name = "Armband (Red)"
	item_path = /obj/item/clothing/accessory/armband/deputy_cosmetic

/datum/loadout_item/accessory/armband/yellow
	name = "Armband (Yellow, Reflective)"
	item_path = /obj/item/clothing/accessory/armband/engine_cosmetic

/datum/loadout_item/accessory/armband/white
	name = "Armband (White)"
	item_path = /obj/item/clothing/accessory/armband/med_cosmetic

/datum/loadout_item/accessory/armband/white_blue
	name = "Armband (White and Blue)"
	item_path = /obj/item/clothing/accessory/armband/medblue_cosmetic

/datum/loadout_item/accessory/dogtags
	name = "Name-Inscribed Dogtags"
	item_path = /obj/item/clothing/accessory/dogtag/name
	loadout_flags = LOADOUT_FLAG_ALLOW_HEIRLOOM

/datum/loadout_item/accessory/bone_charm
	name = "Heirloom Bone Talismin"
	item_path = /obj/item/clothing/accessory/armorless_talisman
	loadout_flags = LOADOUT_FLAG_ALLOW_HEIRLOOM

/datum/loadout_item/accessory/bone_charm/get_item_information()
	. = ..()
	.[FA_ICON_VR_CARDBOARD] = "Cosmetic"

/datum/loadout_item/accessory/bone_codpiece
	name = "Heirloom Skull Codpiece"
	item_path = /obj/item/clothing/accessory/armorless_skullcodpiece
	loadout_flags = LOADOUT_FLAG_ALLOW_HEIRLOOM

/datum/loadout_item/accessory/bone_codpiece/get_item_information()
	. = ..()
	.[FA_ICON_VR_CARDBOARD] = "Cosmetic"

/datum/loadout_item/accessory/pride
	name = "Pride Pin"
	item_path = /obj/item/clothing/accessory/pride
	loadout_flags = LOADOUT_FLAG_ALLOW_RESKIN
