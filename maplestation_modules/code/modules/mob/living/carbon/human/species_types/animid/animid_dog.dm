/datum/animalid_type/dog
	id = "Dog"
	components = list(
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/dog,
		MUTANT_ORGANS = list(/obj/item/organ/external/tail/dog = "Straight"),
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/dog,
	)

	name = "Canid"
	icon = FA_ICON_DOG

/obj/item/organ/internal/tongue/dog
	name = "dog tongue"
	desc = "A long, rough tongue belonging to a dog."

	liked_foodtypes = MEAT | JUNKFOOD | DAIRY  // they don't mind gore / raw / gross but they also don't like it
	disliked_foodtypes = VEGETABLES | FRUIT | NUTS | GRAIN // most of them don't like their veggies tho
	toxic_foodtypes = TOXIC | SUGAR // chocolate

/obj/item/organ/external/tail/dog
	name = "dog tail"
	desc = "A furry tail belonging to a dog."
	visual = TRUE

	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/dog

/datum/bodypart_overlay/mutant/tail/dog
	feature_key = "dog_tail"
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/tail/dog/get_global_feature_list()
	return SSaccessories.dog_tail_list

// Dog tail sprite accessory - sprites ported from Effigy
/datum/sprite_accessory/dog_tail
	icon = 'maplestation_modules/icons/mob/tails/dog.dmi'
	em_block = TRUE

/datum/sprite_accessory/dog_tail/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/dog_tail/lab
	name = "Labrador"
	icon_state = "lab"

/datum/sprite_accessory/dog_tail/drop
	name = "Droplet"
	icon_state = "drop"

/datum/sprite_accessory/dog_tail/straight
	name = "Straight"
	icon_state = "straight"

/datum/sprite_accessory/dog_tail/wolf
	name = "Wolf"
	icon_state = "wolf"

/datum/preference/choiced/dog_tail
	savefile_key = "feature_dog_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/external/tail/dog

/datum/preference/choiced/dog_tail/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["dog_tail"] = value

/datum/preference/choiced/dog_tail/create_default_value()
	return /datum/sprite_accessory/dog_tail/straight::name

/datum/preference/choiced/dog_tail/init_possible_values()
	return assoc_to_keys_features(SSaccessories.dog_tail_list)

/obj/item/organ/internal/ears/dog
	name = "dog ears"
	desc = "A pair of furry ears belonging to a dog."
	visual = TRUE
	damage_multiplier = 1.5

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/dog

	eavesdrop_bonus = 2

/datum/bodypart_overlay/mutant/ears/dog
	feature_key = "dog_ears"
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/ears/dog/get_global_feature_list()
	return SSaccessories.dog_ears_list

// Dog ears sprite accessory - sprites ported from Effigy
/datum/sprite_accessory/ears_dog
	icon = 'maplestation_modules/icons/mob/ears/dog.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_dog/fold
	name = "Fold"
	icon_state = "fold"

/datum/sprite_accessory/ears_dog/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/ears_dog/lab
	name = "Labrador"
	icon_state = "lab"

/datum/sprite_accessory/ears_dog/pointed
	name = "Pointed"
	icon_state = "pointed"

/datum/sprite_accessory/ears_dog/perky
	name = "Perky"
	icon_state = "perky"

/datum/sprite_accessory/ears_dog/wolf
	name = "Wolf (Light)"
	icon_state = "wolf"

/datum/sprite_accessory/ears_dog/wolf/dark
	name = "Wolf (Dark)"
	icon_state = "dark_wolf"

/datum/preference/choiced/dog_ears
	savefile_key = "feature_dog_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	relevant_external_organ = /obj/item/organ/internal/ears/dog

/datum/preference/choiced/dog_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["dog_ears"] = value

/datum/preference/choiced/dog_ears/create_default_value()
	return /datum/sprite_accessory/ears_dog/perky::name

/datum/preference/choiced/dog_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.dog_ears_list)
