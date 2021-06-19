// -- Bodypart pain definitions. --
/obj/item/bodypart
	/// The amount of pain this limb is experiencing (A bit for default)
	var/pain = 15
	var/last_pain = 15
	/// The max amount of pain this limb can experience
	var/max_pain = 70

/obj/item/bodypart/proc/on_gain_pain_effects(amount)
	if(!owner)
		return FALSE

	return TRUE

/obj/item/bodypart/proc/on_lose_pain_effects(amount)
	if(!owner)
		return FALSE

	return TRUE

/obj/item/bodypart/proc/processed_pain_effects(delta_time)
	if(!owner || !pain)
		return FALSE

	return TRUE

/obj/item/bodypart/chest
	max_pain = 120

/obj/item/bodypart/head
	max_pain = 100

/obj/item/bodypart/head/on_gain_pain_effects(amount)
	. = ..()
	if(!.)
		return FALSE

	if(amount > 15)
		brain.applyOrganDamage(amount / 4, 150)

	return TRUE

/obj/item/bodypart/r_leg/processed_pain_effects(delta_time)
	. = ..()
	if(!.)
		return FALSE

	if(pain > 30 && DT_PROB(50, delta_time))
		if(owner.apply_status_effect(STATUS_EFFECT_LIMP_PAIN))
			to_chat(owner, span_danger("Your [name] hurts to walk on!"))

	return TRUE

/obj/item/bodypart/l_leg/processed_pain_effects(delta_time)
	. = ..()
	if(!.)
		return FALSE

	if(pain > 30 && DT_PROB(50, delta_time))
		if(owner.apply_status_effect(STATUS_EFFECT_LIMP_PAIN))
			to_chat(owner, span_danger("Your [name] hurts to walk on!"))

	return TRUE
