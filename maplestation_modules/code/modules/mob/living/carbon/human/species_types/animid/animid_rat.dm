/datum/animid_type/rat
	id = "Rat"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/tail/rat = "Curled"),
		ORGAN_SLOT_EARS = /obj/item/organ/ears/rat,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/rat,
	)

	name = "Murinid"
	icon = FA_ICON_CHEESE

/datum/animid_type/rat/get_extra_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_CHEESE,
			SPECIES_PERK_NAME = "Gouda Food",
			SPECIES_PERK_DESC = "As a [name], you can eat any food you could think of without getting sick. \
				However, the only food you enjoy eating is dairy products like cheese.",
		),
	)

	return to_add

// Rat ear organ
/obj/item/organ/ears/rat
	name = "mouse ears"
	desc = "A pair of large, rounded ears belonging to a rat or mouse."
	visual = TRUE
	damage_multiplier = 2

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/rat

	eavesdrop_bonus = 2

// Rat ear bodypart overlay
/datum/bodypart_overlay/mutant/ears/rat
	feature_key = "mouse_ears"

/datum/bodypart_overlay/mutant/ears/rat/get_global_feature_list()
	return SSaccessories.rat_ears_list

// Rat ear sprite accessory - sprites ported from Effigy, https://github.com/Skyrat-SS13/Skyrat-tg/pull/15797
/datum/sprite_accessory/ears_rat
	icon = 'maplestation_modules/icons/mob/ears/rat.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_rat/simple
	name = "Simple"
	icon_state = "simple"

/datum/sprite_accessory/ears_rat/sharp
	name = "Sharp"
	icon_state = "sharp"

/datum/sprite_accessory/ears_rat/small
	name = "Small"
	icon_state = "small"

// Rat ear preference
/datum/preference/choiced/rat_ears
	savefile_key = "feature_rat_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/ears/rat
	should_generate_icons = TRUE

/datum/preference/choiced/rat_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mouse_ears"] = value

/datum/preference/choiced/rat_ears/create_default_value()
	return /datum/sprite_accessory/ears_rat/simple::name

/datum/preference/choiced/rat_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.rat_ears_list)

/datum/preference/choiced/rat_ears/icon_for(value)
	return GENERATE_HEAD_ICON(value, SSaccessories.rat_ears_list)

// Rat tail organ
/obj/item/organ/tail/rat
	name = "mouse tail"
	desc = "A long, hairless tail belonging to a rat or mouse."
	visual = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/rat

// Rat tail bodypart overlay
/datum/bodypart_overlay/mutant/tail/rat
	feature_key = "mouse_tail"
	color_source = ORGAN_COLOR_INHERIT

/datum/bodypart_overlay/mutant/tail/rat/get_global_feature_list()
	return SSaccessories.tails_list_rat

// Rat tail sprite accessory - sprites ported Effigy, https://github.com/Skyrat-SS13/Skyrat-tg/pull/15797
/datum/sprite_accessory/tail_rat
	icon = 'maplestation_modules/icons/mob/tails/rat.dmi'
	em_block = TRUE

/datum/sprite_accessory/tail_rat/straight
	name = "Straight"
	icon_state = "straight"

/datum/sprite_accessory/tail_rat/curled
	name = "Curled"
	icon_state = "curled"

// Rat tail preference
/datum/preference/choiced/rat_tail
	savefile_key = "feature_rat_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/rat
	should_generate_icons = TRUE

/datum/preference/choiced/rat_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mouse_tail"] = value

/datum/preference/choiced/rat_tail/create_default_value()
	return /datum/sprite_accessory/tail_rat/straight::name

/datum/preference/choiced/rat_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.tails_list_rat)

/datum/preference/choiced/rat_tail/icon_for(value)
	return GENERATE_COLORED_TAIL_ICON(value, SSaccessories.tails_list_rat, skintone2hex("caucasian1"))
