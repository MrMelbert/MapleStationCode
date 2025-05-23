// For any /obj/vehicle's that can be ridden

/datum/component/riding/vehicle/Initialize(mob/living/riding_mob, force = FALSE, ride_check_flags = (RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS), potion_boost = FALSE)
	if(!isvehicle(parent))
		return COMPONENT_INCOMPATIBLE
	return ..()

/datum/component/riding/vehicle/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_RIDDEN_DRIVER_MOVE, PROC_REF(driver_move))

/datum/component/riding/vehicle/riding_can_z_move(atom/movable/movable_parent, direction, turf/start, turf/destination, z_move_flags, mob/living/rider)
	if(!(z_move_flags & ZMOVE_CAN_FLY_CHECKS))
		return COMPONENT_RIDDEN_ALLOW_Z_MOVE

	if(!keycheck(rider))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, "<span class='warning'>[movable_parent] has no key inserted!</span>")
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	if(HAS_TRAIT(rider, TRAIT_INCAPACITATED))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, "<span class='warning'>You cannot operate [movable_parent] right now!</span>")
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	if(ride_check_flags & RIDER_NEEDS_LEGS && HAS_TRAIT(rider, TRAIT_FLOORED))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, "<span class='warning'>You can't seem to manage that while unable to stand up enough to move [movable_parent]...</span>")
		return COMPONENT_RIDDEN_STOP_Z_MOVE
	if(ride_check_flags & RIDER_NEEDS_ARMS && HAS_TRAIT(rider, TRAIT_HANDS_BLOCKED))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider, "<span class='warning'>You can't seem to hold onto [movable_parent] to move it...</span>")
		return COMPONENT_RIDDEN_STOP_Z_MOVE

	return COMPONENT_RIDDEN_ALLOW_Z_MOVE

/datum/component/riding/vehicle/driver_move(atom/movable/movable_parent, mob/living/user, direction)
	if(!COOLDOWN_FINISHED(src, vehicle_move_cooldown))
		return COMPONENT_DRIVER_BLOCK_MOVE
	var/obj/vehicle/vehicle_parent = parent

	if(!keycheck(user))
		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, span_warning("[vehicle_parent] has no key inserted!"))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	if(HAS_TRAIT(user, TRAIT_INCAPACITATED))
		if(ride_check_flags & UNBUCKLE_DISABLED_RIDER)
			vehicle_parent.unbuckle_mob(user, TRUE)
			user.visible_message(span_danger("[user] falls off \the [vehicle_parent]."),\
			span_danger("You slip off \the [vehicle_parent] as your body slumps!"))
			user.Stun(3 SECONDS)

		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, span_warning("You cannot operate \the [vehicle_parent] right now!"))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	if(ride_check_flags & RIDER_NEEDS_LEGS && HAS_TRAIT(user, TRAIT_FLOORED))
		if(ride_check_flags & UNBUCKLE_DISABLED_RIDER)
			vehicle_parent.unbuckle_mob(user, TRUE)
			user.visible_message(span_danger("[user] falls off \the [vehicle_parent]."),\
			span_danger("You fall off \the [vehicle_parent] while trying to operate it while unable to stand!"))
			user.Stun(3 SECONDS)

		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, span_warning("You can't seem to manage that while unable to stand up enough to move \the [vehicle_parent]..."))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	if(ride_check_flags & RIDER_NEEDS_ARMS && HAS_TRAIT(user, TRAIT_HANDS_BLOCKED))
		if(ride_check_flags & UNBUCKLE_DISABLED_RIDER)
			vehicle_parent.unbuckle_mob(user, TRUE)
			user.visible_message(span_danger("[user] falls off \the [vehicle_parent]."),\
			span_danger("You fall off \the [vehicle_parent] while trying to operate it without being able to hold on!"))
			user.Stun(3 SECONDS)

		if(COOLDOWN_FINISHED(src, message_cooldown))
			to_chat(user, span_warning("You can't seem to hold onto \the [vehicle_parent] to move it..."))
			COOLDOWN_START(src, message_cooldown, 5 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE

	handle_ride(user, direction)
	return ..()

/// This handles the actual movement for vehicles once [/datum/component/riding/vehicle/proc/driver_move] has given us the green light
/datum/component/riding/vehicle/proc/handle_ride(mob/user, direction)
	var/atom/movable/movable_parent = parent

	var/turf/next = get_step(movable_parent, direction)
	var/turf/current = get_turf(movable_parent)
	if(!istype(next) || !istype(current))
		return //not happening.
	if(!turf_check(next, current))
		to_chat(user, span_warning("\The [movable_parent] can not go onto [next]!"))
		return
	if(!Process_Spacemove(direction) || !isturf(movable_parent.loc))
		return

	step(movable_parent, direction)
	COOLDOWN_START(src, vehicle_move_cooldown, vehicle_move_delay)

	if(QDELETED(src))
		return
	update_parent_layer_and_offsets(movable_parent.dir)
	return TRUE

/datum/component/riding/vehicle/atv
	keytype = /obj/item/key/atv
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER
	vehicle_move_delay = 1.5

/datum/component/riding/vehicle/atv/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 4),
		TEXT_SOUTH = list(0, 4),
		TEXT_EAST =  list(0, 4),
		TEXT_WEST =  list(0, 4),
	)

