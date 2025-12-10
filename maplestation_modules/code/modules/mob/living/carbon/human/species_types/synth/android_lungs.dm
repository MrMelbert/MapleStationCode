/obj/item/organ/lungs/android
	name = "android lungs"
	desc = "Electronic devices designed to mimic the functions of human lungs. Provides necessary cooling."
	icon_state = /obj/item/organ/lungs/cybernetic/tier2::icon_state
	organ_flags = ORGAN_ROBOTIC|ORGAN_UNREMOVABLE // future todo : if this is ever removable, we need to handle body temperature another way

	safe_oxygen_min = 0

	safe_oxygen_max = INFINITY
	safe_co2_max = INFINITY
	safe_plasma_max = INFINITY

	n2o_detect_min = INFINITY
	n2o_para_min = INFINITY
	n2o_sleep_min = INFINITY
	BZ_trip_balls_min = INFINITY
	BZ_brain_damage_min = INFINITY
	gas_stimulation_min = INFINITY
	healium_para_min = INFINITY
	healium_sleep_min = INFINITY
	helium_speech_min = INFINITY
	suffers_miasma = FALSE

	tritium_irradiation_moles_min = INFINITY
	tritium_irradiation_moles_max = INFINITY

	low_pressure_threshold = 0
	high_pressure_threshold = INFINITY

	organ_traits = list(
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
	)

	var/is_overheating = 0
	var/is_overcooled = 0

/obj/item/organ/lungs/android/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_LIVING_BODY_TEMPERATURE_CHANGE, PROC_REF(temperature_update))
	RegisterSignal(organ_owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS, PROC_REF(brittle_modifier))

/obj/item/organ/lungs/android/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_LIVING_BODY_TEMPERATURE_CHANGE)
	UnregisterSignal(organ_owner, COMSIG_MOB_APPLY_DAMAGE_MODIFIERS)
	if(is_overheating)
		remove_heat_modifiers()
	if(is_overcooled)
		remove_cold_modifiers()

/obj/item/organ/lungs/android/on_life(seconds_per_tick, times_fired)
	. = ..()
	if(is_overheating)
		owner.temperature_burns(1.25 * is_overheating * seconds_per_tick)
	if(is_overcooled)
		owner.temperature_cold_damage(0.5 * is_overcooled * seconds_per_tick)

/obj/item/organ/lungs/android/proc/brittle_modifier(mob/living/carbon/human/source, list/damage_mods, damage_type, damage, damage_amount, ...)
	SIGNAL_HANDLER

	if(damage_type != BRUTE)
		return

	switch(is_overcooled)
		if(2)
			damage_mods += 1.1
		if(3)
			damage_mods += 1.25

/obj/item/organ/lungs/android/proc/temperature_update(mob/living/carbon/human/source, old_temp, new_temp)
	SIGNAL_HANDLER

	if(owner.body_temperature > owner.bodytemp_heat_damage_limit)
		update_heat_modifiers()
	else if(owner.body_temperature < owner.bodytemp_cold_damage_limit)
		update_cold_modifiers()
	else if(is_overheating)
		remove_heat_modifiers()
	else if(is_overcooled)
		remove_cold_modifiers()

/obj/item/organ/lungs/android/proc/update_heat_modifiers()
	if(!HAS_TRAIT_FROM_ONLY(owner, TRAIT_RESISTHEAT, REF(src)))
		remove_heat_modifiers()
		return

	if(owner.body_temperature > owner.bodytemp_heat_damage_limit * 2)
		if(is_overheating != 3)
			owner.add_actionspeed_modifier(/datum/actionspeed_modifier/hot_android/t3)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/hot_android/t3)
			owner.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 3)
			is_overheating = 3

	else if(owner.body_temperature > owner.bodytemp_heat_damage_limit * 1.75)
		if(is_overheating != 2)
			owner.add_actionspeed_modifier(/datum/actionspeed_modifier/hot_android/t2)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/hot_android/t2)
			owner.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 2)
			is_overheating = 2

	else if(owner.body_temperature > owner.bodytemp_heat_damage_limit * 1.2)
		if(is_overheating != 1)
			owner.add_actionspeed_modifier(/datum/actionspeed_modifier/hot_android/t1)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/hot_android/t1)
			owner.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/hot, 1)
			is_overheating = 1

