// -- New changeling abilities / passives --

#define PAIN_MOD_LING_KEY "ling_ability"
#define PAIN_MOD_LING_AMOUNT 0.75
#define PAIN_CLEAR_COOLDOWN 2 MINUTES

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
		to_chat(user, span_warning("We recently rebooted our nervous system, and cannot do it again yet!"))
		return FALSE
	if(!ishuman(user))
		return FALSE

	. = ..()
	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_notice("We reboot our nervous system, completely removing all pain affecting us."))
	our_ling.cause_pain(BODY_ZONES_ALL, -500)
	COOLDOWN_START(src, pain_clear_cooldown, PAIN_CLEAR_COOLDOWN)
	return TRUE

#undef PAIN_CLEAR_COOLDOWN
#undef PAIN_MOD_LING_KEY
#undef PAIN_MOD_LING_AMOUNT
