#define CONVECT_HEAT_ATTUNEMENT 0.5
#define CONVECT_ICE_ATTUNEMENT 0.5

/datum/action/cooldown/spell/pointed/convect
	name = "Convect"
	desc = "Manipulate the temperature of matter around you. Right-click the spell icon to set the temperature alteration."
	school = SCHOOL_TRANSMUTATION

	active_msg = "Nearby matter seems to still eversoslightly."
	deactive_msg = "Your surroundings normalize."

	aim_assist = FALSE
	cast_range = 1 //physical touching

	unset_after_click = FALSE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	var/list/datum/attunement/attunements

	var/temperature_for_cast = 25
	//Maximum temperature change able to be chosen when casting
	var/maximum_temperature_delta = 50
	//Minimum temperature the spell can reach
	var/minimum_temperature_atmos = T0C - 50
	//Maximum temperature the spell can reach
	var/maximum_temperature_atmos = T0C + 100

/datum/action/cooldown/spell/pointed/convect/New(Target, original)
	. = ..()

	update_attunement_dispositions()

	AddComponent(/datum/component/uses_mana/spell, \
		pre_use_check_with_feedback_comsig = COMSIG_SPELL_BEFORE_CAST, \
		post_use_comsig = COMSIG_SPELL_AFTER_CAST, \
		mana_consumed = CALLBACK(src, PROC_REF(get_mana_consumed)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		attunements = src.attunements, \
	)

/datum/action/cooldown/spell/pointed/convect/proc/update_attunement_dispositions()
	if (isnull(attunements))
		attunements = GLOB.default_attunements.Copy()

	if (temperature_for_cast == 0)
		return attunements
	if (temperature_for_cast > 0)
		attunements[MAGIC_ELEMENT_FIRE] += CONVECT_HEAT_ATTUNEMENT
		attunements[MAGIC_ELEMENT_ICE] -= CONVECT_HEAT_ATTUNEMENT
	else
		attunements[MAGIC_ELEMENT_ICE] += CONVECT_ICE_ATTUNEMENT
		attunements[MAGIC_ELEMENT_FIRE] -= CONVECT_ICE_ATTUNEMENT

	return attunements

/datum/action/cooldown/spell/pointed/convect/proc/get_mana_consumed()
	return ((abs(temperature_for_cast) * CONVECT_MANA_COST_PER_KELVIN))
	// todo: methodize the casting cost mult part

/datum/action/cooldown/spell/pointed/convect/is_valid_target(atom/cast_on)
	return TRUE //cant call suepr cause i want to be able to use this on myself

/datum/action/cooldown/spell/pointed/convect/Trigger(trigger_flags, atom/target)
	if (trigger_flags & TRIGGER_SECONDARY_ACTION)
		get_new_cast_temperature()
		return FALSE

	. = ..()

/// Asks the owner for a number via TGUI. If the number isn't 0 or null, sets it to our temperature.
/datum/action/cooldown/spell/pointed/convect/proc/get_new_cast_temperature()
	var/temperature = tgui_input_number(owner, "How many degrees (kelvin) do you wish to shift temperature by?", "Convect", null, max_value = maximum_temperature_delta, min_value = -maximum_temperature_delta, timeout = 5 SECONDS)
	if (!temperature)
		return FALSE
	temperature_for_cast = temperature
	owner.balloon_alert(owner, "casting temperature set to [temperature]K")
	update_attunement_dispositions()

/datum/action/cooldown/spell/pointed/convect/on_activation(mob/on_who)
	. = ..()
	if (!isnum(temperature_for_cast))
		get_new_cast_temperature()
		if (!isnum(temperature_for_cast))
			unset_click_ability(on_who)
			return FALSE

/datum/action/cooldown/spell/pointed/convect/cast(atom/cast_on)
	. = ..()

	var/hot_or_cold
	var/heat_or_cool
	if (temperature_for_cast > 0)
		hot_or_cold = "heat"
		heat_or_cool = "heat"
	else
		hot_or_cold = "cold"
		heat_or_cool = "cool"
	if (iscarbon(cast_on))
		var/mob/living/carbon/carbon_target = cast_on
		carbon_target.adjust_bodytemperature(temperature_for_cast, use_insulation = TRUE)
		var/just_got_convected_text = span_warning("You feel a wave of [hot_or_cold] eminate from [owner]...")
		carbon_target.balloon_alert(carbon_target, just_got_convected_text)
		to_chat(carbon_target, just_got_convected_text)

	var/turf/turf_target = get_turf(cast_on)
	var/datum/gas_mixture/air = cast_on.return_air()
	var/datum/gas_mixture/turf_air = turf_target?.return_air()
	if (air && air != turf_air) // if this has air and we arent a turf
		if(air.temperature + temperature_for_cast >= maximum_temperature_atmos && temperature_for_cast <= 0) //veeery hot
			air.temperature = max(air.temperature + temperature_for_cast, minimum_temperature_atmos)
		else if(air.temperature + temperature_for_cast <= minimum_temperature_atmos && temperature_for_cast > 0) //veeery cold
			air.temperature = min(air.temperature + temperature_for_cast, maximum_temperature_atmos)
		else if(air.temperature + temperature_for_cast >= maximum_temperature_atmos && temperature_for_cast > 0) //These else if blocks suck. Why air doesn't have a proc to set temperature is byond me
			air.temperature = maximum_temperature_atmos
		else if(air.temperature + temperature_for_cast <= minimum_temperature_atmos && temperature_for_cast <= 0)
			air.temperature = minimum_temperature_atmos
		else
			air.temperature = clamp(air.temperature + temperature_for_cast, minimum_temperature_atmos, maximum_temperature_atmos) //don't want fusion temperatures in your pocket now dont you
		air.react(cast_on)
	if (isturf(cast_on) && turf_air)
		if(turf_air.temperature + temperature_for_cast >= maximum_temperature_atmos && temperature_for_cast <= 0)
			turf_air.temperature = max(turf_air.temperature + temperature_for_cast, minimum_temperature_atmos)
		else if(turf_air.temperature + temperature_for_cast <= minimum_temperature_atmos && temperature_for_cast > 0)
			turf_air.temperature = min(turf_air.temperature + temperature_for_cast, maximum_temperature_atmos)
		else if(turf_air.temperature + temperature_for_cast >= maximum_temperature_atmos && temperature_for_cast > 0)
			turf_air.temperature = maximum_temperature_atmos
		else if(turf_air.temperature + temperature_for_cast <= minimum_temperature_atmos && temperature_for_cast <= 0)
			turf_air.temperature = minimum_temperature_atmos
		else
			turf_air.temperature = clamp(turf_air.temperature + temperature_for_cast, minimum_temperature_atmos, maximum_temperature_atmos)
		turf_air.react(turf_target)
		turf_target?.air_update_turf()

	cast_on.reagents?.expose_temperature((cast_on.reagents?.chem_temp)+temperature_for_cast, 1)
	var/just_convected_text = span_warning("You [heat_or_cool] [cast_on] by [temperature_for_cast]K.")
	owner.balloon_alert(owner, just_convected_text)
	to_chat(owner, just_convected_text)

#undef CONVECT_HEAT_ATTUNEMENT
#undef CONVECT_ICE_ATTUNEMENT
