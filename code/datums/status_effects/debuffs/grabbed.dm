/obj/item/grabbing_hand
	name = "grab"
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT | DROPDEL | NOBLUDGEON
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/datum/status_effect/grabbing
	id = "grabbing"
	tick_interval = -1
	alert_type = null
	/// Linked grab status effect
	var/datum/status_effect/grabbed/paried_effect

	var/obj/item/grabbing_hand/hand

/datum/status_effect/grabbing/on_creation(mob/living/new_owner, datum/status_effect/grabbed/grabbed_effect)
	paried_effect = grabbed_effect
	return ..()

/datum/status_effect/grabbing/on_apply()
	hand = new()
	if(!owner.put_in_hands(hand))
		return FALSE

	return TRUE

/datum/status_effect/grabbing/Destroy()
	paried_effect = null
	QDEL_NULL(hand)
	return ..()

/datum/status_effect/grabbing/get_examine_text()
	if(paried_effect.pin)
		switch(owner.grab_state)
			if(GRAB_AGGRESSIVE)
				return span_notice("[owner.p_Theyre()] pinning [paried_effect.owner]!")
			if(GRAB_NECK)
				return span_warning("[owner.p_Theyre()] pinning [paried_effect.owner] by the neck!")
			if(GRAB_KILL)
				return span_boldwarning("[owner.p_Theyre()] pinning [paried_effect.owner] by the neck, strangling [paried_effect.owner.p_them()]!")

	switch(owner.grab_state)
		if(GRAB_PASSIVE)
			if((owner.zone_selected == BODY_ZONE_L_ARM || owner.zone_selected == BODY_ZONE_R_ARM) && paried_effect.owner.usable_hands > 0)
				return span_notice("[owner.p_Theyre()] holding hands with [paried_effect.owner]!")

			return span_notice("[owner.p_Theyre()] holding [paried_effect.owner] passively.")
		if(GRAB_AGGRESSIVE)
			return span_warning("[owner.p_Theyre()] holding [paried_effect.owner] aggressively!")
		if(GRAB_NECK)
			return span_warning("[owner.p_Theyre()] holding [paried_effect.owner] by the neck!")
		if(GRAB_KILL)
			return span_boldwarning("[owner.p_Theyre()] strangling [paried_effect.owner]!")

// melbert todo : add slowdown / stamina cost / sprint cost to fireman carry, scaled on strength / size / etc
/datum/status_effect/grabbed
	id = "grabbed"
	tick_interval = -1
	alert_type = null

	var/datum/status_effect/grabbing/paried_effect
	/// Who is grabbing us
	var/atom/movable/grabbing_us
	/// Whether the grab has been side-graded into a pin
	var/pin = FALSE

/datum/status_effect/grabbed/on_creation(mob/living/new_owner, mob/living/grabber)
	grabbing_us = grabber
	return ..()

/datum/status_effect/grabbed/on_apply()
	if(isnull(grabbing_us))
		stack_trace("Grabbed status effect applied without a grabber!")
		return FALSE

	RegisterSignal(grabbing_us, COMSIG_MOVABLE_SET_GRAB_STATE, PROC_REF(update_state))
	RegisterSignal(grabbing_us, COMSIG_QDELETING, PROC_REF(grabber_gone))

	RegisterSignal(owner, COMSIG_MOB_STATCHANGE, PROC_REF(owner_stat))
	RegisterSignal(owner, COMSIG_LIVING_TRYING_TO_PULL, PROC_REF(try_upgrade))
	RegisterSignal(owner, COMSIG_ATOM_ATTACK_HAND_SECONDARY, PROC_REF(try_pin))
	RegisterSignal(owner, COMSIG_ATOM_NO_LONGER_PULLED, PROC_REF(ungrabbed))
	// melbert todo : put breath signal here

	if(owner.stat >= SOFT_CRIT)
		ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "[id]_softcrit")
	if(isliving(grabbing_us))
		var/mob/living/mob_grabber = grabbing_us
		paried_effect = mob_grabber.apply_status_effect(/datum/status_effect/grabbing, src)
	return TRUE

