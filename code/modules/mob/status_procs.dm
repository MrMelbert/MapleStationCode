//Here are the procs used to modify status effects of a mob.

///Adjust the disgust level of a mob
/mob/proc/adjust_disgust(amount)
	return

///Set the disgust level of a mob
/mob/proc/set_disgust(amount)
	return

/**
 * Get the insulation that is appropriate to the temperature you're being exposed to.
 * All clothing, natural insulation, and traits are combined returning a single value.
 *
 * required temperature The Temperature that you're being exposed to
 *
 * return the percentage of protection as a value from 0 - 1
**/
/mob/living/proc/get_insulation_protection(temperature)
	return (temperature > body_temperature) ? get_heat_protection(temperature) : get_cold_protection(temperature)

/// This returns the percentage of protection from heat as a value from 0 - 1
/// temperature is the temperature you're being exposed to
/mob/living/proc/get_heat_protection(temperature)
	return heat_protection

/// This returns the percentage of protection from cold as a value from 0 - 1
/// temperature is the temperature you're being exposed to
/mob/living/proc/get_cold_protection(temperature)
	return cold_protection

/mob/living/proc/adjust_body_temperature(amount = 0, min_temp = 0, max_temp = INFINITY, use_insulation = FALSE)
	// apply insulation to the amount of change
	if(use_insulation)
		amount *= (1 - get_insulation_protection(body_temperature + amount))
	if(amount == 0)
		return FALSE
	amount = round(amount, 0.01)

	if(body_temperature >= min_temp && body_temperature <= max_temp)
		var/old_temp = body_temperature
		body_temperature = clamp(body_temperature + amount, min_temp, max_temp)
		SEND_SIGNAL(src, COMSIG_LIVING_BODY_TEMPERATURE_CHANGE, old_temp, body_temperature)
		// body_temperature_alerts()

#ifdef TESTING
		if(mind)
			maptext_width = 128
			maptext_x = -16
			maptext_y = -12
			var/r_or_b = body_temperature - old_temp > 0 ? "red" : "blue"
			maptext = MAPTEXT("Temp: [body_temperature]K <font color='[r_or_b]'>([amount]K)</font>")
#endif
		return TRUE
	return FALSE

// Robot bodytemp unimplemented for now. Add overheating later >:3
/mob/living/silicon/adjust_body_temperature(amount, min_temp, max_temp, use_insulation)
	return

/**
 * Get the temperature of the skin of the mob
 *
 * This is a weighted average of the body temperature and the temperature of the air around the mob,
 * plus some other modifiers
 */
/mob/living/proc/get_skin_temperature()
	var/area_temp = get_temperature(loc?.return_air())
	var/protection = get_insulation_protection(area_temp)
	area_temp *= (1 - protection)
	if(!(mob_biotypes & MOB_ORGANIC))
		return area_temp // non-organic mobs likely don't feel or regulate temperature so we can just report the area temp

	. = ((body_temperature * 2) + area_temp) / (3 - protection)
	if(body_temperature >= standard_body_temperature + 2 KELVIN)
		. *= 1.1 // sweating
//	if(body_temperature <= HYPOTHERMIA)
//		. *= 0.8 // extremities are colder
	if(on_fire)
		. += fire_stacks ** 2 KELVIN
	return round(., 0.01)

/// Sight here is the mob.sight var, which tells byond what to actually show to our client
/// See [code\__DEFINES\sight.dm] for more details
/mob/proc/set_sight(new_value)
	SHOULD_CALL_PARENT(TRUE)
	if(sight == new_value)
		return
	var/old_sight = sight
	sight = new_value

	SEND_SIGNAL(src, COMSIG_MOB_SIGHT_CHANGE, new_value, old_sight)

/mob/proc/add_sight(new_value)
	set_sight(sight | new_value)

/mob/proc/clear_sight(new_value)
	set_sight(sight & ~new_value)

/// see invisibility is the mob's capability to see things that ought to be hidden from it
/// Can think of it as a primitive version of changing the alpha of planes
/// We mostly use it to hide ghosts, no real reason why
/mob/proc/set_invis_see(new_sight)
	SHOULD_CALL_PARENT(TRUE)
	if(new_sight == see_invisible)
		return
	var/old_invis = see_invisible
	see_invisible = new_sight
	SEND_SIGNAL(src, COMSIG_MOB_SEE_INVIS_CHANGE, see_invisible, old_invis)
