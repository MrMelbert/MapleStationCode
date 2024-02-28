/obj/projectile/kajari_lance
	name = "Kajari particle lance"
	icon_state = "laser"
	pass_flags = NONE
	damage = 200
	damage_type = BURN
	hitsound = 'sound/weapons/sear.ogg'
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'
	range = 80
	armor_flag = ENERGY
	eyeblur = 4 SECONDS
	impact_effect_type = /obj/effect/temp_visual/impact_effect/red_laser
	light_system = MOVABLE_LIGHT
	light_range = 5
	light_power = 5
	light_color = COLOR_RED_LIGHT
	ricochets_max = 0
	ricochet_chance = 0 //No.
	reflectable = NONE //Hell no, this is a big ass particle beam.
	wound_bonus = -20
	bare_wound_bonus = 10
	hit_threshhold = SPACE_LAYER //Blow up the floors and stuff too.
	projectile_piercing = ALL
	hit_prone_targets = TRUE
	can_hit_turfs = TRUE
	var/explosion_tile_cooldown = 6

/obj/projectile/kajari_lance/prehit_pierce()
	return PROJECTILE_PIERCE_HIT

/obj/projectile/kajari_lance/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE, cross_failed = FALSE)
	if(isturf(target))
		//explosion(src, heavy_impact_range = 2, adminlog = FALSE)
		return TRUE
	. = ..()

/obj/projectile/kajari_lance/scan_crossed_hit(atom/movable/A)
	if(explosion_tile_cooldown <= 0)
		explosion(src, heavy_impact_range = 2, adminlog = FALSE)
		explosion_tile_cooldown = 6
	else
		explosion_tile_cooldown--
	return ..()

/obj/projectile/kajari_lance/singularity_pull()
	return

/obj/projectile/kajari_lance/hitscan
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/emitter
	tracer_type = /obj/effect/projectile/tracer/laser/emitter
	impact_type = /obj/effect/projectile/impact/laser/emitter
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_RED_LIGHT
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = COLOR_RED_LIGHT
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = COLOR_RED_LIGHT
