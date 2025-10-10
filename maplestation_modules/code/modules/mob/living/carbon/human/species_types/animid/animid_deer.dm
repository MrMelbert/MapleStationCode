/datum/animalid_type/deer
	id = "Deer"
	components = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/deer,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/deer,
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/deer,
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/deer,
		MUTANT_ORGANS = list(
			/obj/item/organ/external/tail/deer = "Light",
		),
	)

	name = "Cervid"
	icon = FA_ICON_WHEAT_AWN
	pros = list(
		"Good stamina, strong kicks",
		"Slowed by carrying heavy objects less",
	)
	cons = list(
		"Clumsy at climbing",
	)
	neuts = list(
		"Affected by mood more than most",
	)

// Deer ear organ
/obj/item/organ/internal/ears/deer
	name = "deer ears"
	desc = "A pair of large, pointed ears belonging to a deer."
	visual = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/deer

// Deer ear bodypart overlay
/datum/bodypart_overlay/mutant/ears/deer
	feature_key = "deer_ears"
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/ears/deer/get_global_feature_list()
	return SSaccessories.deer_ears_list

// Deer ear sprite accessory
/datum/sprite_accessory/ears_deer
	icon = 'maplestation_modules/icons/mob/ears/deer.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_deer/tall
	name = "Tall"
	icon_state = "tall"

/datum/sprite_accessory/ears_deer/short
	name = "Short"
	icon_state = "short"

/datum/sprite_accessory/ears_deer/horns
	name = "Horns"
	icon_state = "horns"

// Deer ear preference
/datum/preference/choiced/deer_ears
	savefile_key = "feature_deer_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/internal/ears/deer

/datum/preference/choiced/deer_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["deer_ears"] = value

/datum/preference/choiced/deer_ears/create_default_value()
	return /datum/sprite_accessory/ears_deer/tall::name

/datum/preference/choiced/deer_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.deer_ears_list)

// Deer tail organ
/obj/item/organ/external/tail/deer
	name = "deer tail"
	desc = "A short, fluffy tail belonging to a deer."
	visual = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/deer

// Deer tail bodypart overlay
/datum/bodypart_overlay/mutant/tail/deer
	feature_key = "deer_tail"
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/tail/deer/get_global_feature_list()
	return SSaccessories.deer_tail_list

// Deer tail sprite accessory
/datum/sprite_accessory/tail_deer
	icon = 'maplestation_modules/icons/mob/tails/deer.dmi'
	em_block = TRUE

/datum/sprite_accessory/tail_deer/light
	name = "Light"
	icon_state = "light"

/datum/sprite_accessory/tail_deer/dark
	name = "Dark"
	icon_state = "dark"

// Deer tail preference
/datum/preference/choiced/deer_tail
	savefile_key = "feature_deer_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/deer

/datum/preference/choiced/deer_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["deer_tail"] = value

/datum/preference/choiced/deer_tail/create_default_value()
	return /datum/sprite_accessory/tail_deer/light::name

/datum/preference/choiced/deer_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.deer_tail_list)

// Deer tongue organ
/obj/item/organ/internal/tongue/deer
	name = "deer tongue"
	desc = "A long, rough tongue belonging to a deer."

	liked_foodtypes = VEGETABLES | FRUIT | NUTS | GRAIN
	disliked_foodtypes = GORE | RAW | JUNKFOOD | GROSS | CLOTH
	toxic_foodtypes = MEAT | SEAFOOD | TOXIC

// Deer bodyparts
/obj/item/bodypart/leg/left/deer
	name = "left deer leg"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 30

/obj/item/bodypart/leg/left/deer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bodypart_sprint_buff, 5)

/obj/item/bodypart/leg/right/deer
	name = "right deer leg"
	unarmed_damage_low = 10
	unarmed_damage_high = 15
	unarmed_effectiveness = 30

/obj/item/bodypart/leg/right/deer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/bodypart_sprint_buff, 5)

// Deer brain
/obj/item/organ/internal/brain/deer
	name = "deer brain"
	organ_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_LITERATE,
		TRAIT_QUICK_CARRY,
		TRAIT_STUBBY_BODY,
		TRAIT_STURDY_FRAME,
	)

/obj/item/organ/internal/brain/deer/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	organ_owner.mob_mood?.mood_modifier += 0.34

/obj/item/organ/internal/brain/deer/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	organ_owner.mob_mood?.mood_modifier -= 0.34
