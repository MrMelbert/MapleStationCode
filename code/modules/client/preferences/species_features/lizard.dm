/proc/generate_lizard_side_shot(datum/sprite_accessory/sprite_accessory, key, include_snout = TRUE)
	var/static/icon/lizard
	var/static/icon/lizard_with_snout

	if (isnull(lizard))
		lizard = icon('icons/mob/human/species/lizard/bodyparts.dmi', "lizard_head", EAST)
		var/icon/eyes = icon('icons/mob/human/human_face.dmi', "eyes", EAST)
		eyes.Blend(COLOR_GRAY, ICON_MULTIPLY)
		lizard.Blend(eyes, ICON_OVERLAY)

		lizard_with_snout = icon(lizard)
		lizard_with_snout.Blend(icon('icons/mob/human/species/lizard/lizard_misc.dmi', "m_snout_round_ADJ", EAST), ICON_OVERLAY)

	var/icon/final_icon = include_snout ? icon(lizard_with_snout) : icon(lizard)

	if (!isnull(sprite_accessory))
		var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_ADJ", EAST)
		final_icon.Blend(accessory_icon, ICON_OVERLAY)

	final_icon.Crop(11, 20, 23, 32)
	final_icon.Scale(32, 32)
	final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)

	return final_icon

/datum/preference/choiced/lizard_body_markings
	savefile_key = "feature_lizard_body_markings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Body markings"
	should_generate_icons = TRUE
	relevant_mutant_bodypart = "body_markings"

/datum/preference/choiced/lizard_body_markings/init_possible_values()
	return assoc_to_keys_features(GLOB.body_markings_list)

/datum/preference/choiced/lizard_body_markings/icon_for(value)
	var/datum/sprite_accessory/sprite_accessory = GLOB.body_markings_list[value]

	var/icon/final_icon = icon('icons/mob/human/species/lizard/bodyparts.dmi', "lizard_chest_m")

	if (sprite_accessory.icon_state != "none")
		var/icon/body_markings_icon = icon(
			'icons/mob/human/species/lizard/lizard_misc.dmi',
			"m_body_markings_[sprite_accessory.icon_state]_ADJ",
		)

		final_icon.Blend(body_markings_icon, ICON_OVERLAY)

	final_icon.Blend(COLOR_VIBRANT_LIME, ICON_MULTIPLY)
	final_icon.Crop(10, 8, 22, 23)
	final_icon.Scale(26, 32)
	final_icon.Crop(-2, 1, 29, 32)

	return final_icon

/datum/preference/choiced/lizard_body_markings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["body_markings"] = value

/datum/preference/choiced/lizard_frills
	savefile_key = "feature_lizard_frills"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Frills"
	should_generate_icons = TRUE
	relevant_external_organ = /obj/item/organ/external/frills

/datum/preference/choiced/lizard_frills/init_possible_values()
	return assoc_to_keys_features(GLOB.frills_list)

/datum/preference/choiced/lizard_frills/icon_for(value)
	return generate_lizard_side_shot(GLOB.frills_list[value], "frills")

/datum/preference/choiced/lizard_frills/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["frills"] = value

/datum/preference/choiced/lizard_horns
	savefile_key = "feature_lizard_horns"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Horns"
	should_generate_icons = TRUE
	relevant_external_organ = /obj/item/organ/external/horns

/datum/preference/choiced/lizard_horns/init_possible_values()
	return assoc_to_keys_features(GLOB.horns_list)

/datum/preference/choiced/lizard_horns/icon_for(value)
	return generate_lizard_side_shot(GLOB.horns_list[value], "horns")

/datum/preference/choiced/lizard_horns/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["horns"] = value

/datum/preference/choiced/lizard_legs
	savefile_key = "feature_lizard_legs"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_mutant_bodypart = "legs"

/datum/preference/choiced/lizard_legs/init_possible_values()
	return list("Normal Legs", DIGITIGRADE_LEGS)

/datum/preference/choiced/lizard_legs/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["legs"] = value
	// Hack to update the dummy in the preference menu
	// (Because digi legs are ONLY handled on species change)
	if(!isdummy(target) || target.dna.species.digitigrade_customization == DIGITIGRADE_NEVER)
		return

	var/list/correct_legs = target.dna.species.bodypart_overrides.Copy() & list(BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)

	if(value == DIGITIGRADE_LEGS)
		correct_legs[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/digitigrade
		correct_legs[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/digitigrade

	for(var/obj/item/bodypart/old_part as anything in target.bodyparts)
		if(old_part.change_exempt_flags & BP_BLOCK_CHANGE_SPECIES)
			continue

		var/path = correct_legs[old_part.body_zone]
		if(!path)
			continue
		var/obj/item/bodypart/new_part = new path()
		new_part.replace_limb(target, TRUE)
		new_part.update_limb(is_creating = TRUE)
		qdel(old_part)

/datum/preference/choiced/lizard_legs/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE
	var/datum/species/species_type = preferences.read_preference(/datum/preference/choiced/species)
	return initial(species_type.digitigrade_customization) == DIGITIGRADE_OPTIONAL

/datum/preference/choiced/lizard_snout
	savefile_key = "feature_lizard_snout"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Snout"
	should_generate_icons = TRUE
	relevant_external_organ = /obj/item/organ/external/snout

/datum/preference/choiced/lizard_snout/init_possible_values()
	return assoc_to_keys_features(GLOB.snouts_list)

/datum/preference/choiced/lizard_snout/icon_for(value)
	return generate_lizard_side_shot(GLOB.snouts_list[value], "snout", include_snout = FALSE)

/datum/preference/choiced/lizard_snout/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["snout"] = value

/datum/preference/choiced/lizard_spines
	savefile_key = "feature_lizard_spines"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/spines

/datum/preference/choiced/lizard_spines/init_possible_values()
	return assoc_to_keys_features(GLOB.spines_list)

/datum/preference/choiced/lizard_spines/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["spines"] = value

/datum/preference/choiced/lizard_tail
	savefile_key = "feature_lizard_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/lizard

/datum/preference/choiced/lizard_tail/init_possible_values()
	return assoc_to_keys_features(GLOB.tails_list_lizard)

/datum/preference/choiced/lizard_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_lizard"] = value

/datum/preference/choiced/lizard_tail/create_default_value()
	return /datum/sprite_accessory/tails/lizard/smooth::name
