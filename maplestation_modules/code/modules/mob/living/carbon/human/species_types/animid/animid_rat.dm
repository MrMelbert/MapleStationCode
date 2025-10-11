/datum/animalid_type/rat
	id = "Rat"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/external/tail/rat = "Curled"),
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/rat,
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/rat,
	)

	name = "Murinid"
	icon = FA_ICON_CHEESE
	pros = list(
		"Unimplemented",
	)
	cons = list(
		"Unimplemented",
	)
	neuts = list(
		"Can eat anything, only likes cheese",
	)

// Rat ear organ
/obj/item/organ/internal/ears/rat
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

// Rat ear sprite accessory - sprites ported from Effigy
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
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/internal/ears/rat

/datum/preference/choiced/rat_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mouse_ears"] = value

/datum/preference/choiced/rat_ears/create_default_value()
	return /datum/sprite_accessory/ears_rat/simple::name

/datum/preference/choiced/rat_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.rat_ears_list)

// Rat tail organ
/obj/item/organ/external/tail/rat
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

// Rat tail sprite accessory - sprites ported from Effigy
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
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/rat

/datum/preference/choiced/rat_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["mouse_tail"] = value

/datum/preference/choiced/rat_tail/create_default_value()
	return /datum/sprite_accessory/tail_rat/straight::name

/datum/preference/choiced/rat_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.tails_list_rat)
