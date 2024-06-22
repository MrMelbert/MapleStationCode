/mob/living/silicon/robot/Process_Spacemove(movement_dir = 0, continuous_move = FALSE)
	. = ..()
	if(.)
		return TRUE
	if(ionpulse())
		return TRUE
	return FALSE

/mob/living/silicon/robot
	move_intent = MOVE_INTENT_WALK

/mob/living/silicon/robot/Move(NewLoc, direct)
	. = ..()
	if(!.)
		return
	if(move_intent != MOVE_INTENT_RUN || stat == DEAD || pulledby)
		return
	if((movement_type & (FLOATING|FLYING)) || !(mobility_flags & (MOBILITY_MOVE|MOBILITY_STAND)))
		return
	if(low_power_mode || cell?.charge <= STANDARD_CELL_CHARGE * 0.005)
		set_move_intent(MOVE_INTENT_WALK)
		return
	cell.use(STANDARD_CELL_CHARGE * 0.005)
