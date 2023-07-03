// -- Plasmaman species additions --
/datum/species/plasmaman
	species_pain_mod = 0.75

/datum/species/plasmaman/get_species_speech_sounds(sound_type)
	switch(sound_type)
		if(SOUND_QUESTION)
			return string_assoc_list(list('maplestation_modules/sound/voice/skelly_ask.ogg' = 90))
		if(SOUND_EXCLAMATION)
			return string_assoc_list(list('maplestation_modules/sound/voice/skelly_exclaim.ogg' = 90))
		else
			return string_assoc_list(list('maplestation_modules/sound/voice/skelly.ogg' = 90))
