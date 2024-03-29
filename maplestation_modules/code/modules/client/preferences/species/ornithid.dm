/**
 * Generates a basic body icon for a humanoid when given a list of bodyparts
 *
 * Arguments
 * * bodypart_list - list of bodyparts to put on the body.
 * The first bodypart in the list becomes the base of the icon, which in most cases doesn't matter, but may for layering.
 * * skintone - (optional) skintone of the body.
 * Not a hex color, but corresponds to human skintones.
 * * dir - (optional) direction of all the icons
 */
/proc/get_basic_body_icon(list/bodypart_list, skintone = "caucasian1", icon_dir = NORTH)
	var/icon/base_icon
	for(var/obj/item/bodypart/other_bodypart as anything in bodypart_list)
		var/icon/generated_icon = icon(
			icon = UNLINT(initial(other_bodypart.icon_greyscale)),
			icon_state = UNLINT("[initial(other_bodypart.limb_id)]_[initial(other_bodypart.body_zone)][initial(other_bodypart.is_dimorphic) ? "_m" : ""]"),
			dir = icon_dir,
		)
		generated_icon.Blend(skintone2hex(skintone), ICON_MULTIPLY)
		if(isnull(base_icon))
			base_icon = generated_icon
		else
			base_icon.Blend(generated_icon, ICON_OVERLAY)

	return base_icon

/datum/preference/choiced/ornithid_wings
	main_feature_name = "Arm Wings"
	savefile_key = "feature_arm_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/external/wings/functional/arm_wings
	should_generate_icons = TRUE

/datum/preference/choiced/ornithid_wings/init_possible_values()
	return assoc_to_keys_features(GLOB.arm_wings_list)

/datum/preference/choiced/ornithid_wings/icon_for(value)
	var/datum/sprite_accessory/the_accessory = GLOB.arm_wings_list[value]
	var/icon/body_icon = get_basic_body_icon(
		bodypart_list = list(/obj/item/bodypart/chest, /obj/item/bodypart/arm/left, /obj/item/bodypart/arm/right),
		skintone = "asian1",
		icon_dir = NORTH,
	)
	var/icon/wing_icon = icon(
		icon = 'maplestation_modules/icons/mob/armwings.dmi',
		icon_state = "m_arm_wings_[the_accessory.icon_state]_FRONT",
		dir = SOUTH,
	)
	wing_icon.Blend(COLOR_CLAIREN_RED, ICON_MULTIPLY)
	body_icon.Blend(wing_icon, ICON_OVERLAY)
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

#define X_TAIL_CROP 16
#define Y_TAIL_CROP 5

/datum/preference/choiced/tail_avian
	main_feature_name = "Avian Tail"
	savefile_key = "feature_avian_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/tail/avian
	should_generate_icons = TRUE

/datum/preference/choiced/tail_avian/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_avian)

/datum/preference/choiced/tail_avian/icon_for(value)
	var/datum/sprite_accessory/the_accessory = GLOB.tails_list_avian[value]
	var/icon/body_icon = get_basic_body_icon(
		bodypart_list = list(/obj/item/bodypart/chest, /obj/item/bodypart/leg/left, /obj/item/bodypart/leg/right),
		skintone = "asian1",
		icon_dir = NORTH,
	)
	var/icon/tail_icon = icon(
		icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi',
		icon_state = "m_tail_avian_[the_accessory.icon_state]_BEHIND",
		dir = SOUTH,
	)
	tail_icon.Blend(COLOR_CLAIREN_RED, ICON_MULTIPLY)
	body_icon.Blend(tail_icon, ICON_OVERLAY)
	body_icon.Scale(64, 64)
	body_icon.Crop(X_TAIL_CROP, Y_TAIL_CROP, X_TAIL_CROP + 31, Y_TAIL_CROP + 31)
	return body_icon

/datum/preference/choiced/tail_avian/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_avian"] = value

/datum/preference/choiced/tail_avian/create_default_value()
	return /datum/sprite_accessory/tails/avian::name

#undef X_TAIL_CROP
#undef Y_TAIL_CROP

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
	var/datum/sprite_accessory/the_accessory = GLOB.avian_ears_list[value]
	var/icon/head_icon = get_basic_body_icon(list(/obj/item/bodypart/head), "asian1", EAST)
	var/icon/eyes = icon('icons/mob/human/human_face.dmi', "eyes", EAST)
	var/icon/ears = icon(the_accessory.icon, "m_ears_avian_[the_accessory.icon_state]_FRONT", EAST)
	eyes.Blend(COLOR_ALMOST_BLACK, ICON_MULTIPLY)
	ears.Blend(COLOR_CLAIREN_RED, ICON_MULTIPLY)
	head_icon.Blend(eyes, ICON_OVERLAY)
	head_icon.Blend(ears, ICON_OVERLAY)
	head_icon.Crop(11, 20, 23, 32)
	head_icon.Scale(32, 32)
	return head_icon

/datum/preference/choiced/plumage/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ears_avian"] = value

/datum/preference/choiced/plumage/create_default_value()
	return /datum/sprite_accessory/plumage::name
