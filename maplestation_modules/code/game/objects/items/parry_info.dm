// Extremely bad values, however: funny
/obj/item/cane/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.3 SECONDS, \
	parry_window = 0.5 SECONDS, perfect_parry_window = 0.2 SECONDS, stamina_multiplier = 1, perfect_stamina_multiplier = 0.33, damage_blocked = 1, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 10, block_barrier = 1, parry_miss_cooldown = 0.4 SECONDS, icon_state = "block", \
	effect_color = COLOR_WHITE, projectile_window_multiplier = 0, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_SHOVE = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_SHOVE = TRUE, ACTIVE_COMBAT_KNOCKDOWN = 1 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 10), \
	)

// Some windup but roughly on-par with defaults. Only parries in spars
/obj/item/ceremonial_blade
	block_chance = 0

/obj/item/ceremonial_blade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.1 SECONDS, \
	parry_window = 0.75 SECONDS, perfect_parry_window = 0.25 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1.2, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, block_barrier = 1, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = "#5EB4FF", projectile_window_multiplier = 0, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	parry_callback = CALLBACK(src, PROC_REF(can_parry)), \
	)

/obj/item/ceremonial_blade/proc/can_parry(atom/target)
	return HAS_TRAIT(target, TRAIT_SPARRING)

// Tricky but rewarding
/obj/item/nullrod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.2 SECONDS, \
	parry_window = 0.6 SECONDS, perfect_parry_window = 0.3 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1.2, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, block_barrier = 0.8, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = COLOR_YELLOW, projectile_window_multiplier = 0.3, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_STAMINA = 15), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 12), \
	)

/obj/item/vorpalscythe/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.2 SECONDS, \
	parry_window = 0.6 SECONDS, perfect_parry_window = 0.3 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1.2, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, block_barrier = 0.8, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = COLOR_RED, projectile_window_multiplier = 0.3, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_STAMINA = 15), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 12), \
	)

// Fast, efficient and redirects projectiles
/obj/item/highfrequencyblade
	block_chance = 0

/obj/item/highfrequencyblade/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_OMNIDIRECTIONAL, windup_timer = 0 SECONDS, \
	parry_window = 1.2 SECONDS, perfect_parry_window = 0.2 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 2, \
	damage_block_imperfect_loss = 1.5, maximum_damage_blocked = 25, block_barrier = 0.8, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = COLOR_BLUE, projectile_window_multiplier = 1, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE, ACTIVE_COMBAT_KNOCKDOWN = 1.5 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAMINA = 4), \
	)

// Reflects projectiles but punishes failed parries
/obj/item/melee/energy/sword
	block_chance = 15

/obj/item/melee/energy/sword/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.1 SECONDS, \
	parry_window = 1 SECONDS, perfect_parry_window = 0.25 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1.2, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, block_barrier = 0.8, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = COLOR_RED_LIGHT, projectile_window_multiplier = 1, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = 1.2, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE, ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 4 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	parry_callback = CALLBACK(src, PROC_REF(can_parry)), \
	)

/obj/item/melee/energy/sword/proc/can_parry(atom/target)
	return HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE)

/obj/item/dualsaber
	block_chance = 25

/obj/item/dualsaber/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_OMNIDIRECTIONAL, windup_timer = 0 SECONDS, \
	parry_window = 1.5 SECONDS, perfect_parry_window = 0.3 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 2, \
	damage_block_imperfect_loss = 1.5, maximum_damage_blocked = 35, block_barrier = 0.6, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = COLOR_RED_LIGHT, projectile_window_multiplier = 1, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE, ACTIVE_COMBAT_EMOTE = "spin"), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = 1.2, ACTIVE_COMBAT_REFLECT_PROJECTILE = TRUE, ACTIVE_COMBAT_EMOTE = "spin", ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 2 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	parry_callback = CALLBACK(src, PROC_REF(can_parry)), \
	)

/obj/item/dualsaber/proc/can_parry(atom/target)
	return HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE)

/obj/item/shield
	block_chance = 25 // Git gud, amateur

/obj/item/shield/buckler
	block_chance = 15

/obj/item/shield/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.15 SECONDS, \
	parry_window = 1.5 SECONDS, perfect_parry_window = 0.3 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.2, damage_blocked = 2, \
	damage_block_imperfect_loss = 1.5, maximum_damage_blocked = 35, block_barrier = 0.6, parry_miss_cooldown = 0.4 SECONDS, icon_state = "block", \
	effect_color = COLOR_RED_LIGHT, projectile_window_multiplier = 1, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_SHOVE = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_SHOVE = TRUE, ACTIVE_COMBAT_KNOCKDOWN = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	)

/obj/item/shield/energy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.15 SECONDS, \
	parry_window = 1.5 SECONDS, perfect_parry_window = 0.3 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.2, damage_blocked = 2, \
	damage_block_imperfect_loss = 1.5, maximum_damage_blocked = 35, block_barrier = 0.6, parry_miss_cooldown = 0.4 SECONDS, icon_state = "block", \
	effect_color = COLOR_BLUE_LIGHT, projectile_window_multiplier = 1, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_SHOVE = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_SHOVE = TRUE, ACTIVE_COMBAT_KNOCKDOWN = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	parry_callback = CALLBACK(src, PROC_REF(can_parry)), \
	)

/obj/item/shield/energy/proc/can_parry(atom/target)
	return HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE)

/* TODOS
 *
 * Claymore
 * Cult sword
 * Crowbar
 * Cursed katana
 * Energy katana
 * Fireaxe
 * Hierophant club
 * Katana
 * Kinetic Crusher
 * Knives
 * Pickass
 * Toolboxes
 *
 * Baseball bats
 * Batons
 * Stunbatons
 * Telebatons
 * Heretic Blade
 */

/*
 * Template with "default" parry values

	AddComponent(/datum/component/active_combat, inventory_flags = ITEM_SLOT_HANDS, block_directions = ACTIVE_COMBAT_FACING, windup_timer = 0.2 SECONDS, \
	parry_window = 0.75 SECONDS, perfect_parry_window = 0.25 SECONDS, stamina_multiplier = 0.5, perfect_stamina_multiplier = 0.33, damage_blocked = 1.2, \
	damage_block_imperfect_loss = 0.5, maximum_damage_blocked = 25, block_barrier = 1, parry_miss_cooldown = 0.4 SECONDS, icon_state = "counter", \
	effect_color = "#5EB4FF", projectile_window_multiplier = 0, \
	block_barrier_overrides = list(), \
	parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE), \
	perfect_parry_effects = list(ACTIVE_COMBAT_PARRY = TRUE, ACTIVE_COMBAT_STAGGER = 2 SECONDS), \
	parry_miss_effects = list(ACTIVE_COMBAT_STAGGER = 3 SECONDS, ACTIVE_COMBAT_STAMINA = 5), \
	)

*/
