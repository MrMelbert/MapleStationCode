/// Returns singleton for a passed smell typepath or string+category
/proc/get_smell(smell, category = /datum/smell::category, smell_basetype = /datum/smell)
	var/static/list/smell_register = list()

	var/key = "[smell]"
	if(istext(smell))
		key += "-[category]-[smell_basetype]"

	. = smell_register[key]
	if(isnull(.))
#ifdef UNIT_TESTS
		for(var/key in smell_register)
			var/datum/smell/smell = smell_register[key]
			if(smell.text != smell || smell.category != category)
				continue
			if(smell.type == smell)
				stack_trace("Smell register has an instantiated smell, but failed to retrieve it with key [key].")
			else
				stack_trace("Smell register has a smell of matching text and category, but failed to retrieve it with key [key].")
#endif
		if(ispath(smell, /datum/smell))
			. = new smell()
			smell_register[key] = .

		else if(istext(smell))
			. = new smell_basetype(smell, category)
			smell_register[key] = .

		else
			stack_trace("Invalid smell input passed to get_smell: [smell || "null"]")

/**
 * Smellement
 *
 * The actual element that applies a smell to an atom
 */
/datum/element/simple_smell
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2

	/// Smell singleton this element owns
	var/datum/smell/smell
	/// How strong the smell is
	var/intensity
	/// How big the smell radius is
	var/radius
	/// For smells which may be identical to another smell in all respects but need to be tracked separately
	/// Primarily used for complex smells which may stack multiple times on the same atom, like bloody clothing
	var/id

/**
 * Arguments:
 *
 * * smell - either a string representing the smell type or a /datum/smell typepath.
 * If a string is passed, a smell singleton will be generated for that string and the provided category.
 * If a smell typepath is passed, it will be used directly. Smell basetype and category arguments will be ignored in this case.
 * * intensity - how strong the smell is.
 * * radius - how far the smell reaches.
 * Smell intensity will fall off linearly over distance.
 * * category - Optional: the smell category, used for categorizing smells and determining how they interact with each other.
 * Only used if smell is passed as a string.
 * * id - Optional: identifier for this smell instance, used to differentiate between multiple instances of the same smell on the same atom.
 * * smell_basetype - Optional: the basetype to use when generating a smell singleton from a string. Defaults to /datum/smell.
 */
/datum/element/simple_smell/Attach(datum/target, smell = "stink", intensity = SMELL_INTENSITY_FAINT, radius = 2, category, id = "innate", smell_basetype = /datum/smell)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	if(intensity < SMELL_INTENSITY_FAINT)
		stack_trace("A simple smell was created with invalid intensity - we will coerce it, but it should be fixed: [intensity]")

	src.id = id
	if(isnull(src.smell))
		src.smell = get_smell(smell, category, smell_basetype)
		src.intensity = max(intensity, SMELL_INTENSITY_FAINT)
		src.radius = max(radius, 0)

	var/atom/atom_target = target
	if(isturf(atom_target.loc))
		mark_turfs(target, atom_target.loc)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(update_turfs))

/datum/element/simple_smell/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	var/atom/atom_target = target
	if(isturf(atom_target.loc))
		unmark_turfs(target, atom_target.loc)

/datum/element/simple_smell/proc/update_turfs(atom/movable/source, atom/old_loc)
	SIGNAL_HANDLER

	if(isturf(old_loc))
		unmark_turfs(source, old_loc)
	if(isturf(source.loc))
		mark_turfs(source, source.loc)

/// Used to calculate smell intensity at a target turf based on distance from center
#define CALCULATE_SMELL_INTENSITY(base_intensity, center_turf, target_turf, radius) \
	max(base_intensity - base_intensity * (get_dist(center_turf, target_turf) / max(1, radius)), SMELL_INTENSITY_WEAK)

/datum/element/simple_smell/proc/mark_turfs(atom/source, atom/center)
	for(var/turf/open/nearby in RANGE_TURFS(radius, center))
		LAZYINITLIST(nearby.collective_smells)
		nearby.collective_smells[smell] += CALCULATE_SMELL_INTENSITY(intensity, center, nearby, radius)

/datum/element/simple_smell/proc/unmark_turfs(atom/source, atom/center)
	for(var/turf/open/nearby in RANGE_TURFS(radius, center))
		if(!LAZYLEN(nearby.collective_smells)) // ??
			continue

		nearby.collective_smells[smell] -= CALCULATE_SMELL_INTENSITY(intensity, center, nearby, radius)
		if(nearby.collective_smells[smell] <= 0)
			LAZYREMOVE(nearby.collective_smells, smell)

#undef CALCULATE_SMELL_INTENSITY

/// Debug
/proc/visualize_smells()
	for(var/turf/open/smelled in RANGE_TURFS(12, usr))
		if(!LAZYLEN(smelled.collective_smells))
			continue

		var/total_intensity = 0
		for(var/smell_type, smell_intensity in smelled.collective_smells)
			total_intensity += smell_intensity
		smelled.maptext = MAPTEXT("[total_intensity]")
