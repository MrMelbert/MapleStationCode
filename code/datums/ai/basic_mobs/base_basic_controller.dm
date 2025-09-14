/datum/ai_controller/basic_controller
	movement_delay = 0.4 SECONDS

/datum/ai_controller/basic_controller/TryPossessPawn(atom/new_pawn)
	if(!isbasicmob(new_pawn))
		return AI_CONTROLLER_INCOMPATIBLE
	var/mob/living/basic/basic_mob = new_pawn

	update_speed(basic_mob)

	RegisterSignals(basic_mob, list(POST_BASIC_MOB_UPDATE_VARSPEED, COMSIG_MOB_MOVESPEED_UPDATED), PROC_REF(update_speed))
	RegisterSignal(basic_mob, COMSIG_MOB_ATE, PROC_REF(on_mob_eat))

	return ..() //Run parent at end


/datum/ai_controller/basic_controller/able_to_run()
	. = ..()
	if(!isliving(pawn))
		return
	var/mob/living/living_pawn = pawn
	var/incap_flags = NONE
	if (ai_traits & CAN_ACT_IN_STASIS)
		incap_flags |= IGNORE_STASIS
	if(!(ai_traits & CAN_ACT_WHILE_DEAD) && (living_pawn.incapacitated(incap_flags)))
		return FALSE
	if(ai_traits & PAUSE_DURING_DO_AFTER && LAZYLEN(living_pawn.do_afters))
		return FALSE

/datum/ai_controller/basic_controller/proc/update_speed(mob/living/basic/basic_mob)
	SIGNAL_HANDLER
	movement_delay = basic_mob.cached_multiplicative_slowdown

/datum/ai_controller/basic_controller/proc/on_mob_eat()
	SIGNAL_HANDLER
	var/food_cooldown = blackboard[BB_EAT_FOOD_COOLDOWN] || EAT_FOOD_COOLDOWN
	set_blackboard_key(BB_NEXT_FOOD_EAT, world.time + food_cooldown)
