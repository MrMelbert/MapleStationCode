/datum/animalid_type/fox
	id = "Fox"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/external/tail/fox_animid = "Fox"),
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/fox_animid,
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/fox_animid,
	)

	name = "Vulpinid"
	icon = FA_ICON_FIRE_FLAME_CURVED
	pros = list(
		"Unimplemented"
	)
	cons = list(
		"Unimplemented"
	)

/obj/item/organ/internal/ears/fox_animid
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

// Fox ears sprite accessory
/datum/sprite_accessory/ears_fox
	icon = 'maplestation_modules/icons/mob/ears/fox.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_fox/standard
	name = "Fox"
	icon_state = "fox"

/datum/preference/choiced/fox_ears
	savefile_key = "feature_fox_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/internal/ears/fox_animid

/datum/preference/choiced/fox_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["fox_ears"] = value

/datum/preference/choiced/fox_ears/create_default_value()
	return /datum/sprite_accessory/ears_fox/standard::name

/datum/preference/choiced/fox_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.fox_ears_list)

// Fox tail organ
/obj/item/organ/external/tail/fox_animid
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

/datum/sprite_accessory/fox_tail/standard/fivefox
	name = "Five Fox"
	icon_state = "fivefox"

/datum/preference/choiced/fox_tail
	savefile_key = "feature_fox_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/fox_animid

/datum/preference/choiced/fox_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["fox_tail"] = value

/datum/preference/choiced/fox_tail/create_default_value()
	return /datum/sprite_accessory/fox_tail/standard::name

/datum/preference/choiced/fox_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.fox_tail_list)

/obj/item/organ/internal/tongue/fox_animid
	name = "fox tongue"
	desc = "A long, rough tongue belonging to a fox."

	liked_foodtypes = MEAT | BUGS
	disliked_foodtypes = VEGETABLES | FRUIT | NUTS | CLOTH
	toxic_foodtypes = TOXIC | SUGAR | GRAIN