/datum/status_effect/grabbed/on_remove()
	QDEL_NULL(paried_effect)
	if(grabbing_us)
		UnregisterSignal(grabbing_us, list(
			COMSIG_MOVABLE_SET_GRAB_STATE,
			COMSIG_QDELETING,
		))
		grabbing_us.setGrabState(GRAB_PASSIVE)
		grabbing_us = null

	unlink_mobs()
	UnregisterSignal(owner, list(
		COMSIG_MOB_STATCHANGE,
		COMSIG_ATOM_ATTACK_HAND_SECONDARY,
		COMSIG_LIVING_TRYING_TO_PULL,
		COMSIG_ATOM_NO_LONGER_PULLED,
	))
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, id)
	REMOVE_TRAIT(owner, TRAIT_HANDS_BLOCKED, id)
	REMOVE_TRAIT(owner, TRAIT_FLOORED, id)
	REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "[id]_softcrit")

/datum/status_effect/grabbed/get_examine_text()
	if(pin)
		switch(grabbing_us.grab_state)
			if(GRAB_AGGRESSIVE)
				return span_notice("[owner.p_Theyre()] being pinned by [grabbing_us]!")
			if(GRAB_NECK)
				return span_warning("[owner.p_Theyre()] being pinned by the neck by [grabbing_us]!")
			if(GRAB_KILL)
				return span_boldwarning("[owner.p_Theyre()] being pinned and being strangled by [grabbing_us]!")

	switch(grabbing_us.grab_state)
		if(GRAB_PASSIVE)
			if(isliving(grabbing_us))
				var/mob/living/mob_grabber = grabbing_us
				if((mob_grabber.zone_selected == BODY_ZONE_L_ARM || mob_grabber.zone_selected == BODY_ZONE_R_ARM) && owner.usable_hands > 0)
					return span_notice("[owner.p_Theyre()] holding hands with [grabbing_us]!")

			return span_notice("[owner.p_Theyre()] being held passively by [grabbing_us].")
		if(GRAB_AGGRESSIVE)
			return span_warning("[owner.p_Theyre()] being held aggressively by [grabbing_us]!")
		if(GRAB_NECK)
			return span_warning("[owner.p_Theyre()] being held by the neck by [grabbing_us]!")
		if(GRAB_KILL)
			return span_boldwarning("[owner.p_Theyre()] being strangled by [grabbing_us]!")

/datum/status_effect/grabbed/proc/owner_stat(datum/source, new_stat, old_stat)
	SIGNAL_HANDLER

	if(new_stat >= SOFT_CRIT)
		ADD_TRAIT(owner, TRAIT_IMMOBILIZED, "[id]_softcrit")
	else if(old_stat < SOFT_CRIT)
		REMOVE_TRAIT(owner, TRAIT_IMMOBILIZED, "[id]_softcrit")

/datum/status_effect/grabbed/proc/try_upgrade(datum/source, mob/living/user, force)
	SIGNAL_HANDLER
	if(user != grabbing_us)
		return NONE

	INVOKE_ASYNC(src, PROC_REF(upgrade_attempt))
	return COMSIG_LIVING_CANCEL_PULL

