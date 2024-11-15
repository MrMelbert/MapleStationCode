/atom/movable
	var/datum/mana_pool/mana_pool
	var/has_initial_mana_pool = FALSE // not using flags since this is all modular and flags can be overridden by tg

	var/mana_overload_threshold = BASE_MANA_OVERLOAD_THRESHOLD
	var/mana_overload_coefficient = BASE_MANA_OVERLOAD_COEFFICIENT

	var/mana_overloaded = FALSE

/atom/movable/Destroy(force, ...)

	QDEL_NULL(mana_pool) // why was this after set_mana_pool. it should never ever be
	set_mana_pool(null)

	return ..()

// creates the mana pool for use.
// mostly called on atom_init.
/atom/movable/proc/initialize_mana_pool()
	RETURN_TYPE(/datum/mana_pool)

	var/datum/mana_pool/type = get_initial_mana_pool_type()

	var/datum/mana_pool/pool = new type(parent = src)
	return pool

// base proc to return what kind of mana pool this atom will have.
// meant to be overridden with whatever mana_pool subtype you want.
/atom/movable/proc/get_initial_mana_pool_type()
	RETURN_TYPE(/datum/mana_pool)

	return /datum/mana_pool

/// New_pool is nullable
/// standard setter proc. Input the pool you want to add to the atom, and it'll toss out the old
/atom/movable/proc/set_mana_pool(datum/mana_pool/new_pool)
	if (!can_have_mana_pool(new_pool))
		return FALSE

	SEND_SIGNAL(src, COMSIG_ATOM_MANA_POOL_CHANGED, mana_pool, new_pool)

	if (mana_pool)
		// do stuff like replacement
		QDEL_NULL(mana_pool)
		set_mana_pool(null) // todo: see if this is necessary
	mana_pool = new_pool

	if (isnull(mana_pool))
		if (mana_overloaded)
			stop_mana_overload()

// just retrieves mana_pool and initializes it if it doesn't have one for some reason (and is allowed to have one)
/atom/movable/proc/get_mana_pool_lazy()

	if (!can_have_mana_pool())
		return null

	initialize_mana_pool_if_possible()

	return mana_pool

// initialize the pool if it doesn't have one, and is allowed to
/atom/movable/proc/initialize_mana_pool_if_possible()
	if (isnull(mana_pool) && can_have_mana_pool())
		mana_pool = initialize_mana_pool()

// arg nullable
// override this with whatever if you want special functionality if something wants to check if it can have a mana_pool
/atom/movable/proc/can_have_mana_pool(datum/mana_pool/new_pool)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_BE_PURE(TRUE)

	return TRUE
