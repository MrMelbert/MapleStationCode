/datum/species/abductor/get_species_description()
	return "Abductors, colloquially known as \"Greys\" (or \"Grays\"), are pale skinned inquisitive aliens who can't commicate to the average crew-member."

/datum/species/abductor/get_species_lore()
	return list("Abductor lore.")

/datum/species/abductor/create_pref_unique_perks()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "syringe",
		SPECIES_PERK_NAME = "Disease Immunity",
		SPECIES_PERK_DESC = "Abductors are immune to all viral infections found naturally on the station.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "wind",
		SPECIES_PERK_NAME = "Lungs Optional",
		SPECIES_PERK_DESC = "Abductors don't need to breathe, though exposure to a vacuum is still a hazard.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK, // It may be a stretch to call nohunger a neutral perk but the Abductor's tongue describes it as much, so.
		SPECIES_PERK_ICON = "utensils",
		SPECIES_PERK_NAME = "Hungry for Knowledge",
		SPECIES_PERK_DESC = "Abductors have a greater hunger for knowledge than food, and as such don't need to eat. \
			Which is fortunate, as their speech matrix prevents them from consuming food.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "volume-xmark",
		SPECIES_PERK_NAME = "Superlingual Matrix",
		SPECIES_PERK_DESC = "Abductors cannot physically speak with their natural tongue. \
			They intead naturally communicate telepathically to other Abductors, a process which all other species cannot hear.",
	))
	return perks
