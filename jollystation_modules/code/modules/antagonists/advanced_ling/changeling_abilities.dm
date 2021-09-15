// -- New changeling abilities / passives --

#define PAIN_MOD_LING_KEY "ling_ability"
#define PAIN_MOD_LING_AMOUNT 0.75
#define PAIN_CLEAR_COOLDOWN 2 MINUTES

#define UPLIFT_COOLDOWN 20 MINUTES

/datum/action/changeling/mimicvoice
	name = "Targeted Mimic Voice"

/datum/action/changeling/passive_mimicvoice
	name = "Adaptive Mimic Voice"
	desc = "We adjust our vocal glands to passively always sound as if it were our visible identity's voice."
	button_icon_state = "mimic_voice"
	helptext = "Passive. Functions similarly to the chameleon voice changer mask."
	chemical_cost = 0
	dna_cost = 1

/datum/action/changeling/passive_mimicvoice/on_purchase(mob/user, is_respec)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_green("Our vocal glands will now always mimic the voice of your visible identity."))
	our_ling.voice_matches_id = TRUE

/datum/action/changeling/passive_mimicvoice/Remove(mob/user)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_green("Our vocal glands will now no longer mimic the voice of your visible identity."))
	our_ling.voice_matches_id = FALSE

/mob/living/carbon/human
	var/voice_matches_id = FALSE

/mob/living/carbon/human/GetVoice()
	. = ..()
	if(voice_matches_id)
		var/obj/item/card/id/idcard = wear_id.GetID()
		if(istype(idcard))
			return idcard.registered_name
		else
			return get_face_name()

/datum/action/changeling/pain_reduction
	name = "Nervous System Realignment"
	desc = "We realign our nervous system, making us naturally more resistant to pain. \
		Can be activated to reboot our nervous system, removing all pain on use."
	button_icon_state = "mimic_voice" // MELBERT TODO: ICON
	helptext = "Passively reduces the amount of pain you recieve. On active, removes all pain instantly - though this action has a cooldown period."
	chemical_cost = 15
	dna_cost = 1
	COOLDOWN_DECLARE(pain_clear_cooldown)

/datum/action/changeling/pain_reduction/on_purchase(mob/user, is_respec)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_green("Our nervous system shifts around, making us more resilient to pain."))
	our_ling.set_pain_mod(PAIN_MOD_LING_KEY, PAIN_MOD_LING_AMOUNT)

/datum/action/changeling/pain_reduction/Remove(mob/user)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_green("Our nervous sytem twists back into place, making us less resilient to pain."))
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
	button_icon_state = "mimic_voice" // MELBERT TODO: ICON
	helptext = "Requires the victim be dead or unconscious. On success, the victim is implanted with a changeling headslug, granting them changling powers. \
		The victim gains genetic points equals to half our max genetics points. This abilities goes on a very long cooldown after use, and can only be used twice."
	chemical_cost = 0
	dna_cost = 4
	COOLDOWN_DECLARE(uplift_cooldown)

/datum/action/changeling/grant_powers/can_sting(mob/living/user, mob/target)
	. = ..()
	if(!.)
		return

	var/datum/antagonist/changeling/our_ling = user.mind.has_antag_datum(/datum/antagonist/changeling)

	if(!COOLDOWN_FINISHED(src, uplift_cooldown))
		to_chat(user, span_warning("We uplifted someone recently, and must wait [round(uplift_cooldown / (60 * 60), 0.1)] minutes to regenerate a new headslug!"))
		return FALSE
	if(our_ling.changeling_uplifts >= 2)
		to_chat(user, span_warning("We cannot uplift any more creatures ourself!"))
		return FALSE
	if(!user.pulling || !iscarbon(user.pulling))
		to_chat(user, span_warning("We must be grabbing a creature to uplift it!"))
		return FALSE
	if(user.grab_state <= GRAB_NECK)
		to_chat(user, span_warning("We must have a tighter grip to uplift this creature!"))
		return FALSE
	if(!target.mind)
		to_chat(user, span_warning("This creature has no mind or soul to uplift!"))
		return FALSE
	if(our_ling.isabsorbing)
		to_chat(user, span_warning("We are already attemping to uplift this creature!"))
		return FALSE
	if(target.mind.has_antag_datum(/datum/antagonist/changeling))
		to_chat(user, span_warning("You sense this creature already has a changeling headslug within!"))
		return FALSE

	return TRUE

