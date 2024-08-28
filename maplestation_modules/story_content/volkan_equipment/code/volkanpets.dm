/*
 * # Volkan's companion.
 * A cool pet for volkan! Basically a better poly. Quiet, efficient, and will sit on his shoulder all the time.
 */
//HOLY MOLY WHAT DID I GET MYSELF INTO??
/mob/living/basic/volkan/shoulder_pet
	name = "Companion"
	desc = "An intricate, flying robot. It looks at you inquisitively."

	icon = 'maplestation_modules/story_content/volkan_equipment/icons/companions.dmi'
	held_rh = 'maplestation_modules/story_content/volkan_equipment/icons/companions_inhand_rh.dmi'
	held_lh = 'maplestation_modules/story_content/volkan_equipment/icons/companions_inhand_lh.dmi'
	icon_state = "drone_fly"
	icon_living = "drone_fly"
	icon_dead = "drone_dead"
	held_state = "shoulder_pet"
	bubble_icon = "machine"

	has_unlimited_silicon_privilege = TRUE
	sentience_type = SENTIENCE_ARTIFICIAL
	mob_biotypes = MOB_ROBOTIC
	speech_span = SPAN_ROBOT
	gender = NEUTER
	density = FALSE
	health = 80
	maxHealth = 80
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	can_be_held = TRUE
	held_w_class = WEIGHT_CLASS_SMALL

	habitable_atmos = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 0, STAMINA = 0, OXY = 0)
	bodytemp_cold_damage_limit = 0
	unsuitable_atmos_damage = 0 //temperature robust

	melee_damage_upper = 5 //It is weak sauce.
	melee_damage_lower = 1

	response_help_continuous = "pets"
	response_help_simple = "pet"
	attack_verb_continuous = "slams into"
	attack_verb_simple = "slam into"
	attack_sound = 'sound/weapons/etherealhit.ogg'

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
		food_types = list(/obj/item/circuitboard/volkan/imprint_key,), \
		tame_chance = 100, \
		bonus_tame_chance = 15, \
		after_tame = CALLBACK(src, PROC_REF(tamed)), \
		unique = FALSE)
	AddComponent(/datum/component/obeys_commands, pet_commands) // follows pet command

///Proc to run once imprinted
/mob/living/basic/volkan/shoulder_pet/proc/tamed(mob/living/tamer)
	visible_message(span_notice("[src] beeps and turns its head toward [tamer] with its head tilted."))
