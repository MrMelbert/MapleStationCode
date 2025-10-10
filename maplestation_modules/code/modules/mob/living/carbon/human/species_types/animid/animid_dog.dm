/datum/animalid_type/dog
	id = "Dog"
	components = list(
		ORGAN_SLOT_TONGUE = /obj/item/organ/internal/tongue/dog,
	)

	name = "Canid"
	icon = FA_ICON_DOG
	pros = list(
		"Unimplemented"
	)
	cons = list(
		"Unimplemented"
	)
/obj/item/organ/internal/tongue/dog
	name = "dog tongue"
	desc = "A long, rough tongue belonging to a dog."

	liked_foodtypes = MEAT | JUNKFOOD | DAIRY  // they don't mind gore / raw / gross but they also don't like it
	disliked_foodtypes = VEGETABLES | FRUIT | NUTS | GRAIN // most of them don't like their veggies tho
	toxic_foodtypes = TOXIC | SUGAR // chocolate
