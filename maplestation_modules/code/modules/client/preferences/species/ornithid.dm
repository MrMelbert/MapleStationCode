// code for setting preferences for ornithids
/proc/generate_ornithid_side_shots(list/sprite_accessories, key, list/sides)
	var/list/values = list()

	var/icon/ornithid = icon('icons/mob/human/human_face.dmi', "head", EAST)
	var/icon/eyes = icon('icons/mob/human/human_face.dmi', "eyes", EAST)
	eyes.Blend(COLOR_CLAIREN_RED, ICON_MULTIPLY)

	ornithid.Blend(eyes, ICON_OVERLAY)

	for (var/name in sprite_accessories)

		var/icon/final_icon = icon(ornithid)


		final_icon.Crop(11, 20, 23, 32)
		final_icon.Scale(32, 32)
		final_icon.Blend(COLOR_BLUE_GRAY, ICON_MULTIPLY)

		values[name] = final_icon

	return values

/datum/preference/choiced/ornithid_wings
	savefile_key = "feature_arm_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Arm Wings"
	relevant_external_organ = /obj/item/organ/external/wings/functional/arm_wings
	should_generate_icons = TRUE

/datum/preference/choiced/ornithid_wings/init_possible_values()
	return assoc_to_keys_features(GLOB.arm_wings_list)

/datum/preference/choiced/ornithid_wings/icon_for(value)
	return icon(
		icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi',
		icon_state = "m_arm_wings_[GLOB.arm_wings_list[value]]_FRONT",
	)

/datum/preference/choiced/ornithid_wings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arm_wings"] = value

/datum/preference/choiced/tail_avian
	savefile_key = "feature_avian_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/tail/avian
	should_generate_icons = TRUE

/datum/preference/choiced/tail_avian/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_avian)

/datum/preference/choiced/tail_avian/icon_for(value)
	return icon(
		icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi',
		icon_state = "m_tail_avian_[GLOB.tails_list_avian[value]]_BEHIND",
	)

/datum/preference/choiced/tail_avian/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_avian"] = value

/datum/preference/choiced/tail_avian/create_default_value()
	var/datum/sprite_accessory/tails/avian/tail = /datum/sprite_accessory/tails/avian
	return initial(tail.name)

/datum/preference/choiced/plumage
	main_feature_name = "Plumage"
	savefile_key = "feature_avian_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/plumage
	should_generate_icons = TRUE

/datum/preference/choiced/plumage/init_possible_values()
	return assoc_to_keys_features(GLOB.avian_ears_list)

/datum/preference/choiced/plumage/icon_for(value)
	return icon(
		icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi',
		icon_state = "m_ears_avian_[GLOB.avian_ears_list[value]]_FRONT",
	)

/datum/preference/choiced/plumage/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ears_avian"] = value

/datum/preference/choiced/plumage/create_default_value()
	var/datum/sprite_accessory/plumage/plumage = /datum/sprite_accessory/plumage
	return initial(plumage.name)
