/// ++ Effects used by the Sense Equilibrium spell ++
// Positive

/// Understand All Languages
/datum/status_effect/language_comprehension
	id = "language_comprehension"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	var/trait_source = MAGIC_TRAIT

/datum/status_effect/language_comprehension/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/language_comprehension/on_apply()
	owner.grant_all_languages(source = LANGUAGE_BABEL)
	return ..()

/datum/status_effect/language_comprehension/on_remove()
	owner.remove_all_languages(source = LANGUAGE_BABEL)
	return ..()

// Negative

/// Tower of Babel with no alert
/datum/status_effect/tower_of_babel/equilibrium
	id = "tower_of_babel_equilibrium"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	trait_source = MAGIC_TRAIT

/// Phobia brain trauma w/ a duration
/datum/status_effect/sudden_phobia
	id = "sudden_phobia"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	trait_source = MAGIC_TRAIT
	duration = 30 SECONDS

/datum/status_effect/sudden_phobia/on_creation(mob/living/new_owner, duration = 30 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/sudden_phobia/on_apply()
	owner.gain_trauma(/datum/brain_trauma/mild/phobia, TRAUMA_RESILIENCE_MAGIC)
	return ..()

/datum/status_effect/sudden_phobia/on_remove()
	owner.cure_trauma_type(/datum/brain_trauma/mild/phobia, resilience = TRAUMA_RESILIENCE_MAGIC)
	return ..()

