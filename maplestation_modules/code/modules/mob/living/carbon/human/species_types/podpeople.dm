// -- Podperson species additions --
/datum/species/pod
	species_pain_mod = 1.05

/datum/species/pod/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = "#886600" // player reference :smug:
	human.dna.features["pod_hair"] = "Rose"
	human.update_body(is_creating = TRUE)

/datum/species/pod/get_species_description()
	return "Podpeople are largely peaceful plant based lifeforms, resembling a humanoid figure made of leaves, flowers, and vines."

/datum/species/pod/get_species_lore()
	return list(
		"Little is known about the origins of the Podpeople. \
		Many assume them to be the result of a long forgotten botanical experiment, slowly mutating for years on years until they became the beings they are today. \
		Ever since they were uncovered long ago, their kind have been found on board stations and planets across the galaxy, \
		often working in hydroponics bays, kitchens, or science departments, working with plants and other botanical lifeforms.",
	)

/datum/species/pod/create_pref_unique_perks()
	var/list/perks = ..()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_LEAF,
		SPECIES_PERK_NAME = "Green Thumbs",
		SPECIES_PERK_DESC = "Podpeople are friend to all plants. Hostile sentient \
			plants will not harm them and dangerous botanical produce can \
			be handled without gloves.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SUN,
		SPECIES_PERK_NAME = "Photosynthesis",
		SPECIES_PERK_DESC = "Podpeople feed themselves and heal when exposed to light, \
			but wilt and starve when living in darkness.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_FIRST_AID,
		SPECIES_PERK_NAME = "Plant Matter",
		SPECIES_PERK_DESC = "Podpeople must use plant analyzers to scan themselves \
			instead of heath analyzers.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_BIOHAZARD,
		SPECIES_PERK_NAME = "Weedkiller Susceptability",
		SPECIES_PERK_DESC = "Being a floral life form, you are susceptable to anti-florals and will take extra toxin damage from it!"
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_PAW,
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

/obj/item/organ/tongue/pod
	speech_sound_list = list(
		'maplestation_modules/sound/voice/pod.ogg' = 70,
		'maplestation_modules/sound/voice/pod2.ogg' = 60,
		)
	speech_sound_list_question = null
	speech_sound_list_exclamation = null
