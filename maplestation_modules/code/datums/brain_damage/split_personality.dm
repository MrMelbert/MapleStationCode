/datum/brain_trauma/severe/split_personality/orderly/
	name = "Orderly Split Personality"
	desc = "Patient's brain is split into two personalities, which switch control of the body occasionally."


/datum/brain_trauma/severe/split_personality/orderly/on_life(seconds_per_tick, times_fired)
	return //no random switching

/datum/brain_trauma/severe/split_personality/orderly/on_gain()
	. = ..()
	var/datum/action/request_switch/stranger/stranger_spell = new(src)
	stranger_spell.Grant(stranger_backseat)

	var/datum/action/request_switch/owner/owner_spell = new(src)
	owner_spell.Grant(owner)


// Action to request switch between bodies

/datum/action/request_switch
	name = "Request Switch"
	desc = "Request to switch control over the shared body."
	background_icon_state = "bg_spell"
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "swap"
	overlay_icon_state = "bg_spell_border"
	var/requested = FALSE


/datum/action/request_switch/owner

/datum/action/request_switch/stranger

/datum/action/request_switch/New(Target)
	. = ..()

	if(!istype(target, /datum/brain_trauma/severe/split_personality))
		stack_trace("[type] was created on a target that isn't a /datum/brain_trauma/severe/split_personality, this doesn't work.")
		qdel(src)

/datum/action/request_switch/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return FALSE

	requested = !requested

	if (requested)
		to_chat(target, "REQUESTED")
	else
		to_chat(target, "NOT REQUESTED")

/datum/action/request_switch/owner/Trigger(trigger_flags)
	. = ..()

	var/datum/brain_trauma/severe/split_personality/trauma = target
	var/mob/living/carbon/human/personality_body = trauma.owner
	var/mob/living/split_personality/non_controller = target.stranger_backseat

	request(personality_body, non_controller)

/datum/action/request_switch/stranger/Trigger(trigger_flags)
	. = ..()

	var/datum/brain_trauma/severe/split_personality/trauma = target
	var/mob/living/carbon/human/personality_body = trauma.owner
	var/mob/living/split_personality/non_controller = trauma.stranger_backseat

	request(personality_body, non_controller)

/datum/action/request_switch/stranger/proc/request(mob/controller, mob/non_controller)
	var/str_request_msg = span_boldnotice("You concentrate on attempting to take direct control over your body.")
	var/str_requested_msg = span_boldnotice("You feel your other side attempting to take direct control over your body.")

	var/str_cancel_msg = span_boldnotice("You give up on attempting to take direct control over your body.")
	var/str_cancelled_msg = span_boldnotice("You feel your other side giving up on taking direct control over your body.")

	if(requested)
		to_chat(non_controller, "STRANGER MSG [str_request_msg]")

		controller.balloon_alert(controller, "your brain tickles")
		to_chat(controller, "STRANGER MSG [str_requested_msg]")
	else
		to_chat(non_controller, "STRANGER MSG [str_cancel_msg]")

		controller.balloon_alert(controller, "str your brain tickles")
		to_chat(controller, "STRANGER MSG [str_cancelled_msg]")

/datum/action/request_switch/owner/proc/request(mob/controller, mob/non_controller)
	var/own_request_msg = span_boldnotice("You start to give up control over your body.")
	var/own_requested_msg = span_boldnotice("You feel your body allowing your control over them.")

	var/own_cancel_msg = span_boldnotice("You take back full control of your body.")
	var/own_cancelled_msg = span_boldnotice("You feel your body taking back full control over them.")

	if(requested)
		to_chat(non_controller, "OWNER MSG [own_request_msg]")

		controller.balloon_alert(controller, "your brain tickles")
		to_chat(controller, "OWNER MSG [own_requested_msg]")
	else
		to_chat(non_controller, "OWNER MSG [own_cancel_msg]")

		controller.balloon_alert(controller, "your brain tickles")
		to_chat(controller, "OWNER MSG [own_cancelled_msg]")
