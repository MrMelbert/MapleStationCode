/datum/animalid_type/cat
	id = "Cat"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/tail/cat = "Cat"),
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/felinid,
		ORGAN_SLOT_EARS = /obj/item/organ/ears/cat,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/felinid,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/cat,
	)

	name = "Felinid"
	icon = FA_ICON_CAT

/datum/animalid_type/cat/get_extra_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_GRIN_TONGUE,
			SPECIES_PERK_NAME = "Grooming",
			SPECIES_PERK_DESC = "[name]s can lick cuts to reduce blood loss.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_COMMENT_DOTS,
			SPECIES_PERK_NAME = "Early Adopter",
			SPECIES_PERK_DESC = "While most Animids have a shared language, [name]s also have their own tongue, [/datum/language/nekomimetic::name].",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_PERSON_FALLING,
			SPECIES_PERK_NAME = "Catlike Grace",
			SPECIES_PERK_DESC = "[name]s have catlike instincts allowing them to land upright on their feet. \
				Instead of being knocked down from falling, you only receive a short slowdown. \
				However, they lack catlike legs, causing any falls to deal additional damage.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_SHOWER,
			SPECIES_PERK_NAME = "Hydrophobia",
			SPECIES_PERK_DESC = "[name]s don't like getting soaked with water.",
		),
	)

	return to_add

/datum/animalid_type/cat/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	species.species_language_holder = /datum/language_holder/felinid
	LAZYOR(species.family_heirlooms, /obj/item/toy/cattoy)

// Felinid extra customization
/datum/sprite_accessory/tails/human/cat/big
	name = "Big"
	icon_state = "big"
	icon = 'maplestation_modules/icons/mob/tails/cat.dmi'

// Felinid prefs tweak
/datum/preference/choiced/ears
	category = PREFERENCE_CATEGORY_FEATURES
	should_generate_icons = TRUE

/datum/preference/choiced/ears/icon_for(value)
	return GENERATE_HEAD_ICON(value, SSaccessories.ears_list)

/datum/preference/choiced/tail_human
	category = PREFERENCE_CATEGORY_FEATURES
	should_generate_icons = TRUE

/datum/preference/choiced/tail_human/icon_for(value)
	return GENERATE_TAIL_ICON(value, SSaccessories.tails_list_human)
