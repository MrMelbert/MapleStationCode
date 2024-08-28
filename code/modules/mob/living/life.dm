/**
 * Handles the biological and general over-time processes of the mob.
 *
 *
 * Arguments:
 * - seconds_per_tick: The amount of time that has elapsed since this last fired.
 * - times_fired: The number of times SSmobs has fired
 */
/mob/living/proc/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	set waitfor = FALSE

	var/signal_result = SEND_SIGNAL(src, COMSIG_LIVING_LIFE, seconds_per_tick, times_fired)

	if(signal_result & COMPONENT_LIVING_CANCEL_LIFE_PROCESSING) // mmm less work
		return

	if (client)
		var/turf/T = get_turf(src)
		if(!T)
			move_to_error_room()
			var/msg = " was found to have no .loc with an attached client, if the cause is unknown it would be wise to ask how this was accomplished."
			message_admins(ADMIN_LOOKUPFLW(src) + msg)
			send2tgs_adminless_only("Mob", key_name_and_tag(src) + msg, R_ADMIN)
			src.log_message("was found to have no .loc with an attached client.", LOG_GAME)

		// This is a temporary error tracker to make sure we've caught everything
		else if (registered_z != T.z)
#ifdef TESTING
			message_admins("[ADMIN_LOOKUPFLW(src)] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z]. If you could ask them how that happened and notify coderbus, it would be appreciated.")
