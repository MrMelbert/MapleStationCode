/// Hypo and Hyperthermia status effects.
/datum/status_effect/thermia
	alert_type = null
	tick_interval = 2 SECONDS
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	remove_on_fullheal = TRUE
	heal_flag_necessary = HEAL_TEMP
	/// What trait resists this status effect?
	var/resist_trait
	/// tracks how long the effect has been active
	VAR_PRIVATE/seconds_active = 0
	/// tracks the intensity of the effect. goes up to 100 (which is "uh oh" territory)
	/// intensity increases over time, scaling with how far the body temperature is from the threshold and how long the effect has been active
	VAR_PRIVATE/intensity = 0
	/// Used to prevent spamming the player with the same warning
	VAR_PRIVATE/last_warning = 0
	/// Message displayed early on to warn the player it's starting
	var/early_warning = ""
	/// Message displayed mid-way to warn about worsening condition
	var/mid_warning = ""
	/// Message displayed when the condition is severe and nearing critical
	var/late_warning = ""

/datum/status_effect/thermia/on_apply()
	if(HAS_TRAIT(owner, resist_trait))
		return FALSE

	RegisterSignal(owner, SIGNAL_ADDTRAIT(resist_trait), PROC_REF(clear_effect))
	RegisterSignal(owner, COMSIG_LIVING_HEALTHSCAN, PROC_REF(on_scan))
	return TRUE

/datum/status_effect/thermia/on_remove()
	owner.remove_consciousness_modifier(id)
	owner.remove_max_consciousness_value(id)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(resist_trait))
	UnregisterSignal(owner, COMSIG_LIVING_HEALTHSCAN)

