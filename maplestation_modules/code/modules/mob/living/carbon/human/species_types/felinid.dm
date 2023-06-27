// -- Felinid species additions --
/datum/species/human/felinid

/datum/species/human/felinid/get_species_speech_sounds(sound_type)
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/meow1.ogg' = 50,
		'maplestation_modules/sound/voice/meow2.ogg' = 50,
		'maplestation_modules/sound/voice/meow3.ogg' = 50,
	))
