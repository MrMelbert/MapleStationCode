// -- Helper procs and hooks for pain. --
/mob/living/carbon
	/// A paint controller datum, to track and deal with pain.
	/// Only initialized on humans.
	var/datum/pain/pain_controller

/mob/living/carbon/human/Initialize()
	. = ..()
	pain_controller = new(src)

/mob/living/carbon/human/Destroy()
	if(pain_controller)
		QDEL_NULL(pain_controller)
	return ..()

/*
 * Helper carbon proc to cause [amount] pain of [type] damage type to [target_zone].
 */
/mob/living/carbon/proc/cause_pain(target_zone, amount = 0, type = BRUTE)
	pain_controller?.adjust_bodypart_pain(target_zone, amount, type)

/*
 * Cause [amount] of [type] sharp pain [target_zone].
 * Sharp pain is for sudden spikes of pain that go away in [duration] time.
 */
/mob/living/carbon/proc/sharp_pain(target_zones, amount = 0, type = BRUTE, duration = 2 MINUTES)
	if(!islist(target_zones))
		target_zones = list(target_zones)
	for(var/zone in target_zones)
		apply_status_effect(/datum/status_effect/sharp_pain, zone, amount, type, duration)

/*
 * Do pain related [emote] from a mob, and start a [cooldown] long cooldown before a pain emote can be done again.
 */
/mob/living/carbon/proc/pain_emote(emote, cooldown)
	pain_controller?.do_pain_emote(emote, cooldown)

/*
 * Helper carbon proc to set [zone] min pain to [amount] that expires after [time].
 */
/mob/living/carbon/proc/apply_min_pain(zone, amount = 0, time = 0)
	apply_status_effect(/datum/status_effect/minimum_bodypart_pain, zone, amount, time)

/*
 * Helper carbon proc to set [id] pain mod with amount [amount] that expires after [time].
 */
/mob/living/carbon/proc/set_pain_mod(id, amount = 0, time = 0)
	pain_controller?.set_pain_modifier(id, amount)
	if(time > 0)
		addtimer(CALLBACK(src, .proc/unset_pain_mod, id), time)

/*
 * Returns the bodypart pain of [zone].
 * If [get_modified] is TRUE, returns the bodypart's pain multiplied by any modifiers affecting it.
 */
/mob/living/carbon/proc/get_bodypart_pain(zone, get_modified = FALSE)
	var/obj/item/bodypart/checked_bodypart = pain_controller?.body_zones[zone]
	if(!checked_bodypart)
		return 0

	if(get_modified)
		return checked_bodypart.get_modified_pain()
	else
		return checked_bodypart.pain

/*
 * Helper carbon proc to clear [id] pain mod.
 */
/mob/living/carbon/proc/unset_pain_mod(id)
	pain_controller?.unset_pain_modifier(id)

/datum/species/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	if(!isnull(species_pain_mod))
		C.set_pain_mod(PAIN_MOD_SPECIES, species_pain_mod)

/datum/species/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	C.unset_pain_mod(PAIN_MOD_SPECIES)
