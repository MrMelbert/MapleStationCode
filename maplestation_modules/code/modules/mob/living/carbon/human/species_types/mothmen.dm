// -- Mothperson species additions --
/datum/species/moth
	species_pain_mod = 1.1

/datum/species/moth/get_species_speech_sounds(sound_type)
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/moff_1.ogg' = 80,
		'maplestation_modules/sound/voice/moff_2.ogg' = 80,
		'maplestation_modules/sound/voice/moff_3.ogg' = 80,
	))
