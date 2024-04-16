/mob/living/basic/volkan/shoulder_pet
	name = "Companion"
	desc = "An intricate, flying drone. It looks at you inquisitively."

	icon = 'maplestation_modules/story_content/volkan_equipment/icons/companions.dmi'
	icon_state = "drone_fly"
	icon_living = "drone_fly"
	icon_dead = "drone_dead"

	density = FALSE
	health = 80
	maxHealth = 80
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL

	ai_controller = /datum/ai_controller/basic_controller/volkan/shoulder_pet

/datum/ai_controller/basic_controller/volkan/shoulder_pet
	blackboard = list()

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list()
