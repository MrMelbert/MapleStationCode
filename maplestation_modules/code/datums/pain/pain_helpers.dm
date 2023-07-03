// -- Helper procs and hooks for pain. --
/mob/living
	/// The pain controller datum - tracks, processes, and handles pain.
	/// Only intialized on humans (currently), here for ease of access / future compatibillity?
	var/datum/pain/pain_controller

/mob/living/Destroy()
	QDEL_NULL(pain_controller)
	return ..()

/mob/living/carbon/human/Initialize()
	. = ..()
	var/datum/pain/new_pain_controller = new(src)
	if(!QDELETED(new_pain_controller))
		pain_controller = new_pain_controller

/mob/living/proc/cause_pain(target_zone, amount, dam_type = BRUTE)
	return pain_controller?.adjust_bodypart_pain(target_zone, amount, dam_type)

/mob/living/proc/pain_emote(emote, cooldown)
	return pain_controller?.do_pain_emote(emote, cooldown)

/mob/living/proc/apply_min_pain(target_zone, amount, time)
	return apply_status_effect(/datum/status_effect/minimum_bodypart_pain, target_zone, amount, time)

/mob/living/proc/set_pain_mod(id, amount)
	return pain_controller?.set_pain_modifier(id, amount)

/mob/living/proc/unset_pain_mod(id)
	return  pain_controller?.unset_pain_modifier(id)

/mob/living/carbon

/**
 * Cause [amount] of [dam_type] sharp pain to [target_zones].
 * Sharp pain is for sudden spikes of pain that go away after [duration] deciseconds.
 */
/mob/living/proc/sharp_pain(target_zones, amount = 0, dam_type = BRUTE, duration = 1 MINUTES)
	if(!pain_controller)
		return
	if(!islist(target_zones))
		target_zones = list(target_zones)
	for(var/zone in target_zones)
		apply_status_effect(/datum/status_effect/sharp_pain, zone, amount, dam_type, duration)

/**
 * Set [id] pain modifier to [amount], and
 * unset it automatically after [time] deciseconds have elapsed.
 */
/mob/living/proc/set_timed_pain_mod(id, amount = 0, time = 0)
	if(!pain_controller)
		return
	if(time <= 0)
		return
	set_pain_mod(id, amount)
	addtimer(CALLBACK(pain_controller, TYPE_PROC_REF(/datum/pain, unset_pain_modifier), id), time)

/**
 * Returns the bodypart pain of [zone].
 * If [get_modified] is TRUE, returns the bodypart's pain multiplied by any modifiers affecting it.
 */
/mob/living/proc/get_bodypart_pain(target_zone, get_modified = FALSE)
	return 0

/mob/living/carbon/get_bodypart_pain(target_zone, get_modified = FALSE)
	var/obj/item/bodypart/checked_bodypart = pain_controller?.body_zones[target_zone]
	if(!checked_bodypart)
		return 0

	return get_modified ? checked_bodypart.get_modified_pain() : checked_bodypart.pain
