// For any mob that can be ridden

/datum/component/riding/creature
	/// If TRUE, this creature's movements can be controlled by the rider while mounted (as opposed to riding cyborgs and humans, which is passive)
	var/can_be_driven = TRUE
	/// If TRUE, this creature's abilities can be triggered by the rider while mounted
	var/can_use_abilities = FALSE
	/// list of blacklisted abilities that cant be shared
	var/list/blacklist_abilities = list()

/datum/component/riding/creature/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = NONE, potion_boost = FALSE)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	. = ..()
	var/mob/living/living_parent = parent
	living_parent.stop_pulling() // was only used on humans previously, may change some other behavior
	log_riding(living_parent, riding_mob)
	riding_mob.set_glide_size(living_parent.glide_size)
	update_parent_layer_and_offsets(living_parent.dir)

	if(can_use_abilities)
		setup_abilities(riding_mob)

	if(isanimal(parent))
		var/mob/living/simple_animal/simple_parent = parent
		simple_parent.stop_automated_movement = TRUE

/datum/component/riding/creature/Destroy(force)
	unequip_buckle_inhands(parent)
	if(isanimal(parent))
		var/mob/living/simple_animal/simple_parent = parent
		simple_parent.stop_automated_movement = FALSE
	REMOVE_TRAIT(parent, TRAIT_AI_PAUSED, REF(src))
	return ..()

/datum/component/riding/creature/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_EMOTE, PROC_REF(check_emote))
	if(can_be_driven)
		RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(driver_move)) // this isn't needed on riding humans or cyborgs since the rider can't control them

/// Creatures need to be logged when being mounted
/datum/component/riding/creature/proc/log_riding(mob/living/living_parent, mob/living/rider)
	if(!istype(living_parent) || !istype(rider))
		return

	living_parent.log_message("is now being ridden by [rider].", LOG_GAME, color="pink")
	rider.log_message("started riding [living_parent].", LOG_GAME, color="pink")

// this applies to humans and most creatures, but is replaced again for cyborgs
/datum/component/riding/creature/ride_check(mob/living/rider, consequences = TRUE)
	. = TRUE
	var/mob/living/living_parent = parent

	if(living_parent.body_position != STANDING_UP) // if we move while on the ground, the rider falls off
		. = FALSE
	// for piggybacks and (redundant?) borg riding, check if the rider is stunned/restrained
	else if((ride_check_flags & RIDER_NEEDS_ARMS) && (HAS_TRAIT(rider, TRAIT_RESTRAINED) || rider.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)))
		. = FALSE
	// for fireman carries, check if the ridden is stunned/restrained
	else if((ride_check_flags & CARRIER_NEEDS_ARM) && (HAS_TRAIT(living_parent, TRAIT_RESTRAINED) || living_parent.incapacitated(IGNORE_RESTRAINTS|IGNORE_GRAB)))
		. = FALSE
	else if((ride_check_flags & JUST_FRIEND_RIDERS) && !(living_parent.faction.Find(REF(rider))))
		. = FALSE

	if(. || !consequences)
		return

	rider.visible_message(span_warning("[rider] falls off of [living_parent]!"), \
					span_warning("You fall off of [living_parent]!"))
	rider.Paralyze(1 SECONDS)
	rider.Knockdown(4 SECONDS)
	living_parent.unbuckle_mob(rider)

/datum/component/riding/creature/vehicle_mob_buckle(mob/living/ridden, mob/living/rider, force = FALSE)
	// Ensure that the /mob/post_buckle_mob(mob/living/M) does not mess us up with layers
	// If we do not do this override we'll be stuck with the above proc (+ 0.1)-ing our rider's layer incorrectly
	rider.layer = initial(rider.layer)
	if(can_be_driven)
		//let the player take over if they should be controlling movement
		ADD_TRAIT(ridden, TRAIT_AI_PAUSED, REF(src))
	return ..()

/datum/component/riding/creature/vehicle_mob_unbuckle(mob/living/formerly_ridden, mob/living/former_rider, force = FALSE)
	if(istype(formerly_ridden) && istype(former_rider))
		formerly_ridden.log_message("is no longer being ridden by [former_rider].", LOG_GAME, color="pink")
		former_rider.log_message("is no longer riding [formerly_ridden].", LOG_GAME, color="pink")
	remove_abilities(former_rider)
	if(!formerly_ridden.buckled_mobs.len)
		REMOVE_TRAIT(formerly_ridden, TRAIT_AI_PAUSED, REF(src))
	// We gotta reset those layers at some point, don't we?
	former_rider.layer = MOB_LAYER
	formerly_ridden.layer = MOB_LAYER
	return ..()

