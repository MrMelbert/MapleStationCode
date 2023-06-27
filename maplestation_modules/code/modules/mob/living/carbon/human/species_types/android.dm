// -- Android species additions --
/datum/species/android
	species_pain_mod = 0.2

/datum/species/android/get_species_speech_sounds(sound_type)
	return string_assoc_list(list('maplestation_modules/sound/voice/radio_ai.ogg' = 100))