/datum/status_effect/thermia/proc/clear_effect(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/thermia/proc/on_scan(datum/source, list/report, advanced, ...)
	SIGNAL_HANDLER

	report += "<span class='alert ml-1'>[id] detected.[advanced ? " ([round(intensity)]%)" : ""]</span><br>"

/datum/status_effect/thermia/proc/adjust_intensity(change, min = 0, max = 100)
	intensity = clamp(intensity + change, min, max)
	if(change <= 0 && intensity <= 0)
		qdel(src)
		return

	// updating consciousness / max consciousness
	owner.add_consciousness_modifier(id, intensity * -0.5)
	if(intensity >= 75)
		owner.add_max_consciousness_value(id, 50)
	else if(intensity >= 90)
		owner.add_max_consciousness_value(id, 25)
	else
		owner.remove_max_consciousness_value(id)

	// resetting warnings
	if(change <= 0)
		if(intensity <= 5)
			last_warning = 0
		else if(intensity <= 40)
			last_warning = 1
		else if(intensity <= 75)
			last_warning = 2

/datum/status_effect/thermia/tick(seconds_between_ticks)
	if(HAS_TRAIT(owner, TRAIT_STASIS) || owner.stat == DEAD)
		return
	seconds_active += seconds_between_ticks
	update_intenisty_per_temp(seconds_between_ticks, clamp(seconds_active / 30, 1, 6))
	if(QDELETED(src))
		return
	on_tick(seconds_between_ticks)
	switch(intensity)
		if(5 to 10)
			if(last_warning < 1)
				to_chat(owner, span_warning(early_warning))
				last_warning = 1
		if(40 to 50)
			if(last_warning < 2)
				to_chat(owner, span_warning(mid_warning))
				last_warning = 2
		if(75 to 85)
			if(last_warning < 3)
				to_chat(owner, span_warning(late_warning))
				last_warning = 3

/datum/status_effect/thermia/proc/update_intenisty_per_temp(seconds_between_ticks = 2, time_modifier = 1)
	return

/datum/status_effect/thermia/proc/on_tick(seconds_between_ticks)
	return

/datum/status_effect/thermia/hypo
	id = "Hypothermia"
	resist_trait = TRAIT_RESISTCOLD
	early_warning = "You start to shiver."
	mid_warning = "You can barely feel your fingers."
	late_warning = "You feel like you're about to pass out from the cold!"

	VAR_PRIVATE/cold_stacks = 0
	VAR_PRIVATE/cold_threshold = 0

	// Thresholds for when we should increase the intensity faster
	VAR_PRIVATE/cold_threshold_low
	VAR_PRIVATE/cold_threshold_medium
	VAR_PRIVATE/cold_threshold_high

/datum/status_effect/thermia/hypo/on_apply()
	if(owner.body_temperature > owner.bodytemp_cold_damage_limit)
		return FALSE

	cold_threshold = 10 + rand(0, 15)

	var/cold_diff = owner.bodytemp_cold_damage_limit - owner.standard_body_temperature
	cold_threshold_low = owner.bodytemp_cold_damage_limit + cold_diff * 1.2
	cold_threshold_medium = owner.bodytemp_cold_damage_limit + cold_diff * 1.75
	cold_threshold_high = owner.bodytemp_cold_damage_limit + cold_diff * 2
	return ..()

/datum/status_effect/thermia/hypo/update_intenisty_per_temp(seconds_between_ticks = 2, time_modifier = 1)
	if(owner.body_temperature > owner.bodytemp_heat_damage_limit)
		adjust_intensity( -3 * seconds_between_ticks)
	else if(owner.body_temperature > owner.bodytemp_cold_damage_limit)
		adjust_intensity( -1  * seconds_between_ticks)
	else if(owner.has_reagent(/datum/reagent/medicine/cryoxadone, needs_metabolizing = TRUE))
		adjust_intensity( -1  * seconds_between_ticks, min = 25)

	else if(owner.body_temperature > cold_threshold_low)
		adjust_intensity(0.2 * time_modifier * seconds_between_ticks, max = 75)
	else if(owner.body_temperature > cold_threshold_medium)
		adjust_intensity(0.5 * time_modifier * seconds_between_ticks, max = 90)
	else if(owner.body_temperature > cold_threshold_high)
		adjust_intensity(  1 * time_modifier * seconds_between_ticks)
	else
		adjust_intensity(1.5 * time_modifier * seconds_between_ticks)

/datum/status_effect/thermia/hypo/on_tick(seconds_between_ticks)
	if(!ishuman(owner))
		return

	var/area_temp = owner.get_temperature(owner.loc?.return_air())
	if(area_temp < owner.bodytemp_cold_damage_limit)
		cold_stacks += (0.5 * seconds_between_ticks)
	else
		cold_stacks = max(cold_stacks - (1 * seconds_between_ticks), 0)

	if(cold_stacks >= cold_threshold)
		apply_frostbite()
		cold_stacks = 0
		// threshold re-randomizes
		cold_threshold = 10 + rand(0, 25)

/datum/status_effect/thermia/hypo/proc/apply_frostbite()
	var/mob/living/carbon/human/human_owner = owner
	var/list/pick_from = BODY_ZONES_LIMBS
	while(length(pick_from))
		var/obj/item/bodypart/bodypart = human_owner.get_bodypart(pick_n_take(pick_from))
		if(isnull(bodypart))
			continue
		if(locate(/datum/wound/flesh/frostbite) in bodypart.wounds)
			continue
		bodypart.force_wound_upwards(/datum/wound/flesh/frostbite, wound_source = "cold temperatures")
		return

/datum/status_effect/thermia/hyper
	id = "Hyperthermia"
	resist_trait = TRAIT_RESISTHEAT
	early_warning = "You start to sweat profusely."
	mid_warning = "You feel dizzy and disoriented."
	late_warning = "You feel like you're about to pass out from the heat!"

	/// Tracks the number of burn stacks before we apply a burn wound
	VAR_PRIVATE/burn_stacks = 0
	/// The threshold of stacks needed to be passed to apply a wound
	VAR_PRIVATE/burn_threshold = 0
	/// Tracks number of wounds applied, so the threshold increases per wound
	VAR_PRIVATE/wounds_applied = 0

	// Thresholds for when we should increase the intensity faster
	VAR_PRIVATE/heat_threshold_low
	VAR_PRIVATE/heat_threshold_medium
	VAR_PRIVATE/heat_threshold_high

/datum/status_effect/thermia/hyper/on_apply()
	if(owner.body_temperature < owner.bodytemp_heat_damage_limit)
		return FALSE

	var/heat_diff = owner.bodytemp_heat_damage_limit - owner.standard_body_temperature
	heat_threshold_low = owner.bodytemp_heat_damage_limit + heat_diff * 0.75
	heat_threshold_medium = owner.bodytemp_heat_damage_limit + heat_diff * 1.25
	heat_threshold_high = owner.bodytemp_heat_damage_limit + heat_diff * 2

	burn_threshold = 10 + rand(0, 20)
	return ..()

/datum/status_effect/thermia/hyper/update_intenisty_per_temp(seconds_between_ticks = 2, time_modifier = 1)

	if(owner.body_temperature < owner.bodytemp_cold_damage_limit)
		adjust_intensity( -3 * seconds_between_ticks)
	else if(owner.body_temperature < owner.bodytemp_heat_damage_limit)
		adjust_intensity( -1  * seconds_between_ticks)
	else if(owner.has_reagent(/datum/reagent/medicine/pyroxadone, needs_metabolizing = TRUE))
		adjust_intensity( -1 * seconds_between_ticks, min = 25)
	else if(owner.body_temperature < heat_threshold_low)
		adjust_intensity(0.2 * time_modifier * seconds_between_ticks, max = 75)
	else if(owner.body_temperature < heat_threshold_medium)
		adjust_intensity(0.5 * time_modifier * seconds_between_ticks, max = 90)
	else if(owner.body_temperature < heat_threshold_high)
		adjust_intensity(  1 * time_modifier * seconds_between_ticks)
	else
		adjust_intensity(  1.5 * time_modifier * seconds_between_ticks)

// if we're experiencing hyperthermia and we are in a hot area, we will start to get burn wounds!
/datum/status_effect/thermia/hyper/on_tick(seconds_between_ticks)
	if(!ishuman(owner))
		return

	var/area_temp = owner.get_temperature(owner.loc?.return_air())
	if(area_temp > owner.bodytemp_heat_damage_limit)
		burn_stacks += (0.5 * seconds_between_ticks)
	else
		burn_stacks = max(burn_stacks - (1 * seconds_between_ticks), 0)

	if(burn_stacks >= burn_threshold)
		apply_burn()
		wounds_applied += 1
		burn_stacks = 0
		// threshold re-randomizes and goes up, slightly
		burn_threshold = 10 + rand(0, 20) + (wounds_applied * 2)

/datum/status_effect/thermia/hyper/proc/apply_burn()
	var/mob/living/carbon/human/human_owner = owner
	// Lets pick a random body part and check for an existing burn
	var/obj/item/bodypart/bodypart = pick(human_owner.bodyparts)
	var/datum/wound/existing_burn
	for (var/datum/wound/iterated_wound as anything in bodypart.wounds)
		var/datum/wound_pregen_data/pregen_data = iterated_wound.get_pregen_data()
		if (pregen_data.wound_series in GLOB.wounding_types_to_series[WOUND_BURN])
			existing_burn = iterated_wound
			break

	// If we have an existing burn try to upgrade it
	var/severity = WOUND_SEVERITY_MODERATE
	var/heat_damage = 2 * HEAT_DAMAGE * human_owner.physiology.heat_mod
	if(human_owner.body_temperature > heat_threshold_medium * 8)
		if(existing_burn?.severity < WOUND_SEVERITY_CRITICAL)
			severity = WOUND_SEVERITY_CRITICAL
		heat_damage *= 8

	else if(human_owner.body_temperature > heat_threshold_medium * 2)
		if(existing_burn?.severity < WOUND_SEVERITY_SEVERE)
			severity = WOUND_SEVERITY_SEVERE
		heat_damage *= 3

	human_owner.cause_wound_of_type_and_severity(WOUND_BURN, bodypart, severity, wound_source = "hot temperatures")
	human_owner.apply_damage(HEAT_DAMAGE, BURN, bodypart, wound_bonus = CANT_WOUND)
