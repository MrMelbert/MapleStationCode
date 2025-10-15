/datum/status_effect/restrained
	id = "resisting_off_cuffs"
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = 1 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/restrained
	// remove_on_fullheal = TRUE
	// heal_flag_necessary = HEAL_RESTRAINTS

	/// Slot flag the restraint is placed
	VAR_PRIVATE/cuff_slot
	/// The actual restraining item, cannot exist without this
	VAR_PRIVATE/obj/item/linked_cuffs
	/// If we are actively resisting
	VAR_PRIVATE/is_resisting = FALSE
	/// Progress towards breaking out of restraints
	VAR_PRIVATE/break_out_progress = 0
	/// Progress bar shown on the alert at all times
	VAR_PRIVATE/datum/progressbar/alert_bar
	/// Progress bar shown on the mob only when resisting
	VAR_PRIVATE/datum/progressbar/mob_bar
	/// Text to use in various messages to describe how we're restrained
	VAR_PRIVATE/restrained_verb_text

/datum/status_effect/restrained/on_creation(mob/living/new_owner, obj/item/linked_cuffs, slot)
	src.linked_cuffs = linked_cuffs
	src.cuff_slot = slot
	. = ..()
	if(!.)
		return
	restrained_verb_text = restrained_verb()
	alert_bar = new(owner, linked_cuffs.breakouttime, linked_alert, -34)
	linked_alert.name = "[capitalize(restrained_verb_text)]"
	linked_alert.desc = "You are [restrained_verb_text] by [linked_cuffs.get_examine_name(owner)]. Click to attempt to break free!"

/datum/status_effect/restrained/get_alert_master()
	return linked_cuffs

/datum/status_effect/restrained/get_examine_text(mob/user)
	return span_warning("[owner.p_They()] [owner.p_are()] [restrained_verb_text] by [linked_cuffs.examine_title(user, href = TRUE)]\
		[is_resisting ? ", <b>and [owner.p_are()] currently struggling to break free</b>!" : "."]")

/datum/status_effect/restrained/on_apply()
	if(isnull(linked_cuffs))
		stack_trace("[type] applied without restraints!")
		return FALSE

	RegisterSignals(linked_cuffs, list(
		COMSIG_QDELETING,
		COMSIG_MOVABLE_MOVED,
	), PROC_REF(cuffs_gone))
	RegisterSignal(owner, COMSIG_LIVING_RESIST, PROC_REF(on_resist))
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(move_interrupt))
	RegisterSignals(owner, list(
		COMSIG_LIVING_STATUS_IMMOBILIZE,
		COMSIG_LIVING_STATUS_INCAPACITATE,
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_PARALYZE,
		COMSIG_LIVING_STATUS_SLEEP,
		COMSIG_LIVING_STATUS_STUN,
		COMSIG_LIVING_STATUS_UNCONSCIOUS,
	), PROC_REF(stun_interrupt))

	// Add restrained trait unless it's a legcuff
	if(!(cuff_slot & ITEM_SLOT_LEGCUFFED))
		ADD_TRAIT(owner, TRAIT_RESTRAINED, REF(linked_cuffs))

	return TRUE

