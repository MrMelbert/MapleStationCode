/datum/animid_type/rabbit
	id = "Rabbit"
	components = list(
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/bunny,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/bunny,
		MUTANT_ORGANS = list(
			/obj/item/organ/tail/bunny = "Tall",
		),
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/bunny,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/bunny,
	)

	name = "Leporid"
	icon = FA_ICON_CARROT

/datum/animid_type/rabbit/get_extra_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_PERSON_RUNNING,
			SPECIES_PERK_NAME = "Powerful Legs",
			SPECIES_PERK_DESC = "[name]s have powerful legs, allowing them to kick harder.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_FIST_RAISED,
			SPECIES_PERK_NAME = "Weak Arms",
			SPECIES_PERK_DESC = "[name]s have weak arms, reducing unarmed damage dealt with punches.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BONE,
			SPECIES_PERK_NAME = "Fragile Fur",
			SPECIES_PERK_DESC = "[name]s have weak and fragile limbs, sustaining more brute damage and burn damage.",
		),
	)

	return to_add

/obj/item/organ/tongue/bunny
	name = "bunny tongue"
	desc = "A tiny tongue belonging to a bunny."

	liked_foodtypes = VEGETABLES | FRUIT | GRAIN // carrot
	disliked_foodtypes = GORE | RAW | JUNKFOOD | GROSS | CLOTH | BUGS
	toxic_foodtypes = MEAT | TOXIC | NUTS | SUGAR // chocolate

// Bunny ears organ
/obj/item/organ/ears/bunny
	name = "bunny ears"
	desc = "A pair of long ears belonging to a bunny."
	visual = TRUE
	damage_multiplier = 1.5

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/bunny

	eavesdrop_bonus = 3

// Bunny ears bodypart overlay
/datum/bodypart_overlay/mutant/ears/bunny
	feature_key = "bunny_ears"
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/ears/bunny/get_global_feature_list()
	return SSaccessories.bunny_ears_list

// Bunny ears sprite accessory - sprites ported from Effigy
/datum/sprite_accessory/ears_bunny
	icon = 'maplestation_modules/icons/mob/ears/bunny.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_bunny/side
	name = "Side"
	icon_state = "side"

/datum/sprite_accessory/ears_bunny/tall
	name = "Tall"
	icon_state = "tall"

// https://github.com/Skyrat-SS13/Skyrat13/pull/2644
/datum/sprite_accessory/ears_bunny/long
	name = "Long"
	icon_state = "long"

/datum/sprite_accessory/ears_bunny/droopy
	name = "Droopy"
	icon_state = "droopy"

/datum/sprite_accessory/ears_bunny/rounded
	name = "Rounded"
	icon_state = "rounded"

// Bunny ears preference
/datum/preference/choiced/bunny_ears
	savefile_key = "feature_bunny_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/ears/bunny
	should_generate_icons = TRUE

/datum/preference/choiced/bunny_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["bunny_ears"] = value

/datum/preference/choiced/bunny_ears/create_default_value()
	return /datum/sprite_accessory/ears_bunny/tall::name

/datum/preference/choiced/bunny_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.bunny_ears_list)

/datum/preference/choiced/bunny_ears/icon_for(value)
	return GENERATE_HEAD_ICON(value, SSaccessories.bunny_ears_list)

// Bunny tail organ
/obj/item/organ/tail/bunny
	name = "bunny tail"
	desc = "A small, fluffy tail belonging to a bunny."
	visual = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/bunny
	wag_flags = WAG_ABLE

// Bunny tail bodypart overlay
/datum/bodypart_overlay/mutant/tail/bunny
	feature_key = "bunny_tail"
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/tail/bunny/get_global_feature_list()
	return SSaccessories.bunny_tail_list

// Bunny tail sprite accessory - sprites ported from Effigy
/datum/sprite_accessory/tail_bunny
	icon = 'maplestation_modules/icons/mob/tails/bunny.dmi'
	em_block = TRUE

/datum/sprite_accessory/tail_bunny/small
	name = "Small"
	icon_state = "small"

/datum/sprite_accessory/tail_bunny/tall
	name = "Tall"
	icon_state = "tall"

// Bunny tail preference
/datum/preference/choiced/bunny_tail
	savefile_key = "feature_bunny_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/bunny
	should_generate_icons = TRUE

/datum/preference/choiced/bunny_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["bunny_tail"] = value

/datum/preference/choiced/bunny_tail/create_default_value()
	return /datum/sprite_accessory/tail_bunny/tall::name

/datum/preference/choiced/bunny_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.bunny_tail_list)

/datum/preference/choiced/bunny_tail/icon_for(value)
	return GENERATE_TAIL_ICON(value, SSaccessories.bunny_tail_list)

// Bunny bodyparts
/obj/item/bodypart/leg/left/bunny
	name = "left rabbit leg"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 25
	brute_modifier = 1.2

/obj/item/bodypart/leg/right/bunny
	name = "right rabbit leg"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 25
	brute_modifier = 1.2
	burn_modifier = 1.2

/obj/item/bodypart/arm/left/bunny
	name = "left rabbit arm"
	unarmed_damage_low = 4
	unarmed_damage_high = 8
	brute_modifier = 1.2
	burn_modifier = 1.2

/obj/item/bodypart/arm/right/bunny
	name = "right rabbit arm"
	unarmed_damage_low = 4
	unarmed_damage_high = 8
	brute_modifier = 1.2
	burn_modifier = 1.2

/obj/item/bodypart/chest/bunny
	name = "rabbit chest"
	brute_modifier = 1.2
	burn_modifier = 1.2

/obj/item/bodypart/head/bunny
	name = "rabbit head"
	brute_modifier = 1.2
	burn_modifier = 1.2
