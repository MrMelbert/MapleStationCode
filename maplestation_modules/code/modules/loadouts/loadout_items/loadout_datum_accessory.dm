// --- Loadout item datums for accessories ---

/// Accessory Items (Moves overrided items to backpack)
/datum/loadout_category/accessories
	category_name = "Accessory"
	ui_title = "Uniform Accessory Items"
	type_to_generate = /datum/loadout_item/accessory

/datum/loadout_item/accessory
	abstract_type = /datum/loadout_item/accessory
	// Can we adjust this accessory to be above or below suits?
	VAR_FINAL/can_be_layer_adjusted = FALSE

/datum/loadout_item/accessory/New()
	. = ..()
	if(!ispath(item_path, /obj/item/clothing/accessory))
		can_be_layer_adjusted = TRUE

/datum/loadout_item/accessory/get_ui_buttons()
	. = ..()
	if(can_be_layer_adjusted)
		UNTYPED_LIST_ADD(., list(
			"icon" = FA_ICON_ARROW_DOWN,
			"act_key" = "set_layer",
			"tooltip" = "You can modify this item to be above or below your over suit."
		))

/datum/loadout_item/accessory/handle_loadout_action(datum/preference_middleware/loadout/manager, mob/user, action)
	switch(action)
		if("set_layer")
			if(can_be_layer_adjusted)
				set_accessory_layer(manager, user)
				. = TRUE // update to show the new layer

	return ..()

/datum/loadout_item/accessory/proc/set_accessory_layer(datum/preference_middleware/loadout/manager, mob/user)
	var/list/loadout = get_active_loadout(manager.preferences)
	if(!loadout?[item_path])
		manager.select_item(src)

	if(isnull(loadout[item_path][INFO_LAYER]))
		loadout[item_path][INFO_LAYER] = FALSE

	loadout[item_path][INFO_LAYER] = !loadout[item_path][INFO_LAYER]
	to_chat(user, span_boldnotice("[name] will now appear [loadout[item_path][INFO_LAYER] ? "above" : "below"] suits."))
	update_loadout(manager.preferences, loadout)

/datum/loadout_item/accessory/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(outfit.accessory)
		LAZYADD(outfit.backpack_contents, outfit.accessory)
	outfit.accessory = item_path

/datum/loadout_item/accessory/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only = FALSE, list/preference_list)
	. = ..()
	var/obj/item/clothing/accessory/equipped_item = .
	var/obj/item/clothing/under/suit = equipper.w_uniform
	if(!istype(equipped_item))
		return

	equipped_item.above_suit = !!preference_list[item_path]?[INFO_LAYER]
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
	additional_tooltip_contents = list("Contains multiple pens.")

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
	item_path = /obj/item/clothing/accessory/dogtag/name
	additional_tooltip_contents = list("The name inscribed on this item matches your character's name on spawn.")

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
