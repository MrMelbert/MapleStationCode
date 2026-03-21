// -- New changeling stings --

#define DOAFTER_SOURCE_LINGSTING "doafter_changeling_sting"

// Extra modular code so ling stings can have a working hud icon.
/datum/action/changeling/sting
	var/hud_icon = 'icons/hud/screen_changeling.dmi'

/datum/action/changeling/sting/set_sting(mob/user)
	var/datum/antagonist/changeling/our_ling = is_any_changeling(user)
	our_ling?.lingstingdisplay.icon = hud_icon
	return ..()

/datum/action/changeling/sting/unset_sting(mob/user)
	. = ..()
	var/datum/antagonist/changeling/our_ling = is_any_changeling(user)
	our_ling?.lingstingdisplay.icon = initial(our_ling.lingstingdisplay.icon)

/**
 * Simple proc to check if [target] is in range of [user] according to the user's [var/sting_range]
 */
/datum/action/changeling/sting/proc/check_range(mob/user, mob/target)
	var/datum/antagonist/changeling/our_ling = is_any_changeling(user)
	if(!our_ling)
		CRASH("changeling sting check_range failed to find changeling antagonist datum of [user]!")
	return IN_GIVEN_RANGE(user, target, our_ling.sting_range)

/// Changeling sting that injects knock-out chems, to give lings a stealthy way of kidnapping people.
/datum/action/changeling/sting/knock_out
	name = "Knockout Sting"
	desc = "After a short preparation, we sting our victim with a chemical that induces a short sleep after a short time. Costs 40 chemicals."
	helptext = "The sting takes three seconds to prepare, during which you must remain in range of the victim. The victim will be made aware \
		of the sting when complete, and will be able to call for help or attempt to run for a short period of time until falling asleep. \
		The chemical takes about 20 seconds to kick in, and lasts for roughly 1 minute."
	hud_icon = 'maplestation_modules/icons/hud/screen_changeling.dmi'
	button_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "sting_sleep"
	chemical_cost = 40
	dna_cost = 2

/datum/action/changeling/sting/knock_out/can_sting(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return
	if(target.reagents.has_reagent(/datum/reagent/toxin/sodium_thiopental))
		to_chat(user, span_warning("[target] was recently stung and cannot be stung again."))
		return FALSE

	if(DOING_INTERACTION(user, DOAFTER_SOURCE_LINGSTING))
		return FALSE

	if(!do_after(
		user,
		3 SECONDS,
		target,
		timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE,
		extra_checks = CALLBACK(src, PROC_REF(check_range), user, target),
		interaction_key = DOAFTER_SOURCE_LINGSTING,
		hidden = TRUE,
	))
		to_chat(user, span_warning("We could not complete the sting on [target]. They are not yet aware."))
		return FALSE
	return TRUE

/datum/action/changeling/sting/knock_out/sting_action(mob/user, mob/target)
	..()
	log_combat(user, target, "stung", "knock-out sting")
	// 3 units to sleep to trigger. For ever additional 3 units, 20 seconds of sleep.
	target.reagents?.add_reagent(/datum/reagent/toxin/sodium_thiopental, 12)
	return TRUE

/datum/action/changeling/sting/knock_out/sting_feedback(mob/user, mob/target)
	if(!target)
		return FALSE
	to_chat(user, span_notice("We successfully sting [target]. They are aware of the sting that occured."))
	to_chat(target, span_warning("You feel a tiny prick."))
	return TRUE

/// Changeling sting that injects poison chems.
/datum/action/changeling/sting/poison
	name = "Toxin Sting"
	desc = "After a short preparation, we sting our victim with debilitating toxic chemicals, \
		dealing roughly 50 toxins damage to the victim over time, as well as fatiguing them and causing brain damage. Costs 30 chemicals."
	helptext = "The sting takes a second to prepare, during which you must remain in range of the victim. \
		The target will feel the toxins entering their body when the sting is complete, but will be unaware the sting itself occured."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "sting_poison"
	chemical_cost = 30
	dna_cost = 2

/datum/action/changeling/sting/poison/can_sting(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return
	if(target.reagents.has_reagent(/datum/reagent/toxin, 5))
		to_chat(user, span_warning("[target] was recently stung and cannot be stung again."))
		return FALSE

	if(DOING_INTERACTION(user, DOAFTER_SOURCE_LINGSTING))
		return FALSE

	if(!do_after(
		user,
		1 SECONDS,
		target,
		timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE,
		extra_checks = CALLBACK(src, PROC_REF(check_range), user, target),
		interaction_key = DOAFTER_SOURCE_LINGSTING,
		hidden = TRUE,
	))
		to_chat(user, span_warning("We could not complete the sting on [target]. They are not yet aware."))
		return FALSE
	return TRUE

/datum/action/changeling/sting/poison/sting_action(mob/user, mob/target)
	..()
	log_combat(user, target, "stung", "poison sting")
	target.reagents?.add_reagent(/datum/reagent/toxin, 10)
	target.reagents?.add_reagent(/datum/reagent/toxin/formaldehyde, 10)
	target.reagents?.add_reagent(/datum/reagent/consumable/ethanol/neurotoxin, 10)
	return TRUE

/datum/action/changeling/sting/poison/sting_feedback(mob/user, mob/target)
	. = ..()
	if(!.)
		return

	to_chat(target, span_danger("You feel unwell."))

#undef DOAFTER_SOURCE_LINGSTING
