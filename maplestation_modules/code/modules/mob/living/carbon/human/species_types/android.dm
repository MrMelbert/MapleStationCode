// -- Android species additions --
/datum/species/android
	species_pain_mod = 0.2
	exotic_bloodtype = /datum/blood_type/oil

/datum/species/android/get_species_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))