#endif
			log_game("Z-TRACKING: [src] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z].")
			update_z(T.z)
	else if (registered_z)
		log_game("Z-TRACKING: [src] of type [src.type] has a Z-registration despite not having a client.")
		update_z(null)

	if(isnull(loc) || HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	if(!HAS_TRAIT(src, TRAIT_STASIS))

		if(stat != DEAD)
			//Mutations and radiation
			handle_mutations(seconds_per_tick, times_fired)
			//Breathing, if applicable
			handle_breathing(seconds_per_tick, times_fired)

		handle_diseases(seconds_per_tick, times_fired)// DEAD check is in the proc itself; we want it to spread even if the mob is dead, but to handle its disease-y properties only if you're not.

		if (QDELETED(src)) // diseases can qdel the mob via transformations
			return

		if(stat != DEAD)
			//Random events (vomiting etc)
			handle_random_events(seconds_per_tick, times_fired)

		//Handle temperature/pressure differences between body and environment
		var/datum/gas_mixture/environment = loc.return_air()
		if(environment)
			handle_environment(environment, seconds_per_tick, times_fired)
			body_temperature_damage(environment, seconds_per_tick, times_fired)
		if(stat <= SOFT_CRIT && !on_fire)
			temperature_homeostasis(seconds_per_tick, times_fired)

		handle_gravity(seconds_per_tick, times_fired)

	if(stat != DEAD)
		body_temperature_alerts()
	handle_wounds(seconds_per_tick, times_fired)

	if(machine)
		machine.check_eye(src)

	if(stat != DEAD)
		return 1

/mob/living/proc/handle_breathing(seconds_per_tick, times_fired)
	SEND_SIGNAL(src, COMSIG_LIVING_HANDLE_BREATHING, seconds_per_tick, times_fired)
	return

/mob/living/proc/body_temperature_damage(datum/gas_mixture/environment, seconds_per_tick, times_fired)
	// Body temperature is too hot, and we do not have resist traits
	// Apply some burn damage to the body
	if(body_temperature > bodytemp_heat_damage_limit && !HAS_TRAIT(src, TRAIT_RESISTHEAT))
		var/firemodifier = fire_stacks / 50
		if (!on_fire) // We are not on fire, reduce the modifier
			firemodifier = min(firemodifier, 0)

		var/burn_damage = 0.5 * max(log(2 - firemodifier, (body_temperature - standard_body_temperature)) - 5, 0)
		if(ishuman(src))
			// melbert todo : temp
			var/mob/living/carbon/human/husrc = src
			burn_damage *= husrc.physiology.heat_mod
		apply_damage(burn_damage * seconds_per_tick, BURN, spread_damage = TRUE)

	// For cold damage, we cap at the threshold if you're dead
	if(getFireLoss() >= maxHealth && stat == DEAD)
		return

	if(body_temperature < bodytemp_cold_damage_limit && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		var/cold_damage = 0
		// Can't be a switch due to http://www.byond.com/forum/post/2750423
		if(body_temperature > 201)
			cold_damage = COLD_DAMAGE_LEVEL_1
		else if(body_temperature > 120 && body_temperature <= 200)
			cold_damage = COLD_DAMAGE_LEVEL_2
		else
			cold_damage = COLD_DAMAGE_LEVEL_3

		if(ishuman(src))
			// melbert todo : temp
			var/mob/living/carbon/human/husrc = src
			cold_damage *= husrc.physiology.cold_mod
		apply_damage(cold_damage * seconds_per_tick, BURN, spread_damage = TRUE)

/mob/living/carbon/human/body_temperature_damage(datum/gas_mixture/environment, seconds_per_tick, times_fired)
	if(body_temperature > BODYTEMP_HEAT_WOUND_LIMIT)
		heat_exposure_stacks = min(heat_exposure_stacks + (0.5 * seconds_per_tick), 40)
	else
		heat_exposure_stacks = max(heat_exposure_stacks - (2 * seconds_per_tick), 0)

	if(heat_exposure_stacks > (10 + rand(0, 20)))
		apply_burn_wounds_from_heat(seconds_per_tick, times_fired)
		heat_exposure_stacks = 0
	return ..()

/mob/living/carbon/human/proc/apply_burn_wounds_from_heat(seconds_per_tick, times_fired)
	// If we are resistant to heat exit
	if(HAS_TRAIT(src, TRAIT_RESISTHEAT) || body_temperature < BODYTEMP_HEAT_WOUND_LIMIT)
		return

	// Lets pick a random body part and check for an existing burn
	var/obj/item/bodypart/bodypart = pick(bodyparts)
	var/datum/wound/existing_burn
	for (var/datum/wound/iterated_wound as anything in bodypart.wounds)
		var/datum/wound_pregen_data/pregen_data = iterated_wound.get_pregen_data()
		if (pregen_data.wound_series in GLOB.wounding_types_to_series[WOUND_BURN])
			existing_burn = iterated_wound
			break
	// If we have an existing burn try to upgrade it
	var/severity
	if(existing_burn)
		switch(existing_burn.severity)
			if(WOUND_SEVERITY_MODERATE)
				if(body_temperature > BODYTEMP_HEAT_WOUND_LIMIT + 400) // 800k
					severity = WOUND_SEVERITY_SEVERE
			if(WOUND_SEVERITY_SEVERE)
				if(body_temperature > BODYTEMP_HEAT_WOUND_LIMIT + 2800) // 3200k
					severity = WOUND_SEVERITY_CRITICAL
	else // If we have no burn apply the lowest level burn
		severity = WOUND_SEVERITY_MODERATE

	cause_wound_of_type_and_severity(WOUND_BURN, bodypart, severity, wound_source = "hot temperatures")

	// always take some burn damage
	var/burn_damage = HEAT_DAMAGE_LEVEL_1
	if(body_temperature > BODYTEMP_HEAT_WOUND_LIMIT + 400)
		burn_damage = HEAT_DAMAGE_LEVEL_2
	if(body_temperature > BODYTEMP_HEAT_WOUND_LIMIT + 2800)
		burn_damage = HEAT_DAMAGE_LEVEL_3

	apply_damage(burn_damage * seconds_per_tick, BURN, bodypart)

/mob/living/proc/body_temperature_alerts()
	// give out alerts based on how the skin feels, not how the body is
	// this gives us an early warning system - since we tend to trend up/down to skin temperature -
	// how we're going to be feeling soon if we don't change our environment
	var/feels_like = get_skin_temperature()

	// Body temperature is too hot, and we do not have resist traits
	if(feels_like >= BODYTEMP_HEAT_WARNING_1 && !HAS_TRAIT(src, TRAIT_RESISTHEAT))
		// Clear cold mood and apply hot mood
		clear_mood_event("cold")
		add_mood_event("hot", /datum/mood_event/hot)
		remove_movespeed_modifier(/datum/movespeed_modifier/cold)
		// display alerts based on how hot it is
		// melbert todo : these should not be defined, but variable
		if(feels_like > BODYTEMP_HEAT_WARNING_3)
			throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 2)
		else if(feels_like > BODYTEMP_HEAT_WARNING_2)
			throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 2)
		else
			throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 1)

	// Body temperature is too cold, and we do not have resist traits
	else if(feels_like <= BODYTEMP_COLD_WARNING_1 && !HAS_TRAIT(src, TRAIT_RESISTCOLD))
		clear_mood_event("hot")
		add_mood_event("cold", /datum/mood_event/cold)
		// melbert todo : these should not be defined, but variable
		if(body_temperature < BODYTEMP_COLD_WARNING_2) // only apply slowdown if the body is cold rather than the skin
			add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/cold, multiplicative_slowdown = ((BODYTEMP_COLD_WARNING_2 - body_temperature) / COLD_SLOWDOWN_FACTOR))
		if(feels_like > BODYTEMP_COLD_WARNING_2)
			throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 1)
		else if(feels_like > BODYTEMP_COLD_WARNING_3)
			throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 2)
		else
			throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 3)

	// We are not to hot or cold, remove status and moods
	// Optimization here, we check these things based off the old temperature to avoid unneeded work
	// We're not perfect about this, because it'd just add more work to the base case, and resistances are rare
	else if(old_recorded_temperature > BODYTEMP_HEAT_WARNING_1 || old_recorded_temperature < BODYTEMP_COLD_WARNING_1)
		clear_alert(ALERT_TEMPERATURE)
		if(body_temperature > bodytemp_cold_damage_limit)
			remove_movespeed_modifier(/datum/movespeed_modifier/cold)
		clear_mood_event("cold")
		clear_mood_event("hot")

	// Store the old bodytemp for future checking
	old_recorded_temperature = feels_like