/datum/component/riding/creature/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	if(!COOLDOWN_FINISHED(src, vehicle_move_cooldown))
		return COMPONENT_DRIVER_BLOCK_MOVE
	if(!keycheck(user))
		if(ispath(keytype, /obj/item))
			var/obj/item/key = keytype
			to_chat(user, span_warning("You need a [initial(key.name)] to ride [movable_parent]!"))
		return COMPONENT_DRIVER_BLOCK_MOVE
	step(parent, direction)
	var/modified_move_delay = vehicle_move_delay
	if(HAS_TRAIT(user, TRAIT_SETTLER))
		switch(HAS_TRAIT(user, TRAIT_PRIMITIVE) ? SANITY_LEVEL_GREAT : user.mob_mood?.sanity_level)
			if(SANITY_LEVEL_GREAT)
				modified_move_delay *= 0.5
			if(SANITY_LEVEL_NEUTRAL)
				modified_move_delay *= 0.8
			if(SANITY_LEVEL_DISTURBED)
				modified_move_delay *= 1
			if(SANITY_LEVEL_CRAZY)
				modified_move_delay *= 1.2
			if(SANITY_LEVEL_INSANE)
				modified_move_delay *= 1.5
	COOLDOWN_START(src, vehicle_move_cooldown, modified_move_delay)
	return ..()

/// Yeets the rider off, used for animals and cyborgs, redefined for humans who shove their piggyback rider off
/datum/component/riding/creature/proc/force_dismount(mob/living/rider, gentle = FALSE)
	var/atom/movable/movable_parent = parent
	movable_parent.unbuckle_mob(rider)

	if(!iscyborg(movable_parent) && !isanimal_or_basicmob(movable_parent))
		return

	var/turf/target = get_edge_target_turf(movable_parent, movable_parent.dir)
	var/turf/targetm = get_step(get_turf(movable_parent), movable_parent.dir)
	rider.Move(targetm)
	rider.Knockdown(3 SECONDS)
	if(gentle)
		rider.visible_message(span_warning("[rider] is thrown clear of [movable_parent]!"), \
		span_warning("You're thrown clear of [movable_parent]!"))
		rider.throw_at(target, 8, 3, movable_parent, gentle = TRUE)
	else
		rider.visible_message(span_warning("[rider] is thrown violently from [movable_parent]!"), \
		span_warning("You're thrown violently from [movable_parent]!"))
		rider.throw_at(target, 14, 5, movable_parent, gentle = FALSE)

/// If we're a cyborg or animal and we spin, we yeet whoever's on us off us
/datum/component/riding/creature/proc/check_emote(mob/living/user, datum/emote/emote)
	SIGNAL_HANDLER
	if((!iscyborg(user) && !isanimal_or_basicmob(user)) || !istype(emote, /datum/emote/spin))
		return

	for(var/mob/yeet_mob in user.buckled_mobs)
		force_dismount(yeet_mob, (!user.combat_mode)) // gentle on help, byeeee if not


/// If the ridden creature has abilities, and some var yet to be made is set to TRUE, the rider will be able to control those abilities
/datum/component/riding/creature/proc/setup_abilities(mob/living/rider)
	if(!isliving(parent))
		return

	var/mob/living/ridden_creature = parent

	for(var/datum/action/action as anything in ridden_creature.actions)
		if(is_type_in_list(action, blacklist_abilities))
			continue
		action.GiveAction(rider)

/// Takes away the riding parent's abilities from the rider
/datum/component/riding/creature/proc/remove_abilities(mob/living/rider)
	if(!isliving(parent))
		return

	var/mob/living/ridden_creature = parent

	for(var/datum/action/action as anything in ridden_creature.actions)
		if(istype(action, /datum/action/cooldown) && rider.click_intercept == action)
			var/datum/action/cooldown/cooldown_action = action
			cooldown_action.unset_click_ability(rider, refund_cooldown = TRUE)
		action.HideFrom(rider)

/datum/component/riding/creature/riding_can_z_move(atom/movable/movable_parent, direction, turf/start, turf/destination, z_move_flags, mob/living/rider)
	if(!(z_move_flags & ZMOVE_CAN_FLY_CHECKS))
		return COMPONENT_RIDDEN_ALLOW_Z_MOVE
	if(!can_be_driven)
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, span_warning("[movable_parent] cannot be driven around. Unbuckle from [movable_parent.p_them()] first."))
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	if(!ride_check(rider, FALSE))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, span_warning("You're unable to ride [movable_parent] right now!"))
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	return COMPONENT_RIDDEN_ALLOW_Z_MOVE


