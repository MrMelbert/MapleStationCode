/**
 * The flying machinegun drone planning:
 * - If too close to target, back up to keep distance.
 * - If too far from target, close the distance.
 * - BANG BANG BANG.
 * - Find non DEEP RED faction target.
 */
/datum/ai_controller/basic_controller/rapidlightflying
	blackboard = list(
			BB_BASIC_MOB_CURRENT_TARGET
	)
	ai_movement = /datum/ai_movement/jps
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
			/datum/ai_planning_subtree/maintain_distance/rapidlightflying
	)

/datum/ai_planning_subtree/maintain_distance/rapidlightflying
	var/minimum_distance = 3
	var/maximum_distance = 8
