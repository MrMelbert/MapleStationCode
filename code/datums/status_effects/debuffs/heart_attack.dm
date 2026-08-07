/datum/status_effect/cardiac_arrest
	id = "cardiac_arrest"
	alert_type = null
	tick_interval = 2 SECONDS
	/// TimerID for the initial knock out
	VAR_FINAL/ko_timer

/datum/status_effect/cardiac_arrest/on_apply()
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/carbon_owner = owner
	if(isnull(carbon_owner.dna?.species?.mutantheart))
		return FALSE

	RegisterSignal(owner, COMSIG_SPECIES_GAIN, PROC_REF(species_changed))

	// You get 1 tick of grace before you fall over due to your heart stopping
	ko_timer = addtimer(CALLBACK(src, PROC_REF(delayed_ko)), initial(tick_interval), TIMER_STOPPABLE)
	return TRUE

/datum/status_effect/cardiac_arrest/on_remove()
	deltimer(ko_timer)

	UnregisterSignal(owner, COMSIG_SPECIES_GAIN)

	if(!QDELING(owner))
		owner.heal_pain(20, BODY_ZONE_CHEST)
		owner.remove_consciousness_multiplier(id)
		owner.remove_max_consciousness_value(id)
		REMOVE_TRAIT(owner, TRAIT_SOFT_CRIT, id)

/datum/status_effect/cardiac_arrest/proc/delayed_ko()
	ko_timer = null
	owner.add_consciousness_multiplier(id, 0.75)
	owner.add_max_consciousness_value(id, HARD_CRIT_THRESHOLD)
	ADD_TRAIT(owner, TRAIT_SOFT_CRIT, id)

/datum/status_effect/cardiac_arrest/proc/species_changed(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	if(isnull(new_species.mutantheart))
		qdel(src)

/datum/status_effect/cardiac_arrest/tick(seconds_between_ticks)
	if(ko_timer) // Not yet
		return
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_STABLEHEART) || HAS_TRAIT(owner, TRAIT_NOBLOOD) || HAS_TRAIT(owner, TRAIT_STASIS))
		return
	if(owner.has_status_effect(/datum/status_effect/cpr_applied))
		return

	owner.adjust_traumatic_shock(2 * seconds_between_ticks)
	// More oxy damage is caused via losebreath (in breath())
	owner.apply_damage(2 * seconds_between_ticks, OXY)
	owner.apply_damage(2 * seconds_between_ticks, PAIN, BODY_ZONE_CHEST)
	// Tissues die without blood circulation
	owner.apply_damage(1 * seconds_between_ticks, BRUTE, BODY_ZONE_CHEST, forced = TRUE, wound_bonus = CANT_WOUND)
