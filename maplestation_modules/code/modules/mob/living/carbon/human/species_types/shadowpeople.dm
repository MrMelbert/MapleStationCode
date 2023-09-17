// -- Shadowperson (& Nightmare) species additions --
/datum/species/shadow
	name = "Shadowperson"

/datum/species/shadow/get_species_speech_sounds(sound_type)
	switch(sound_type)
		if(SOUND_EXCLAMATION)
			return string_assoc_list(list('maplestation_modules/sound/voice/shad_exclaim.ogg' = 55))
		else
			return string_assoc_list(list('maplestation_modules/sound/voice/shad1.ogg' = 55, 'maplestation_modules/sound/voice/shad2.ogg' = 55))
