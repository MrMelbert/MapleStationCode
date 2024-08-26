/datum/species/abductor/get_species_speech_sounds(sound_type)
	return

/datum/species/abductor/get_species_description()
	return "Abductors, colloquially known as \"Greys\" (or \"Grays\"), \
		are pale skinned inquisitive aliens who can't communicate well to the average crew-member."

/datum/species/abductor/get_species_lore()
	return list(
		"A species of scholars and intellects, \"Abductors\" are a humanoid race known for their titular abudctions. \
		Their scientific prowess can be attributed to their biological collective consciousness, which replaces contemporary forms of communication. \
		Rather than speech, Abductors are capable of transmitting thoughts and ideas between one another through the use of a communal thoughtspace, \
		accessed via a \"Speech Matrix\" which covers their trachea. For this same reason, the true name which Abductors refer to themselves as is \
		impossible to speak verbally, as it is simply a mental image of their collective peoples.",

		"Little is known about the Abductors' home, as few humanoid beings have gone there and fewer still have returned. \
		The Abductors' governmental heirarchy appears to center upon the creation and constant additions to museums, with surviving \
		Abductees frantically babbling stories of glass enclosures filled with monsters and plantlife never before seen. \
		No matter thier true intentions, it is accepted among the general population that 99% of Abductors likely suffer a form of \
		Obsessive-Compulsive Disorder leading them to hoard as much \"scientific knowledge\" as they can possibly get. \
		Realistically, this knowledge tends to come in the form of what most other species would believe to be garbage.",

		"Few Abductors have been employed with Nanotrasen, though it is not uncommon among them to avoid all subject matter regarding \
		their origins or home. It is likely that most of this knowledge was lost to them upon their exile from their communal thoughtspace, \
		and as such the topic should be avoided in order to not cause further distress."
	)

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
