/atom
    var/datum/mana_pool/mana_pool

/atom/Initialize(mapload, ...)

	mana_pool = initialize_mana_pool()

	return ..()

/atom/proc/initialize_mana_pool()
	return null

/// New_pool is nullable
/atom/proc/set_mana_pool(datum/mana_pool/new_pool)
	if (mana_pool)
		// do stuff like replacement
	mana_pool = new_pool

/atom/Destroy(force, ...)
	QDEL_NULL(mana_pool)

	return ..()

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

