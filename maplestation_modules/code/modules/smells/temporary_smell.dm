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

	/// If TRUE, the smell intensity will fade over time until it reaches 0, at which point the component will be removed.
	VAR_FINAL/fade_intensity_over_time = FALSE
	/// Calculated period between intensity losses.
	VAR_PRIVATE/intensity_loss_period
	/// Calculated intensity loss per second if fading over time is enabled.
	VAR_PRIVATE/intensity_per_period = 0
	/// Cooldown to handle intensity loss over time.
	COOLDOWN_DECLARE(intensity_loss_cooldown)

/datum/component/temporary_smell/Initialize(duration = 10 MINUTES, smell, intensity, radius, category, wash_types = NONE, fade_intensity_over_time = FALSE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.smell = smell
	src.intensity = intensity
	src.radius = radius
	src.category = category
	src.wash_types = wash_types
	src.fade_intensity_over_time = fade_intensity_over_time

	parent.AddElement(/datum/element/smell, smell, intensity, radius, category)

	if(fade_intensity_over_time)
		START_PROCESSING(SSobj, src)
		intensity_loss_period = clamp(duration / 10, SSobj.wait, duration)
		intensity_per_period = intensity / (duration / intensity_loss_period)
	else
		addtimer(CALLBACK(src, PROC_REF(clean_up)), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME|TIMER_NO_HASH_WAIT)
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_wash))

/datum/component/temporary_smell/Destroy()
	parent.RemoveElement(/datum/element/smell, smell, intensity, radius, category)
	UnregisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT)
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/temporary_smell/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, intensity_loss_cooldown))
		return

	COOLDOWN_START(src, intensity_loss_cooldown, intensity_loss_period)
	parent.RemoveElement(/datum/element/smell, smell, intensity, radius, category)
	intensity -= intensity_per_period
	if(intensity <= 0)
		qdel(src)
		return
	parent.AddElement(/datum/element/smell, smell, intensity, radius, category)

/datum/component/temporary_smell/proc/clean_up(...)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/temporary_smell/proc/on_wash(datum/source, clean_types)
	SIGNAL_HANDLER

	if(wash_types && (clean_types & wash_types))
		qdel(src)

/datum/component/temporary_smell/CheckDupeComponent(datum/component/clone, duration, smell, intensity, radius, category, wash_types)
	if(smell != src.smell || category != src.category || wash_types != src.wash_types)
		return FALSE

	if(intensity > src.intensity || radius > src.radius)
		parent.RemoveElement(/datum/element/smell, smell, src.intensity, src.radius, category)
		parent.AddElement(/datum/element/smell, smell, intensity, radius, category)
		src.intensity = intensity
		src.radius = radius

	addtimer(CALLBACK(src, PROC_REF(clean_up)), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME|TIMER_NO_HASH_WAIT)
	return TRUE
