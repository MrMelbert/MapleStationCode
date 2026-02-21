/mob/living/carbon
	has_initial_mana_pool = TRUE

/mob/living/carbon/get_initial_mana_pool_type()
	return /datum/mana_pool/mob/living/carbon

/mob/living/carbon/human/dummy
	has_initial_mana_pool = FALSE

/datum/mana_pool/mob/living/carbon
	maximum_mana_capacity = CARBON_BASE_MANA_CAPACITY

	exponential_decay_divisor = BASE_CARBON_MANA_EXPONENTIAL_DIVISOR

	intrinsic_recharge_sources = NONE

// carbons have softcap mults, this adds it to the pool.
/mob/living/carbon/initialize_mana_pool()
	var/datum/mana_pool/mob/living/carbon/our_pool = ..()

	our_pool.softcap *= get_mana_softcap_mult(mana_pool)

	return our_pool

/mob/living/carbon/proc/get_mana_softcap_mult(datum/mana_pool/pool)
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	if (mob_biotypes & MOB_ROBOTIC)
		mult *= ROBOTIC_MANA_SOFTCAP_MULT

	return mult

/mob/living/carbon/proc/get_max_mana_capacity_mult()
	SHOULD_BE_PURE(TRUE)

	var/mult = 1

	return mult

/mob/living/carbon/proc/safe_adjust_personal_mana(amount_to_adjust)
// proc for adjusting mana without going over the softcap
	if(mana_pool) // playing it safe, does nothing if you have no mana pool
		if(amount_to_adjust < 0) // if the amount is negative
			if(mana_pool.amount > -amount_to_adjust) // not risking negatives
				mana_pool.adjust_mana(amount_to_adjust)
		else
			if(mana_pool.amount < mana_pool.softcap)
				mana_pool.adjust_mana(amount_to_adjust)

/mob/living/carbon/proc/adjust_personal_mana(amount_to_adjust)
// proc for adjusting mana that CAN go over the softcap
	if(mana_pool) // playing it safe, does nothing if you have no mana pool
		if(amount_to_adjust < 0) // if the amount is negative - you *should* use the above if you know its gonna go into the negatives, though.
			if(mana_pool.amount > -amount_to_adjust) // not risking negatives
				mana_pool.adjust_mana(amount_to_adjust)
		else
			mana_pool.adjust_mana(amount_to_adjust)

/datum/mana_pool/mob/living/carbon/blank // exists entirely for quirks or other odd permanent effects that make you basically unable to hold mana
	// to be precise, this is for when you also want to have additional behavior, like the status report being altered: if you just want to hemorrage the player's mana/disable it, you can just set the softcap to zero through proc easily
	softcap = 1
	amount = 0

/datum/mana_pool/mob/living/carbon/blank/mana_status_report(datum/source, list/status_tab)
	SIGNAL_HANDLER
	// basically just only show the status report if you're overloaded or bugged
	var/general_amount_estimate
	if(amount)
		if (amount <= softcap)
			return
		else if (amount > softcap)
			general_amount_estimate = "OVERLOADED"
	else
		general_amount_estimate = "ERROR"

	status_tab += "Mana Count: [general_amount_estimate]"
