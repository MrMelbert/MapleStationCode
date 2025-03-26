// -- New changeling abilities / passives --

// Defines for "Nervous System Realignment".
#define PAIN_MOD_LING_KEY "ling_ability"
#define PAIN_MOD_LING_AMOUNT 0.75
#define PAIN_CLEAR_COOLDOWN 2 MINUTES

// Defines for "Uplift Human".
#define UPLIFT_COOLDOWN 20 MINUTES

/datum/action/changeling/mimicvoice
	name = "Targeted Mimic Voice"

/datum/action/changeling/passive_mimicvoice
	name = "Adaptive Mimic Voice"
	desc = "We adjust our vocal glands to passively always sound as if it were our visible identity's voice."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "mimic_voice_passive"
	helptext = "Passive. Functions similarly to the chameleon voice changer mask."
	chemical_cost = 0
	dna_cost = 1

/datum/action/changeling/passive_mimicvoice/on_purchase(mob/user, is_respec)
	. = ..()
	to_chat(user, span_changeling("Our vocal glands will now always mimic the voice of your visible identity."))
	ADD_TRAIT(user, TRAIT_VOICE_MATCHES_ID, CHANGELING_ABILITY)

/datum/action/changeling/passive_mimicvoice/Remove(mob/user)
	. = ..()
	to_chat(user, span_changeling("Our vocal glands will now no longer mimic the voice of your visible identity."))
	REMOVE_TRAIT(user, TRAIT_VOICE_MATCHES_ID, CHANGELING_ABILITY)

/// Extension of GetVoice for TRAIT_VOICE_MATCHES_ID.
/mob/living/carbon/human/GetVoice()
	if(!HAS_TRAIT(src, TRAIT_VOICE_MATCHES_ID))
		return ..()
	var/obj/item/card/id/idcard = get_idcard(FALSE)
	return istype(idcard) ? idcard.registered_name : get_face_name()

/datum/action/changeling/pain_reduction
	name = "Nervous System Realignment"
	desc = "We realign our nervous system, making us naturally more resistant to pain. \
		Can be activated to reboot our nervous system, removing all pain on use."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "system_reboot"
	helptext = "Passively reduces the amount of pain you recieve. On active, removes all pain instantly - though this action has a cooldown period."
	chemical_cost = 15
	dna_cost = 1
	COOLDOWN_DECLARE(pain_clear_cooldown)

/datum/action/changeling/pain_reduction/on_purchase(mob/user, is_respec)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_changeling("Our nervous system shifts around, making us more resilient to pain."))
	our_ling.set_pain_mod(PAIN_MOD_LING_KEY, PAIN_MOD_LING_AMOUNT)

/datum/action/changeling/pain_reduction/Remove(mob/user)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_changeling("Our nervous sytem twists back into place, making us less resilient to pain."))
	our_ling.unset_pain_mod(PAIN_MOD_LING_KEY)

/datum/action/changeling/pain_reduction/sting_action(mob/user, mob/target)
	if(!COOLDOWN_FINISHED(src, pain_clear_cooldown))
		to_chat(user, span_warning("We recently rebooted our nervous system, and cannot do it again for [round(pain_clear_cooldown / (60 * 60), 0.1)] minutes!"))
		return FALSE
	if(!ishuman(user))
		return FALSE

	. = ..()
	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_notice("We reboot our nervous system, completely removing all pain affecting us."))
	our_ling.cause_pain(BODY_ZONES_ALL, -500)
	COOLDOWN_START(src, pain_clear_cooldown, PAIN_CLEAR_COOLDOWN)
	return TRUE

/datum/action/changeling/grant_powers
	name = "Uplift Human"
	desc = "After a long period, we integrate a victim into our changeling hivemind, granting them changeling powers. Requires us to strangle them."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_changeling.dmi'
	button_icon_state = "grant_powers"
	helptext = "Requires the victim be dead or unconscious. On success, the victim is implanted with a changeling headslug, granting them changling powers. \
		The victim gains genetic points equal to half our max genetics points. This abilities goes on a very long cooldown after use, and can only be used twice."
	chemical_cost = 0
	dna_cost = 3
	/// Whether we're currently uplifting them
	var/is_uplifting = FALSE
	/// The cooldown for uplifting
	COOLDOWN_DECLARE(uplift_cooldown)

/datum/action/changeling/grant_powers/can_be_used_by(mob/user)
	. = ..()
	if(!.)
		return

	var/static/list/lings_that_cannot_use_this = list(
		/datum/antagonist/changeling/fresh,
		/datum/antagonist/fallen_changeling,
		/datum/antagonist/changeling/headslug,
	)

	var/datum/antagonist/ling_datum = is_any_changeling(user)
	if(ling_datum.type in lings_that_cannot_use_this)
		to_chat(user, span_changeling("You are not developed enough as a changeling to use this!"))
		return FALSE

	return TRUE