/datum/status_effect/grabbed/proc/upgrade_attempt()
	var/mob/living/mob_grabber = grabbing_us
	if(istype(mob_grabber) && DOING_INTERACTION_WITH_TARGET(mob_grabber, owner))
		return
	if(!(owner.status_flags & CANPUSH) || HAS_TRAIT(owner, TRAIT_PUSHIMMUNE))
		to_chat(grabbing_us, span_warning("[owner] can't be grabbed more aggressively!"))
		return
	if(grabbing_us.grab_state >= GRAB_AGGRESSIVE && HAS_TRAIT(grabbing_us, TRAIT_PACIFISM))
		to_chat(grabbing_us, span_warning("You don't want to risk hurting [owner]!"))
		return
	if(grabbing_us.grab_state >= grabbing_us.max_grab)
		to_chat(grabbing_us, span_warning("You can't grab [owner] any more aggressively!"))
		return

	playsound(owner, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	grabbing_us.do_attack_animation(owner, "grab")
	if(istype(mob_grabber))
		mob_grabber.changeNext_move(CLICK_CD_GRABBING)
	owner.add_fingerprint(grabbing_us)
	if(grabbing_us.grab_state >= GRAB_AGGRESSIVE)
		owner.visible_message(
			span_danger("[grabbing_us] starts to tighten [grabbing_us.p_their()] grip on [owner]!"),
			span_userdanger("[grabbing_us] starts to tighten [grabbing_us.p_their()] grip on you!"),
			span_hear("You hear aggressive shuffling!"),
			null,
			grabbing_us,
		)
		to_chat(grabbing_us, span_danger("You start to tighten your grip on [owner]!"))
		if(owner.is_blind())
			to_chat(owner, span_danger("Someone starts to tighten their grip on you!"))
		switch(grabbing_us.grab_state)
			if(GRAB_AGGRESSIVE)
				log_combat(grabbing_us, owner, "attempted to neck grab", addition = "neck grab")
			if(GRAB_NECK)
				log_combat(grabbing_us, owner, "attempted to strangle", addition = "kill grab")
		if(!do_after(grabbing_us, 4 SECONDS, owner, extra_checks = CALLBACK(src, PROC_REF(upgrade_check), grabbing_us.grab_state),))
			return

	grabbing_us.setGrabState(grabbing_us.grab_state + 1)
	switch(grabbing_us.grab_state)
		if(GRAB_AGGRESSIVE)
			var/add_log = ""
			if(HAS_TRAIT(grabbing_us, TRAIT_PACIFISM))
				owner.visible_message(
					span_danger("[grabbing_us] firmly grips [owner]!"),
					span_danger("[grabbing_us] firmly grips you!"),
					span_hear("You hear aggressive shuffling!"),
					null,
					grabbing_us,
				)
				to_chat(grabbing_us, span_danger("You firmly grip [owner]!"))
				if(owner.is_blind())
					to_chat(owner, span_danger("Someone firmly grips you!"))
				add_log = " (pacifist)"
			else
				owner.visible_message(
					span_danger("[grabbing_us] grabs [owner] aggressively!"),
					span_userdanger("[grabbing_us] grabs you aggressively!"),
					span_hear("You hear aggressive shuffling!"),
					null,
					grabbing_us,
				)
				to_chat(grabbing_us, span_danger("You grab [owner] aggressively!"))
				if(owner.is_blind())
					to_chat(owner, span_danger("Someone grabs you aggressively!"))
			owner.stop_pulling()
			log_combat(grabbing_us, owner, "grabbed", addition = "aggressive grab[add_log]")
		if(GRAB_NECK)
			log_combat(grabbing_us, owner, "grabbed", addition = "neck grab")
			owner.visible_message(
				span_danger("[grabbing_us] grabs [owner] by the neck!"),
				span_userdanger("[grabbing_us] grabs you by the neck!"),
				span_hear("You hear aggressive shuffling!"),
				null,
				grabbing_us,
			)
			to_chat(grabbing_us, span_danger("You grab [owner] by the neck!"))
			if(owner.is_blind())
				to_chat(owner, span_userdanger("Someone grabs you by the neck!"))
		if(GRAB_KILL)
			log_combat(grabbing_us, owner, "strangled", addition = "kill grab")
			owner.visible_message(
				span_danger("[grabbing_us] is strangling [owner]!"),
				span_userdanger("[grabbing_us] is strangling you!"),
				span_hear("You hear aggressive shuffling!"),
				null,
				grabbing_us,
			)
			to_chat(grabbing_us, span_danger("You're strangling [owner]!"))
			if(owner.is_blind())
				to_chat(owner, span_userdanger("Someone is strangling you!"))

	if(grabbing_us.grab_state >= GRAB_NECK && !owner.buckled)
		link_mobs()

	if(QDELETED(src))
		return
	if(istype(mob_grabber))
		mob_grabber.set_pull_offsets(owner, grabbing_us.grab_state)

/datum/status_effect/grabbed/proc/upgrade_check(initial_state)
	return !QDELETED(src) && !QDELETED(grabbing_us) && grabbing_us.grab_state == initial_state

/datum/status_effect/grabbed/proc/try_pin(datum/source, mob/living/user, modifiers)
	SIGNAL_HANDLER
	if(user != grabbing_us)
		return NONE

	INVOKE_ASYNC(src, PROC_REF(pin_attempt))
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/status_effect/grabbed/proc/pin_attempt()
	if(pin)
		unpin()
		return
	if(grabbing_us.grab_state < GRAB_AGGRESSIVE)
		return
	var/mob/living/mob_grabber = grabbing_us
	if(istype(mob_grabber) && DOING_INTERACTION_WITH_TARGET(mob_grabber, owner))
		return
	if(!grabbing_us.has_gravity())
		to_chat(grabbing_us, span_warning("You can't pin someone if you're not standing on the ground!"))
		return
	if(!owner.has_gravity())
		to_chat(grabbing_us, span_warning("You can't pin someone who's not standing on the ground!"))
		return
	if(owner.buckled)
		to_chat(grabbing_us, span_warning("You can't pin someone buckled to something"))
		return

	playsound(owner, 'sound/weapons/thudswoosh.ogg', 50, TRUE, -1)
	grabbing_us.do_attack_animation(owner, "grab")
	if(istype(mob_grabber))
		mob_grabber.changeNext_move(CLICK_CD_GRABBING)
	// owner.add_fingerprint(grabbing_us)
	owner.visible_message(
		span_danger("[grabbing_us] starts to pin [owner] to the ground!"),
		span_userdanger("[grabbing_us] starts to pin you to the ground!"),
		span_hear("You hear aggressive shuffling!"),
		null,
		grabbing_us,
	)
	to_chat(grabbing_us, span_danger("You start to pin [owner] to the ground!"))
	if(owner.is_blind())
		to_chat(owner, span_userdanger("Someone is trying to pin you to the ground!"))

	// future todo : scale pin time based on size vs size, strength vs strength, martial arts, etc
	if(!do_after(grabbing_us, 4 SECONDS, owner, extra_checks = CALLBACK(src, PROC_REF(pin_check)),))
		return
	if(owner.buckled || HAS_TRAIT(owner, TRAIT_FORCED_STANDING))
		to_chat(grabbing_us, span_warning("You fail to pin [owner] to the ground!"))
		return

	owner.visible_message(
		span_danger("[grabbing_us] pins [owner] to the ground!"),
		span_userdanger("[grabbing_us] pins you to the ground!"),
		span_hear("You hear a loud thud!"),
		null,
		grabbing_us,
	)
	to_chat(grabbing_us, span_danger("You pin [owner] to the ground!"))
	if(owner.is_blind())
		to_chat(owner, span_userdanger("You are pinned to the ground!"))

	log_combat(grabbing_us, owner, "pinned")
	pin = TRUE
	unlink_mobs()
	ADD_TRAIT(owner, TRAIT_FLOORED, id)
	owner.Paralyze(2 SECONDS)
	owner.setDir(SOUTH)
	owner.setDir(UNLINT(owner.lying_angle) == 270 ? EAST : WEST) // melbert todo

/datum/status_effect/grabbed/proc/pin_check()
	return !QDELETED(src) && !QDELETED(grabbing_us) && !pin && grabbing_us.grab_state >= GRAB_AGGRESSIVE

/datum/status_effect/grabbed/proc/unpin()
	owner.visible_message(
		span_danger("[grabbing_us] releases [owner] from the pin!"),
		span_danger("[grabbing_us] releases you from the pin!"),
		null,
		null,
		grabbing_us,
	)
	to_chat(grabbing_us, span_danger("You release [owner] from the pin!"))
	if(owner.is_blind())
		to_chat(owner, span_danger("Someone releases you from a pin!"))
	owner.Paralyze(1 SECONDS)
	grabbing_us.stop_pulling()

/datum/status_effect/grabbed/proc/update_state(datum/source, new_state)
	SIGNAL_HANDLER
	if(new_state == GRAB_PASSIVE)
		qdel(src)
		return

	if(new_state >= GRAB_AGGRESSIVE)
		ADD_TRAIT(owner, TRAIT_IMMOBILIZED, id)
		ADD_TRAIT(owner, TRAIT_HANDS_BLOCKED, id)

/datum/status_effect/grabbed/proc/ungrabbed(datum/source, mob/living/gone)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/grabbed/proc/grabber_gone(...)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/grabbed/proc/link_mobs()
	if(HAS_TRAIT_FROM(owner, TRAIT_UNDENSE, id))
		return

	ADD_TRAIT(owner, TRAIT_UNDENSE, id)
	owner.Move(grabbing_us.loc)
	RegisterSignal(grabbing_us, COMSIG_MOVABLE_MOVED, PROC_REF(bring_along))

/datum/status_effect/grabbed/proc/unlink_mobs()
	REMOVE_TRAIT(owner, TRAIT_UNDENSE, id)
	if(!QDELING(src))
		owner.Move(get_step(owner.loc, owner.dir), owner.dir)
	if(grabbing_us)
		UnregisterSignal(grabbing_us, COMSIG_MOVABLE_MOVED, PROC_REF(bring_along))

/datum/status_effect/grabbed/proc/bring_along(datum/source, atom/old_loc, movement_dir)
	SIGNAL_HANDLER

	owner.Move(grabbing_us.loc, movement_dir, grabbing_us.glide_size)
	owner.setDir(grabbing_us.dir)
