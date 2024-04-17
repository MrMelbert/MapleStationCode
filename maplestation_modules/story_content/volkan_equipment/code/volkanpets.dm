/**
 * # Volkan's companion.
 * A cool pet for volkan! Basically a better poly. Quiet, efficient, and will sit on his shoulder all the time.
 */
//HOLY MOLY WHAT DID I GET MYSELF INTO??
/mob/living/basic/volkan/shoulder_pet
	name = "Companion"
	desc = "An intricate, flying robot. It looks at you inquisitively."

	icon = 'maplestation_modules/story_content/volkan_equipment/icons/companions.dmi'
	icon_state = "drone_fly"
	icon_living = "drone_fly"
	icon_dead = "drone_dead"

	density = FALSE
	health = 80
	maxHealth = 80
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL

	melee_damage_upper = 10
	melee_damage_lower = 5

	response_help_continuous = "pets"
	response_help_simple = "pet"

	ai_controller = /datum/ai_controller/basic_controller/volkan/shoulder_pet

	//The drone shall be able to perch on things.
	var/icon_sit = "drone_perch"
	/// Contains all of the perches that the drone will sit on.
	var/static/list/desired_perches = typecacheof(list(
		/obj/machinery/dna_scannernew,
		/obj/machinery/nuclearbomb,
		/obj/machinery/recharge_station,
		/obj/machinery/suit_storage_unit,
		/obj/structure/displaycase,
		/obj/structure/filingcabinet,
		/obj/structure/rack,
	))
	//The command list
	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/perch,
		/datum/pet_command/follow,
		/datum/pet_command/point_targeting/fetch,
	)



/mob/living/basic/volkan/shoulder_pet/Initialize(mapload)
	. = ..()
	ai_controller.set_blackboard_key(BB_PARROT_PERCH_TYPES, desired_perches)// uses parrot code to perch

	AddElement(/datum/element/simple_flying) //The thing flys.
	AddComponent(/datum/component/tameable, \
	food_types = list(/obj/item/stock_parts/cell, \
	/obj/item/stock_parts/capacitor,), \
	tame_chance = 100, \
	bonus_tame_chance = 15, \
	after_tame = CALLBACK(src, PROC_REF(tamed)), \
	unique = FALSE)
	AddComponent(/datum/component/obeys_commands, pet_commands) // follows pet command

/datum/pet_command/follow/volkan/shoulder_pet
	speech_commands = list("heel", "follow", "come")

///Proc to run once imprinted
/mob/living/basic/volkan/shoulder_pet/proc/tamed(mob/living/tamer)
	visible_message(span_notice("[src] beeps and turns it's head toward [tamer] with it's head tilted."))
	new /obj/effect/temp_visual/destabilising_tear(drop_location())


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
	if(!target.buckle_mob(src,TRUE,FALSE))
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
	else
		ADD_TRAIT(src, TRAIT_PARROT_PERCHED, TRAIT_GENERIC)
	update_appearance(UPDATE_ICON_STATE)

//----------------------------------------AI CONTROLLER--------------------------------------------------
/datum/ai_controller/basic_controller/volkan/shoulder_pet
	blackboard = list()

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk/volkan/shoulder_pet
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic/allow_items,
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
	radial_icon = 'icons/mob/actions/actions_spells.dmi'
	radial_icon_state = "repulse"
	speech_commands = list("perch")
	command_feedback = "flies up to your shoulder!"
	var/perch_behavior = /datum/ai_behavior/perch_on_target/

/datum/pet_command/perch/set_command_active(mob/living/parent, mob/living/commander)
	. = ..()
	set_command_target(parent, commander)

/datum/pet_command/perch/execute_action(datum/ai_controller/controller)
	controller.queue_behavior(perch_behavior, BB_CURRENT_PET_TARGET)
	return SUBTREE_RETURN_FINISH_PLANNING
