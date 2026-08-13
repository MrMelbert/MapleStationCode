#define IS_AI_MOB(mob) (!isnull(mob.ai_controller) && isnull(mob.client))
#define IS_PLAYER(mob) (!isnull(mob.client) && isnull(mob.ai_controller))

/**
 * Locks onto a target, turning to face the mob so long as we're in combat mode
 *
 * Arguments
 * * target - The target to lock onto
 * * duration - How long to lock onto the target for
 * * force_override_target - If set to FALSE, existing targets will not be overridden unless they are further than the new target.
 * * mirror_to_ai_mobs - If set to TRUE, will also lock the target onto the source mob if the target is an AI controlled mob.
 */
/mob/living/proc/combat_lock_on(atom/movable/target, duration, force_override_target = FALSE, mirror_to_ai_mobs = TRUE)
	if(target == src || get_dist(src, target) > 7)
		return
	// Avoid having AI mobs lock onto players using position based weapons at all (anti-frustration feature)
	if(IS_AI_MOB(src))
		for(var/obj/item/weapon in astype(target, /mob/living)?.held_items)
			if(HAS_TRAIT(weapon, TRAIT_POSITION_BASED_WEAPON))
				return

	apply_status_effect(/datum/status_effect/combat_lock, target, duration, force_override_target)
	// Immediately mirror combat lock if fighting an AI, makes it look like they're reacting to you like a player would.
	var/mob/living/target_living = target
	if(!istype(target_living) || !mirror_to_ai_mobs || !IS_AI_MOB(target_living))
		return

	target_living.combat_lock_on(src, duration, force_override_target, mirror_to_ai_mobs = FALSE)

/datum/status_effect/combat_lock
	id = "combat_lock"
	tick_interval = -1
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	on_remove_on_mob_delete = TRUE
	/// Movable we struck and are locked onto
	VAR_PRIVATE/atom/movable/combat_target

/datum/status_effect/combat_lock/on_creation(mob/living/new_owner, atom/movable/combat_target, duration = 20 SECONDS, force_override_target)
	if(isnull(combat_target))
		stack_trace("Attempted to create a combat lock without a target!")
		qdel(src)
		return

	src.duration = duration
	src.combat_target = combat_target
	RegisterSignals(combat_target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING), PROC_REF(drop_combat_lock))
	RegisterSignal(combat_target, COMSIG_MOVABLE_MOVED, PROC_REF(combat_target_moved))
	return ..()

/datum/status_effect/combat_lock/on_apply()
	if(!IS_AI_MOB(owner) && !IS_PLAYER(owner))
		return FALSE

	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(owner_moved))
	RegisterSignal(owner, COMSIG_LIVING_COMBAT_MODE_CHANGE, PROC_REF(combat_target_moved))
	face_combat_target()
	return TRUE

/datum/status_effect/combat_lock/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_MOVABLE_MOVED, COMSIG_LIVING_COMBAT_MODE_CHANGE))
	owner.set_dir_on_move = initial(owner.set_dir_on_move)

/datum/status_effect/combat_lock/Destroy()
	UnregisterSignal(combat_target, list(COMSIG_LIVING_DEATH, COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	combat_target = null
	return ..()

// Refresh refreshes duration - but then if a different, closer target is passed in, swap to that one instead.
/datum/status_effect/combat_lock/refresh(effect, atom/movable/other_lock, duration = 20 SECONDS, force_override_target)
	src.duration = min(src.duration + duration, world.time + duration)
	if(combat_target == other_lock || (!force_override_target && get_dist(owner, combat_target) < get_dist(owner, other_lock)))
		return
	UnregisterSignal(combat_target, COMSIG_QDELETING)
	UnregisterSignal(combat_target, COMSIG_MOVABLE_MOVED)
	combat_target = other_lock
	RegisterSignal(combat_target, COMSIG_QDELETING, PROC_REF(drop_combat_lock))
	RegisterSignal(combat_target, COMSIG_MOVABLE_MOVED, PROC_REF(combat_target_moved))
	face_combat_target()

/datum/status_effect/combat_lock/proc/drop_combat_lock(datum/source)
	SIGNAL_HANDLER
	// Target is gone, no more lock.
	qdel(src)

/datum/status_effect/combat_lock/proc/combat_target_moved(datum/source, ...)
	SIGNAL_HANDLER
	// They left the distance, drop the lock and let them reacquire it later.
	if(get_dist(owner, combat_target) > 7)
		qdel(src)
		return
	// Otherwise keep facing them wherever they are now.
	face_combat_target()

/datum/status_effect/combat_lock/proc/owner_moved(datum/source, ...)
	SIGNAL_HANDLER
	// Prevents the mob from turning to face their direction if they successfully faced the target.
	owner.set_dir_on_move = !face_combat_target()

/datum/status_effect/combat_lock/proc/face_combat_target()
	// - If we're a not AI controlled, we have to be in combat mode to face the target
	// - Otherwise if we ARE an AI mob, then skip the combat mode check, because they can enter and exit it sporadically
	if(IS_PLAYER(owner))
		if(!owner.combat_mode)
			return FALSE
	else
		if(!IS_AI_MOB(owner))
			return FALSE
		for(var/obj/item/weapon in astype(combat_target, /mob/living)?.held_items)
			if(HAS_TRAIT(weapon, TRAIT_POSITION_BASED_WEAPON))
				return FALSE
	// - No turn if we're being pulled, let the puller handle it.
	// - No turn if incap, because of course we can't... we're probably dead.
	if(!isnull(owner.pulledby) || HAS_TRAIT(owner, TRAIT_INCAPACITATED))
		return FALSE
	// - Turf checks are for nullspace shenanigans
	// - Otherwise we can't face them if we're on the same tile
	if(!isturf(owner.loc) || !isturf(combat_target.loc) || owner.loc == combat_target.loc)
		return FALSE
	// - Low alpha is intended to be harder to see, so don't let people aimbot them. 64 is picked as ~25% alpha.
	// - Invisibility is obviously intended to make people incapable of being seen so don't let people aimbot them either
	if(combat_target.alpha <= 64 || combat_target.invisibility > owner.see_invisible)
		return FALSE
	// - Blanket "can we even see see them" check, most expensive one (relatively) so it comes last.
	if(!(owner in viewers(5, combat_target)))
		return FALSE

	owner.face_atom(combat_target)
	return TRUE

#undef IS_AI_MOB
#undef IS_PLAYER

// Locking on to random relevant targets. Could make this an element but it's whatever
/obj/machinery/porta_turret/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!.)
		return
	user.combat_lock_on(src, 5 SECONDS)

/obj/structure/spawner/lavaland/goliath/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!.)
		return
	user.combat_lock_on(src, 5 SECONDS)

/obj/vehicle/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!.)
		return
	user.combat_lock_on(src, 5 SECONDS)

/obj/vehicle/sealed/mecha/attacked_by(obj/item/attacking_item, mob/living/user, list/modifiers, list/attack_modifiers)
	. = ..()
	if(!.)
		return

	user.combat_lock_on(src)
