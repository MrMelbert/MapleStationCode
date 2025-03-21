

/mob/living/carbon/alien/larva/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return
	if(!..() || HAS_TRAIT(src, TRAIT_STASIS) || (amount_grown >= max_grown))
		return // We're dead, in stasis, or already grown.
	// GROW!
	amount_grown = min(amount_grown + (0.5 * seconds_per_tick), max_grown)
	update_icons()


/mob/living/carbon/alien/larva/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat == DEAD)
		return
	if(health <= -maxHealth || !get_organ_by_type(/obj/item/organ/internal/brain))
		death()
		return
	if(HAS_TRAIT(src, TRAIT_KNOCKEDOUT))
		set_resting(TRUE)
		return
	set_stat(CONSCIOUS)
