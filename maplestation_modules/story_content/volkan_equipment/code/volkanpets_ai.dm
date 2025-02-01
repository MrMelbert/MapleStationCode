/**
 * # The AI code for Volkan's pets
 * has some various procs and AI stuff needed for the pets.
 */

//perching stuff. Since it is not a parrot I need to copy its code over?? Tell me if there is an easier way to do this.
/mob/living/basic/volkan/shoulder_pet/update_icon_state()
	. = ..()
	if(stat == DEAD)
		return
	icon_state = HAS_TRAIT(src, TRAIT_PARROT_PERCHED) ? icon_sit : icon_living

/mob/living/basic/volkan/shoulder_pet/proc/start_perching(atom/target)
	if(HAS_TRAIT(src, TRAIT_PARROT_PERCHED))
		balloon_alert(src, "already perched!")
		return FALSE

	if(ishuman(target))
		return perch_on_human(target)

	if(!is_type_in_typecache(target, desired_perches))
		return FALSE

	forceMove(get_turf(target))
	toggle_perched(perched = TRUE)
	RegisterSignal(src, COMSIG_MOVABLE_MOVED, PROC_REF(after_move))
	return TRUE

/mob/living/basic/volkan/shoulder_pet/proc/after_move(atom/source)
	SIGNAL_HANDLER

	UnregisterSignal(src, COMSIG_MOVABLE_MOVED)
	toggle_perched(perched = FALSE)

/mob/living/basic/volkan/shoulder_pet/proc/perch_on_human(mob/living/carbon/human/target)
	if(LAZYLEN(target.buckled_mobs) >= target.max_buckled_mobs)
		balloon_alert(src, "can't perch on them!")
		return FALSE

	forceMove(get_turf(target))
	if(!target.buckle_mob(src, TRUE, FALSE))
		return FALSE

	to_chat(src, span_notice("You sit on [target]'s shoulder."))
	toggle_perched(perched = TRUE)
	RegisterSignal(src, COMSIG_LIVING_SET_BUCKLED, PROC_REF(on_unbuckle))
	return TRUE

/mob/living/basic/volkan/shoulder_pet/proc/on_unbuckle(mob/living/source, atom/movable/new_buckled)
	SIGNAL_HANDLER

	if(new_buckled)
		return
	UnregisterSignal(src, COMSIG_LIVING_SET_BUCKLED)
	toggle_perched(perched = FALSE)

/mob/living/basic/volkan/shoulder_pet/proc/toggle_perched(perched)
	if(!perched)
		REMOVE_TRAIT(src, TRAIT_PARROT_PERCHED, TRAIT_GENERIC)
		remove_offsets("perched")
	else
		ADD_TRAIT(src, TRAIT_PARROT_PERCHED, TRAIT_GENERIC)
		add_offsets("perched", y_add = 9)
	update_appearance(UPDATE_ICON_STATE)

// - AI CONTROLLER -
#define BB_PLACEABLE_ITEM "BB_placeable_item"

/datum/ai_controller/basic_controller/volkan/shoulder_pet
	blackboard = list()

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk/volkan/shoulder_pet
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/allow_items,
		BB_PLACEABLE_ITEM = /obj/item/stack/cable_coil,
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
	)

//perching stuff. perching is using the parrot code :)
/datum/idle_behavior/idle_random_walk/volkan/shoulder_pet
	//we do not want it to fly away from your shoulder without an order.
	var/walk_chance_when_perched = 0


/**
 * # Pet Command: Perch
 * Tells a pet that can perch, to perch on your shoulder.
 */
/datum/pet_command/perch
	command_name = "Perch"
	command_desc = "Command your pet to perch on your shoulder."
	radial_icon = 'icons/mob/actions/actions_minor_antag.dmi'
	radial_icon_state = "beam_up"
	speech_commands = list("perch", "step up")
	command_feedback = "flies up!"
	var/perch_behavior = /datum/ai_behavior/perch_on_target/

/datum/pet_command/perch/set_command_active(mob/living/parent, mob/living/commander)
	. = ..()
	set_command_target(parent, commander)

/datum/pet_command/perch/execute_action(datum/ai_controller/controller)
	controller.queue_behavior(perch_behavior, BB_CURRENT_PET_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING
