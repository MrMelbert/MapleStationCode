/datum/animalid_type/fox
	id = "Fox"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/tail/fox_animid = "Fox"),
		ORGAN_SLOT_EARS = /obj/item/organ/ears/fox_animid,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/fox_animid,
	)

	name = "Vulpinid"
	icon = FA_ICON_FIRE_FLAME_CURVED

/obj/item/organ/ears/fox_animid
	name = "fox ears"
	desc = "A pair of large, pointed ears belonging to a fox."
	visual = TRUE
	damage_multiplier = 2

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/fox_animid

	eavesdrop_bonus = 2

/datum/bodypart_overlay/mutant/ears/fox_animid
	feature_key = "fox_ears"

/datum/bodypart_overlay/mutant/ears/fox_animid/get_global_feature_list()
	return SSaccessories.fox_ears_list

// Fox ears sprite accessory - sprites ported from Effigy
/datum/sprite_accessory/ears_fox
	icon = 'maplestation_modules/icons/mob/ears/fox.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_fox/standard
	name = "Fox"
	icon_state = "fox"

/datum/sprite_accessory/ears_fox/dark
	name = "Fox (Dark)"
	icon_state = "dark"

/datum/sprite_accessory/ears_fox/light
	name = "Fox (Light)"
	icon_state = "light"

// https://github.com/Skyrat-SS13/Skyrat-tg/pull/17913
/datum/sprite_accessory/ears_fox/four
	name = "Four Fox"
	icon_state = "four"

/datum/sprite_accessory/ears_fox/fennec
	name = "Fennec"
	icon_state = "fennec"

/datum/preference/choiced/fox_ears
	savefile_key = "feature_fox_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/ears/fox_animid
	should_generate_icons = TRUE

/datum/preference/choiced/fox_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["fox_ears"] = value

/datum/preference/choiced/fox_ears/create_default_value()
	return /datum/sprite_accessory/ears_fox/standard::name

/datum/preference/choiced/fox_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.fox_ears_list)

/datum/preference/choiced/fox_ears/icon_for(value)
	return GENERATE_HEAD_ICON(value, SSaccessories.fox_ears_list)

// Fox tail organ
/obj/item/organ/tail/fox_animid
	name = "fox tail"
	desc = "A bushy tail belonging to a fox."
	visual = TRUE
	wag_flags = WAG_ABLE

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/fox_animid

/datum/bodypart_overlay/mutant/tail/fox_animid
	feature_key = "fox_tail"
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/tail/fox_animid/get_global_feature_list()
	return SSaccessories.fox_tail_list

// Fox tail sprite accessory
/datum/sprite_accessory/fox_tail
	icon = 'maplestation_modules/icons/mob/tails/fox.dmi'
	em_block = TRUE

/datum/sprite_accessory/fox_tail/standard
	name = "Fox"
	icon_state = "fox"

/datum/sprite_accessory/fox_tail/fivefox
	name = "Five Fox"
	icon_state = "fivefox"

// Sprite ported from Effigy
/datum/sprite_accessory/fox_tail/fennec
	name = "Fennec"
	icon_state = "fennec"

/datum/sprite_accessory/fox_tail/low
	name = "Low"
	icon_state = "lower"

/datum/sprite_accessory/fox_tail/swoop
	name = "Swoop"
	icon_state = "swoop"

/datum/sprite_accessory/fox_tail/long
	name = "Long"
	icon_state = "long"

/datum/sprite_accessory/fox_tail/long/alt
	name = "Long (Alt)"
	icon_state = "long_alt"

/datum/preference/choiced/fox_tail
	savefile_key = "feature_fox_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/tail/fox_animid
	should_generate_icons = TRUE

/datum/preference/choiced/fox_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["fox_tail"] = value

/datum/preference/choiced/fox_tail/create_default_value()
	return /datum/sprite_accessory/fox_tail/standard::name

/datum/preference/choiced/fox_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.fox_tail_list)

/datum/preference/choiced/fox_tail/icon_for(value)
	return GENERATE_TAIL_ICON(value, SSaccessories.fox_tail_list)

/obj/item/organ/tongue/fox_animid
	name = "fox tongue"
	desc = "A long, rough tongue belonging to a fox."

	liked_foodtypes = MEAT | BUGS
	disliked_foodtypes = VEGETABLES | FRUIT | NUTS | CLOTH
	toxic_foodtypes = TOXIC | SUGAR | GRAIN
