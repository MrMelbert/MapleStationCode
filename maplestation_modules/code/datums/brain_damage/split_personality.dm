/datum/brain_trauma/severe/split_personality/orderly/
	name = "Orderly Split Personality"
	desc = "Patient's brain is split into two personalities, which switch control of the body occasionally."


/datum/brain_trauma/severe/split_personality/orderly/on_life(seconds_per_tick, times_fired)
	return //no random switching

/datum/brain_trauma/severe/split_personality/orderly/on_gain()
	. = ..()
	var/datum/action/request_switch/stranger/strangerseat_spell = new(src)
	strangerseat_spell.Grant(stranger_backseat)

	var/datum/action/request_switch/stranger/ownerseat_spell = new(src)
	ownerseat_spell.Grant(owner_backseat)

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

	var/datum/brain_trauma/severe/split_personality/trauma
	var/datum/action/request_switch/twin_action
	var/mob/living/split_personality/non_controller

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

	trauma = target

	requested = !requested

/datum/action/request_switch/proc/handle_switch()
	trauma.switch_personalities()
	requested = FALSE
	twin_action.requested = FALSE
	return

/datum/action/request_switch/owner/Trigger(trigger_flags)
	. = ..()
	var/non_controller

	if(trauma.current_controller == /*OWNER*/0)
		twin_action = locate(/datum/action/request_switch) in trauma.stranger_backseat.actions
		non_controller = trauma.stranger_backseat
	else if(trauma.current_controller == /*STRANGER*/1)
		twin_action = locate(/datum/action/request_switch) in trauma.owner_backseat.actions
		non_controller = trauma.owner_backseat

	if(twin_action.requested)
		handle_switch()
	else
		request(trauma.owner, non_controller)

/datum/action/request_switch/stranger/Trigger(trigger_flags)
	. = ..()

	twin_action = locate(/datum/action/request_switch)  in trauma.owner.actions
	if(trauma.current_controller == /*OWNER*/0)
		non_controller = trauma.stranger_backseat
	else if(trauma.current_controller == /*STRANGER*/1)
		non_controller = trauma.owner_backseat

	if(twin_action.requested)
		handle_switch()
	else
		request(trauma.owner, non_controller)

/datum/action/request_switch/stranger/proc/request(mob/controller, mob/non_controller)
	var/str_request_msg = span_boldnotice("You concentrate on attempting to take direct control over your body.")
	var/str_requested_msg = span_boldnotice("You feel your other side attempting to take direct control over your body.")

	var/str_cancel_msg = span_boldnotice("You give up on attempting to take direct control over your body.")
	var/str_cancelled_msg = span_boldnotice("You feel your other side giving up on taking direct control over your body.")

	controller.balloon_alert(controller, "your brain tickles")
	non_controller.balloon_alert(controller, "your brain tickles")
	if(requested)
		to_chat(non_controller, "[str_request_msg]")
		to_chat(controller, "[str_requested_msg]")
	else
		to_chat(non_controller, "[str_cancel_msg]")
		to_chat(controller, "[str_cancelled_msg]")


/datum/action/request_switch/owner/proc/request(mob/controller, mob/non_controller)
	var/own_request_msg = span_boldnotice("You concentrate on giving your other side control to your body.")
	var/own_requested_msg = span_boldnotice("You feel your other side attempting to let you take over their body.")

	var/own_cancel_msg = span_boldnotice("You give up on attempting to give your other side control to your body.")
	var/own_cancelled_msg = span_boldnotice("You feel your other side giving up on giving you control.")

	controller.balloon_alert(controller, "your brain tickles")
	non_controller.balloon_alert(controller, "your brain tickles")
	if(requested)
		to_chat(non_controller, "[own_requested_msg]")
		to_chat(controller, "[own_request_msg]")
	else
		to_chat(non_controller, "[own_cancelled_msg]")
		to_chat(controller, "[own_cancel_msg]")
