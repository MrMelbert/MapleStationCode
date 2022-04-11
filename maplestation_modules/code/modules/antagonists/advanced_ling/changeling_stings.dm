// -- New changeling stings --

#define DOAFTER_SOURCE_LINGSTING "doafter_changeling_sting"
/// The duration of temp. transform sting.
#define TRANSFORMATION_STING_DURATION 4 MINUTES

// Extra modular code so ling stings can have a working hud icon.
/datum/action/changeling/sting
	var/hud_icon = 'icons/hud/screen_changeling.dmi'

/datum/action/changeling/sting/set_sting(mob/user)
	user.hud_used.lingstingdisplay.icon = hud_icon
	. = ..()

/datum/action/changeling/sting/unset_sting(mob/user)
	. = ..()
	user.hud_used.lingstingdisplay.icon = initial(user.hud_used.lingstingdisplay.icon)

/*
 * Simple proc to check if [target] is in range of [user] according to the user's [var/sting_range]
 */
/datum/action/changeling/sting/proc/check_range(mob/user, mob/target)
	var/datum/antagonist/changeling/our_ling = is_any_changeling(user)
	if(!our_ling)
		CRASH("changeling sting check_range failed to find changeling antagonist datum of [user]!")
	return IN_GIVEN_RANGE(user, target, our_ling.sting_range)

/// Temporary transform sting. Transform sting but hopefully less bad / encourages more tactical or stealth uses.
/// Duration is halved for conscious people, full duration for crit people, and permanent for dead people.
/datum/action/changeling/sting/temp_transformation
	name = "Temporary Transformation Sting"
	desc = "We silently sting a human, injecting a retrovirus that forces them to transform. \
		If the human is alive, the transformation is temporary, and lasts 4 minutes. Costs 50 chemicals."
	helptext = "If the victim is conscious, the sting will take a second to complete, during which you must remain in range of them. \
		The victim will transform much like a changeling would. Does not provide a warning to others. \
		Mutations and quirks will not be transferred, and monkeys will become human."
	button_icon_state = "sting_transform"
	chemical_cost = 50
	dna_cost = 2
	/// Our DNA we're using to target.
	var/datum/changeling_profile/selected_dna

/datum/action/changeling/sting/temp_transformation/Trigger(trigger_flags)
	var/mob/user = usr
	var/datum/antagonist/changeling/changeling = is_any_changeling(user)
	if(changeling.chosen_sting)
		unset_sting(user)
		return
	selected_dna = changeling.select_dna()
	if(QDELETED(src) || QDELETED(changeling) || !selected_dna)
		return
	if(NOTRANSSTING in selected_dna.dna.species.species_traits)
		to_chat(user, span_notice("That DNA is not compatible with changeling retrovirus!"))
		return
	. = ..()

/datum/action/changeling/sting/temp_transformation/can_sting(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return
	if((HAS_TRAIT(target, TRAIT_HUSK)) || !iscarbon(target) || (!ismonkey(target) && (NOTRANSSTING in target.dna.species.species_traits)))
		to_chat(user, span_warning("Our sting appears ineffective against [target]'s DNA."))
		return FALSE

	if(target.stat == CONSCIOUS)
		if(DOING_INTERACTION(user, DOAFTER_SOURCE_LINGSTING))
			return FALSE

		if(!do_mob(user, target, 1 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE, extra_checks = CALLBACK(src, .proc/check_range, user, target), interaction_key = DOAFTER_SOURCE_LINGSTING))
			to_chat(user, span_warning("We could not complete the sting on [target]."))
			return FALSE

	return TRUE

// MELBERT TODO: All DNA is copied over correctly... except for hairstyle. But that's fixable in a mirror, so.
/datum/action/changeling/sting/temp_transformation/sting_action(mob/user, mob/target)
	if(!iscarbon(target))
		return FALSE
	var/mob/living/carbon/carbon_target = target
	var/datum/dna/old_dna = new()
	carbon_target.dna.copy_dna(old_dna)

	if(ismonkey(carbon_target))
		to_chat(user, span_notice("Our genes cry out as we sting [target]!"))

	// Monkeys and dead people are transformed permanently. Alive humans are only transformed for a few minutes.
	if(!ismonkey(carbon_target) && target.stat != DEAD)
		log_combat(user, carbon_target, "stung", "temporary transformation sting", "- New identity is '[selected_dna.dna.real_name]'")
		addtimer(CALLBACK(src, .proc/sting_transform, carbon_target, old_dna), ((carbon_target.stat ? 1 : 0.5) * TRANSFORMATION_STING_DURATION))
	else
		log_combat(user, carbon_target, "stung", "permanent transformation sting", "- New identity is '[selected_dna.dna.real_name]'.")
	return sting_transform(carbon_target, selected_dna.dna)

/*
 * Transform [target] into the [transform_dna] DNA, changing the target's appearance.
 */
/datum/action/changeling/sting/temp_transformation/proc/sting_transform(mob/living/carbon/target, datum/dna/transform_dna)
	// This check should never run (probably), but just in case monkey DNA sneaks past via "old_DNA" some how
	if(istype(transform_dna.species, /datum/species/monkey))
		return FALSE

	if(ismonkey(target))
		target.humanize(transform_dna.species)

	message_admins("[key_name(target)] has been transformed into [transform_dna.real_name] by a changeling (linked to: [key_name(owner)]).")
	transform_dna.transfer_identity(target)
	target.updateappearance(mutcolor_update = 1)
	target.real_name = target.dna.real_name
	target.name = target.dna.real_name
	return TRUE

/// Changeling sting that injects knock-out chems, to give lings a stealthy way of kidnapping people.
/datum/action/changeling/sting/knock_out
	name = "Knockout Sting"
	desc = "After a short preparation, we sting our victim with a chemical that induces a short sleep after a short time. Costs 40 chemicals."
	helptext = "The sting takes three seconds to prepare, during which you must remain in range of the victim. The victim will be made aware \
		of the sting when complete, and will be able to call for help or attempt to run for a short period of time until falling asleep. \
		The chemical takes about 20 seconds to kick in, and lasts for roughly 1 minute."
	hud_icon = 'maplestation_modules/icons/hud/screen_changeling.dmi'
	icon_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
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

	if(!do_mob(user, target, 3 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE, extra_checks = CALLBACK(src, .proc/check_range, user, target), interaction_key = DOAFTER_SOURCE_LINGSTING))
		to_chat(user, span_warning("We could not complete the sting on [target]. They are not yet aware."))
		return FALSE
	return TRUE

/datum/action/changeling/sting/knock_out/sting_action(mob/user, mob/target)
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
	icon_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
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

	if(!do_mob(user, target, 1 SECONDS, timed_action_flags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE, extra_checks = CALLBACK(src, .proc/check_range, user, target), interaction_key = DOAFTER_SOURCE_LINGSTING))
		to_chat(user, span_warning("We could not complete the sting on [target]. They are not yet aware."))
		return FALSE
	return TRUE

/datum/action/changeling/sting/poison/sting_action(mob/user, mob/target)
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
#undef TRANSFORMATION_STING_DURATION