/datum/status_effect/restrained/on_remove()
	if(!isnull(linked_cuffs))
		REMOVE_TRAIT(owner, TRAIT_RESTRAINED, REF(linked_cuffs))
		UnregisterSignal(linked_cuffs, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
		linked_cuffs = null
	UnregisterSignal(owner, list(
		COMSIG_LIVING_RESIST,
		COMSIG_MOVABLE_MOVED,
		COMSIG_LIVING_STATUS_IMMOBILIZE,
		COMSIG_LIVING_STATUS_INCAPACITATE,
		COMSIG_LIVING_STATUS_KNOCKDOWN,
		COMSIG_LIVING_STATUS_PARALYZE,
		COMSIG_LIVING_STATUS_SLEEP,
		COMSIG_LIVING_STATUS_STUN,
		COMSIG_LIVING_STATUS_UNCONSCIOUS,
	))
	QDEL_NULL(alert_bar)
	QDEL_NULL(mob_bar)

/datum/status_effect/restrained/proc/cuffs_gone(...)
	SIGNAL_HANDLER
	qdel(src)

/datum/status_effect/restrained/proc/on_resist(mob/living/source)
	SIGNAL_HANDLER
	// on generic resist, first restraint is prioritized
	if(source.has_status_effect(type) != src)
		return NONE

	start_breaking_cuffs()
	return RESIST_HANDLED

/datum/status_effect/restrained/proc/start_breaking_cuffs()
	if(owner.last_special > world.time)
		return
	if(!owner.buckled && !(owner.mobility_flags & MOBILITY_MOVE))
		to_chat(owner, span_warning("You can't move your arms to struggle right now!"))
		return

	if(break_out_progress >= linked_cuffs.breakouttime)
		clear_cuffs()
		return

	if(is_resisting)
		owner.changeNext_move(CLICK_CD_LOOK_UP)
		owner.last_special = world.time + CLICK_CD_LOOK_UP
		owner.visible_message(span_notice("[owner] stops struggling against [linked_cuffs]."), null, null, 5, ignored_mobs = list(owner))
		to_chat(owner, span_notice("You stop struggling against [linked_cuffs]."))
		is_resisting = FALSE
		mob_bar.end_progress()
		mob_bar = null
		return
	for(var/datum/status_effect/restrained/other in owner.status_effects - src)
		if(!other.is_resisting)
			continue
		to_chat(owner, span_notice("You are struggling against [other.linked_cuffs]!"))
		return

	owner.changeNext_move(linked_cuffs.resist_cooldown)
	owner.last_special = world.time + linked_cuffs.resist_cooldown
	if(SEND_SIGNAL(owner, COMSIG_MOB_REMOVING_CUFFS, linked_cuffs) & BLOCK_CUFF_REMOVAL)
		return

	owner.visible_message(span_notice("[owner] starts struggling against [linked_cuffs]!"), null, null, 5, ignored_mobs = list(owner))
	if(break_out_progress)
		to_chat(owner, span_notice("You resume struggling against [linked_cuffs]! \
			(This will take around [DisplayTimeText(max(0.01, (linked_cuffs.breakouttime - break_out_progress) / get_speed_modifier()))] more, and you still need to stand still.)"))
	else
		to_chat(owner, span_notice("You start struggling against [linked_cuffs]! \
			(This will take around [DisplayTimeText(max(0.01, linked_cuffs.breakouttime / get_speed_modifier()))] and you need to stand still.)"))
	is_resisting = TRUE
	mob_bar = new(owner, linked_cuffs.breakouttime, owner)
	mob_bar.update(break_out_progress)

/datum/status_effect/restrained/proc/clear_cuffs()
	var/breakem = FALSE
	if(SEND_SIGNAL(owner, COMSIG_MOB_REMOVED_CUFFS, linked_cuffs) & BREAK_CUFFS)
		breakem = TRUE

	owner.visible_message(span_danger("[owner] manages to [breakem ? "break" : "remove"] [linked_cuffs]!"), null, null, 5, ignored_mobs = list(owner))
	to_chat(owner, span_notice("You successfully [breakem ? "break" : "remove"] [linked_cuffs]."))
	owner.changeNext_move(CLICK_CD_MELEE)
	if(breakem)
		qdel(linked_cuffs)
	else
		owner.dropItemToGround(linked_cuffs, force = TRUE)

/datum/status_effect/restrained/tick(seconds_between_ticks)
	if(HAS_TRAIT(owner, TRAIT_SOFT_CRIT) || HAS_TRAIT(owner, TRAIT_KNOCKEDOUT))
		// slowly lose progress when hurt / unconscious
		break_out_progress = max(0, break_out_progress - (seconds_between_ticks * 0.5 SECONDS))
	else if(break_out_progress >= linked_cuffs.breakouttime || !is_resisting)
		return
	else
		break_out_progress += round(seconds_between_ticks * 1 SECONDS * get_speed_modifier(), 0.1)

	mob_bar?.update(break_out_progress)
	alert_bar.update(break_out_progress)

	if(break_out_progress < linked_cuffs.breakouttime)
		return
	if(should_drop_on_finish())
		clear_cuffs()
		return
	to_chat(owner, span_notice("You've loosened [linked_cuffs] enough to slip them off, resist again or click the alert to drop them!"))
	is_resisting = FALSE
	mob_bar.end_progress()
	mob_bar = null
	linked_alert.desc = "You are loosely [restrained_verb_text] by [linked_cuffs.get_examine_name(owner)]. Click to remove them!"

/// Returns modifier to speed at which we break out of cuffs
/datum/status_effect/restrained/proc/get_speed_modifier()
	var/mod = 1
	if(owner.buckled || owner.pulledby)
		mod *= 0.5
	if(HAS_TRAIT(owner, TRAIT_HULK))
		mod *= 12 // 1 minute -> 5 seconds
	if(isalienadult(owner))
		mod *= INFINITY // instant breakout
	return mod

/// Return TRUE if we should drop the cuffs as soon as we finish breaking out of them
/// Return FALSE to let the player resist again or click the alert to drop them
/datum/status_effect/restrained/proc/should_drop_on_finish()
	if(cuff_slot & ITEM_SLOT_LEGCUFFED)
		return TRUE
	if(linked_cuffs.item_flags & DROPDEL)
		return TRUE
	return FALSE

/// Returns what verb to use to describe how we're restrained
/datum/status_effect/restrained/proc/restrained_verb(mob/user)
	if(cuff_slot & ITEM_SLOT_LEGCUFFED)
		return "entrapped"
	return "restrained"

/datum/status_effect/restrained/proc/move_interrupt(mob/living/source)
	SIGNAL_HANDLER
	if(!is_resisting)
		return

	is_resisting = FALSE
	mob_bar.end_progress()
	mob_bar = null
	if(break_out_progress >= linked_cuffs.breakouttime)
		return
	to_chat(owner, span_warning("Your struggle is interrupted, but have not lost any progress towards escaping [linked_cuffs]."))

/datum/status_effect/restrained/proc/stun_interrupt(mob/living/source, stun_amount)
	SIGNAL_HANDLER

	if(is_resisting)
		is_resisting = FALSE
		mob_bar.end_progress()
		mob_bar = null
		to_chat(owner, span_warning("Your struggle is interrupted, losing some progress towards escaping [linked_cuffs]."))
		break_out_progress = max(0, break_out_progress - stun_amount)
	else
		to_chat(owner, span_warning("You lose some progress towards escaping [linked_cuffs]."))
		break_out_progress = max(0, break_out_progress - stun_amount * 0.5)

	alert_bar.update(break_out_progress)

/atom/movable/screen/alert/status_effect/restrained
	name = "Restrained"
	desc = "You are restrained by something. Click to attempt to break free."
	click_master = FALSE
	mouse_over_pointer = MOUSE_HAND_POINTER

/atom/movable/screen/alert/status_effect/restrained/Click(location, control, params)
	. = ..()
	if(!.)
		return
	if(usr != owner || !isliving(owner))
		return FALSE

	var/mob/living/clicker = owner
	if(!clicker.can_resist())
		return FALSE

	var/datum/status_effect/restrained/effect = attached_effect
	effect.start_breaking_cuffs()
	return TRUE
