// -- Ethereal species additions --
/datum/species/ethereal

/datum/species/ethereal/get_species_speech_sounds(sound_type)
	switch(sound_type)
		if(SOUND_QUESTION)
			return string_assoc_list(list('maplestation_modules/sound/voice/etheral_ask.ogg' = 80))
		if(SOUND_EXCLAMATION)
			return string_assoc_list(list('maplestation_modules/sound/voice/etheral_exclaim.ogg' = 80))
		else
			return string_assoc_list(list('maplestation_modules/sound/voice/etheral.ogg' = 60))
