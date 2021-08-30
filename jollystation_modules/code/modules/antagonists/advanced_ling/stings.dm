// -- Changeling sting rebalancing/ and additions. --

#define DOAFTER_SOURCE_LINGSTING "doafter_changeling_sting"
/// The duration of temp. transform sting.
#define TRANSFORMATION_STING_DURATION 10 SECONDS//4 MINUTES

// Buffs adrenal sacs so they work like old adrenals. Increased chemical cost to compensate.
/datum/action/changeling/adrenaline
	desc = "We evolve additional sacs of adrenaline throughout our body. Costs 40 chemicals."
	chemical_cost = 40

/// MELBERT TODO; this doesn't get up instantly cause stamcrit?
/datum/action/changeling/adrenaline/sting_action(mob/living/user)
	user.adjustStaminaLoss(-75)
	user.set_resting(FALSE, instant = TRUE)
	user.SetStun(0)
	user.SetImmobilized(0)
	user.SetParalyzed(0)
	user.SetKnockdown(0)
	. = ..()

// Disables spread infestation.
/datum/action/changeling/spiders
	dna_cost = -1

// Disables transform sting.
/datum/action/changeling/sting/transformation
	dna_cost = -1

// Extra modular code so ling stings can have a working hud icon.
/datum/action/changeling/sting
	var/hud_icon = 'icons/hud/screen_changeling.dmi'

/datum/action/changeling/sting/set_sting(mob/user)
	user.hud_used.lingstingdisplay.icon = hud_icon
	. = ..()

/datum/action/changeling/sting/unset_sting(mob/user)
	. = ..()
	user.hud_used.lingstingdisplay.icon = initial(user.hud_used.lingstingdisplay.icon)

/// Temporary transform sting. Transform sting but hopefully less bad / encourages more tactical or stealth uses.
/// Duration is halved for conscious people, full duration for crit people, and permanent for dead people.
/datum/action/changeling/sting/temp_transformation
	name = "Temporary Transformation Sting"
	desc = "We silently sting a human, injecting a retrovirus that forces them to transform. \
		If the human is alive, the transformation is temporary, and lasts 3 minutes. Costs 50 chemicals."
	helptext = "If the victim is conscious, the sting will take a second to complete, during which you must both remain still. \
		The victim will transform much like a changeling would. Does not provide a warning to others. \
		Mutations and quirks will not be transferred, and monkeys will become human."
	button_icon_state = "sting_transform"
	chemical_cost = 50
	dna_cost = 2
	/// Our DNA we're using to target.
	var/datum/changelingprofile/selected_dna

/datum/action/changeling/sting/temp_transformation/Trigger()
	var/mob/user = usr
	var/datum/antagonist/changeling/changeling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	if(changeling.chosen_sting)
		unset_sting(user)
		return
	selected_dna = changeling.select_dna("Select the target DNA: ", "Target DNA")
	if(!selected_dna)
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

		if(!do_after(user, 1 SECONDS, target, interaction_key = DOAFTER_SOURCE_LINGSTING))
			to_chat(user, span_warning("We could not complete the sting on [target]."))
			return FALSE

	return TRUE


// MELBERT TODO; hair doesn't stay
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
	helptext = "The sting takes one second to prepare, during which you and the victim must not move. The victim will be made aware \
		of the sting when complete, and will be able to call for help or attempt to run for a short period of time until falling asleep."
	hud_icon = 'jollystation_modules/icons/hud/screen_changeling.dmi'
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_changeling.dmi'
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

	if(!do_after(user, 1 SECONDS, target, interaction_key = DOAFTER_SOURCE_LINGSTING))
		to_chat(user, span_warning("We could not complete the sting on [target]. They are not aware of the sting yet."))
		return FALSE
	return TRUE

/datum/action/changeling/sting/knock_out/sting_action(mob/user, mob/target)
	log_combat(user, target, "stung", "knock-out sting")
	target.reagents?.add_reagent(/datum/reagent/toxin/sodium_thiopental, 10)
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
		dealing roughly 50 toxins damage to the victim over time. Costs 30 chemicals."
	helptext = "The sting takes a half second to prepare, during which you and the victim must not move. \
		The target will feel the toxins entering their body when the sting is complete, but will be unaware the sting itself occured."
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "sting_poison"
	chemical_cost = 30
	dna_cost = 2

/datum/action/changeling/sting/poison/can_sting(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return
	if(target.reagents.has_reagent(/datum/reagent/toxin, 5, TRUE))
		to_chat(user, span_warning("[target] was recently stung and cannot be stung again."))
		return FALSE

	if(DOING_INTERACTION(user, DOAFTER_SOURCE_LINGSTING))
		return FALSE

	if(!do_after(user, 0.5 SECONDS, target, interaction_key = DOAFTER_SOURCE_LINGSTING))
		to_chat(user, span_warning("We could not complete the sting on [target]."))
		return FALSE
	return TRUE

/datum/action/changeling/sting/poison/sting_action(mob/user, mob/target)
	to_chat(target, span_danger("You feel unwell."))
	log_combat(user, target, "stung", "poison sting")
	target.reagents?.add_reagent(/datum/reagent/toxin, 10)
	target.reagents?.add_reagent(/datum/reagent/toxin/formaldehyde, 10)
	return TRUE

#undef DOAFTER_SOURCE_LINGSTING
#undef TRANSFORMATION_STING_DURATION
