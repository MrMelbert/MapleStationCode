
///Default override for echo
/sound
	environment = SOUND_ENVIRONMENT_NONE //Default to none so sounds without overrides dont get reverb

/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * source - Origin of sound.
 * soundin - Either a file, or a string that can be used to get an SFX.
 * vol - The volume of the sound, excluding falloff and pressure affection.
 * vary - bool that determines if the sound changes pitch every time it plays.
 * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE.
 * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * frequency - playback speed of audio.
 * channel - The channel the sound is played at.
 * pressure_affected - Whether or not difference in pressure affects the sound (E.g. if you can hear in space).
 * ignore_walls - Whether or not the sound can pass through walls.
 * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 */
/proc/playsound(
	atom/source,
	soundin,
	vol as num,
	vary,
	extrarange as num,
	falloff_exponent = SOUND_FALLOFF_EXPONENT,
	frequency = null,
	channel = 0,
	pressure_affected = TRUE,
	ignore_walls = TRUE,
	falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE,
	use_reverb = TRUE,
	pref_to_use, // NON-MODULE CHANGE
)
	if(isarea(source))
		CRASH("playsound(): source is an area")

	var/turf/turf_source = get_turf(source)

	if (!turf_source || !soundin || !vol)
		return

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/used_sound = isdatum(soundin) ? soundin : sound(get_sfx(soundin)) // NON-MODULE CHANGE
	var/maxdistance = SOUND_RANGE + extrarange
	var/source_z = turf_source.z
	var/list/listeners = SSmobs.clients_by_zlevel[source_z].Copy()

	. = list()//output everything that successfully heard the sound

	var/turf/above_turf = GET_TURF_ABOVE(turf_source)
	var/turf/below_turf = GET_TURF_BELOW(turf_source)

	if(ignore_walls)

		if(above_turf && istransparentturf(above_turf))
			listeners += SSmobs.clients_by_zlevel[above_turf.z]

		if(below_turf && istransparentturf(turf_source))
			listeners += SSmobs.clients_by_zlevel[below_turf.z]

	else //these sounds don't carry through walls
		listeners = get_hearers_in_view(maxdistance, turf_source)

		if(above_turf && istransparentturf(above_turf))
			listeners += get_hearers_in_view(maxdistance, above_turf)

		if(below_turf && istransparentturf(turf_source))
			listeners += get_hearers_in_view(maxdistance, below_turf)

	for(var/mob/listening_mob in listeners | SSmobs.dead_players_by_zlevel[source_z])//observers always hear through walls
		// NON-MODULE CHANGE
		if(pref_to_use && listening_mob.client && !listening_mob.client.prefs.read_preference(pref_to_use))
			continue

		if(get_dist(listening_mob, turf_source) > maxdistance)
			if(!(listening_mob.mob_flags & MOB_HAS_HEARING_RELAY))
				continue

			var/mob/true_hearer = listening_mob.get_hearing_relay(source)
			if(QDELETED(true_hearer))
				continue

			if(true_hearer == listening_mob)
				stack_trace("Mob [listening_mob] ([listening_mob.type]) has MOB_HAS_HEARING_RELAY but returned self as true hearer")
				listening_mob.mob_flags &= ~MOB_HAS_HEARING_RELAY // disable the flag as it's clearly wrong
				continue

			if(get_dist(true_hearer, turf_source) > maxdistance)
				continue

			listening_mob = true_hearer

		listening_mob.playsound_local(
			turf_source = turf_source,
			soundin = soundin,
			sound_to_use = used_sound,
			vol = vol,
			vary = vary,
			frequency = frequency,
			falloff_exponent = falloff_exponent,
			channel = channel,
			pressure_affected = pressure_affected,
			max_distance = maxdistance,
			falloff_distance = falloff_distance,
			distance_multiplier = 1,
			use_reverb = use_reverb,
		)
		. += listening_mob
		// NON-MODULE CHANGE END