///////Yes, I said humans. No, this won't end well...//////////
/datum/component/riding/creature/human
	can_be_driven = FALSE

/datum/component/riding/creature/human/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = NONE, potion_boost = FALSE)
	. = ..()
	var/mob/living/carbon/human/human_parent = parent
	if(ride_check_flags & RIDER_NEEDS_ARMS) // piggyback
		human_parent.buckle_lying = 0
		// the riding mob is made nondense so they don't bump into any dense atoms the carrier is pulling,
		// since pulled movables are moved before buckled movables
		ADD_TRAIT(riding_mob, TRAIT_UNDENSE, VEHICLE_TRAIT)
		human_parent.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/human_carry, TRUE, HUMAN_CARRY_SLOWDOWN)

	else if(ride_check_flags & CARRIER_NEEDS_ARM) // fireman
		human_parent.buckle_lying = 90
		// melbert todo : tweak this value
		human_parent.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/human_carry, TRUE, round(HUMAN_CARRY_SLOWDOWN * 1.33, 0.1))

/datum/component/riding/creature/human/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_LIVING_UNARMED_ATTACK, PROC_REF(on_host_unarmed_melee))
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(check_carrier_fall_over))

/datum/component/riding/creature/human/log_riding(mob/living/living_parent, mob/living/rider)
	if(!istype(living_parent) || !istype(rider))
		return

	if(ride_check_flags & RIDER_NEEDS_ARMS) // piggyback
		living_parent.log_message("started giving [rider] a piggyback ride.", LOG_GAME, color="pink")
		rider.log_message("started piggyback riding [living_parent].", LOG_GAME, color="pink")
	else if(ride_check_flags & CARRIER_NEEDS_ARM) // fireman
		living_parent.log_message("started fireman carrying [rider].", LOG_GAME, color="pink")
		rider.log_message("was fireman carried by [living_parent].", LOG_GAME, color="pink")

/datum/component/riding/creature/human/vehicle_mob_unbuckle(datum/source, mob/living/former_rider, force = FALSE)
	unequip_buckle_inhands(parent)
	var/mob/living/carbon/human/H = parent
	H.remove_movespeed_modifier(/datum/movespeed_modifier/human_carry)
	REMOVE_TRAIT(former_rider, TRAIT_UNDENSE, VEHICLE_TRAIT)
	return ..()

/// If the carrier shoves the person they're carrying, force the carried mob off
/datum/component/riding/creature/human/proc/on_host_unarmed_melee(mob/living/source, atom/target, proximity, modifiers)
	SIGNAL_HANDLER

	if(LAZYACCESS(modifiers, RIGHT_CLICK) && (target in source.buckled_mobs))
		force_dismount(target)
		return COMPONENT_CANCEL_ATTACK_CHAIN
	return NONE

/// If the carrier gets knocked over, force the rider(s) off and see if someone got hurt
/datum/component/riding/creature/human/proc/check_carrier_fall_over(mob/living/carbon/human/human_parent)
	SIGNAL_HANDLER

	for(var/mob/living/rider as anything in human_parent.buckled_mobs)
		human_parent.unbuckle_mob(rider)
		rider.Paralyze(1 SECONDS)
		rider.Knockdown(4 SECONDS)
		human_parent.visible_message(
			span_danger("[rider] topples off of [human_parent] as they both fall to the ground!"),
			span_warning("You fall to the ground, bringing [rider] with you!"),
			span_hear("You hear two consecutive thuds."),
			COMBAT_MESSAGE_RANGE,
			ignored_mobs = rider,
			visible_message_flags = ALWAYS_SHOW_SELF_MESSAGE,
		)
		to_chat(rider, span_danger("[human_parent] falls to the ground, bringing you with [human_parent.p_them()]!"))

/datum/component/riding/creature/human/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	var/mob/living/carbon/human/seat = parent
	// fireman carry
	if(seat.buckle_lying)
		return list(
			TEXT_NORTH = list(0, 6, MOB_ABOVE_PIGGYBACK_LAYER),
			TEXT_SOUTH = list(0, 6, MOB_BELOW_PIGGYBACK_LAYER),
			TEXT_EAST =  list(0, 6, MOB_BELOW_PIGGYBACK_LAYER),
			TEXT_WEST =  list(0, 6, MOB_BELOW_PIGGYBACK_LAYER),
		)
	// piggyback
	return list(
		TEXT_NORTH = list( 0, 8, MOB_ABOVE_PIGGYBACK_LAYER),
		TEXT_SOUTH = list( 0, 8, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_EAST =  list(-6, 8, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_WEST =  list( 6, 8, MOB_BELOW_PIGGYBACK_LAYER),
	)

/datum/component/riding/creature/human/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0),
		TEXT_SOUTH = list(0, 0),
		TEXT_EAST =  list(0, 0),
		TEXT_WEST =  list(0, 0),
	)