/datum/component/riding/vehicle/atv/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, OBJ_LAYER),
		TEXT_SOUTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/vehicle/bicycle
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER
	vehicle_move_delay = 0

/datum/component/riding/vehicle/bicycle/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 4),
		TEXT_SOUTH = list(0, 4),
		TEXT_EAST =  list(0, 4),
		TEXT_WEST =  list(0, 4),
	)

/datum/component/riding/vehicle/lavaboat
	ride_check_flags = NONE // not sure
	keytype = /obj/item/oar
	/// The one turf we can move on.
	var/allowed_turf = /turf/open/lava

/datum/component/riding/vehicle/lavaboat/Initialize(mob/living/riding_mob, force, ride_check_flags, potion_boost)
	. = ..()
	allowed_turf_typecache = typecacheof(allowed_turf)

/datum/component/riding/vehicle/lavaboat/not_lava
	allowed_turf = /turf/open/water

/datum/component/riding/vehicle/lavaboat/dragonboat
	vehicle_move_delay = 1
	keytype = null

/datum/component/riding/vehicle/lavaboat/dragonboat/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(1, 2),
		TEXT_SOUTH = list(1, 2),
		TEXT_EAST =  list(1, 2),
		TEXT_WEST =  list(1, 2),
	)

/datum/component/riding/vehicle/janicart
	keytype = /obj/item/key/janitor

/datum/component/riding/vehicle/janicart/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, 4),
		TEXT_SOUTH = list( 0, 7),
		TEXT_EAST =  list(-12, 7),
		TEXT_WEST =  list( 12, 7),
	)

/datum/component/riding/vehicle/scooter
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/scooter/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	if(iscyborg(offsetter))
		return list(
			TEXT_NORTH = list(0, 2),
			TEXT_SOUTH = list(0, 2),
			TEXT_EAST =  list(0, 2),
			TEXT_WEST =  list(2, 2),
		)
	return list(
		TEXT_NORTH = list( 2, 2),
		TEXT_SOUTH = list(-2, 2),
		TEXT_EAST =  list( 0, 2),
		TEXT_WEST =  list( 2, 2),
	)

/datum/component/riding/vehicle/scooter/skateboard
	vehicle_move_delay = 1.5
	ride_check_flags = RIDER_NEEDS_LEGS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/scooter/skateboard/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 5),
		TEXT_SOUTH = list(0, 5),
		TEXT_EAST =  list(0, 5),
		TEXT_WEST =  list(2, 5),
	)

/datum/component/riding/vehicle/scooter/skateboard/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_SOUTH = list(0, 0, ABOVE_MOB_LAYER),
		TEXT_EAST =  list(0, 0, OBJ_LAYER),
		TEXT_WEST =  list(0, 0, OBJ_LAYER),
	)

/datum/component/riding/vehicle/scooter/skateboard/wheelys
	vehicle_move_delay = 0

/datum/component/riding/vehicle/scooter/skateboard/wheelys/rollerskates
	vehicle_move_delay = 1.5

/datum/component/riding/vehicle/scooter/skateboard/wheelys/skishoes
	vehicle_move_delay = 1

/datum/component/riding/vehicle/scooter/skateboard/wheelys/skishoes/Initialize(mob/living/riding_mob, force, ride_check_flags, potion_boost)
	. = ..()
	allowed_turf_typecache = typecacheof(list(/turf/open/misc/asteroid/snow, /turf/open/misc/snow, /turf/open/floor/holofloor/snow, /turf/open/misc/ice, /turf/open/floor/fake_snow))

/datum/component/riding/vehicle/secway
	keytype = /obj/item/key/security
	vehicle_move_delay = 1.75
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/secway/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list(0, 4),
		TEXT_SOUTH = list(0, 4),
		TEXT_EAST =  list(0, 4),
		TEXT_WEST =  list(0, 4),
	)

