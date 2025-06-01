/datum/component/local_anesthetic_reagent
	/// How much to reduce the pain modifier of the bodypart by
	var/bodypart_pain_modifier = 1
	/// The methods that can apply this reagent to a bodypart
	var/required_methods = TOUCH
	/// The bodypart affected by this reagent
	VAR_PRIVATE/obj/item/bodypart/active
	/// If applied incorrectly, starts causing nausea and dizziness
	VAR_PRIVATE/toxic = FALSE

/datum/component/local_anesthetic_reagent/Initialize(bodypart_pain_modifier = 1, required_methods = TOUCH)
	if(!istype(parent, /datum/reagent))
		return COMPONENT_INCOMPATIBLE

	src.bodypart_pain_modifier = bodypart_pain_modifier
	src.required_methods = required_methods

/datum/component/local_anesthetic_reagent/RegisterWithParent()
	RegisterSignal(parent, COMSIG_REAGENT_EXPOSE_MOB, PROC_REF(exposed))
	RegisterSignal(parent, COMSIG_REAGENT_EXPOSE_OBJECT, PROC_REF(exposed))

/datum/component/local_anesthetic_reagent/proc/exposed(datum/reagent/source, mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection, exposed_zone)
	SIGNAL_HANDLER

	var/obj/item/bodypart/part = exposed_mob.get_bodypart(exposed_zone)
	if(isnull(part) || !IS_ORGANIC_LIMB(part))
		return
	if(active)
		stack_trace("Attempted to apply [src] to [part] while already applied to [active].")
		return

	if(methods & required_methods)
		part.bodypart_pain_modifier *= bodypart_pain_modifier
		active = part
		RegisterSignals(part, list(COMSIG_BODYPART_REMOVED, COMSIG_QDELETING), PROC_REF(clear_ref))
		return

	toxic = TRUE