/datum/component/riding/creature/human/force_dismount(mob/living/dismounted_rider)
	var/atom/movable/AM = parent
	AM.unbuckle_mob(dismounted_rider)
	dismounted_rider.Paralyze(1 SECONDS)
	dismounted_rider.Knockdown(4 SECONDS)
	dismounted_rider.visible_message(
		span_warning("[AM] pushes [dismounted_rider] off of [AM.p_them()]!"),
		span_warning("[AM] pushes you off of [AM.p_them()]!"),
	)


//Now onto cyborg riding//
/datum/component/riding/creature/cyborg
	can_be_driven = FALSE

/datum/component/riding/creature/cyborg/ride_check(mob/living/user, consequences = TRUE)
	var/mob/living/silicon/robot/robot_parent = parent
	if(!iscarbon(user))
		return TRUE
	. = user.usable_hands
	if(!. && consequences)
		Unbuckle(user)
		to_chat(user, span_warning("You can't grab onto [robot_parent] with no hands!"))

/datum/component/riding/creature/cyborg/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	var/mob/living/silicon/robot/robot_parent = parent
	return robot_parent.model?.ride_offsets || DEFAULT_ROBOT_RIDING_OFFSETS

/datum/component/riding/creature/cyborg/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, MOB_BELOW_PIGGYBACK_LAYER),
		TEXT_SOUTH = list(0, 0, MOB_ABOVE_PIGGYBACK_LAYER),
		TEXT_EAST =  list(0, 0, MOB_ABOVE_PIGGYBACK_LAYER),
		TEXT_WEST =  list(0, 0, MOB_ABOVE_PIGGYBACK_LAYER),
	)

//now onto every other ridable mob//
/datum/component/riding/creature/mulebot

/datum/component/riding/creature/mulebot/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 12),
		TEXT_SOUTH = list(0, 12),
		TEXT_EAST =  list(0, 12),
		TEXT_WEST =  list(0, 12),
	)

/datum/component/riding/creature/mulebot/get_parent_offsets_and_layers()
	return null

/datum/component/riding/creature/cow

/datum/component/riding/creature/cow/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 8),
		TEXT_SOUTH = list( 0, 8),
		TEXT_EAST =  list(-2, 8),
		TEXT_WEST =  list( 2, 8),
	)

/datum/component/riding/creature/cow/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/pig

/datum/component/riding/creature/pig/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 8),
		TEXT_SOUTH = list( 0, 8),
		TEXT_EAST =  list(-2, 8),
		TEXT_WEST =  list( 2, 8),
	)

/datum/component/riding/creature/pig/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/pony
	vehicle_move_delay = 1.5
	COOLDOWN_DECLARE(pony_trot_cooldown)

/datum/component/riding/creature/pony/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 9),
		TEXT_SOUTH = list( 0, 9),
		TEXT_EAST =  list(-2, 9),
		TEXT_WEST =  list( 2, 9),
	)

/datum/component/riding/creature/pony/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/pony/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	. = ..()

	if (. == COMPONENT_DRIVER_BLOCK_MOVE || !COOLDOWN_FINISHED(src, pony_trot_cooldown))
		return

	var/mob/living/carbon/human/human_user = user

	if(human_user && is_clown_job(human_user.mind?.assigned_role))
		// there's a new sheriff in town
		playsound(movable_parent, 'sound/creatures/pony/clown_gallup.ogg', 50)
		COOLDOWN_START(src, pony_trot_cooldown, 500 MILLISECONDS)

/datum/component/riding/creature/bear

/datum/component/riding/creature/bear/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 1, 8),
		TEXT_SOUTH = list( 1, 8),
		TEXT_EAST =  list(-3, 6),
		TEXT_WEST =  list( 3, 6),
	)

/datum/component/riding/creature/bear/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, ABOVE_MOB_LAYER),
		TEXT_WEST =  list(0, 0, ABOVE_MOB_LAYER),
	)

/datum/component/riding/creature/carp
	override_allow_spacemove = TRUE

