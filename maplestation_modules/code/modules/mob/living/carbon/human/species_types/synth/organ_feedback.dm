/**
 * Send a feedback message to the mob based on on whether they have an organ, or if the organ is organic vs robotic
 */
/mob/living/proc/organ_feedback_message(organ_or_slot, span = "notice", organic_msg, robotic_msg, missing_msg)
	var/obj/item/organ/organ = organ_or_slot
	if(!istype(organ))
		if(istext(organ_or_slot))
			organ = get_organ_slot(organ_or_slot)
		else if(ispath(organ_or_slot, /obj/item/organ))
			organ = get_organ_by_type(organ_or_slot)

	if(isnull(organ))
		if(missing_msg)
			to_chat(src, "<span class='[span]'>[missing_msg]</span>")
		return

	if(IS_ORGANIC_ORGAN(organ))
		if(organic_msg)
			to_chat(src, "<span class='[span]'>[organic_msg]</span>")
	else
		if(robotic_msg)
			to_chat(src, "<span class='[span]'>[robotic_msg]</span>")

/**
 * Performs an emote based on whether the passed organ is organic or robotic
 */
/mob/living/proc/organ_emote(organ_or_slot, organic_emote, robotic_emote, missing_emote)
	var/obj/item/organ/organ = organ_or_slot
	if(!istype(organ))
		if(istext(organ_or_slot))
			organ = get_organ_slot(organ_or_slot)
		else if(ispath(organ_or_slot, /obj/item/organ))
			organ = get_organ_by_type(organ_or_slot)

	if(isnull(organ))
		if(missing_emote)
			emote(missing_emote)
		return

	if(IS_ORGANIC_ORGAN(organ))
		if(organic_emote)
			emote(organic_emote)
	else
		if(robotic_emote)
			emote(robotic_emote)
