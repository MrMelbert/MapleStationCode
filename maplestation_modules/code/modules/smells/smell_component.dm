/**
 * Used for smells with  more complex behaviors, such as
 * - Having a duration
 * - Fading intensity over time
 * - Propagating to the wearer of an item
 * - Being removed by specific cleaning methods
 */
/datum/component/complex_smell
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

	/// Optional list of signals that immediately clear the effect if received.
	VAR_FINAL/list/clear_signals

/datum/component/complex_smell/Initialize(duration = 10 MINUTES, smell, intensity, radius, category, wash_types = NONE, fade_intensity_over_time = FALSE, list/clear_signals)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.smell = smell
	src.intensity = intensity
	src.radius = radius
	src.category = category
	src.wash_types = wash_types
	src.fade_intensity_over_time = fade_intensity_over_time
	src.clear_signals = clear_signals

	add_element()
	RegisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_wash))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_worn))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_unworn))

	if(length(clear_signals))
		RegisterSignals(parent, clear_signals, PROC_REF(clean_up))

	if(duration != INFINITY)
		if(fade_intensity_over_time)
			START_PROCESSING(SSobj, src)
			intensity_loss_period = clamp(duration / 10, SSobj.wait, duration)
			intensity_per_period = intensity / (duration / intensity_loss_period)
		else
			addtimer(CALLBACK(src, PROC_REF(clean_up)), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME|TIMER_NO_HASH_WAIT)

/datum/component/complex_smell/Destroy()
	UnregisterSignal(parent, COMSIG_COMPONENT_CLEAN_ACT)
	UnregisterSignal(parent, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(parent, COMSIG_ITEM_DROPPED)
	if(length(clear_signals))
		UnregisterSignal(parent, clear_signals)
	remove_element()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/component/complex_smell/proc/add_element()
	parent.AddElement(/datum/element/simple_smell, smell, intensity, radius, category, REF(src))
	// propagate to wearer if applicable
	if(isitem(parent))
		var/obj/item/item_parent = parent
		if(ismob(item_parent.loc))
			on_worn(item_parent, item_parent.loc)

/datum/component/complex_smell/proc/remove_element()
	parent.RemoveElement(/datum/element/simple_smell, smell, intensity, radius, category, REF(src))
	// clear from wearer if applicable
	if(isitem(parent))
		var/obj/item/item_parent = parent
		if(ismob(item_parent.loc))
			on_unworn(item_parent, item_parent.loc)

/datum/component/complex_smell/process(seconds_per_tick)
	if(!COOLDOWN_FINISHED(src, intensity_loss_cooldown))
		return

	COOLDOWN_START(src, intensity_loss_cooldown, intensity_loss_period)
	remove_element()
	intensity -= intensity_per_period
	if(intensity <= 0)
		qdel(src)
		return

	add_element()

/datum/component/complex_smell/proc/on_worn(datum/source, mob/wearer)
	SIGNAL_HANDLER
	wearer.RemoveElement(/datum/element/simple_smell, smell, intensity, radius, category, REF(src))
	wearer.AddElement(/datum/element/simple_smell, smell, intensity, radius, category, REF(src))

/datum/component/complex_smell/proc/on_unworn(datum/source, mob/wearer)
	SIGNAL_HANDLER
	wearer.RemoveElement(/datum/element/simple_smell, smell, intensity, radius, category, REF(src))

/datum/component/complex_smell/proc/clean_up(...)
	SIGNAL_HANDLER
	qdel(src)

/datum/component/complex_smell/proc/on_wash(datum/source, clean_types)
	SIGNAL_HANDLER

	if(wash_types && (clean_types & wash_types))
		qdel(src)

/datum/component/complex_smell/CheckDupeComponent(datum/component/clone, duration, smell, intensity, radius, category, wash_types)
	if(smell != src.smell || category != src.category || wash_types != src.wash_types)
		return FALSE

	if(intensity > src.intensity || radius > src.radius)
		parent.RemoveElement(/datum/element/simple_smell, smell, src.intensity, src.radius, category, REF(src))
		parent.AddElement(/datum/element/simple_smell, smell, intensity, radius, category, REF(src))
		src.intensity = intensity
		src.radius = radius

	addtimer(CALLBACK(src, PROC_REF(clean_up)), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME|TIMER_NO_HASH_WAIT)
	return TRUE