/mob/living/proc/handle_mutations(seconds_per_tick, times_fired)
	return

/mob/living/proc/handle_diseases(seconds_per_tick, times_fired)
	return

/mob/living/proc/handle_wounds(seconds_per_tick, times_fired)
	return

/mob/living/proc/handle_random_events(seconds_per_tick, times_fired)
	return

/**
 * Handle this mob's interactions with the environment
 *
 * By default handles body temperature normalization to the area's temperature,
 * but also handles pressure for many mobs
 *
 * Arguments:
 * * environment: The gas mixture of the area the mob is in, will never be null
 * * seconds_per_tick: The amount of time that has elapsed since this last fired.
 * * times_fired: The number of times SSmobs has fired
 */
/mob/living/proc/handle_environment(datum/gas_mixture/environment, seconds_per_tick, times_fired)
	var/loc_temp = get_temperature(environment)
	var/temp_delta = loc_temp - body_temperature
	if(temp_delta == 0)
		return
	if(temp_delta < 0 && on_fire) // do not reduce body temp when on fire
		return

	// Get the insulation value based on the area's temp
	var/thermal_protection = get_insulation_protection(loc_temp)
	var/protection_modifier = 1
	if(standard_body_temperature + 2 KELVIN < body_temperature)
		// we are overheating and sweaty - insulation is not as good reducing thermal protection
		protection_modifier = 0.7

	var/temp_change = (1 - (thermal_protection * protection_modifier)) * temp_delta * temperature_normalization_speed
	// Cap increase and decrease
	temp_change = temp_change < 0 ? max(temp_change, BODYTEMP_COOLING_MAX) : min(temp_change, BODYTEMP_HEATING_MAX)
	adjust_body_temperature(temp_change * seconds_per_tick) // no use_insulation beacuse we account for it manually

