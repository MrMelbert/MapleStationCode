// -- Podperson species additions --
/datum/species/pod
	species_speech_sounds = list(
		'maplestation_modules/sound/voice/pod.ogg' = 70,
		'maplestation_modules/sound/voice/pod2.ogg' = 60,
	)
	species_speech_sounds_ask = list()
	species_speech_sounds_exclaim = list()
	species_pain_mod = 1.05

/datum/species/pod/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = "886600" // player reference :smug:
	human.dna.features["pod_hair"] = "Rose"
	human.update_body(is_creating = TRUE)

/datum/species/pod/get_species_description()
	return "Podpeople are made of plants!"

/datum/species/pod/get_species_lore()
	return list("Podpserson lore.")

/datum/species/pod/create_pref_unique_perks()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "leaf",
		SPECIES_PERK_NAME = "Green Thumbs",
		SPECIES_PERK_DESC = "Podpeople are friend to all plants. Hostile sentient \
			plants will not harm them and dangerous botanical produce can \
			be handled without gloves.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "sun",
		SPECIES_PERK_NAME = "Photosynthesis",
		SPECIES_PERK_DESC = "Podpeople feed themselves and heal when exposed to light, \
			and wilt and starve when living in darkness.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "first-aid",
		SPECIES_PERK_NAME = "Plant Matter",
		SPECIES_PERK_DESC = "Podpeople must use plant analyzers to scan themselves \
			instead of heath analyzers.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "paw",
		SPECIES_PERK_NAME = "Herbivore Target",
		SPECIES_PERK_DESC = "Being made of plants and leaves, podpeople are a target \
			of herbivorous creatures such as goats.",
	))
	return perks

/datum/species/pod/create_pref_damage_perks()
	return null

/datum/species/pod/create_pref_temperature_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "burn",
		SPECIES_PERK_NAME = "Leafy Skin",
		SPECIES_PERK_DESC = "As their skin and flesh is made from leaves and stems, \
			podpeople are more vulnerable to fire.",
	))
	return perks
