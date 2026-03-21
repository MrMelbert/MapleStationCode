/obj/projectile/beam/er_laser
	name = "extended range laser beam"
	icon = 'icons/obj/weapons/guns/projectiles_tracer.dmi'
	icon_state = "beam_heavy"
	damage = 40
	armour_penetration = 20
	light_color = COLOR_RED_LIGHT
	wound_bonus = -20
	hitscan = TRUE
	muzzle_type = /obj/effect/projectile/muzzle/laser/er_laser
	tracer_type = /obj/effect/projectile/tracer/laser/er_laser
	impact_type = /obj/effect/projectile/impact/laser/er_laser
	impact_effect_type = null
	hitscan_light_intensity = 2
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_RED_LIGHT
	muzzle_flash_intensity = 6
	muzzle_flash_range = 1.5
	muzzle_flash_color_override = COLOR_RED_LIGHT
	impact_light_intensity = 7
	impact_light_range = 2
	impact_light_color_override = COLOR_RED_LIGHT

/obj/projectile/beam/er_laser/pulse //weaker end of NT stuff, only 50% as good.
	name = "extended range pulse beam"
	damage = 60
	armour_penetration = 30
	icon_state = "u_laser"
	muzzle_type = /obj/effect/projectile/muzzle/laser/er_laser/pulse
	tracer_type = /obj/effect/projectile/tracer/laser/er_laser/pulse
	impact_type = /obj/effect/projectile/impact/laser/er_laser/pulse
	light_color = LIGHT_COLOR_BLUE
	hitscan_light_color_override = LIGHT_COLOR_BLUE
	muzzle_flash_color_override = LIGHT_COLOR_BLUE
	impact_light_color_override = LIGHT_COLOR_BLUE

/obj/projectile/beam/weak/pulsed
	armour_penetration = 20 //Just a small lil bonus AP
	icon_state = "redtrac"

/obj/projectile/beam/laser/hellfire/pulsed
	icon_state = "lava"
