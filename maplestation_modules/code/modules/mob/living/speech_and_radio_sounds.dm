/// -- mob/living vars and overrides. --

/// Default, middle frequency
#define DEFAULT_FREQUENCY 44100

/**
 * Gets the sound this mob plays when they speak
 *
 * Returns null or a statically cached list (via string_assoc_list)
 */
/mob/living/proc/get_speech_sounds(sound_type)
	// These sounds have been ported from Goonstation.
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/speak_1.ogg' = 120,
		'maplestation_modules/sound/voice/speak_2.ogg' = 120,
		'maplestation_modules/sound/voice/speak_3.ogg' = 120,
		'maplestation_modules/sound/voice/speak_4.ogg' = 120,
	))

/mob/living/basic/get_speech_sounds(sound_type)
	return

/mob/living/simple_animal/get_speech_sounds(sound_type)
	return

/mob/living/simple_animal/bot/get_speech_sounds(sound_type)
	return string_assoc_list(list('maplestation_modules/sound/voice/radio_ai.ogg' = 100))

/mob/living/silicon/get_speech_sounds(sound_type)
	return string_assoc_list(list('maplestation_modules/sound/voice/radio_ai.ogg' = 100))

/mob/living/carbon/get_speech_sounds(sound_type)
	return dna?.species?.get_species_speech_sound(sound_type)

/**
 * Gets the sound this mob plays when they transmit over radio (to other people on the radio)
 *
 * Returns null or a statically cached list (via string_assoc_list)
 */
/mob/living/proc/get_radio_sounds()
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/radio.ogg' = 75,
		'maplestation_modules/sound/voice/radio_2.ogg' = 75,
	))

/mob/living/simple_animal/bot/get_radio_sounds()
	return string_assoc_list(list('maplestation_modules/sound/voice/radio_ai.ogg' = 100))

/mob/living/silicon/get_radio_sounds()
	return string_assoc_list(list('maplestation_modules/sound/voice/radio_ai.ogg' = 100))

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

	var/list/sound_pool = get_speech_sounds()
	if(!LAZYLEN(sound_pool))
		return

	// Whether this is a question, an exclamation, or neither
	var/sound_type
	// What frequency we pass to playsound for variance. Melbert todo : Add pref for frequency
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
			sound_frequency = round((get_rand_frequency() + get_rand_frequency())/2) //normal speaking is just the average of 2 random frequencies (to trend to the middle)

	var/list/message_mods = list()
	message = get_message_mods(message, message_mods)

	// Pick a sound from our found sounds and play it.
	var/picked_sound = pick(sound_pool)
	if(message_mods[WHISPER_MODE])
		playspeechsound(
			soundin = picked_sound,
			vol = max(10, (chosen_speech_sounds[picked_sound] - 10)),
			vary = TRUE,
			extrarange = -10,
			frequency = sound_frequency,
			pressure_affected = TRUE,
			ignore_walls = FALSE,
			fallof_distance = SILENCED_SOUND_EXTRARANGE,
		)
	else
		playspeechsound(
			soundin = picked_sound,
			vol = chosen_speech_sounds[picked_sound],
			vary = TRUE,
			extrarange = -1-10,
			frequency = sound_frequency,
			pressure_affected = TRUE,
			ignore_walls = FALSE,
		)

/// This is literally a copy paste of playsound that respects the "speech sounds" pref
/mob/living/proc/playspeechsound(soundin, vol as num, vary, extrarange as num, frequency = null, pressure_affected = TRUE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE, channel = 0)
	var/turf/turf_source = get_turf(src)

	if (!turf_source)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	// Looping through the player list has the added bonus of working for mobs inside containers
	var/sound/played_sound = sound(get_sfx(soundin))
	var/maxdistance = SOUND_RANGE + extrarange
	var/source_z = turf_source.z
	var/list/listeners = SSmobs.clients_by_zlevel[source_z].Copy()

	var/turf/above_turf = SSmapping.get_turf_above(turf_source)
	var/turf/below_turf = SSmapping.get_turf_below(turf_source)

	if(!ignore_walls) //these sounds don't carry through walls
		listeners = listeners & hearers(maxdistance,turf_source)

		if(above_turf && istransparentturf(above_turf))
			listeners += hearers(maxdistance,above_turf)

		if(below_turf && istransparentturf(turf_source))
			listeners += hearers(maxdistance,below_turf)

	else
		if(above_turf && istransparentturf(above_turf))
			listeners += SSmobs.clients_by_zlevel[above_turf.z]

		if(below_turf && istransparentturf(turf_source))
			listeners += SSmobs.clients_by_zlevel[below_turf.z]

	for(var/mob/mob_in_range as anything in listeners)
		if(!mob_in_range.client?.prefs?.read_preference(/datum/preference/toggle/toggle_speech))
			continue

		if(get_dist(mob_in_range, turf_source) > maxdistance)
			continue

		mob_in_range.playsound_local(turf_source, soundin, vol, vary, frequency, SOUND_FALLOFF_EXPONENT, channel, pressure_affected, played_sound, maxdistance, falloff_distance, 1, use_reverb)

	for(var/mob/dead_mob_in_range as anything in SSmobs.dead_players_by_zlevel[source_z])
		if(!dead_mob_in_range.client?.prefs?.read_preference(/datum/preference/toggle/toggle_speech))
			continue
		if(get_dist(dead_mob_in_range, turf_source) > maxdistance)
			continue

		dead_mob_in_range.playsound_local(turf_source, soundin, vol, vary, frequency, SOUND_FALLOFF_EXPONENT, channel, pressure_affected, played_sound, maxdistance, falloff_distance, 1, use_reverb)

/// Extend hear so we can have radio messages make radio sounds.
/mob/living/Hear(message, atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	. = ..()

	// No message = no sound.
	if(!message || !client)
		return

	// Don't bother playing sounds to clientless mobs to save time
	if(!client.prefs.read_preference(/datum/preference/toggle/toggle_radio))
		return

	// We only deal with radio messages from this point
	if(!message_mods[MODE_HEADSET] && !message_mods[RADIO_EXTENSION])
		return

	// Speaker typecasted into a virtual speaker (Radios use virtualspeakers)
	var/atom/movable/virtualspeaker/vspeaker = speaker
	// Speaker typecasted into a /mob/living
	var/mob/living/living_speaker
	// Speaker is either a virtual speaker or a mob - whatever it is it needs to be a mob in the end.
	if(istype(vspeaker))
		living_speaker = vspeaker.source
		if(!istype(living_speaker))
			return
	else if(isliving(speaker))
		living_speaker = speaker
	else
		return

	var/list/sound_pool = living_speaker.get_radio_sounds()
	if(!LAZYLEN(sound_pool))
		return

	// Pick a sound from our found sounds and play it.
	var/picked_sound = pick(sound_pool)
	var/radio_sound_vol = chosen_speech_sounds[picked_sound]
	if(living_speaker != src)
		chosen_speech_sounds[picked_sound] -= 10

	// It would be pretty cool to make this come from nearby intercoms, if that's how they're hearing the radio -
	// But that's for a later time. At least when I undertand vspeakers more
	playsound_local(
		source = get_turf(src),
		soundin = picked_sound,
		vol = radio_sound_vol,
		vary = TRUE,
	)

#undef DEFAULT_FREQUENCY
