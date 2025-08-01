#define TENTACLE_PATCH 1
#define SPAWN_CHILDREN 2
#define RAGE 3
#define CALL_CHILDREN 4

/**
 * # Goliath Broodmother
 *
 * A stronger, faster variation of the goliath.  Has the ability to spawn baby goliaths, which it can later detonate at will.
 * When it's health is below half, tendrils will spawn randomly around it.  When it is below a quarter of health, this effect is doubled.
 * It's attacks are as follows:
 * - Spawns a 3x3/plus shape of tentacles on the target location
 * - Spawns 2 baby goliaths on its tile, up to a max of 8.  Children blow up when they die.
 * - The broodmother lets out a noise, and is able to move faster for 6.5 seconds.
 * - Summons your children around you.
 * The broodmother is a fight revolving around stage control, as the activator has to manage the baby goliaths and the broodmother herself, along with all the tendrils.
 */

/mob/living/simple_animal/hostile/asteroid/elite/broodmother
	name = "goliath broodmother"
	desc = "An example of sexual dimorphism, this female goliath looks much different than the males of her species.  She is, however, just as dangerous, if not more."
	gender = FEMALE
	icon = 'icons/mob/simple/lavaland/lavaland_elites_64.dmi'
	icon_state = "broodmother"
	icon_living = "broodmother"
	icon_aggro = "broodmother"
	icon_dead = "egg_sac"
	icon_gib = "syndicate_gib"
	pixel_x = -16
	base_pixel_x = -16
	health_doll_icon = "broodmother"
	maxHealth = 1000
	health = 1000
	melee_damage_lower = 30
	melee_damage_upper = 30
	armour_penetration = 30
	attack_verb_continuous = "beats down on"
	attack_verb_simple = "beat down on"
	attack_sound = 'sound/weapons/punch1.ogg'
	throw_message = "does nothing to the rocky hide of the"
	speed = 2
	move_to_delay = 5
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	mouse_opacity = MOUSE_OPACITY_ICON
	death_message = "explodes into gore!"
	loot_drop = /obj/item/crusher_trophy/broodmother_tongue

	attack_action_types = list(/datum/action/innate/elite_attack/tentacle_patch,
								/datum/action/innate/elite_attack/spawn_children,
								/datum/action/innate/elite_attack/rage,
								/datum/action/innate/elite_attack/call_children)

	var/rand_tent = 0
	var/list/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child/children_list = list()

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TENTACLE_IMMUNE, INNATE_TRAIT)

/datum/action/innate/elite_attack/tentacle_patch
	name = "Tentacle Patch"
	button_icon_state = "tentacle_patch"
	chosen_message = "<span class='boldwarning'>You are now attacking with a patch of tentacles.</span>"
	chosen_attack_num = TENTACLE_PATCH

/datum/action/innate/elite_attack/spawn_children
	name = "Spawn Children"
	button_icon_state = "spawn_children"
	chosen_message = "<span class='boldwarning'>You will spawn two children at your location to assist you in combat.  You can have up to 8.</span>"
	chosen_attack_num = SPAWN_CHILDREN

/datum/action/innate/elite_attack/rage
	name = "Rage"
	button_icon_state = "rage"
	chosen_message = "<span class='boldwarning'>You will temporarily increase your movement speed.</span>"
	chosen_attack_num = RAGE

/datum/action/innate/elite_attack/call_children
	name = "Call Children"
	button_icon_state = "call_children"
	chosen_message = "<span class='boldwarning'>You will summon your children to your location.</span>"
	chosen_attack_num = CALL_CHILDREN

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/OpenFire()
	if(client)
		switch(chosen_attack)
			if(TENTACLE_PATCH)
				tentacle_patch(target)
			if(SPAWN_CHILDREN)
				spawn_children()
			if(RAGE)
				rage()
			if(CALL_CHILDREN)
				call_children()
		return
	var/aiattack = rand(1,4)
	switch(aiattack)
		if(TENTACLE_PATCH)
			tentacle_patch(target)
		if(SPAWN_CHILDREN)
			spawn_children()
		if(RAGE)
			rage()
		if(CALL_CHILDREN)
			call_children()

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	. = ..()
	if(!.) //Checks if they are dead as a rock.
		return
	if(health < maxHealth * 0.5 && rand_tent < world.time)
		rand_tent = world.time + 30
		var/tentacle_amount = 5
		if(health < maxHealth * 0.25)
			tentacle_amount = 10
		var/tentacle_loc = spiral_range_turfs(5, get_turf(src))
		for(var/i in 1 to tentacle_amount)
			var/turf/t = pick_n_take(tentacle_loc)
			new /obj/effect/goliath_tentacle/broodmother(t, src)

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/proc/tentacle_patch(target)
	ranged_cooldown = world.time + 15
	var/tturf = get_turf(target)
	if(!isturf(tturf))
		return
	visible_message(span_warning("[src] digs its tentacles under [target]!"))
	new /obj/effect/goliath_tentacle/broodmother/patch(tturf, src)

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/proc/spawn_children(target)
	ranged_cooldown = world.time + 40
	visible_message(span_boldwarning("The ground churns behind [src]!"))
	for(var/i in 1 to 2)
		if(children_list.len >= 8)
			return
		var/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child/newchild = new /mob/living/simple_animal/hostile/asteroid/elite/broodmother_child(loc)
		newchild.GiveTarget(target)
		newchild.faction = faction.Copy()
		visible_message(span_boldwarning("[newchild] appears below [src]!"))
		newchild.mother = src
		children_list += newchild

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/proc/rage()
	ranged_cooldown = world.time + 100
	playsound(src,'sound/voice/insane_low_laugh.ogg', 200, 1)
	visible_message(span_warning("[src] starts picking up speed!"))
	color = "#FF0000"
	set_varspeed(0)
	move_to_delay = 3
	addtimer(CALLBACK(src, PROC_REF(reset_rage)), 6.5 SECONDS)

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/proc/reset_rage()
	color = "#FFFFFF"
	set_varspeed(2)
	move_to_delay = 5

