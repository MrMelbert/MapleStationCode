/mob/living/carbon/Initialize(mapload)
	if (mob_biotypes & MOB_ROBOTIC)
		mana_overload_coefficient *= ROBOTIC_MANA_OVERLOAD_COEFFICIENT_MULT
		mana_overload_threshold *= ROBOTIC_MANA_OVERLOAD_THRESHOLD_MULT

	return ..()

/atom/movable/proc/process_mana_overload(effect_mult, seconds_per_tick)
	mana_overloaded = TRUE

/mob/process_mana_overload(effect_mult, seconds_per_tick)
	if (!mana_overloaded)
		balloon_alert(src, "mana overload!")
		to_chat(src, span_warning("You start feeling fuzzy and tingly all around..."))

	return ..()

/mob/living/carbon/process_mana_overload(effect_mult, seconds_per_tick)
	. = ..()

	var/adjusted_mult = effect_mult * seconds_per_tick

	adjust_disgust(adjusted_mult)

	if (effect_mult > MANA_OVERLOAD_DAMAGE_THRESHOLD)
		apply_damage(MANA_OVERLOAD_BASE_DAMAGE * adjusted_mult, damagetype = BRUTE, forced = TRUE, spread_damage = TRUE)

/atom/movable/proc/stop_mana_overload()
	mana_overloaded = FALSE

/mob/stop_mana_overload()
	balloon_alert(src, "mana overload end")
	to_chat(src, span_notice("You feel your body returning to normal."))

	return ..()
