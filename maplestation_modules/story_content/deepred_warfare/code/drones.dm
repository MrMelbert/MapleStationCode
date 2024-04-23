/mob/living/basic/reddrone
	name = "light airborne drone"
	desc = "A small, flying drone. It's equipped with a rapid-fire machinecoil."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/reddrone.dmi'
	icon_state = "rapid_light_flying"
	icon_living = "rapid_light_flying"
	icon_dead = "rapid_light_flying_dead"
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC

	// Relatively weak armour.
	health = 60
	maxHealth = 60

	// But, armour is optimized for thermal and energy damage.
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 0, STAMINA = 0, OXY = 0)

	// Most drones are ranged attackers so they don't deal much melee damage.
	melee_damage_lower = 5
	melee_damage_upper = 5

	attack_verb_continuous = "rams"
	attack_verb_simple = "ram"
	attack_sound = 'sound/weapons/genhit1.ogg'
	attack_vis_effect = ATTACK_EFFECT_PUNCH
	verb_say = "states"
	verb_ask = "queries"
	verb_exclaim = "declares"
	verb_yell = "alarms"
	bubble_icon = "machine"

	faction = list(FACTION_DEEPRED)
	combat_mode = TRUE
	speech_span = SPAN_ROBOT
	death_message = "shudders, then falls to the ground, inoperable."

	habitable_atmos = list("min_oxy" = 0, "max_oxy" = 0, "min_plas" = 0, "max_plas" = 0, "min_co2" = 0, "max_co2" = 0, "min_n2" = 0, "max_n2" = 0)
	minimum_survivable_temperature = TCMB

	ai_controller = /datum/ai_controller/basic_controller/rapidlightflying

	var/ranged = TRUE

	var/ranged_cooldown = 3 SECONDS
	var/projectile_type = /obj/projectile/bullet/coil
	var/shoot_sound = 'sound/weapons/gun/smg/shot.ogg'
	var/burst_amount = 8
	var/burst_cooldown = 0.25 SECONDS

	var/flying = TRUE
	var/list/death_loot = list(/obj/item/stack/sheet/plasteel = 3, /obj/item/stock_parts/capacitor/redtech = 1, /obj/item/stock_parts/servo/redtech = 1)

/mob/living/basic/reddrone/Initialize(mapload)
	. = ..()

	if(flying)
		AddElement(/datum/element/simple_flying)

	if(ranged)
		AddComponent(\
			/datum/component/ranged_attacks,\
			cooldown_time = ranged_cooldown,\
			projectile_type = projectile_type,\
			projectile_sound = shoot_sound,\
			burst_shots = burst_amount,\
			burst_intervals = burst_cooldown,\
		)

	AddElement(/datum/element/death_drops, death_loot)
