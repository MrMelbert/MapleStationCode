/atom
	var/datum/mana_pool/mana_pool
	var/has_initial_mana_pool = FALSE // not using flags since this is all modular and flags can be overridden by tg

	var/mana_overload_threshold = BASE_MANA_OVERLOAD_THRESHOLD
	var/mana_overload_coefficient = BASE_MANA_OVERLOAD_COEFFICIENT

	var/mana_overloaded = FALSE

/atom/Initialize(mapload, ...)
	. = ..()

	if (has_initial_mana_pool && can_have_mana_pool())
		mana_pool = initialize_mana_pool()

/atom/Destroy(force, ...)
	QDEL_NULL(mana_pool)

	return ..()

/atom/proc/initialize_mana_pool()
	RETURN_TYPE(/datum/mana_pool)

	var/datum/mana_pool/type = get_initial_mana_pool_type()

	var/datum/mana_pool/pool = new type(parent = src)
	return pool

/atom/proc/get_initial_mana_pool_type()
	RETURN_TYPE(/datum/mana_pool)

	return /datum/mana_pool

/// New_pool is nullable
/atom/proc/set_mana_pool(datum/mana_pool/new_pool)
	if (!can_have_mana_pool(new_pool))
		return FALSE

	if (mana_pool)
		// do stuff like replacement
	mana_pool = new_pool

	if (isnull(mana_pool))
		if (mana_overloaded)
			stop_mana_overload()

// arg nulalble
/atom/proc/can_have_mana_pool(datum/mana_pool/new_pool)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_BE_PURE(TRUE)

	return TRUE

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