/obj/item/organ/lungs/android/proc/update_cold_modifiers()
	if(HAS_TRAIT_NOT_FROM(owner, TRAIT_RESISTCOLD, REF(src)))
		remove_cold_modifiers()
		return

	if(owner.body_temperature < owner.bodytemp_cold_damage_limit * 2)
		if(is_overcooled != 3)
			owner.add_actionspeed_modifier(/datum/actionspeed_modifier/cold_android/t3)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/cold_android/t3)
			owner.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 3)
			is_overcooled = 3

	else if(owner.body_temperature < owner.bodytemp_cold_damage_limit * 1.75)
		if(is_overcooled != 2)
			owner.add_actionspeed_modifier(/datum/actionspeed_modifier/cold_android/t2)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/cold_android/t2)
			owner.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 2)
			is_overcooled = 2

	else if(owner.body_temperature < owner.bodytemp_cold_damage_limit * 1.2)
		if(is_overcooled != 1)
			owner.add_actionspeed_modifier(/datum/actionspeed_modifier/cold_android/t1)
			owner.add_movespeed_modifier(/datum/movespeed_modifier/cold_android/t1)
			owner.throw_alert(ALERT_TEMPERATURE, /atom/movable/screen/alert/cold, 1)
			is_overcooled = 1

/obj/item/organ/lungs/android/proc/remove_heat_modifiers()
	if(!is_overheating)
		return

	is_overheating = 0
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/hot_android)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/hot_android)
	owner.clear_alert(ALERT_TEMPERATURE)

/obj/item/organ/lungs/android/proc/remove_cold_modifiers()
	if(!is_overcooled)
		return

	is_overcooled = 0
	owner.remove_actionspeed_modifier(/datum/actionspeed_modifier/cold_android)
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/cold_android)
	owner.clear_alert(ALERT_TEMPERATURE)

/datum/actionspeed_modifier/cold_android
	id = "cold_android"

/datum/actionspeed_modifier/cold_android/t1
	multiplicative_slowdown = 1.2

/datum/actionspeed_modifier/cold_android/t2
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/cold_android/t3
	multiplicative_slowdown = 2.0

/datum/movespeed_modifier/cold_android
	id = "cold_android"

/datum/movespeed_modifier/cold_android/t1
	multiplicative_slowdown = 1.0

/datum/movespeed_modifier/cold_android/t2
	multiplicative_slowdown = 1.2

/datum/movespeed_modifier/cold_android/t3
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/hot_android
	id = "hot_android"

/datum/actionspeed_modifier/hot_android/t1
	multiplicative_slowdown = 1.2

/datum/actionspeed_modifier/hot_android/t2
	multiplicative_slowdown = 1.5

/datum/actionspeed_modifier/hot_android/t3
	multiplicative_slowdown = 2.0

/datum/movespeed_modifier/hot_android
	id = "hot_android"

/datum/movespeed_modifier/hot_android/t1
	multiplicative_slowdown = 1.2

/datum/movespeed_modifier/hot_android/t2
	multiplicative_slowdown = 1.5

/datum/movespeed_modifier/hot_android/t3
	multiplicative_slowdown = 2.0

/obj/item/organ/lungs/android/heal_oxyloss_on_breath(mob/living/carbon/human/breather, datum/gas_mixture/breath)
	breather.adjustOxyLoss(-2)

// androids don't do homeostasis, instead they use their lungs to cool themselves
/obj/item/organ/lungs/android/handle_breath_temperature(datum/gas_mixture/breath, mob/living/carbon/human/breather)
	var/temp_delta = round((breath.temperature - breather.body_temperature), 0.01) // future todo: make better heat capacity gases work better here
	if(temp_delta == 0)
		return

	temp_delta = temp_delta < 0 ? max(temp_delta, BODYTEMP_HOMEOSTASIS_COOLING_MAX) : min(temp_delta, BODYTEMP_HOMEOSTASIS_HEATING_MAX)

	var/min = temp_delta < 0 ? breather.standard_body_temperature : 0
	var/max = temp_delta > 0 ? breather.standard_body_temperature : INFINITY

	breather.adjust_body_temperature(temp_delta, min, max)
	breath.temperature = breather.body_temperature
