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

	gender = NEUTER
	density = FALSE
	health = 80
	maxHealth = 80
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	can_be_held = TRUE
	held_w_class = WEIGHT_CLASS_SMALL

	melee_damage_upper = 5
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



/*
 * # The Vroomba!
 * A roomba, that has combat functionality! It will have two modes, cleaner mode, which is similar to a cleanbot, and combat mode, where it will float and have various attacks, and have telekinesis!
 * TODO: It will also be able to explode, either on purpose or on death.
 * TODO: When it dies, all the stuff it picks up falls out
 */

/mob/living/basic/bot/cleanbot/vroomba
	name = "\improper Strange Roomba"
	desc = "A little cleaning robot, So circular! It looks like it is out of plasteel."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/companions.dmi'
	base_icon_state = "vroomba_drive"
	icon_state = "vroomba_drive"
	icon_living = "vroomba_drive"
	base_icon = "vroomba_drive"
	pass_flags = PASSMOB | PASSFLAPS | PASSTABLE
	density = FALSE
	anchored = FALSE
	layer = ABOVE_NORMAL_TURF_LAYER

	health = 100
	maxHealth = 100
	damage_coeff = list(BRUTE = 0.7, BURN = 1, TOX = 0, STAMINA = 0, OXY = 0) //It's secretly a combat drone. This thing is tanky.

	maints_access_required = list(ACCESS_ROBOTICS, ACCESS_JANITOR, ACCESS_ENGINEERING)
	radio_key = /obj/item/encryptionkey/ai
	radio_channel = RADIO_CHANNEL_SERVICE
	bot_type = CLEAN_BOT
	hackables = " software"
	additional_access = /datum/id_trim/job/janitor
	possessed_message = "You are a roomba! Clean the station to the best of your ability! Protect your master! Don't let anybody boss YOU around!"
	ai_controller = /datum/ai_controller/basic_controller/bot/cleanbot
	path_image_color = "#ddda2a"

	///the icon state for when it is flying
	var/flying_icon = "vroomba_float"
	//speed it goes in combat mode. lower is faster.
	var/combat_speed = 0.5

/mob/living/basic/bot/cleanbot/vroomba/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/basic_inhands)

//it will not get job titles like cleanbots.
/mob/living/basic/bot/cleanbot/vroomba/update_title(new_job_title)
	return

//boom boom
/mob/living/basic/bot/cleanbot/vroomba/explode()
	visible_message(span_boldnotice("[src] blows apart!"))
	do_sparks(3, TRUE, src)
	explosion(src, heavy_impact_range = 1, light_impact_range = 4)

//the sprite doesn't show up unless I do this
/mob/living/basic/bot/cleanbot/vroomba/update_icon_state()
	SHOULD_CALL_PARENT(FALSE)
	return SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_ICON_STATE)

/mob/living/basic/bot/cleanbot/vroomba/set_combat_mode(new_mode, silent)
	. = ..()
	if(combat_mode)
		go_angry()

	if(!combat_mode)
		calm_down()

	update_basic_mob_varspeed()

///The robot activating its hidden combat capabilities!
/mob/living/basic/bot/cleanbot/vroomba/proc/go_angry()
	icon_state = flying_icon
	speed = combat_speed
	layer = MOB_LAYER

	AddElement(/datum/element/simple_flying)

///the robot hiding its combat capabilities!
/mob/living/basic/bot/cleanbot/vroomba/proc/calm_down()
	icon_state = base_icon_state
	speed = 3
	layer = ABOVE_NORMAL_TURF_LAYER

	RemoveElement(/datum/element/simple_flying)



