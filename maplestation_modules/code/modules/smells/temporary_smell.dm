/// Attach this component to an atom to make it smell temporarily
/datum/component/temporary_smell
	dupe_mode = COMPONENT_DUPE_SELECTIVE
	/// Smell applied, tracked solely for dupe checking
	VAR_FINAL/smell
	/// Intensity of the smell applied, tracked solely for dupe checking
	VAR_FINAL/intensity
	/// Radius of the smell applied, tracked solely for dupe checking
	VAR_FINAL/radius
	/// Category of the smell applied, tracked solely for dupe checking
	VAR_FINAL/category

	/// Flags indicating which cleaning types will remove this smell. If NONE, no cleaning type will remove it.
	VAR_FINAL/wash_types = NONE

/datum/component/temporary_smell/Initialize(duration = 10 MINUTES, smell, intensity, radius, category, wash_types = NONE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.smell = smell
	src.intensity = intensity
	src.radius = radius
	src.category = category
	src.wash_types = wash_types

	parent.AddElement(/datum/element/smell, smell, intensity, radius, category)
	addtimer(CALLBACK(src, PROC_REF(clean_up)), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME|TIMER_NO_HASH_WAIT)
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_wash))

/datum/component/temporary_smell/Destroy()
	UnregisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT)
	return ..()

/datum/component/temporary_smell/proc/clean_up(...)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/temporary_smell/proc/on_wash(datum/source, clean_types)
	SIGNAL_HANDLER

	if(wash_types && (clean_types & wash_types))
		qdel(src)

/datum/component/temporary_smell/CheckDupeComponent(datum/component/clone, duration, smell, intensity, radius, category)
	if(smell != src.smell || category != src.category)
		return FALSE

	if(intensity > src.intensity || radius > src.radius)
		parent.RemoveElement(/datum/element/smell, smell, src.intensity, src.radius, category)
		parent.AddElement(/datum/element/smell, smell, intensity, radius, category)
		src.intensity = intensity
		src.radius = radius

	addtimer(CALLBACK(src, PROC_REF(clean_up)), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME|TIMER_NO_HASH_WAIT)
	return TRUE