/datum/action/changeling/grant_powers/sting_action(mob/user, mob/target)
	var/datum/antagonist/changeling/our_ling = user.mind.has_antag_datum(/datum/antagonist/changeling)
	var/mob/living/carbon/carbon_target = target
	our_ling.isabsorbing = TRUE
	for(var/i in 1 to 3)
		switch(i)
			if(1)
				to_chat(user, span_notice("This creature is compatible. We must hold still..."))
			if(2)
				user.visible_message(span_warning("[user] releases a headslug!"), span_notice("We release a headslug to infect [target]."))
			if(3)
				target.visible_message(span_danger("A headslug begins to inject [target] with a proboscis!"), span_danger("A headslug begins to inject you with a proboscis!"))
				to_chat(target, span_userdanger("You feel a sharp pain, followed by numbness..."))
				carbon_target.sharp_pain(BODY_ZONE_CHEST, 75, BRUTE, 15 SECONDS)

		SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("Grant Powers", "[i]"))
		if(!do_mob(user, target, (i * 8 SECONDS)))
			to_chat(user, span_warning("Our uplifting of [target] has been interrupted!"))
			our_ling.isabsorbing = FALSE
			return

	SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("Grant Powers", "4"))
	message_admins("Changeling [ADMIN_LOOKUPFLW(user)] has granted changeling powers to [ADMIN_LOOKUPFLW(target)].")
	log_game("Changeling [key_name(user)] has granted changeling powers to [key_name(target)].")
	target.visible_message(span_danger("The headslug takes over [target]!"), span_danger("The headslug takes us over!"))

	var/datum/antagonist/changeling/fresh/new_ling_datum = target.mind.add_antag_datum(/datum/antagonist/changeling/fresh)

	new_ling_datum.granter = WEAKREF(user)
	new_ling_datum.total_chem_storage = round(0.66 * our_ling.total_chem_storage)
	new_ling_datum.chem_storage = new_ling_datum.total_chem_storage
	new_ling_datum.chem_charges = 10
	new_ling_datum.total_geneticspoints = round(0.5 * our_ling.total_geneticspoints)
	new_ling_datum.geneticpoints = new_ling_datum.total_geneticspoints

	carbon_target.do_jitter_animation(80)
	if(carbon_target.heal_and_revive(60, span_danger("[target] begins to write as their body is infiltrated by a headslug!")))
		var/datum/action/changeling/regenerate/regenerate_action = locate() in target.actions
		regenerate_action?.sting_action(target) // Regenerate ourselves after
		carbon_target.AdjustUnconscious(8 SECONDS, TRUE)
		carbon_target.cause_pain(BODY_ZONE_CHEST, 40)
		carbon_target.cause_pain(BODY_ZONE_HEAD, 30)
		carbon_target.cause_pain(BODY_ZONES_LIMBS, 15)
	to_chat(target, span_bold(span_green("[user] has uplifted you into their changeling hive, granting you powers of a changeling!")))
	to_chat(target, span_green("You are weaker than them, inheriting only half of their genetic power potential. You are to assist them wherever possible."))

	our_ling.changeling_uplifts++
	our_ling.isabsorbing = FALSE
	COOLDOWN_START(src, uplift_cooldown, UPLIFT_COOLDOWN)

/datum/antagonist/changeling
	var/changeling_uplifts = 0

/datum/antagonist/changeling/fresh
	name = "Fresh Changeling"
	you_are_greet = FALSE
	show_in_antagpanel = FALSE
	give_objectives = FALSE
	soft_antag = TRUE
	var/datum/weakref/granter

/datum/antagonist/changeling/fresh/greet()
	if(you_are_greet)
		to_chat(owner, span_boldannounce("You are a fresh changeling! You were once human, but uplifted into the changeling hive by another changeling. You are weaker than them, but assist them where you can."))
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, TRUE, 42000, pressure_affected = FALSE, use_reverb = FALSE)

#undef PAIN_CLEAR_COOLDOWN
#undef PAIN_MOD_LING_KEY
#undef PAIN_MOD_LING_AMOUNT

#undef UPLIFT_COOLDOWN
