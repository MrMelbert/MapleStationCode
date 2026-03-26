//Darude sandstorm starts playing
/datum/weather/sand_storm
	name = "severe sandstorm"
	desc = "A severe dust storm that engulfs an area, dealing intense damage to the unprotected."
	probability = 90

	telegraph_message = span_danger("You see a dust cloud rising over the horizon. That can't be good...")
	telegraph_duration = 30 SECONDS
	telegraph_overlay = "dust_med"
	// telegraph_sound = 'sound/effects/siren.ogg'

	weather_message = span_userdanger("<i>Hot sand and wind batter you! Get inside!</i>")
	weather_duration_lower = 1 MINUTES
	weather_duration_upper = 2 MINUTES
	weather_overlay = "dust_high"

	end_message = span_bolddanger("The shrieking wind whips away the last of the sand and falls to its usual murmur. It should be safe to go outside now.")
	end_duration = 30 SECONDS
	end_overlay = "dust_med"

	area_type = /area
	protect_indoors = TRUE
	target_trait = ZTRAIT_SANDSTORM
	immunity_type = TRAIT_SANDSTORM_IMMUNE
	probability = 90

	// weather_flags = (WEATHER_MOBS | WEATHER_BAROMETER)

	barometer_predictable = TRUE

// /datum/weather/sand_storm/get_playlist_ref()
// 	return GLOB.sand_storm_sounds

/datum/weather/sand_storm/can_get_alert(mob/player)
	if(!..())
		return FALSE

	if(!is_station_level(player.z))
		return TRUE // bypass checks

	if(isobserver(player))
		return TRUE

	if(HAS_MIND_TRAIT(player, TRAIT_DETECT_STORM))
		return TRUE

	if(istype(get_area(player), /area/mine))
		return TRUE

	for(var/area/snow_area in impacted_areas)
		if(locate(snow_area) in view(player))
			return TRUE

	return FALSE

/datum/weather/sand_storm/telegraph()
	GLOB.sand_storm_sounds.Cut()
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.sand_storm_sounds[impacted_area] = /datum/looping_sound/weak_outside_ashstorm
	return ..()

/datum/weather/sand_storm/start()
	GLOB.sand_storm_sounds.Cut()
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.sand_storm_sounds[impacted_area] = /datum/looping_sound/active_outside_ashstorm
	return ..()

/datum/weather/sand_storm/wind_down()
	GLOB.sand_storm_sounds.Cut()
	for(var/area/impacted_area as anything in impacted_areas)
		GLOB.sand_storm_sounds[impacted_area] = /datum/looping_sound/weak_outside_ashstorm
	return ..()

/datum/weather/sand_storm/end()
	. = ..()
	GLOB.sand_storm_sounds.Cut()

/datum/weather/sand_storm/weather_act(mob/living/victim)
	if(!ishuman(victim))
		victim.adjustBruteLoss(5, required_bodytype = BODYTYPE_ORGANIC)
		return

	for(var/zone in GLOB.all_body_zones)
		victim.apply_damage(1, BRUTE, zone, victim.getarmor(zone, BOMB))
	victim.adjust_body_temperature(0.5 KELVIN, use_insulation = TRUE)
	if(!victim.is_eyes_covered() && victim.get_organ_slot(ORGAN_SLOT_EYES))
		victim.adjust_eye_blur_up_to(4 SECONDS, 1 MINUTES)
		if(prob(10))
			to_chat(victim, span_warning("Sand gets in your eyes!"))
			if(prob(20))
				victim.adjust_temp_blindness(4 SECONDS)

/datum/weather/sand_storm/harmless
	name = "sandfall"
	desc = "A passing sandstorm blankets the area in sand."

	telegraph_message = span_danger("The wind begins to intensify, blowing sand up from the ground...")
	telegraph_overlay = "dust_low"
	telegraph_sound = null

	weather_message = span_notice("Gentle sand wafts down around you like grotesque snow. The storm seems to have passed you by...")
	weather_overlay = "dust_med"

	end_message = span_notice("The sandfall slows, stops. Another layer of sand on the mesa beneath your feet.")
	end_overlay = "dust_low"

	probability = 10
	// weather_flags = parent_type::weather_flags & ~WEATHER_MOBS
