/atom
    var/datum/mana_pool/mana_pool

/atom/Initialize(mapload, ...)
	. = ..()

	mana_pool = initialize_mana_pool()

/atom/Destroy(force, ...)
	QDEL_NULL(mana_pool)

	return ..()

/atom/proc/initialize_mana_pool()

	var/max = generate_max_mana_capacity()
	if (isnull(max))
		return null

	var/datum/mana_pool/pool = new /datum/mana_pool(
		maximum_mana_capacity = max,
		softcap = generate_initial_mana_softcap(max),
		exponential_decay_coeff = generate_initial_mana_exp_coeff(),
		max_donation_rate = generate_mana_donation_rate(max),
		recharge_rate = generate_mana_recharge_rate(),
		attunements = generate_initial_attunements(),
		amount = generate_initial_mana_amount(max)
	)

/atom/proc/generate_max_mana_capacity()
	return null

/atom/proc/generate_initial_mana_softcap(max)
	return (max * get_mana_softcap_percent())

/atom/proc/get_mana_softcap_percent()
	return BASE_MANA_SOFTCAP_PERCENT_OF_MAX

/atom/proc/generate_initial_mana_exp_coeff()
	return BASE_MANA_EXPONENTIAL_DIVISOR

/atom/proc/generate_mana_recharge_rate()
	return 0

/atom/proc/generate_initial_attunements()
	RETURN_TYPE(/list/datum/attunement)

	return GLOB.default_attunements.Copy()

/atom/proc/generate_mana_donation_rate(max)
	return max

/atom/proc/generate_initial_mana_amount(max)
	return max

/// New_pool is nullable
/atom/proc/set_mana_pool(datum/mana_pool/new_pool)
	if (mana_pool)
		// do stuff like replacement
	mana_pool = new_pool

/// Should return a list of all mana pools that this datum can access at the given moment. Defaults to returning nothing.
/datum/proc/get_available_mana()
	return null

/atom/get_available_mana()
	return mana_pool

/// If this mob is casting/using something that costs mana, it should always multiply the cost against this.
/mob/proc/get_casting_cost_mult()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_casting_cost_mult()
	. = ..()
	var/obj/held_item = src.get_active_held_item()
	if (!held_item)
		. *= NO_CATALYST_COST_MULT

