// -- Helper procs and hooks for pain. --
/mob/living
	/// The pain controller datum - tracks, processes, and handles pain.
	/// Only intialized on humans (currently), here for ease of access / future compatibillity?
	var/datum/pain/pain_controller

/mob/living/Destroy()
	QDEL_NULL(pain_controller)
	return ..()

/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	var/datum/pain/new_pain_controller = new(src)
	if(!QDELETED(new_pain_controller))
		pain_controller = new_pain_controller

/**
 * Causes pain to this mob.
 *
 * Excess pain is converted to shock directly.
 *
 * (Note that most damage causes pain regardless, but this is still useful for direct pain damage)
 *
 * * target_zone - required, which zone or zones to afflict pain to
 * If passed multiple zones, the amount will be divided evenly between them,
 * though leftover pain will be distributed to the remaining zones.
 * * amount - how much pain to inflict
 * * dam_type - the type of pain to inflict. Only [BRUTE] and [BURN] really matters.
 *
 * Returns the amount of pain caused, or 0 if nothing was caused or no pain controller exists.
 */
/mob/living/proc/cause_pain(target_zone, amount, dam_type = BRUTE)
	ASSERT(istext(target_zone) || islist(target_zone))
	ASSERT(isnum(amount))
	if(isnull(pain_controller))
		return 0

	amount = round(abs(amount), DAMAGE_PRECISION)

	var/sum_damage = 0
	if(islist(target_zone))
		var/num_zones = length(target_zone)
		var/list/target_zones = shuffle(target_zone)
		var/per_bodypart = amount / num_zones
		for(var/i in 1 to num_zones)
			// adjust_bodypart_pain can return a smaller amount than requested if entering the soft cap, so adjust accordingly
			var/dealt = min(pain_controller.adjust_bodypart_pain(target_zones[i], per_bodypart, dam_type), per_bodypart)
			sum_damage += dealt
			// some was left over, let remaining zones pick it up before putting it to shock
			if(dealt < abs(per_bodypart) && i != num_zones)
				per_bodypart = (amount - dealt) / (num_zones - i)

	else
		// adjust_bodypart_pain can return a smaller amount than requested if entering the soft cap, so adjust accordingly
		sum_damage += min(pain_controller?.adjust_bodypart_pain(target_zone, amount, dam_type), amount)

	var/leftover = round(abs(amount) - sum_damage, DAMAGE_PRECISION)
	if(leftover > 1)
		pain_controller?.adjust_traumatic_shock(leftover * 0.1)

	return sum_damage

/**
 * Heals pain on the mob.
 *
 * Converts excess healing to (some) shock healing
 *
 * * amount - how much pain to heal
 * * target_zone - which zone or zones to heal pain from. Defaults to all zones.
 * If you pass it multiple zones, the amount will be divided evenly between them,
 * though leftover healing will be distributed to the remaining zones.
 *
 * Returns the amount of pain healed, or 0 if nothing was healed or no pain controller exists.
 */
/mob/living/proc/heal_pain(amount, target_zone = BODY_ZONES_ALL)
	ASSERT(istext(target_zone) || islist(target_zone))
	ASSERT(isnum(amount))
	if(isnull(pain_controller))
		return 0

	amount = round(abs(amount) * -1, DAMAGE_PRECISION)

	var/sum_heal = 0
	if(islist(target_zone))
		var/num_zones = length(target_zone)
		var/list/target_zones = shuffle(target_zone)
		var/per_bodypart = amount / num_zones
		for(var/i in 1 to num_zones)
			// adjust_bodypart_pain can return a larger amount than requested if in the soft cap, so adjust accordingly
			var/heal = max(pain_controller.adjust_bodypart_pain(target_zones[i], per_bodypart), per_bodypart)
			sum_heal += heal
			// some was left over, let remaining zones pick it up before putting it to shock
			if(heal > per_bodypart && i != num_zones)
				per_bodypart = (amount - abs(heal)) / (num_zones - i)

	else
		// adjust_bodypart_pain can return a larger amount than requested if in the soft cap, so adjust accordingly
		sum_heal += max(pain_controller.adjust_bodypart_pain(target_zone, amount), amount)

	var/leftover = round(abs(amount) - sum_heal, DAMAGE_PRECISION)
	if(leftover > 0.5)
		pain_controller.adjust_traumatic_shock(leftover * -0.1, down_to = 30)

	return sum_heal

