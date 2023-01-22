///PPCs, special hitscan mech weapons.
/obj/projectile/beam/ppc
	name = "particle beam"
	icon = 'maplestation_modules/icons/obj/weapons/guns/projectile_tracer.dmi'
	icon_state = "ppc"
	damage = 60 //60 damage, but no armor penetration means you can easily knock this down.
	light_color = LIGHT_COLOR_HALOGEN
	wound_bonus = -40
	bare_wound_bonus = 5
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/ppc
	tracer_type = /obj/effect/projectile/tracer/laser/ppc
	impact_type = /obj/effect/projectile/impact/laser/ppc
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = LIGHT_COLOR_HALOGEN
	muzzle_flash_intensity = 6
	muzzle_flash_range = 2
	muzzle_flash_color_override = LIGHT_COLOR_HALOGEN
	impact_light_intensity = 7
	impact_light_range = 2.5
	impact_light_color_override = LIGHT_COLOR_HALOGEN

/obj/projectile/beam/ppc/hellstar //the ultimate weapon
	name = "high-power particle beam"
	icon_state = "er_ppc"
	muzzle_type = /obj/effect/projectile/muzzle/laser/ppc/hellstar
	tracer_type = /obj/effect/projectile/tracer/laser/ppc/hellstar
	impact_type = /obj/effect/projectile/impact/laser/ppc/hellstar
	damage = 95 //ow fuck
	armour_penetration = 50 // oh
	wound_bonus = 0
	bare_wound_bonus = 20
