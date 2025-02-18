/datum/status_effect/staggered
	id = "staggered"
	tick_interval = 1 SECONDS
	alert_type = null
	remove_on_fullheal = TRUE
	var/spawn_animating = TRUE

/datum/status_effect/staggered/on_creation(mob/living/new_owner, duration = 10 SECONDS)
	src.duration = duration
	return ..()

/datum/status_effect/staggered/on_apply()
	//you can't stagger the dead.
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_NO_STAGGER))
		return FALSE

	RegisterSignals(owner, list(COMSIG_LIVING_DEATH, SIGNAL_ADDTRAIT(TRAIT_NO_STAGGER)), PROC_REF(clear_staggered))
	owner.add_movespeed_modifier(/datum/movespeed_modifier/staggered)
	addtimer(VARSET_CALLBACK(src, spawn_animating, FALSE), initial(tick_interval), TIMER_DELETE_ME)
	return TRUE

/datum/status_effect/staggered/on_remove()
	UnregisterSignal(owner, list(COMSIG_LIVING_DEATH, SIGNAL_ADDTRAIT(TRAIT_NO_STAGGER)))
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/staggered)

/// Signal proc that self deletes our staggered effect
/datum/status_effect/staggered/proc/clear_staggered(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/datum/status_effect/staggered/tick(seconds_between_ticks)
	//you can't stagger the dead - in case somehow you die mid-stagger
	if(owner.stat == DEAD || HAS_TRAIT(owner, TRAIT_NO_STAGGER))
		qdel(src)
		return
	if(HAS_TRAIT(owner, TRAIT_FAKEDEATH))
		return
	INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob/living, do_stagger_animation))

/// Helper proc that causes the mob to do a stagger animation.
/// Doesn't change significantly, just meant to represent swaying back and forth
/mob/living/proc/do_stagger_animation()
	animate(src, pixel_w = 3, time = 0.2 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)
	animate(pixel_w = -6, time = 0.4 SECONDS, flags = ANIMATION_RELATIVE)
	animate(pixel_w = 3, time = 0.2 SECONDS, flags = ANIMATION_RELATIVE)