/datum/component/riding/vehicle/secway/driver_move(mob/living/user, direction)
	var/obj/vehicle/ridden/secway/the_secway = parent

	if(keycheck(user) && the_secway.eddie_murphy)
		if(COOLDOWN_FINISHED(src, message_cooldown))
			the_secway.visible_message(span_warning("[the_secway] sputters and refuses to move!"))
			playsound(get_turf(the_secway), 'sound/effects/stall.ogg', 70)
			COOLDOWN_START(src, message_cooldown, 0.75 SECONDS)
		return COMPONENT_DRIVER_BLOCK_MOVE
	return ..()

/datum/component/riding/vehicle/speedbike
	vehicle_move_delay = 0
	override_allow_spacemove = TRUE
	ride_check_flags = RIDER_NEEDS_LEGS | RIDER_NEEDS_ARMS | UNBUCKLE_DISABLED_RIDER

/datum/component/riding/vehicle/speedbike/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	return list(
		TEXT_NORTH = list( 0, -8),
		TEXT_SOUTH = list( 0,  4),
		TEXT_EAST =  list(-10, 5),
		TEXT_WEST =  list( 10, 5),
	)

/datum/component/riding/vehicle/speedbike/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(-16, -16),
		TEXT_SOUTH = list(-16, -16),
		TEXT_EAST =  list(-18,   0),
		TEXT_WEST =  list(-18,   0),
	)

/datum/component/riding/vehicle/speedwagon
	vehicle_move_delay = 0

/datum/component/riding/vehicle/speedwagon/get_rider_offsets_and_layers(pass_index, mob/offsetter)
	switch(pass_index)
		if(1)
			return list(
				TEXT_NORTH = list(-10, -4),
				TEXT_SOUTH = list( 16, -4),
				TEXT_EAST =  list( -4, 30),
				TEXT_WEST =  list(  4, -3),
			)
		if(2)
			return list(
				TEXT_NORTH = list( 19, -5),
				TEXT_SOUTH = list(-13,  3),
				TEXT_EAST =  list( -4, -3),
				TEXT_WEST =  list(  4, 28),
			)
		if(3)
			return list(
				TEXT_NORTH = list(-10, -18),
				TEXT_SOUTH = list( 16,  25),
				TEXT_EAST =  list(-22,  30),
				TEXT_WEST =  list( 22,  -3,),
			)
		if(4)
			return list(
				TEXT_NORTH = list( 19, -18),
				TEXT_SOUTH = list(-13,  25),
				TEXT_EAST =  list(-22,   3),
				TEXT_WEST =  list( 22,  28),
			)

/datum/component/riding/vehicle/speedwagon/get_parent_offsets_and_layers()
	. = ..()
	return list(
		TEXT_NORTH = list(-48, -48, BELOW_MOB_LAYER),
		TEXT_SOUTH = list(-48, -48, BELOW_MOB_LAYER),
		TEXT_EAST =  list(-48, -48, BELOW_MOB_LAYER),
		TEXT_WEST =  list(-48, -48, BELOW_MOB_LAYER),
	)

/datum/component/riding/vehicle/wheelchair
	vehicle_move_delay = 0
	ride_check_flags = RIDER_NEEDS_ARMS

/datum/component/riding/vehicle/wheelchair/get_parent_offsets_and_layers()
	return list(
		TEXT_NORTH = list(0, 0),
		TEXT_SOUTH = list(0, 0),
		TEXT_EAST =  list(0, 0),
		TEXT_WEST =  list(0, 0),
	)

/datum/component/riding/vehicle/wheelchair/hand
	/// Magic number used in calculating the speed of the wheelchair
	var/delay_multiplier = 6.7

/datum/component/riding/vehicle/wheelchair/hand/driver_move(obj/vehicle/vehicle_parent, mob/living/user, direction)
	vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * delay_multiplier) / clamp(user.usable_hands, 1, 2)
	return ..()

/datum/component/riding/vehicle/wheelchair/motorized

/datum/component/riding/vehicle/wheelchair/motorized/driver_move(obj/vehicle/vehicle_parent, mob/living/user, direction)
	var/obj/vehicle/ridden/wheelchair/motorized/our_chair = parent
	var/speed = our_chair.speed
	var/delay_multiplier = our_chair.delay_multiplier
	vehicle_move_delay = round(CONFIG_GET(number/movedelay/run_delay) * delay_multiplier) / speed
	return ..()

/datum/component/riding/vehicle/wheelchair/motorized/handle_ride(mob/user, direction)
	. = ..()
	var/obj/vehicle/ridden/wheelchair/motorized/our_chair = parent
	if(istype(our_chair) && our_chair.power_cell)
		our_chair.power_cell.use(our_chair.energy_usage / max(our_chair.power_efficiency, 1) * 0.05)
