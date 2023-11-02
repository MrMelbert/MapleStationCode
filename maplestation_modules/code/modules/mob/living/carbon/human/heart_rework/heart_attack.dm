/datum/status_effect/heart_attack
	id = "heart_attack"
	alert_type = null
	tick_interval = 2 SECONDS
	/// TimerID for the initial knock out
	VAR_FINAL/ko_timer

/datum/status_effect/heart_attack/on_apply()
	if(!iscarbon(owner))
		return FALSE
	var/mob/living/carbon/carbon_owner = owner
	if(isnull(carbon_owner.dna?.species?.mutantheart))
		return FALSE

	RegisterSignal(owner, COMSIG_SPECIES_GAIN, PROC_REF(species_changed))

	// You get 1 tick of grace before you fall over due to your heart stopping
	ko_timer = addtimer(CALLBACK(src, PROC_REF(delayed_ko)), initial(tick_interval), TIMER_STOPPABLE)
	return TRUE

/datum/status_effect/heart_attack/on_remove()
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	deltimer(ko_timer)

	UnregisterSignal(owner, COMSIG_SPECIES_GAIN)
	UnregisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_NOBREATH))
	UnregisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_NOBREATH))

/datum/status_effect/heart_attack/proc/delayed_ko()
	if(!HAS_TRAIT(owner, TRAIT_NOBREATH))
		ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))
	ko_timer = null

	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_NOBREATH), PROC_REF(gained_nobreath))
	RegisterSignal(owner, SIGNAL_REMOVETRAIT(TRAIT_NOBREATH), PROC_REF(lost_nobreath))

/datum/status_effect/heart_attack/proc/species_changed(datum/source, datum/species/new_species, datum/species/old_species)
	SIGNAL_HANDLER
	if(isnull(new_species.mutantheart))
		qdel(src)

/datum/status_effect/heart_attack/proc/gained_nobreath()
	SIGNAL_HANDLER
	REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/heart_attack/proc/lost_nobreath()
	SIGNAL_HANDLER
	if(!HAS_TRAIT(owner, TRAIT_NOBREATH))
		ADD_TRAIT(owner, TRAIT_KNOCKEDOUT, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/heart_attack/tick(seconds_per_tick, times_fired)
	seconds_per_tick = initial(tick_interval) // to remove when upstream merge

	if(ko_timer) // Not yet
		return
	if(HAS_TRAIT(owner, TRAIT_STABLEHEART) || HAS_TRAIT(owner, TRAIT_NOBLOOD))
		return
	if(owner.get_organ_slot(ORGAN_SLOT_HEART) && owner.has_status_effect(/datum/status_effect/cpr_applied)) // A heart is required for CPR to work
		return

	if(!HAS_TRAIT(owner, TRAIT_NOBREATH))
		owner.adjustOxyLoss(4 * seconds_per_tick)
		owner.losebreath = max(owner.losebreath, 1)
	// Tissues die without blood circulation
	owner.adjustBruteLoss(1 * seconds_per_tick)
