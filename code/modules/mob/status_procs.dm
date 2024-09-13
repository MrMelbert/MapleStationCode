//Here are the procs used to modify status effects of a mob.

///Adjust the disgust level of a mob
/mob/proc/adjust_disgust(amount)
	return

///Set the disgust level of a mob
/mob/proc/set_disgust(amount)
	return

#define THERMAL_PROTECTION_HEAD 0.3
#define THERMAL_PROTECTION_CHEST 0.2
#define THERMAL_PROTECTION_GROIN 0.10
#define THERMAL_PROTECTION_LEG (0.075 * 2)
#define THERMAL_PROTECTION_FOOT (0.025 * 2)
#define THERMAL_PROTECTION_ARM (0.075 * 2)
#define THERMAL_PROTECTION_HAND (0.025 * 2)

/**
 * Get the insulation that is appropriate to the temperature you're being exposed to.
 * All clothing, natural insulation, and traits are combined returning a single value.
 *
 * Args
 * * temperature - what temperature is being exposed to this mob?
 * some articles of clothing are only effective within a certain temperature range
 *
 * returns the percentage of protection as a value from 0 - 1
**/
/mob/living/proc/get_insulation(temperature = T20C)
	// There is an occasional bug where the temperature is miscalculated in areas with small amounts of gas.
	// This is necessary to ensure that does not affect this calculation.
	// Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	temperature = max(temperature, T0C)

	var/thermal_protection_flags = NONE
	for(var/obj/item/worn in get_equipped_items())
		var/valid = FALSE
		if(isnum(worn.max_heat_protection_temperature) && isnum(worn.min_cold_protection_temperature))
			valid = worn.max_heat_protection_temperature >= temperature && worn.min_cold_protection_temperature <= temperature

		else if (isnum(worn.max_heat_protection_temperature))
			valid = worn.max_heat_protection_temperature >= temperature

		else if (isnum(worn.min_cold_protection_temperature))
			valid = worn.min_cold_protection_temperature <= temperature

		if(valid)
			thermal_protection_flags |= worn.body_parts_covered

	var/thermal_protection = temperature_insulation
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & LEGS)
			thermal_protection += THERMAL_PROTECTION_LEG
		if(thermal_protection_flags & FEET)
			thermal_protection += THERMAL_PROTECTION_FOOT
		if(thermal_protection_flags & ARMS)
			thermal_protection += THERMAL_PROTECTION_ARM
		if(thermal_protection_flags & HANDS)
			thermal_protection += THERMAL_PROTECTION_HAND

	return min(1, round(thermal_protection, 0.05))

#undef THERMAL_PROTECTION_HEAD
#undef THERMAL_PROTECTION_CHEST
#undef THERMAL_PROTECTION_GROIN
#undef THERMAL_PROTECTION_LEG
#undef THERMAL_PROTECTION_FOOT
#undef THERMAL_PROTECTION_ARM
#undef THERMAL_PROTECTION_HAND

/mob/living/proc/adjust_body_temperature(amount = 0, min_temp = 0, max_temp = INFINITY, use_insulation = FALSE)
	// apply insulation to the amount of change
	if(use_insulation)
		amount *= (1 - get_insulation(body_temperature + amount))
	if(amount == 0)
		return 0
	amount = round(amount, 0.01)

	if(body_temperature >= min_temp && body_temperature <= max_temp)
		var/old_temp = body_temperature
		body_temperature = clamp(body_temperature + amount, min_temp, max_temp)
		SEND_SIGNAL(src, COMSIG_LIVING_BODY_TEMPERATURE_CHANGE, old_temp, body_temperature)
		// body_temperature_alerts()
		return body_temperature - old_temp
	return 0

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
	var/area_temperature = get_temperature(loc?.return_air())
	if(!(mob_biotypes & MOB_ORGANIC))
		// non-organic mobs likely don't feel or regulate temperature
		// so we can just report the area temp... probably
		// there's an argument to be made for putting a cold blooded check here,
		// but i'm not since it may be misleading in gameplay ("this lizard is 1000c??")
		return round(area_temperature, 0.01)

	// calculate skin temp based on a weight average between body temp and area temp plus a multiplier
	// this weighting gives us about 34.4c for a 37c body temp in a 20c room which is about average
	var/skin_temp = ((body_temperature * 2 + area_temperature * 1) / 3)
	// convert to kelvin before multiplying, otherwise we go to the moon
	var/result = KELVIN_TO_CELCIUS(skin_temp)
	var/multiplier = 1.1
	// factor in insulation, but to a far lesser degree
	// wearing a winter coat in a room temp area will increase skin temp to about 38.3c
	multiplier *= (1 + (get_insulation(area_temperature) * 0.25))

	if(temperature_homeostasis_speed != 0)
		if(body_temperature >= standard_body_temperature + 2 CELCIUS)
			multiplier *= 1.1 // vasodilation / sweating
		if(body_temperature <= standard_body_temperature + ((bodytemp_cold_damage_limit - standard_body_temperature) * 0.5))
			multiplier *= 0.9 // vasoconstriction

	// reverse the effect of insulation if we're subzero
	// (otherwise, wearing a coat makes you colder)
	if(result < 0)
		multiplier = 1 / multiplier

	. = CELCIUS_TO_KELVIN(result * multiplier)
	// and if we're on fire just add a flat amount of heat
	if(on_fire)
		. += fire_stacks ** 2 KELVIN

	return .

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
