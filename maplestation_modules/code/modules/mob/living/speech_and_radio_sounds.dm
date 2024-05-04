/// -- mob/living vars and overrides. --

/// Default, middle frequency
#define DEFAULT_FREQUENCY 44100

/mob/living
	/// Modifier to speech sounds frequency
	/// Lower = longer, deeper speech sounds
	/// Higher = quicker, higher-pitch speech sounds
	var/speech_sound_frequency_modifier = 1
	/// Modifier to speech sounds pitch
	/// Like frequency but doesn't affect length
	/// Lower = deeper speech sounds
	/// Higher = higher-pitch speech sounds
	var/speech_sound_pitch_modifier = 1

/mob/living/silicon
	speech_sound_frequency_modifier = -1 // is set from preferences when we first speak.
	speech_sound_pitch_modifier = -1 // ditto

/**
 * Gets the sound this mob plays when they speak
 *
 * Returns null or a statically cached list (via string_assoc_list)
 */
/mob/living/proc/get_speech_sounds(sound_type)
	// These sounds have been ported from Goonstation.
	return string_assoc_list(list(
		'goon/sound/voice/speak_1.ogg' = 120,
		'goon/sound/voice/speak_2.ogg' = 120,
		'goon/sound/voice/speak_3.ogg' = 120,
		'goon/sound/voice/speak_4.ogg' = 120,
	))

/mob/living/basic/get_speech_sounds(sound_type)
	return

/mob/living/simple_animal/get_speech_sounds(sound_type)
	return

/mob/living/simple_animal/bot/get_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/silicon/get_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/carbon/get_speech_sounds(sound_type)
	return dna?.species?.get_species_speech_sounds(sound_type)

/**
 * Gets the sound this movable plays when they transmit over radio (to other people on the radio)
 *
 * Returns null or a statically cached list (via string_assoc_list)
 */
/atom/movable/proc/get_radio_sounds()
	return

/mob/living/get_radio_sounds()
	return string_assoc_list(list(
		'goon/sound/voice/radio.ogg' = 75,
		'goon/sound/voice/radio_2.ogg' = 75,
	))

/mob/living/simple_animal/bot/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/basic/bot/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/silicon/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/proc/update_pitch_and_frequency()
	speech_sound_frequency_modifier = 1
	speech_sound_pitch_modifier = 1

/mob/living/carbon/human/update_pitch_and_frequency()
	speech_sound_frequency_modifier = client?.prefs?.read_preference(/datum/preference/numeric/frequency_modifier) || 1
	speech_sound_pitch_modifier = client?.prefs?.read_preference(/datum/preference/numeric/pitch_modifier) || 1

/mob/living/silicon/update_pitch_and_frequency()
	speech_sound_frequency_modifier = client?.prefs?.read_preference(/datum/preference/numeric/frequency_modifier) || 1
	speech_sound_pitch_modifier = client?.prefs?.read_preference(/datum/preference/numeric/pitch_modifier) || 1

/// Extend say so we can have talking make sounds.
/mob/living/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, filterproof = null, message_range = 7, datum/saymode/saymode = null)
	. = ..()
	// If say failed for some reason we should probably fail
	if(!.)
		return
	// Eh, probably don't play a sound if it's forced (like spells)
	if(forced)
		return
	// No sounds for sign language folk
	if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
		return

	// Whether this is a question, an exclamation, or neither
	var/sound_type
	// What frequency we pass to playsound for variance.
	var/sound_frequency = DEFAULT_FREQUENCY
	// Determine if this is a question, an exclamation, or neither and update sound_type and sound_frequency accordingly.
	switch(copytext_char(message, -1))
		if("?")
			sound_type = SOUND_QUESTION
			sound_frequency = rand(DEFAULT_FREQUENCY, 55000) //questions are raised in the end
		if("!")
			sound_type = SOUND_EXCLAMATION
			sound_frequency = rand(32000, DEFAULT_FREQUENCY) //exclamations are lowered in the end
		else
			sound_type = SOUND_NORMAL
			sound_frequency = round((get_rand_frequency() + get_rand_frequency()) / 2) //normal speaking is just the average of 2 random frequencies (to trend to the middle)

	// [speech_sound_frequency_modifier] is set directly for humans via pref [apply_to_humans], but for other mobs we need to double-check
	if(speech_sound_frequency_modifier == -1 || speech_sound_pitch_modifier == -1)
		update_pitch_and_frequency()

	sound_frequency *= speech_sound_frequency_modifier

	var/list/sound_pool = get_speech_sounds(sound_type)
	if(!LAZYLEN(sound_pool))
		return
	var/list/message_mods = list()
	message = get_message_mods(message, message_mods)

	// Pick a sound from our found sounds and play it.
	var/picked_sound = pick(sound_pool)
	var/speech_sound_vol = sound_pool[picked_sound]
	var/speech_sound_rangemod = -10 // 7 range
	if(message_mods[WHISPER_MODE])
		speech_sound_vol = max(speech_sound_vol - 10, 10)
		speech_sound_rangemod = -15 // 2 range

	var/sound/the_sound = sound(picked_sound)
	the_sound.pitch = speech_sound_pitch_modifier
	the_sound.frequency = sound_frequency
	if(is_mouth_covered())
		the_sound.echo[1] = -900
		speech_sound_vol *= 1.5

	playsound(
		source = src,
		soundin = the_sound,
		vol = speech_sound_vol,
		vary = FALSE,
		extrarange = speech_sound_rangemod,
		pressure_affected = TRUE,
		ignore_walls = FALSE,
		pref_to_use = /datum/preference/toggle/toggle_speech,
	)

/obj/item/radio/talk_into_impl(atom/movable/talking_movable, message, channel, list/spans, datum/language/language, list/message_mods)
	. = ..()
	if(!.)
		return
	if(!isliving(talking_movable))
		return

	var/mob/living/radio_guy = talking_movable

	var/list/radio_sound_pool = radio_guy.get_radio_sounds()
	if(!LAZYLEN(radio_sound_pool))
		return

	var/picked_radio_sound = pick(radio_sound_pool)
	playsound(
		source = src,
		soundin = picked_radio_sound,
		vol = max(radio_sound_pool[picked_radio_sound] - 10, 10),
		vary = TRUE,
		extrarange = -15, // 2 range
		pressure_affected = TRUE,
		ignore_walls = FALSE,
		pref_to_use = /datum/preference/toggle/toggle_radio,
	)

#undef DEFAULT_FREQUENCY
