/// Status effect that simply adds and removes a trait with a duration
/datum/status_effect/trait_effect
	id = "trait_effect"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	duration = 30 SECONDS
	/// The trait(s) we're adding
	var/trait_to_add

/datum/status_effect/trait_effect/on_creation(mob/living/new_owner, duration = 15 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/trait_effect/on_apply()
	if(!trait_to_add)
		return FALSE
	if(islist(trait_to_add))
		for(status_trait in trait_to_add)
			ADD_TRAIT(owner, status_trait, type)
		return ..()
	ADD_TRAIT(owner, trait_to_add, type)
	return ..()

/datum/status_effect/trait_effect/on_remove()
	if(!trait_to_add)
		return FALSE
	if(islist(trait_to_add))
		for(status_trait in trait_to_add)
			REMOVE_TRAIT(owner, status_trait, type)
		return ..()
	REMOVE_TRAIT(owner, trait_to_add, type)
	return ..()
