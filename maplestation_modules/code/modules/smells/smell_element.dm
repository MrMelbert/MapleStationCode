/// Returns singleton for a passed smell typepath or string+category
/proc/get_smell(smell, category = /datum/smell::category)
	var/static/list/smell_register = list()

	var/key = "[smell]-[category]"

	. = smell_register[key]
	if(isnull(.))
		if(ispath(smell, /datum/smell))
			. = new smell()
			smell_register[key] = .

		else if(istext(smell))
			. = new /datum/smell(smell, category)
			smell_register[key] = .

		else
			stack_trace("Invalid smell input passed to get_smell: [smell || "null"]")

/// The actual datum that handles emitting a smell from an atom
/// NB: Currently nested contents don't propagate smell out to turf. Maybe later
/datum/element/smell
	element_flags = ELEMENT_BESPOKE|ELEMENT_DETACH_ON_HOST_DESTROY
	argument_hash_start_idx = 2

	/// Smell singleton this element owns
	var/datum/smell/smell
	/// How strong the smell is
	var/intensity
	/// How big the smell radius is
	var/radius

/datum/element/smell/Attach(datum/target, smell = "stink", intensity = 1, radius = 2, category)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE

	if(isnull(src.smell))
		src.smell = get_smell(smell, category)
		src.intensity = intensity
		src.radius = radius

	var/atom/atom_target = target
	if(isturf(atom_target.loc))
		mark_turfs(target, atom_target.loc)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(update_turfs))

/datum/element/smell/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOVABLE_MOVED)
	var/atom/atom_target = target
	if(isturf(atom_target.loc))
		unmark_turfs(target, atom_target.loc)

/datum/element/smell/proc/update_turfs(atom/movable/source, atom/old_loc)
	SIGNAL_HANDLER

	if(isturf(old_loc))
		unmark_turfs(source, old_loc)
	if(isturf(source.loc))
		mark_turfs(source, source.loc)

/// Used to calculate smell intensity at a target turf based on distance from center
#define CALCULATE_SMELL_INTENSITY(base_intensity, center_turf, target_turf, radius) \
	clamp(base_intensity * (get_dist(center_turf, target_turf) / max(1, radius)), SMELL_INTENSITY_FAINT, base_intensity)

/datum/element/smell/proc/mark_turfs(atom/source, atom/center)
	for(var/turf/open/nearby in RANGE_TURFS(radius, center))
		LAZYINITLIST(nearby.collective_smells)
		nearby.collective_smells[smell] += CALCULATE_SMELL_INTENSITY(intensity, center, nearby, radius)

/datum/element/smell/proc/unmark_turfs(atom/source, atom/center)
	for(var/turf/open/nearby in RANGE_TURFS(radius, center))
		if(!LAZYLEN(nearby.collective_smells)) // ??
			continue

		nearby.collective_smells[smell] -= CALCULATE_SMELL_INTENSITY(intensity, center, nearby, radius)
		if(nearby.collective_smells[smell] <= 0)
			LAZYREMOVE(nearby.collective_smells, smell)

#undef CALCULATE_SMELL_INTENSITY