/**
 * Handles this mob internally managing its body temperature.
 *
 * Arguments:
 * * seconds_per_tick: The amount of time that has elapsed since this last fired.
 * * times_fired: The number of times SSmobs has fired
 */
/mob/living/proc/temperature_homeostasis(seconds_per_tick, times_fired)
	if(HAS_TRAIT(src, TRAIT_COLD_BLOODED))
		return

	var/natural_change = (standard_body_temperature - body_temperature) * metabolism_efficiency * temperature_homeostasis_speed
	// Scale based on how hungry we are, hungrier means we have less energy to regulate our temperature
	if(!HAS_TRAIT(src, TRAIT_NOHUNGER))
		switch(nutrition)
			if(NUTRITION_LEVEL_WELL_FED to INFINITY)
				natural_change *= 1.25
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_WELL_FED)
				pass()
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
				natural_change *= 0.5
			if(-INFINITY to NUTRITION_LEVEL_STARVING)
				natural_change *= 0.25
	// Cap increase and decrease
	natural_change = natural_change < 0 ? max(natural_change, BODYTEMP_COOLING_MAX) : min(natural_change, BODYTEMP_HEATING_MAX)
	var/min = natural_change < 0 ? standard_body_temperature : 0
	var/max = natural_change > 0  ? standard_body_temperature : INFINITY
	adjust_body_temperature(natural_change * seconds_per_tick, min_temp = min, max_temp = max) // no use_insulation beacuse this is internal
	adjust_nutrition(-1 * HUNGER_FACTOR * natural_change * seconds_per_tick)

/**
 * Get the fullness of the mob
 *
 * This returns a value form 0 upwards to represent how full the mob is.
 * The value is a total amount of consumable reagents in the body combined
 * with the total amount of nutrition they have.
 * This does not have an upper limit.
 */
/mob/living/proc/get_fullness()
	var/fullness = nutrition
	// we add the nutrition value of what we're currently digesting
	for(var/bile in reagents.reagent_list)
		var/datum/reagent/consumable/bits = bile
		if(bits)
			fullness += bits.get_nutriment_factor(src) * bits.volume / bits.metabolization_rate
	return fullness

/**
 * Check if the mob contains this reagent.
 *
 * This will validate the the reagent holder for the mob and any sub holders contain the requested reagent.
 * Vars:
 * * reagent (typepath) takes a PATH to a reagent.
 * * amount (int) checks for having a specific amount of that chemical.
 * * needs_metabolizing (bool) takes into consideration if the chemical is matabolizing when it's checked.
 */
/mob/living/proc/has_reagent(reagent, amount = -1, needs_metabolizing = FALSE)
	return reagents.has_reagent(reagent, amount, needs_metabolizing)

/mob/living/proc/update_damage_hud()
	return

/mob/living/proc/handle_gravity(seconds_per_tick, times_fired)
	if(gravity_state > STANDARD_GRAVITY)
		handle_high_gravity(gravity_state, seconds_per_tick, times_fired)

/mob/living/proc/gravity_animate()
	if(!get_filter("gravity"))
		add_filter("gravity",1,list("type"="motion_blur", "x"=0, "y"=0))
	animate(get_filter("gravity"), y = 1, time = 10, loop = -1)
	animate(y = 0, time = 10)

/mob/living/proc/handle_high_gravity(gravity, seconds_per_tick, times_fired)
	if(gravity < GRAVITY_DAMAGE_THRESHOLD) //Aka gravity values of 3 or more
		return

	var/grav_strength = gravity - GRAVITY_DAMAGE_THRESHOLD
	adjustBruteLoss(min(GRAVITY_DAMAGE_SCALING * grav_strength, GRAVITY_DAMAGE_MAXIMUM) * seconds_per_tick)
