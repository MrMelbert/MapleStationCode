
/proc/generate_skrell_side_shots(list/sprite_accessories, key, list/sides)
	var/list/values = list()

	var/icon/skrell = icon(DEFAULT_BODYPART_ICON_ORGANIC, "skrell_head_m", EAST)
	var/icon/eyes = icon('maplestation_modules/icons/mob/skrell_eyes.dmi', "eyes", EAST)

	eyes.Blend(COLOR_ALMOST_BLACK, ICON_MULTIPLY)
	skrell.Blend(eyes, ICON_OVERLAY)

	for (var/name in sprite_accessories)
		var/datum/sprite_accessory/sprite_accessory = sprite_accessories[name]

		var/icon/final_icon = icon(skrell)

		if (sprite_accessory.icon_state != "none")
			for(var/side in sides)
				var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_[side]", EAST)
				final_icon.Blend(accessory_icon, ICON_OVERLAY)

		final_icon.Crop(11, 20, 23, 32)
		final_icon.Scale(32, 32)
		final_icon.Blend(COLOR_BLUE_GRAY, ICON_MULTIPLY)

		values[name] = final_icon

	return values

/datum/preference/choiced/skrell_hair
	savefile_key = "feature_head_tentacles"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Head Tentacles"
	should_generate_icons = TRUE

/datum/preference/choiced/skrell_hair/init_possible_values()
	return generate_skrell_side_shots(GLOB.head_tentacles_list, "head_tentacles", list("ADJ", "FRONT"))

/datum/preference/choiced/skrell_hair/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["head_tentacles"] = value
