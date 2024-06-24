/datum/component/wearertargeting/knockoff_move
	signals = list(COMSIG_MOVABLE_MOVED)
	proctype = PROC_REF(check_fall)
	var/fall_chance = 100
	var/how_fall

/datum/component/wearertargeting/knockoff_move/Initialize(chance = 10, list/slots, how_fall = "falls!")
	src.valid_slots = slots
	src.fall_chance = chance
	src.how_fall = how_fall
	return ..()

/datum/component/wearertargeting/knockoff_move/proc/check_fall(mob/living/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER

	if(forced)
		return
	if(!isturf(source.loc))
		return
	var/final_chance = fall_chance
	switch(source.move_intent)
		if(MOVE_INTENT_RUN)
			final_chance = fall_chance * 2
		if(MOVE_INTENT_WALK)
			pass()
		if(MOVE_INTENT_SNEAK)
			final_chance = fall_chance / 4
	if(!prob(final_chance))
		return

	var/obj/item/item_parent = parent
	if(!source.dropItemToGround(item_parent))
		return

	source.visible_message(
		span_warning("[source]'s [item_parent.name] [how_fall]"),
		span_warning("[item_parent] [how_fall]"),
	)