/mob/living/simple_animal/hostile/asteroid/elite/broodmother/proc/call_children()
	ranged_cooldown = world.time + 60
	visible_message(span_warning("The ground shakes near [src]!"))
	var/list/directions = GLOB.cardinals.Copy() + GLOB.diagonals.Copy()
	for(var/mob/child in children_list)
		var/spawndir = pick_n_take(directions)
		var/turf/T = get_step(src, spawndir)
		if(T)
			child.forceMove(T)
			playsound(src, 'sound/effects/bamf.ogg', 100, 1)

//The goliath's children.  Pretty weak, simple mobs which are able to put a single tentacle under their target when at range.
/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child
	name = "baby goliath"
	desc = "A young goliath recently born from it's mother.  While they hatch from eggs, said eggs are incubated in the mother until they are ready to be born."
	icon = 'icons/mob/simple/lavaland/lavaland_monsters.dmi'
	icon_state = "goliath_baby"
	icon_living = "goliath_baby"
	icon_aggro = "goliath_baby"
	icon_dead = "goliath_baby_dead"
	icon_gib = "syndicate_gib"
	maxHealth = 30
	health = 30
	melee_damage_lower = 5
	melee_damage_upper = 5
	attack_verb_continuous = "bashes against"
	attack_verb_simple = "bash against"
	attack_sound = 'sound/weapons/punch1.ogg'
	throw_message = "does nothing to the rocky hide of the"
	speed = 2
	move_to_delay = 5
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	mouse_opacity = MOUSE_OPACITY_ICON
	butcher_results = list()
	guaranteed_butcher_results = list(/obj/item/stack/sheet/animalhide/goliath_hide = 1)
	death_message = "falls to the ground."
	status_flags = CANPUSH
	var/mob/living/simple_animal/hostile/asteroid/elite/broodmother/mother = null

/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_TENTACLE_IMMUNE, INNATE_TRAIT)

/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child/OpenFire(target)
	ranged_cooldown = world.time + 40
	var/tturf = get_turf(target)
	if(!isturf(tturf))
		return
	if(get_dist(src, target) <= 7)//Screen range check, so it can't attack people off-screen
		visible_message(span_warning("[src] digs one of its tentacles under [target]!"))
		new /obj/effect/goliath_tentacle/broodmother(tturf, src)

/mob/living/simple_animal/hostile/asteroid/elite/broodmother_child/death()
	. = ..()
	if(mother != null)
		mother.children_list -= src
	visible_message(span_warning("[src] explodes!"))
	explosion(src, flame_range = 3, adminlog = FALSE)
	gib(DROP_ALL_REMAINS)

/obj/effect/goliath_tentacle/broodmother
	grapple_time = 1 SECONDS
	min_damage = 30
	max_damage = 35

/obj/effect/goliath_tentacle/broodmother/patch/Initialize(mapload, new_spawner)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(createpatch))

/obj/effect/goliath_tentacle/broodmother/patch/proc/createpatch()
	var/tentacle_locs = spiral_range_turfs(1, get_turf(src))
	for(var/T in tentacle_locs)
		new /obj/effect/goliath_tentacle/broodmother(T)
	var/list/directions = GLOB.cardinals.Copy()
	for(var/i in directions)
		var/turf/T = get_step(get_turf(src), i)
		T = get_step(T, i)
		new /obj/effect/goliath_tentacle/broodmother(T)

// Broodmother's loot: Broodmother Tongue
/obj/item/crusher_trophy/broodmother_tongue
	name = "broodmother tongue"
	desc = "The tongue of a broodmother. If attached a certain way, makes for a suitable crusher trophy.  It also feels very spongey, I wonder what would happen if you squeezed it?..."
	icon = 'icons/obj/mining_zones/elite_trophies.dmi'
	icon_state = "broodmother_tongue"
	denied_type = /obj/item/crusher_trophy/broodmother_tongue
	bonus_value = 10
	/// Time at which the item becomes usable again
	var/use_time

/obj/item/crusher_trophy/broodmother_tongue/effect_desc()
	return "mark detonation to have a <b>[bonus_value]%</b> chance to summon a patch of goliath tentacles at the target's location"

/obj/item/crusher_trophy/broodmother_tongue/on_mark_detonation(mob/living/target, mob/living/user)
	if(prob(bonus_value) && target.stat != DEAD)
		new /obj/effect/goliath_tentacle/broodmother/patch(get_turf(target), user)

/obj/item/crusher_trophy/broodmother_tongue/attack_self(mob/user)
	if(!isliving(user))
		return
	var/mob/living/living_user = user
	if(use_time > world.time)
		to_chat(living_user, "<b>The tongue looks dried out. You'll need to wait longer to use it again.</b>")
		return
	else if(HAS_TRAIT(living_user, TRAIT_LAVA_IMMUNE))
		to_chat(living_user, "<b>You stare at the tongue. You don't think this is any use to you.</b>")
		return
	ADD_TRAIT(living_user, TRAIT_LAVA_IMMUNE, type)
	to_chat(living_user, "<b>You squeeze the tongue, and some transluscent liquid shoots out all over you.</b>")
	addtimer(TRAIT_CALLBACK_REMOVE(user, TRAIT_LAVA_IMMUNE, type), 10 SECONDS)
	use_time = world.time + 60 SECONDS

#undef CALL_CHILDREN
#undef RAGE
#undef SPAWN_CHILDREN
#undef TENTACLE_PATCH
