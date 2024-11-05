GLOBAL_VAR(captain_weapon_picked)
//Weapons for the captain to use in melee.

/obj/item/melee/sabre
	block_chance = 0

/obj/item/melee/sabre/Initialize(mapload)
	. = ..()
	if(!GLOB.captain_weapon_picked)
		AddComponent(/datum/component/subtype_picker, GLOB.captain_weapons, CALLBACK(src, PROC_REF(on_captain_weapon_picked)))

	// Larger window, smaller perfect parries, no windup and has a bit of a leeway for full blocks for imperfect parries
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0 SECONDS, \
		parry_window = 1.0 SECONDS, perfect_parry_window = 0.25 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1.3, \
		damage_block_imperfect_loss = 0.6, maximum_damage_blocked = 25, block_barrier = 1, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
		effect_color = COLOR_LIGHT_ORANGE, projectile_window_multiplier = 0.5, \
		block_barrier_overrides = list(), \
		parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE), \
		perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = 1.2, ACTIVE_COMBAT_STAGGER = 3 SECONDS), \
		parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
		)

///Probably doesn't need to be a proc, but this is used when the captain's weapon is chosen to make sure you can keep picking the sabre over and over. Has to be a global list so that its on the next weapon.
/obj/item/melee/sabre/proc/on_captain_weapon_picked(obj/item/melee/sabre/captain_weapon_picked)
	GLOB.captain_weapon_picked = captain_weapon_picked

/obj/item/melee/baseball_bat/golden
	name = "Il Batto Doro"
	desc = "A bat made entirely out of 24-karat gold. It's incredibly heavy, but perfect for turning assistant kneecaps into powder."
	icon_state = "baseball_bat_golden"
	inhand_icon_state = "baseball_bat_golden"
	force = 30 //OUCH
	wound_bonus = 40 //Bones? Never heard of em.
	bare_wound_bonus = 45
	belt_sprite = "-golden"
	drop_sound = 'maplestation_modules/sound/items/drop/metal_drop.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/metalweapon.ogg'
	equip_sound = 'maplestation_modules/sound/items/drop/metal_drop.ogg'

/obj/item/melee/energy/sword/captain_rapier
	name = "laser rapier"
	desc = "The captain's own laser rapier, designed to ruin any obnoxious security cameras. Marked with the logo of a company named TriOptimum."
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	icon_state = "laser_rapier"
	base_icon_state = "laser_rapier"
	inhand_icon_state = "laser_rapier"
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 5 //The golden hilt is very blunt
	active_force = 25
	active_throwforce = 35 //Its a fucking spear of a sword
	armour_penetration = 50

/obj/item/melee/energy/sword/captain_rapier/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.1 SECONDS, \
	parry_window = 0.5 SECONDS, perfect_parry_window = 0.2 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, block_barrier = 1, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = COLOR_LIGHT_ORANGE, projectile_window_multiplier = 1, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = 1.2, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE, ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 4 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	)

/obj/item/melee/energy/sword/captain_rapier/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity)
		return
	if(!HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return

	//deals double damage to cameras
	if(!istype(target, /obj/machinery/camera))
		return
	//Techncially this cast is not necessary at all because take damage is atom level
	//but not all overrides of take damage pass parameters so we can't use named args. Grr
	var/obj/machinery/camera/casted_for_dumb_reason = target
	casted_for_dumb_reason.take_damage(
		damage_amount = force,
		sound_effect = FALSE,
		armour_penetration = armour_penetration,
	)
