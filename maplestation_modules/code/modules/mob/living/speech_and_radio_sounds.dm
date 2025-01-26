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

/**
 * Gets the sound this movable plays when they speak
 *
 * * sound_type: SOUND_NORMAL, SOUND_QUESTION, SOUND_EXCLAMATION
 *
 * Returns null or a statically cached list (via string_assoc_list)
 */
/atom/movable/proc/get_speech_sounds(sound_type)
	return

/mob/living/get_speech_sounds(sound_type)
	// These sounds have been ported from Goonstation.
	return string_assoc_list(list(
		'goon/sound/voice/speak_1.ogg' = 120,
		'goon/sound/voice/speak_2.ogg' = 120,
		'goon/sound/voice/speak_3.ogg' = 120,
		'goon/sound/voice/speak_4.ogg' = 120,
	))

/mob/living/basic/get_speech_sounds(sound_type)
	return

/mob/living/basic/drone/get_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/simple_animal/get_speech_sounds(sound_type)
	return

/mob/living/circuit_drone/get_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/simple_animal/bot/get_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/silicon/get_speech_sounds(sound_type)
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/carbon/get_speech_sounds(sound_type)
	if(HAS_TRAIT(src, TRAIT_UNKNOWN))
		return ..()
	if(HAS_TRAIT(src, TRAIT_SIGN_LANG))
		return null
	var/obj/item/organ/internal/tongue/tongue = src?.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(isnull(tongue))
		return null
	if(!tongue.speech_sounds_enabled)
		return null
	if(tongue.speech_sound_only_normal)
		sound_type = SOUND_NORMAL
	switch(sound_type)
		if(SOUND_NORMAL)
			return string_assoc_list(tongue.speech_sound_list)
		if(SOUND_QUESTION)
			return string_assoc_list(tongue.speech_sound_list_question)
		if(SOUND_EXCLAMATION)
			return string_assoc_list(tongue.speech_sound_list_exclamation)
	return null

/mob/living/basic/robot_customer/get_speech_sounds(sound_type)
	var/datum/customer_data/customer_info = ai_controller?.blackboard[BB_CUSTOMER_CUSTOMERINFO]
	if(isnull(customer_info?.speech_sound))
		return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))
	return string_assoc_list(list("[customer_info.speech_sound]" = 30))

/**
 * Gets the sound this movable plays when they transmit over radio (to other people on the radio)
 *
 * Returns null or a statically cached list (via string_assoc_list)
 */
/atom/movable/proc/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/get_radio_sounds()
	return string_assoc_list(list(
		'goon/sound/voice/radio.ogg' = 75,
		'goon/sound/voice/radio_2.ogg' = 75,
	))

/mob/living/simple_animal/bot/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/basic/bot/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/basic/drone/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/silicon/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/mob/living/circuit_drone/get_radio_sounds()
	return string_assoc_list(list('goon/sound/voice/radio_ai.ogg' = 100))

/// Extend say so we can have talking make sounds.
/mob/living/send_speech(message_raw, message_range, obj/source, bubble_type, list/spans, datum/language/message_language, list/message_mods, forced, tts_message, list/tts_filter)
	. = ..()
	if(message_mods[MODE_CUSTOM_SAY_ERASE_INPUT])
		return

	// Whether this is a question, an exclamation, or neither
	var/sound_type
	// What frequency we pass to playsound for variance.
	var/sound_frequency = DEFAULT_FREQUENCY
	// Determine if this is a question, an exclamation, or neither and update sound_type and sound_frequency accordingly.
	switch(copytext_char(message_raw, -1))
		if("?")
			sound_type = SOUND_QUESTION
			sound_frequency = rand(DEFAULT_FREQUENCY, 55000) //questions are raised in the end
		if("!")
			sound_type = SOUND_EXCLAMATION
			sound_frequency = rand(32000, DEFAULT_FREQUENCY) //exclamations are lowered in the end
		else
			sound_type = SOUND_NORMAL
			sound_frequency = round((get_rand_frequency() + get_rand_frequency()) / 2) //normal speaking is just the average of 2 random frequencies (to trend to the middle)

	var/list/sound_pool = get_speech_sounds(sound_type)
	if(!length(sound_pool))
		return

	// Pick a sound from our found sounds and play it.
	var/picked_sound = pick(sound_pool)
	var/speech_sound_vol = sound_pool[picked_sound]
	var/speech_sound_rangemod = -10 // 7 range
	if(message_mods[WHISPER_MODE])
		speech_sound_vol = max(speech_sound_vol - 10, 10)
		speech_sound_rangemod = -15 // 2 range

	var/sound/the_sound = sound(picked_sound)
	the_sound.pitch = speech_sound_pitch_modifier
	the_sound.frequency = sound_frequency * speech_sound_frequency_modifier
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
	var/list/radio_sound_pool = talking_movable.get_radio_sounds()
	if(!length(radio_sound_pool))
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
