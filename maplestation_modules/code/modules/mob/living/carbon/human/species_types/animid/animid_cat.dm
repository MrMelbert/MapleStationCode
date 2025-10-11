/datum/animalid_type/cat
	id = "Cat"
	components = list(
		MUTANT_ORGANS = list(/obj/item/organ/external/tail/cat = "Cat"),
		ORGAN_SLOT_BRAIN = /obj/item/organ/internal/brain/felinid,
		ORGAN_SLOT_EARS = /obj/item/organ/internal/ears/cat,
		ORGAN_SLOT_LIVER = /obj/item/organ/internal/liver/felinid,
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/cat,
	)

	name = "Felinid"
	icon = FA_ICON_CAT
	pros = list(
		"Lick cuts to stop bleeding",
	)
	cons = list(
		"Sensitive water",
	)
	neuts = list(
		"Always land on your feet",
	)

/datum/animalid_type/cat/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	species.species_language_holder = /datum/language_holder/felinid

/datum/sprite_accessory/tails/human/cat/big
	name = "Big"
	icon_state = "big"
