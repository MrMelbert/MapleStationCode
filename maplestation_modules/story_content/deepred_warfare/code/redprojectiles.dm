/obj/projectile/bullet/coil
	name ="low velocity 10mm coilslug"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "coilslug"
	range = 40
	damage = 10
	armour_penetration = 0

/obj/projectile/bullet/coil/highvelo
	name ="10mm coilslug"
	icon_state = "high_velo"
	speed = 0.4
	range = 80
	damage = 20
	armour_penetration = 20

/obj/projectile/bullet/coil/red_lightning
	name = "charged 10mm coilslug"
	icon_state = "red_lightning"
	range = 80
	damage = 20
	armour_penetration = 60

	var/extra_damage = 20 // Damage done by shock aftereffect.
	var/emp_radius = 0 // Radius of EMP effect.

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
	else
		empulse(target, emp_radius, emp_radius)
		new /obj/effect/temp_visual/impact_effect/ion(get_turf(target))

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

/obj/projectile/bullet/godslayer
	name = "annihilator round"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "godslayer_tracer"
	range = 120
	damage = 80
	armour_penetration = 100

	dismemberment = 10
	catastropic_dismemberment = TRUE
	parried = TRUE

	projectile_piercing = PASSTABLE|PASSGLASS|PASSGRILLE|PASSBLOB|PASSMOB|PASSMACHINE|PASSSTRUCTURE|PASSFLAPS|PASSDOORS|PASSVEHICLE

	muzzle_type = /obj/effect/projectile/muzzle/godslayer
	tracer_type = /obj/effect/projectile/tracer/godslayer
	impact_type = /obj/effect/projectile/impact/godslayer
	hitscan = TRUE
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_BLUE_LIGHT
	muzzle_flash_intensity = 5
	muzzle_flash_range = 1
	muzzle_flash_color_override = COLOR_BLUE_LIGHT
	impact_light_intensity = 5
	impact_light_range = 1
	impact_light_color_override = COLOR_BLUE_LIGHT

	var/extra_damage = 500 // Extra damage dealt to non-mob, non-vehicle objects (secondary shot will not trigger).

	var/datum/marked_target

	var/warp_sound = 'maplestation_modules/story_content/deepred_warfare/sound/techpowerup.ogg'
	var/fire_sound = 'maplestation_modules/story_content/deepred_warfare/sound/techblaster.ogg'

/obj/projectile/bullet/godslayer/fire(angle, atom/direct_target, make_sound)
	if(make_sound != null)
		playsound(firer, fire_sound, 100, extrarange = 10)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fire_warp))

/obj/projectile/bullet/godslayer/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if(marked_target != null)
		return
	if(isliving(target) || isvehicle(target))
		marked_target = target
	else
		target.take_damage(extra_damage)

/obj/projectile/bullet/godslayer/proc/fire_warp()
	sleep(35)
	if(marked_target == null || QDELETED(marked_target) || QDELETED(firer))
		return
	playsound(firer, warp_sound, 100, extrarange = 10)
	sleep(25)

	if(marked_target != null && !QDELETED(marked_target) && !QDELETED(firer))
		var/obj/projectile/A = new /obj/projectile/bullet/supergodslayer(get_turf(firer))
		A.preparePixelProjectile(marked_target, get_turf(firer))
		A.firer = firer
		A.fired_from = firer
		A.fire(null, marked_target)

/obj/effect/projectile/muzzle/godslayer
	name = "annihilator muzzle flash"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "godslayer_muzzle"

/obj/effect/projectile/tracer/godslayer
	name = "annihilator tracer"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "godslayer_tracer"

/obj/effect/projectile/impact/godslayer
	name = "annihilator warp site"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "godslayer_impact"

/obj/projectile/bullet/godslayer/generate_hitscan_tracers(cleanup = TRUE, duration = 4 SECONDS, impacting = TRUE)
	duration = 4 SECONDS
	. = ..()

/obj/projectile/bullet/supergodslayer
	name = "supercharged annihilator round"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "godslayer_tracer"
	range = 120
	damage = 800
	armour_penetration = 100

	dismemberment = 10
	catastropic_dismemberment = TRUE
	parried = TRUE

	muzzle_type = /obj/effect/projectile/muzzle/supergodslayer
	tracer_type = /obj/effect/projectile/tracer/supergodslayer
	impact_type = /obj/effect/projectile/impact/supergodslayer
	hitscan = TRUE
	impact_effect_type = null
	hitscan_light_intensity = 3
	hitscan_light_range = 0.75
	hitscan_light_color_override = COLOR_BLUE_LIGHT
	muzzle_flash_intensity = 5
	muzzle_flash_range = 1
	muzzle_flash_color_override = COLOR_BLUE_LIGHT
	impact_light_intensity = 5
	impact_light_range = 1
	impact_light_color_override = COLOR_BLUE_LIGHT

	var/supercharge_sound = 'maplestation_modules/story_content/deepred_warfare/sound/techexplosion.ogg'

/obj/effect/projectile/muzzle/supergodslayer
	name = "supercharged annihilator warp site"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "supergodslayer_muzzle"

/obj/effect/projectile/tracer/supergodslayer
	name = "supercharged annihilator tracer"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "supergodslayer_tracer"

/obj/effect/projectile/impact/supergodslayer
	name = "supercharged annihilator impact"
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/projectiles.dmi'
	icon_state = "supergodslayer_impact"

/obj/projectile/bullet/supergodslayer/generate_hitscan_tracers(cleanup = TRUE, duration = 5 SECONDS, impacting = TRUE)
	duration = 5 SECONDS
	. = ..()

/obj/projectile/bullet/supergodslayer/fire(angle, atom/direct_target)
	playsound(firer, supercharge_sound, 100, extrarange = 10)
	. = ..()

/obj/projectile/bullet/supergodslayer/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	if (!QDELETED(target) && isliving(target))
		var/mob/living/duster = target
		duster.dust(just_ash = TRUE, drop_items = FALSE, force = TRUE)
	if(. == BULLET_ACT_HIT && !pierce_hit)
		explosion(src, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 2, flame_range = 2, flash_range = 3, adminlog = FALSE)
		new /obj/effect/temp_visual/cosmic_explosion(get_turf(src))
