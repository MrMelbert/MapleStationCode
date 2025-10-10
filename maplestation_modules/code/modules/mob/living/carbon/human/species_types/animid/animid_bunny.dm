/datum/animalid_type/rabbit
	id = "Rabbit"
	components = list(
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/bunny,
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/bunny,
		MUTANT_ORGANS = list(
			/obj/item/organ/external/tail/bunny = "Tall",
		),
	)

	name = "Leporid"
	icon = FA_ICON_CARROT
	pros = list(
		"Unimplemented"
	)
	cons = list(
		"Unimplemented"
	)

/obj/item/organ/internal/tongue/bunny
	name = "bunny tongue"
	desc = "A tiny tongue belonging to a bunny."

	liked_foodtypes = VEGETABLES | FRUIT | GRAIN // carrot
	disliked_foodtypes = GORE | RAW | JUNKFOOD | GROSS | CLOTH | BUGS
	toxic_foodtypes = MEAT | TOXIC | NUTS | SUGAR // chocolate

// Bunny tail organ
/obj/item/organ/external/tail/bunny
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
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/bunny

/datum/preference/choiced/bunny_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["bunny_tail"] = value

/datum/preference/choiced/bunny_tail/create_default_value()
	return /datum/sprite_accessory/tail_bunny/tall::name

/datum/preference/choiced/bunny_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.bunny_tail_list)

// Bunny ears organ
/obj/item/organ/internal/ears/bunny
	name = "bunny ears"
	desc = "A pair of long ears belonging to a bunny."
	visual = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/bunny

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
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/internal/ears/bunny

/datum/preference/choiced/bunny_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["bunny_ears"] = value

/datum/preference/choiced/bunny_ears/create_default_value()
	return /datum/sprite_accessory/ears_bunny/tall::name

/datum/preference/choiced/bunny_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.bunny_ears_list)
