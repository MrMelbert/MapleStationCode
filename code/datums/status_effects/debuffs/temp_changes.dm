/mob/living/proc/add_temperature_level(
	source,
	to_value,
	delta_change,
	while_stasis,
	while_dead,
)
	ASSERT(source)
	ASSERT(to_value)
	apply_status_effect(/datum/status_effect/temperature_change, source, to_value, delta_change, while_stasis, while_dead)

/mob/living/proc/remove_temperature_level(
	source,
)
	ASSERT(source)
	remove_status_effect(/datum/status_effect/temperature_change, source)

/mob/living/proc/update_temperature_level(
	source,
	to_value,
	delta_change,
)
	ASSERT(source)
	ASSERT(to_value)
	apply_status_effect(/datum/status_effect/temperature_change, source, to_value, delta_change)

/**
 * Attempts to stabilize a mob's body temperature to a set value.
 */
/datum/status_effect/temperature_change
	id = "temp_change"
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = 2 SECONDS
	var/source
	var/to_value
	var/delta_change
	var/while_stasis
	var/while_dead

/datum/status_effect/temperature_change/on_creation(
	mob/living/new_owner,
	source,
	to_value,
	delta_change = 10 KELVIN, // 10 c / 10 k / 18 f
	while_stasis = FALSE,
	while_dead = FALSE,
)
	src.source = source
	src.to_value = to_value
	src.delta_change = delta_change
	src.while_stasis = while_stasis
	src.while_dead = while_dead
	return ..()

/datum/status_effect/temperature_change/on_apply()
	if(isnull(src.source))
		stack_trace("Temperature change status effect applied without a source")
		return FALSE
	if(isnull(src.to_value))
		stack_trace("Temperature change status effect applied without a set temperature")
		return FALSE

	for(var/datum/status_effect/temperature_change/effect in owner.status_effects)
		if(effect.source == src.source)
			src.to_value = effect.to_value
			src.delta_change = effect.delta_change
			return FALSE

	return TRUE

/datum/status_effect/temperature_change/before_remove(source)
	return src.source == source

/datum/status_effect/temperature_change/tick(seconds_between_ticks)
	if(!while_stasis && HAS_TRAIT(owner, TRAIT_STASIS))
		return
	if(!while_dead && owner.stat == DEAD)
		return

	if(to_value < owner.standard_body_temperature)
		if(owner.body_temperature > to_value)
			owner.adjust_body_temperature(-delta_change * seconds_between_ticks)

	else
		if(owner.body_temperature < to_value)
			owner.adjust_body_temperature(delta_change * seconds_between_ticks)