/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent = SOUND_FALLOFF_EXPONENT, channel = 0, pressure_affected = TRUE, sound/sound_to_use, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE)
	if(!client || !can_hear())
		return

	if(!sound_to_use)
		sound_to_use = sound(get_sfx(soundin))

	sound_to_use.wait = 0 //No queue
	sound_to_use.channel = channel || SSsounds.random_available_channel()
	sound_to_use.volume = vol

	if(vary)
		if(frequency)
			sound_to_use.frequency = frequency
		else
			sound_to_use.frequency = get_rand_frequency()

	if(isturf(turf_source))
		var/turf/turf_loc = get_turf(src)

		//sound volume falloff with distance
		var/distance = get_dist(turf_loc, turf_source) * distance_multiplier

		if(max_distance) //If theres no max_distance we're not a 3D sound, so no falloff.
			sound_to_use.volume -= (max(distance - falloff_distance, 0) ** (1 / falloff_exponent)) / ((max(max_distance, distance) - falloff_distance) ** (1 / falloff_exponent)) * sound_to_use.volume
			//https://www.desmos.com/calculator/sqdfl8ipgf

		if(pressure_affected)
			//Atmosphere affects sound
			var/pressure_factor = 1
			var/datum/gas_mixture/hearer_env = turf_loc.return_air()
			var/datum/gas_mixture/source_env = turf_source.return_air()

			if(hearer_env && source_env)
				var/pressure = min(hearer_env.return_pressure(), source_env.return_pressure())
				if(pressure < ONE_ATMOSPHERE)
					pressure_factor = max((pressure - SOUND_MINIMUM_PRESSURE)/(ONE_ATMOSPHERE - SOUND_MINIMUM_PRESSURE), 0)
			else //space
				pressure_factor = 0

			if(distance <= 1)
				pressure_factor = max(pressure_factor, 0.15) //touching the source of the sound

			sound_to_use.volume *= pressure_factor
			//End Atmosphere affecting sound

		if(sound_to_use.volume <= 0)
			return //No sound

		var/dx = turf_source.x - turf_loc.x // Hearing from the right/left
		sound_to_use.x = dx * distance_multiplier
		var/dz = turf_source.y - turf_loc.y // Hearing from infront/behind
		sound_to_use.z = dz * distance_multiplier
		var/dy = (turf_source.z - turf_loc.z) * 5 * distance_multiplier // Hearing from  above / below, multiplied by 5 because we assume height is further along coords.
		sound_to_use.y = dy

		sound_to_use.falloff = max_distance || 1 //use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant.

		// Sounds can't have their own environment. A sound's environment will be:
		// 1. the mob's
		// 2. the area's (defaults to SOUND_ENVRIONMENT_NONE)
		if(sound_environment_override != SOUND_ENVIRONMENT_NONE)
			sound_to_use.environment = sound_environment_override
		else
			var/area/A = get_area(src)
			sound_to_use.environment = A.sound_environment

		if(!use_reverb || sound_to_use.environment == SOUND_ENVIRONMENT_NONE) // Disable revert
			sound_to_use.echo ||= EAX2_DEFAULT_ECHO
			sound_to_use.echo[ECHO_INDEX_ROOM] = -10000 // -10000 = no reverb
			sound_to_use.echo[ECHO_INDEX_ROOMHF] = -10000 // -10000 = no reverb
			sound_to_use.echo[ECHO_INDEX_FLAGS] = NONE

	SEND_SOUND(src, sound_to_use)

/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, null, channel, pressure_affected, S)

/mob/proc/stop_sound_channel(chan)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/client/proc/playtitlemusic(volume_multiplier = 1)
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music

	var/volume = prefs.read_preference(/datum/preference/numeric/volume/sound_lobby_volume) * volume_multiplier
	if(volume > 0 && !CONFIG_GET(flag/disallow_title_music))
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 0, wait = 0, volume = volume, channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS
		for(var/atom/movable/screen/lobby_music/text in mob.hud_used?.static_inventory)
			text.start_tracking()

/client/proc/stoptitlemusic()
	mob.stop_sound_channel(CHANNEL_LOBBYMUSIC)
	for(var/atom/movable/screen/lobby_music/text in mob.hud_used?.static_inventory)
		text.cancel_tracking()

/// If this mob is out of range of a sound, it might have a relay that can hear it instead.
/mob/proc/get_hearing_relay(atom/source)
	return src

/mob/living/silicon/ai/get_hearing_relay(atom/source)
	return eyeobj

/mob/camera/ai_eye/proc/has_nearby_radio(turf/turf_source)
	for(var/obj/item/radio/intercom/radio in dview(5, turf_source))
		if(radio.is_on_and_listening())
			return TRUE
	return FALSE

/mob/camera/ai_eye/playsound_local(turf/turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, sound/sound_to_use, max_distance, falloff_distance, distance_multiplier, use_reverb)
	if(client)
		// cameras shouldn't *have* clients, but just in case..?
		return ..()
	if(isnull(ai?.client))
		// don't waste time
		return
	if(!has_nearby_radio(turf_source))
		// no intercom to "transmit" the sound
		return

	// we gotta be on the same z-level right
	if(turf_source.z != ai.z)
		turf_source = locate(turf_source.x, turf_source.y, ai.z)

	// moves the source to somewhere around the ai, otherwise they wouldn't hear it
	turf_source = get_ranged_target_turf(ai, get_dir(src, turf_source), max_distance * 0.5)
	// if a sound datum was passed, we need to make a copy or else we mutate everyone else's sound
	sound_to_use = isdatum(sound_to_use) ? copy_sound(sound_to_use) : sound(get_sfx(soundin))
	// pitches down the sound a bit so the ai can differentiate it from sounds actually near their core
	sound_to_use.pitch ||= 1
	sound_to_use.pitch *= 0.8
	// and disable these since we're beaming it straight to the ai
	use_reverb = FALSE
	pressure_affected = FALSE

	// relay it to the ai
	ai.playsound_local(arglist(args))

///get a random frequency.
/proc/get_rand_frequency()
	return rand(32000, 55000)

///get_rand_frequency but lower range.
/proc/get_rand_frequency_low_range()
	return rand(38000, 45000)

/// Make a copy of a sound datum
/proc/copy_sound(sound/input)
	var/sound/new_sound = sound(input.file)
	new_sound.channel = input.channel
	new_sound.environment = input.environment
	new_sound.falloff = input.falloff
	new_sound.frequency = input.frequency
	new_sound.offset = input.offset
	new_sound.pan = input.pan
	new_sound.pitch = input.pitch
	new_sound.repeat = input.repeat
	new_sound.volume = input.volume
	new_sound.x = input.x
	new_sound.y = input.y
	new_sound.z = input.z
	if(islist(new_sound.echo))
		var/list/old_echo = input.echo
		new_sound.echo = old_echo.Copy()
	return new_sound

/proc/get_sfx(soundin)
	if(!istext(soundin))
		return soundin
	var/datum/sound_effect/sfx = GLOB.sfx_datum_by_key[soundin]
	return sfx?.return_sfx() || soundin
