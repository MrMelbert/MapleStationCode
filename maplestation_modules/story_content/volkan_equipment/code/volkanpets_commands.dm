/**
 * # The AI code for Volkan's pets pt 2
 * has the pet commands used for the AI.
 */

/**
 * # Pet Command: Fix Wires
 * Tells a pet to place wires on the ground where there is a cut wire
 */

 //it doesn't work yet

/datum/pet_command/fix_wires
	command_name = "fix wires"
	command_desc = "Allow your pet to go and fix cut wires."
	radial_icon = 'icons/hud/radial.dmi'
	radial_icon_state = "coil-yellow"
	speech_commands = list("fix wires", "get wires")
	command_feedback = "beeps, then gets to work!"


/datum/pet_command/fix_wires/execute_action(datum/ai_controller/controller)
	//get things out of blackboard
	//var/datum/weakref/weak_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	//var/atom/target = weak_target?.resolve()
	var/list/wanted = controller.blackboard[BB_PLACEABLE_ITEM]

	controller.queue_behavior(/datum/ai_behavior/find_and_set/in_list, BB_CURRENT_PET_TARGET, wanted) //sets the current target as the coil

	var/atom/target = controller.blackboard[BB_CURRENT_PET_TARGET]
	// We got something to fix so go fix it
	if (!QDELETED(target))
		if (get_dist(controller.pawn, target) > 1) // We're not there yet
			controller.queue_behavior(/datum/ai_behavior/fix_wires_go, BB_CURRENT_PET_TARGET)
			return SUBTREE_RETURN_FINISH_PLANNING
		// If mobs could attack food you would branch here to call `eat_fetched_snack`, however that's a task for the future
		controller.queue_behavior(/datum/ai_behavior/pick_up_item, BB_CURRENT_PET_TARGET, BB_SIMPLE_CARRY_ITEM)
		return SUBTREE_RETURN_FINISH_PLANNING


	var/obj/item/carried_item = controller.blackboard[BB_SIMPLE_CARRY_ITEM]
	if (QDELETED(carried_item))
		return

	return SUBTREE_RETURN_FINISH_PLANNING


/**
 * for fix wires:
 * Traverse to a target with the intention of picking it up.
 * If we can't do that, add it to a list of ignored items.
 */

/datum/ai_behavior/fix_wires_go
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH | AI_BEHAVIOR_CAN_PLAN_DURING_EXECUTION

/datum/ai_behavior/fix_wires_go/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE

	set_movement_target(controller, target)


/datum/ai_behavior/fix_wires_go/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	. = ..()
	var/obj/item/fetch_thing = controller.blackboard[target_key]

	// It stopped existing
	if (QDELETED(fetch_thing))
		finish_action(controller, FALSE, target_key)
		return
	// We can't pick this up
	if (fetch_thing.anchored)
		finish_action(controller, FALSE, target_key)
		return

	finish_action(controller, TRUE, target_key)

/datum/ai_behavior/fix_wires_go/finish_action(datum/ai_controller/controller, success, target_key)
	. = ..()
	if (success)
		return
	// Blacklist item if we failed
	var/obj/item/target = controller.blackboard[target_key]
	if (target)
		controller.set_blackboard_key_assoc_lazylist(BB_FETCH_IGNORE_LIST, target, TRUE)
	controller.clear_blackboard_key(target_key)