/datum/action/changeling/grant_powers/can_sting(mob/living/user)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/target = user.pulling
	var/datum/antagonist/changeling/our_ling = is_any_changeling(user)
	var/datum/antagonist/changeling/fresh/their_ling = is_fresh_changeling(user)

	if(!COOLDOWN_FINISHED(src, uplift_cooldown))
		to_chat(user, span_warning("We uplifted someone recently, and must wait [round(uplift_cooldown / (60 * 60), 0.1)] minutes to regenerate a new headslug."))
		return FALSE
	if(our_ling.changeling_uplifts >= 2)
		to_chat(user, span_warning("We cannot uplift any more creatures into the hive!"))
		return FALSE
	if(!istype(target))
		to_chat(user, span_warning("We must be grabbing a creature to uplift!"))
		return FALSE
	if(user.grab_state <= GRAB_NECK)
		to_chat(user, span_warning("We must have a tighter grip to uplift this creature!"))
		return FALSE
	if(!target.mind)
		to_chat(user, span_warning("This creature has no mind or soul to uplift!"))
		return FALSE
	if(is_uplifting)
		to_chat(user, span_warning("We are already attemping to uplift this creature!"))
		return FALSE
	if(their_ling?.granter?.resolve() == user.mind)
		to_chat(user, span_warning("You already uplifted this creature!"))
		return FALSE
	if(is_any_changeling(target))
		to_chat(user, span_warning("You sense this creature already has a changeling headslug within!"))
		return FALSE

	return TRUE

/datum/action/changeling/grant_powers/sting_action(mob/user)
	SHOULD_CALL_PARENT(FALSE)

	var/datum/antagonist/changeling/our_ling = is_any_changeling(user)
	var/mob/living/target = user.pulling
	is_uplifting = TRUE

	if(!attempt_uplift(target))
		is_uplifting = FALSE
		return

	SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("Grant Powers", "4"))
	message_admins("Changeling [ADMIN_LOOKUPFLW(user)] has granted changeling powers to [ADMIN_LOOKUPFLW(target)].")
	log_game("Changeling [key_name(user)] has granted changeling powers to [key_name(target)].")
	target.visible_message(span_danger("The headslug takes over [target]!"), span_danger("The headslug takes us over!"))

	setup_new_ling(target)

	our_ling.changeling_uplifts++
	is_uplifting = FALSE
	COOLDOWN_START(src, uplift_cooldown, UPLIFT_COOLDOWN)

/// Go through and attempt to uplift [target]. Returns TRUE if successful, FALSE otherwise.
/datum/action/changeling/grant_powers/proc/attempt_uplift(mob/living/carbon/human/target)
	var/datum/action/changeling/absorb_dna/absorb_action = locate() in owner.actions
	if(absorb_action?.is_absorbing)
		to_chat(owner, span_warning("You are currently absorbing someone!"))
		return FALSE

	for(var/i in 1 to 3)
		switch(i)
			if(1)
				to_chat(owner, span_notice("This creature is compatible. We must hold still..."))
			if(2)
				owner.visible_message(span_warning("[owner] releases a headslug!"), span_notice("We release a headslug to infect [target]."))
			if(3)
				target.visible_message(span_danger("A headslug curls around [target] and bites them with their beak!"), span_danger("A headslug begins bite you with its beak!"))
				to_chat(target, span_userdanger("You feel a sharp pain, followed by numbness..."))
				target.sharp_pain(BODY_ZONE_CHEST, 75, BRUTE, 20 SECONDS)

		SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("Grant Powers", "[i]"))
		if(!do_after(owner, (i * 8 SECONDS), target, hidden = TRUE))
			to_chat(owner, span_warning("Our uplifting of [target] has been interrupted!"))
			return FALSE
		if(QDELETED(src))
			return FALSE
	return TRUE

/datum/action/changeling/grant_powers/proc/setup_new_ling(mob/living/carbon/human/target)
	var/datum/antagonist/changeling/our_ling = is_any_changeling(owner)
	var/datum/antagonist/changeling/fresh/new_ling_datum = target.mind.add_antag_datum(/datum/antagonist/changeling/fresh)

	new_ling_datum.granter = WEAKREF(owner.mind)
	new_ling_datum.total_chem_storage = round(0.66 * our_ling.total_chem_storage)
	new_ling_datum.chem_charges = 10
	new_ling_datum.total_genetic_points = round(0.5 * our_ling.total_genetic_points)
	new_ling_datum.genetic_points = new_ling_datum.total_genetic_points

	new_ling_datum.finalize_antag()
	new_ling_datum.create_innate_actions(our_ling)
	new_ling_datum.antag_memory += "[owner.mind] is your hive leader. Assist them where possible."

	var/datum/objective/custom/custom_objective = new()
	custom_objective.explanation_text = "Assist the changeling [owner.mind], your hive leader."
	custom_objective.owner = target.mind
	new_ling_datum.objectives += custom_objective

	target.do_jitter_animation(80)
	if(target.heal_and_revive(60, span_danger("[target] begins to write as their body is infiltrated by a headslug!")))
		var/datum/action/changeling/regenerate/regenerate_action = locate() in target.actions
		regenerate_action?.sting_action(target) // Regenerate ourselves after
		target.AdjustUnconscious(8 SECONDS, TRUE)
		target.cause_pain(BODY_ZONE_CHEST, 40)
		target.cause_pain(BODY_ZONE_HEAD, 30)
		target.cause_pain(BODY_ZONES_LIMBS, 15)
	to_chat(target, span_bold(span_changeling("[owner] has uplifted you into their changeling hive, granting you powers of a changeling!")))
	to_chat(target, span_changeling("You are weaker than them, inheriting only half of their genetic power potential. You are to assist them wherever possible."))

	target.apply_status_effect(/datum/status_effect/agent_pinpointer/changeling_spawn)

#undef PAIN_CLEAR_COOLDOWN
#undef PAIN_MOD_LING_KEY
#undef PAIN_MOD_LING_AMOUNT

#undef UPLIFT_COOLDOWN