/**
 * Runs an emote on the pain emote cooldown
 * Emote supplied does NOT need to be a pain emote
 *
 * If no emote is supplied, randomly picks from all pain-related emotes
 *
 * * emote - what emote key to run
 * * cooldown - applies cooldown on doing similar pain related emotes
 */
/mob/living/proc/pain_emote(emote, cooldown)
	return pain_controller?.do_pain_emote(emote, cooldown)

/**
 * Runs a pain message on the pain message cooldown
 *
 * * message - the message to send
 * * painless_message - optional, the message to send if the mob does not feel pain
 * * cooldown - applies cooldown on doing similar pain messages
 */
/mob/living/proc/pain_message(message, painless_message, cooldown)
	return pain_controller?.do_pain_message(message, painless_message, cooldown)

/**
 * Adjust the minimum pain the target zone can experience for a time
 *
 * This means that the target zone will not be able to go below the specified pain amount
 *
 * * target_zone - required, which zone to afflict pain to
 * * amount - how much min pain to increase
 * * time - how long to incease the min pain to
 */
/mob/living/proc/apply_min_pain(target_zone, amount, time)
	ASSERT(!isnull(target_zone))
	ASSERT(isnum(amount))
	ASSERT(isnum(time))
	return apply_status_effect(/datum/status_effect/minimum_bodypart_pain, target_zone, amount, time)

/**
 * Sets the pain modifier of [id] to [amount].
 */
/mob/living/proc/set_pain_mod(id, amount)
	ASSERT(isnum(amount))
	ASSERT(istext(id) || ispath(id))
	return pain_controller?.set_pain_modifier(id, amount)

/**
 * Unsets the pain mod at the supplied [id].
 */
/mob/living/proc/unset_pain_mod(id)
	ASSERT(istext(id) || ispath(id))
	return pain_controller?.unset_pain_modifier(id)

/**
 * Adjusts the progress of pain shock on the current mob.
 *
 * * amount - the number of ticks of progress to remove. Note that one tick = two seconds for pain.
 * * down_to - the minimum amount of pain shock the mob can have.
 */
/mob/living/proc/adjust_traumatic_shock(amount, down_to = 0)
	pain_controller?.adjust_traumatic_shock(amount, down_to)

/**
 * Cause [amount] of [dam_type] sharp pain to [target_zones].
 * Sharp pain is for sudden spikes of pain that go away after [duration] deciseconds.
 *
 * * target_zones - requried, one or multiple target zones to apply sharp pain to
 * * amount - how much sharp pain to inflict
 * * dam_type - the type of sharp pain to inflict. Only [BRUTE] and [BURN] really matters.
 * * duration - how long the sharp pain lasts for
 * * return_mod - how much of the sharp pain is healed when the effect ends
 */
/mob/living/proc/sharp_pain(target_zones, amount, dam_type = BRUTE, duration = 1 MINUTES, return_mod = 0.33)
	if(isnull(pain_controller))
		return
	ASSERT(!isnull(target_zones))
	ASSERT(isnum(amount))
	apply_status_effect(/datum/status_effect/sharp_pain, target_zones, amount, dam_type, duration, return_mod)

/**
 * Set [id] pain modifier to [amount], and
 * unsets it after [time] deciseconds have elapsed.
 */
/mob/living/proc/set_timed_pain_mod(id, amount, time)
	if(isnull(pain_controller))
		return
	ASSERT(isnum(amount))
	ASSERT(isnum(time))
	ASSERT(istext(id) || ispath(id))
	if(time <= 0)
		// no-op rather than stack trace or anything, so code with variable time can ignore it
		return

	set_pain_mod(id, amount)
	addtimer(CALLBACK(pain_controller, TYPE_PROC_REF(/datum/pain, unset_pain_modifier), id), time)

/**
 * Returns the bodypart pain of [zone].
 * If [get_modified] is TRUE, returns the bodypart's pain multiplied by any modifiers affecting it.
 */
/mob/living/proc/get_bodypart_pain(target_zone, get_modified = FALSE)
	ASSERT(!isnull(target_zone))

	var/obj/item/bodypart/checked_bodypart = get_bodypart(target_zone)
	if(isnull(checked_bodypart))
		return 0

	return get_modified ? checked_bodypart.get_modified_pain() : checked_bodypart.pain