/datum/component/riding/creature/carp/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 13),
		TEXT_SOUTH = list(0, 15),
		TEXT_EAST =  list(-2, 12),
		TEXT_WEST =  list( 2, 12),
	)

/datum/component/riding/creature/carp/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/megacarp

/datum/component/riding/creature/megacarp/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(1, 8),
		TEXT_SOUTH = list(1, 8),
		TEXT_EAST =  list(-3, 6),
		TEXT_WEST =  list(3, 6),
	)

/datum/component/riding/creature/megacarp/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/vatbeast
	override_allow_spacemove = TRUE
	can_use_abilities = TRUE

/datum/component/riding/creature/vatbeast/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 15),
		TEXT_SOUTH = list(0, 15),
		TEXT_EAST =  list(-10, 15),
		TEXT_WEST =  list(10, 15),
	)

/datum/component/riding/creature/vatbeast/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/goliath
	keytype = /obj/item/key/lasso
	vehicle_move_delay = 4

/datum/component/riding/creature/goliath/Initialize(mob/living/riding_mob, force, ride_check_flags, potion_boost)
	. = ..()
	var/mob/living/basic/mining/goliath/goliath = parent
	goliath.add_movespeed_modifier(/datum/movespeed_modifier/goliath_mount)

/datum/component/riding/creature/goliath/Destroy(force)
	var/mob/living/basic/mining/goliath/goliath = parent
	goliath.remove_movespeed_modifier(/datum/movespeed_modifier/goliath_mount)
	return ..()

/datum/component/riding/creature/goliath/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 12),
		TEXT_SOUTH = list( 0, 12),
		TEXT_EAST =  list(-4, 12),
		TEXT_WEST =  list( 3, 12),
	)

/datum/component/riding/creature/goliath/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(-12, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(-12, 0, ABOVE_MOB_LAYER),
		TEXT_EAST =  list(-12, 0, OBJ_LAYER),
		TEXT_WEST =  list(-12, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/glutton

/datum/component/riding/creature/glutton/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 24),
		TEXT_SOUTH = list( 0, 24),
		TEXT_EAST =  list(-16, 24),
		TEXT_WEST =  list( 16, 24),
	)

/datum/component/riding/creature/glutton/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, ABOVE_MOB_LAYER),
		TEXT_WEST =  list(0, 0, ABOVE_MOB_LAYER),
	)

/datum/component/riding/creature/guardian
	can_be_driven = FALSE

/datum/component/riding/creature/guardian/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 4),
		TEXT_SOUTH = list( 0, 4),
		TEXT_EAST =  list(-6, 3),
		TEXT_WEST =  list( 6, 3),
	)

/datum/component/riding/creature/guardian/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, ABOVE_MOB_LAYER),
		TEXT_WEST =  list(0, 0, ABOVE_MOB_LAYER),
	)

/datum/component/riding/creature/guardian/ride_check(mob/living/user, consequences = TRUE)
	var/mob/living/basic/guardian/charger = parent
	if(!istype(charger))
		return ..()
	return charger.summoner == user

/datum/component/riding/creature/goldgrub

/datum/component/riding/creature/goldgrub/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(11, 3),
		TEXT_SOUTH = list(11, 3),
		TEXT_EAST =  list( 9, 3),
		TEXT_WEST =  list(14, 3),
	)

/datum/component/riding/creature/goldgrub/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, OBJ_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/creature/leaper
	can_force_unbuckle = FALSE
	can_use_abilities = TRUE
	blacklist_abilities = list(/datum/action/cooldown/toggle_seethrough)
	ride_check_flags = JUST_FRIEND_RIDERS

/datum/component/riding/creature/leaper/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(17, 46),
		TEXT_SOUTH = list(17, 51),
		TEXT_EAST =  list(27, 46),
		TEXT_WEST =  list( 6, 46),
	)

/datum/component/riding/creature/leaper/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = NONE, potion_boost = FALSE)
	. = ..()
	RegisterSignal(riding_mob, COMSIG_MOB_POINTED, PROC_REF(attack_pointed))

/datum/component/riding/creature/leaper/proc/attack_pointed(mob/living/rider, atom/pointed)
	SIGNAL_HANDLER
	if(!isclosedturf(pointed))
		return
	var/mob/living/basic/basic_parent = parent
	if(!basic_parent.CanReach(pointed))
		return
	basic_parent.melee_attack(pointed)

/datum/component/riding/leaper/handle_unbuckle(mob/living/rider)
	. = ..()
	UnregisterSignal(rider,  COMSIG_MOB_POINTED)
