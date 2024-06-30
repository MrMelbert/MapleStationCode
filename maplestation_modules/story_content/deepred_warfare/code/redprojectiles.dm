/obj/projectile/bullet/coil
	name ="10mm coilslug"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "coilslug"
	range = 80
	damage = 10
	armour_penetration = 0

/obj/projectile/bullet/coil/highvelo
	name ="high velocity 10mm coilslug"
	icon_state = "high_velo"
	speed = 0.4
	range = 120
	damage = 20
	armour_penetration = 20

/obj/projectile/bullet/coil/red_lightning
	name = "charged 10mm coilslug"
	icon_state = "red_lightning"
	range = 120
	damage = 20
	armour_penetration = 60

	var/extra_damage = 20 // Damage done by shock aftereffect (or straight damage to mechs).

	muzzle_type = /obj/effect/projectile/muzzle/RLcoil
	tracer_type = /obj/effect/projectile/tracer/RLcoil
	impact_type = /obj/effect/projectile/impact/RLcoil
	hitscan = TRUE
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_RED_LIGHT
	muzzle_flash_intensity = 5
	muzzle_flash_range = 1
	muzzle_flash_color_override = COLOR_RED_LIGHT
	impact_light_intensity = 5
	impact_light_range = 1
	impact_light_color_override = COLOR_RED_LIGHT

/obj/projectile/bullet/coil/red_lightning/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/shocked_fellow = target
		shocked_fellow.electrocute_act(extra_damage, src, 1, SHOCK_NOSTUN | SHOCK_NOGLOVES)
	if(ismecha(target))
		target.take_damage(extra_damage, BURN, BULLET, FALSE)

/obj/effect/projectile/muzzle/RLcoil
	name = "charged coilslug muzzle flash"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "rl_coil_muzzle"

/obj/effect/projectile/tracer/RLcoil
	name = "charged coilslug tracer"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "rl_coil_tracer"

/obj/effect/projectile/impact/RLcoil
	name = "charged coilslug impact"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "rl_coil_impact"
