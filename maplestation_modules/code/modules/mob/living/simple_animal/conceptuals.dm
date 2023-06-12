//WIP:Turn into basic mob, might retool abilities if unable to keep close to Pandora. Faster moving pandora for the Conceptual away mission. Moves faster but hits for less.
/mob/living/simple_animal/hostile/asteroid/elite/pandora/threat
	name = "Concept of Threat"
	desc = "The sharp corners and pulsing charges put you on edge."
	maxHealth = 500
	health = 500
	melee_damage_lower = 5
	melee_damage_upper = 5
	move_to_delay = 5
	loot_drop = /obj/item/clothing/accessory/pandora_hope/threat

//Less damaging tile projectile.
/obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat
	damage = 5

//Changing all attacks to use lesser damaging version.
/mob/living/simple_animal/hostile/asteroid/elite/pandora/threat/singular_shot_line(procsleft, angleused, turf/T)
	if(procsleft <= 0)
		return
	new /obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat(T, src)
	T = get_step(T, angleused)
	procsleft = procsleft - 1
	addtimer(CALLBACK(src, PROC_REF(singular_shot_line), procsleft, angleused, T), cooldown_time * 0.1)

/mob/living/simple_animal/hostile/asteroid/elite/pandora/threat/magic_box()
	ranged_cooldown = world.time + cooldown_time
	var/turf/T = get_turf(target)
	for(var/t in spiral_range_turfs(3, T))
		if(get_dist(t, T) > 1)
			new /obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat(t, src)

/mob/living/simple_animal/hostile/asteroid/elite/pandora/threat/pandora_teleport_2(turf/T, turf/source)
	new /obj/effect/temp_visual/hierophant/telegraph/teleport(T, src)
	new /obj/effect/temp_visual/hierophant/telegraph/teleport(source, src)
	for(var/t in RANGE_TURFS(1, T))
		new /obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat(t, src)
	for(var/t in RANGE_TURFS(1, source))
		new /obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat(t, src)
	animate(src, alpha = 0, time = 2, easing = EASE_OUT) //fade out
	visible_message(span_hierophant_warning("[src] fades out!"))
	set_density(FALSE)
	addtimer(CALLBACK(src, PROC_REF(pandora_teleport_3), T), 2)

/mob/living/simple_animal/hostile/asteroid/elite/pandora/threat/aoe_squares(target)
	ranged_cooldown = world.time + cooldown_time
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat(T, src)
	var/max_size = 3
	addtimer(CALLBACK(src, PROC_REF(aoe_squares_2), T, 0, max_size), 2)

/mob/living/simple_animal/hostile/asteroid/elite/pandora/threat/aoe_squares_2(turf/T, ring, max_size)
	if(ring > max_size)
		return
	for(var/t in spiral_range_turfs(ring, T))
		if(get_dist(t, T) == ring)
			new /obj/effect/temp_visual/hierophant/blast/damaging/pandora/threat(t, src)
	addtimer(CALLBACK(src, PROC_REF(aoe_squares_2), T, (ring + 1), max_size), cooldown_time * 0.1)


//Pulsating Tumor that only spawns Concept of Threat.
/obj/structure/elite_tumor/threat
	name = "Concept of Danger"
	desc = "An odd, pulsing tumor sticking out of the ground. It flashes and beats similar to a heart."
	light_color = COLOR_LIGHT_PINK
	potentialspawns = /mob/living/simple_animal/hostile/asteroid/elite/pandora/threat

/obj/structure/elite_tumor/threat/onEliteLoss()
	playsound(loc,'maplestation_modules/sound/radiodrum.ogg', 200, 0, 50, TRUE, TRUE)
	visible_message(span_boldwarning("[src] begins to convulse violently before beginning to dissipate."))
	visible_message(span_boldwarning("As [src] closes, something is forced up from down below."))
	var/obj/structure/closet/crate/necropolis/tendril/lootbox = new /obj/item/clothing/accessory/pandora_hope/threat(loc)
	//I don't expect anyone to boost the away mission tumor, but I'll leave this in just incase.
	if(boosted)
		if(mychild.loot_drop != null && prob(50))
			new mychild.loot_drop(lootbox)
		else
			new /obj/item/tumor_shard(lootbox)
	qdel(src)

//Concept of Threat's loot: Hope, adding a different name and description.
/obj/item/clothing/accessory/pandora_hope/threat
	name = "Pure Heart"
	desc = "The warmth and beating rhythm is comforting at an instinctual level."

/*WIP:Scramble tiles for a longer time. Perhaps include it in 2nd boss somehow.
/datum/action/cooldown/spell/spacetime_dist/concept
	name = "Spacetime Distortion Longer"
	scramble_radius = 3
	duration = 2 MINUTES
*/
//WIP:Turn into basic mob, del on death.
/mob/living/basic/concept_hunger
	name = "Concept of Hunger"
	desc = "An non-distinct mass of light?"
	icon = 'icons/effects/light_overlays/light_32.dmi'
	icon_state = "light"
	icon_living = "light"
	mob_biotypes = MOB_SPIRIT
	maxHealth = 10 //easy to kill
	health = 10
	gender = NEUTER
	basic_mob_flags = DEL_ON_DEATH
	melee_damage_lower = 5
	melee_damage_upper = 8
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/weapons/bite.ogg'
	attack_vis_effect = ATTACK_EFFECT_BITE
