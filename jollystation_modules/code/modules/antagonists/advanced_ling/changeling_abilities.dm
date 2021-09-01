// -- New changeling abilities / passives --

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
	to_chat(our_ling, span_notice("Our vocal glands will now always mimic the voice of your visible identity."))
	our_ling.voice_matches_id = TRUE

/datum/action/changeling/passive_mimicvoice/Remove(mob/user)
	. = ..()
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/our_ling = user
	to_chat(our_ling, span_notice("Our vocal glands will now no longer mimic the voice of your visible identity."))
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
