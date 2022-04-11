/// -- Extensions of species and species procs. --
/datum/species
	/// Assoc list of [sounds that play on speech for mobs of this species] to [volume].
	var/species_speech_sounds = list('maplestation_modules/sound/voice/speak_1.ogg' = 120, \
									'maplestation_modules/sound/voice/speak_2.ogg' = 120, \
									'maplestation_modules/sound/voice/speak_3.ogg' = 120, \
									'maplestation_modules/sound/voice/speak_4.ogg' = 120)
	/// Assoc list of [sounds that play on question for mobs of this species] to [volume].
	var/species_speech_sounds_ask = list('maplestation_modules/sound/voice/speak_1_ask.ogg' = 120, \
										'maplestation_modules/sound/voice/speak_2_ask.ogg' = 120, \
										'maplestation_modules/sound/voice/speak_3_ask.ogg' = 120, \
										'maplestation_modules/sound/voice/speak_4_ask.ogg' = 120)
	/// Assoc list of [sounds that play on exclamation for mobs of this species] to [volume].
	var/species_speech_sounds_exclaim = list('maplestation_modules/sound/voice/speak_1_exclaim.ogg' = 120, \
											'maplestation_modules/sound/voice/speak_2_exclaim.ogg' = 120, \
											'maplestation_modules/sound/voice/speak_3_exclaim.ogg' = 120, \
											'maplestation_modules/sound/voice/speak_4_exclaim.ogg' = 120)
	/// Pain modifier that this species receives.
	var/species_pain_mod = null
