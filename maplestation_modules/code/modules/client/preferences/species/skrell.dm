/datum/preference/choiced/skrell_hair
	savefile_key = "feature_head_tentacles"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Head Tentacles"
	should_generate_icons = TRUE
	relevant_external_organ = /obj/item/organ/head_tentacles

/datum/preference/choiced/skrell_hair/init_possible_values()
	return assoc_to_keys(SSaccessories.head_tentacles_list)

/datum/preference/choiced/skrell_hair/icon_for(value)
	var/datum/sprite_accessory/sprite_accessory = SSaccessories.head_tentacles_list[value]
	var/datum/universal_icon/skrell = uni_icon('maplestation_modules/icons/mob/skrell_parts_greyscale.dmi', "skrell_head_m", EAST)
	var/datum/universal_icon/eyes = uni_icon('maplestation_modules/icons/mob/skrell_eyes.dmi', "eyes", EAST)

	eyes.blend_color(COLOR_ALMOST_BLACK, ICON_MULTIPLY)
	skrell.blend_icon(eyes, ICON_OVERLAY)

	var/datum/universal_icon/final_icon = skrell.copy()

	for(var/side in list("ADJ", "FRONT"))
		var/datum/universal_icon/accessory_icon = new(sprite_accessory.icon, "m_head_tentacles_[sprite_accessory.icon_state]_[side]", dir = EAST)
		final_icon.blend_icon(accessory_icon, ICON_OVERLAY)

	final_icon.crop(11, 20, 23, 32)
	final_icon.scale(32, 32)
	final_icon.blend_color(COLOR_BLUE_GRAY, ICON_MULTIPLY)

	return final_icon

/datum/preference/choiced/skrell_hair/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["head_tentacles"] = value
