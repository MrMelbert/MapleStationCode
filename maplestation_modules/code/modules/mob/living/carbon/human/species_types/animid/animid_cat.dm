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
		"Can lick wounds to stop bleeding",
	)
	cons = list(
		"Sensitive to loud noises and water",
	)
	neuts = list(
		"Always land on your feet",
	)

/datum/sprite_accessory/tails/human/cat/big
	name = "Big"
	icon_state = "big"
