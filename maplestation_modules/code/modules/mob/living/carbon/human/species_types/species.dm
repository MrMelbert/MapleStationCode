/// -- Extensions of species and species procs. --
/datum/species
	/// Pain modifier that this species receives.
	var/species_pain_mod = 1

/datum/species/proc/get_species_speech_sounds(sound_type)
	switch(sound_type)
		if(SOUND_QUESTION)
			return string_assoc_list(list(
				'goon/sound/voice/speak_1_ask.ogg' = 120,
				'goon/sound/voice/speak_2_ask.ogg' = 120,
				'goon/sound/voice/speak_3_ask.ogg' = 120,
				'goon/sound/voice/speak_4_ask.ogg' = 120,
			))
		if(SOUND_EXCLAMATION)
			return string_assoc_list(list(
				'goon/sound/voice/speak_1_exclaim.ogg' = 120,
				'goon/sound/voice/speak_2_exclaim.ogg' = 120,
				'goon/sound/voice/speak_3_exclaim.ogg' = 120,
				'goon/sound/voice/speak_4_exclaim.ogg' = 120,
			))
		else
			return string_assoc_list(list(
				'goon/sound/voice/speak_1.ogg' = 120,
				'goon/sound/voice/speak_2.ogg' = 120,
				'goon/sound/voice/speak_3.ogg' = 120,
				'goon/sound/voice/speak_4.ogg' = 120,
			))

/datum/species/create_pref_damage_perks()
	var/list/perks = ..()

	if(isnum(species_pain_mod) && species_pain_mod != 1)
		var/negative = species_pain_mod > 1
		perks += list(list(
			SPECIES_PERK_TYPE = negative ? SPECIES_NEGATIVE_PERK : SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "band-aid",
			SPECIES_PERK_NAME = "Pain [negative ? "Vulnerability" : "Resilience"]",
			SPECIES_PERK_DESC = "[plural_form] take [negative ? "more" : "less"] pain on average.",
		))

	if (isnum(damage_modifier) && damage_modifier != 0)
		var/negative = damage_modifier < 1
		perks += list(list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "shield",
			SPECIES_PERK_NAME = "[negative ? "Vulnerable" : "Armored"]",
			SPECIES_PERK_DESC = "[plural_form] are [negative ? "physically vulnerable" : "armored"], [negative ? "increasing" : "decreasing"] external damage taken by [abs(damage_modifier)]%.",
		))

	return perks
