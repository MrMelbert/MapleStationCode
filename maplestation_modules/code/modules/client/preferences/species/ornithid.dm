/datum/preference/choiced/ornithid_wings
	main_feature_name = "Arm Wings"
	savefile_key = "feature_arm_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/wings/functional/arm_wings
	should_generate_icons = TRUE

/datum/preference/choiced/ornithid_wings/init_possible_values()
	return assoc_to_keys_features(SSaccessories.arm_wings_list)

/datum/preference/choiced/ornithid_wings/icon_for(value)
	var/datum/sprite_accessory/the_accessory = SSaccessories.arm_wings_list[value]
	var/datum/universal_icon/body_icon = generate_body_icon(
		bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/arm/left, /obj/item/bodypart/arm/right),
		color = "asian1",
	)
	var/datum/universal_icon/wing_icon = uni_icon(the_accessory.icon, "m_arm_wings_[the_accessory.icon_state]_ADJ", dir = SOUTH)
	wing_icon.blend_color(COLOR_CLAIREN_RED, ICON_MULTIPLY)
	body_icon.blend_icon(wing_icon, ICON_OVERLAY)
	body_icon.scale(48, 48)
	body_icon.crop_32x32(8, 8)
	return body_icon

/datum/preference/choiced/ornithid_wings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arm_wings"] = value

/datum/preference/choiced/ornithid_wings/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = "feather_color"
	return data

/datum/preference/color/feather_color
	savefile_key = "feather_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_inherent_trait = TRAIT_FEATHERED

/datum/preference/color/feather_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["feathers"] = value

/datum/preference/choiced/tail_avian
	main_feature_name = "Avian Tail"
	savefile_key = "feature_avian_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/tail/avian
	should_generate_icons = TRUE

/datum/preference/choiced/tail_avian/init_possible_values()
	return assoc_to_keys_features(SSaccessories.tails_list_avian)

/datum/preference/choiced/tail_avian/icon_for(value)
	var/datum/sprite_accessory/the_accessory = SSaccessories.tails_list_avian[value]
	var/datum/universal_icon/body_icon = generate_body_icon(
		bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/arm/left, /obj/item/bodypart/arm/right),
		color = "asian1",
	)
	var/datum/universal_icon/tail_icon = uni_icon('maplestation_modules/icons/mob/ornithidfeatures.dmi', "m_tail_avian_[the_accessory.icon_state]_BEHIND", dir = SOUTH)
	tail_icon.blend_color(COLOR_CLAIREN_RED, ICON_MULTIPLY)
	body_icon.blend_icon(tail_icon, ICON_OVERLAY)
	body_icon.scale(64, 64)
	body_icon.crop_32x32(16, 5)
	return body_icon

/datum/preference/choiced/tail_avian/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_avian"] = value

/datum/preference/choiced/tail_avian/create_default_value()
	return /datum/sprite_accessory/tails/avian::name

/datum/preference/choiced/plumage
	main_feature_name = "Plumage"
	savefile_key = "feature_avian_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/ears/avian
	should_generate_icons = TRUE

/datum/preference/choiced/plumage/init_possible_values()
	return assoc_to_keys_features(SSaccessories.avian_ears_list)

/datum/preference/choiced/plumage/icon_for(value)
	var/datum/sprite_accessory/the_accessory = SSaccessories.avian_ears_list[value]
	var/datum/universal_icon/head_icon = generate_body_icon(
		bodyparts = list(/obj/item/bodypart/head),
		color = "asian1",
	)
	var/datum/universal_icon/eyes_l = uni_icon('icons/mob/human/human_face.dmi', "eyes_l", EAST)
	var/datum/universal_icon/eyes_r = uni_icon('icons/mob/human/human_face.dmi', "eyes_r", EAST)
	var/datum/universal_icon/ears = uni_icon(the_accessory.icon, "m_ears_avian_[the_accessory.icon_state]_FRONT", EAST)
	eyes_l.blend_color(COLOR_ALMOST_BLACK, ICON_MULTIPLY)
	eyes_r.blend_color(COLOR_ALMOST_BLACK, ICON_MULTIPLY)
	ears.blend_color(COLOR_CLAIREN_RED, ICON_MULTIPLY)
	head_icon.blend_icon(eyes_l, ICON_OVERLAY)
	head_icon.blend_icon(eyes_r, ICON_OVERLAY)
	head_icon.blend_icon(ears, ICON_OVERLAY)
	head_icon.crop(11, 20, 23, 32)
	head_icon.scale(32, 32)
	return head_icon

/datum/preference/choiced/plumage/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ears_avian"] = value

/datum/preference/choiced/plumage/create_default_value()
	return /datum/sprite_accessory/plumage::name
