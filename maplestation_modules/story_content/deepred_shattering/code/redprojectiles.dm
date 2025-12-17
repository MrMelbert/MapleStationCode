/obj/projectile/bullet/godslayer
	name = "godslayer slug"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
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

	var/extra_damage = 500

	var/datum/marked_target

	var/warp_sound = 'maplestation_modules/story_content/deepred_shattering/sound/techpowerup.ogg'
	var/fire_sound = 'maplestation_modules/story_content/deepred_shattering/sound/techblaster.ogg'
	var/terrybullet = 0

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
		var/obj/projectile/bullet/supergodslayer/A = new /obj/projectile/bullet/supergodslayer(get_turf(firer))
		A.preparePixelProjectile(marked_target, get_turf(firer))
		A.send_to_terry = terrybullet
		A.firer = firer
		A.fired_from = firer
		A.fire(null, marked_target)

/obj/effect/projectile/muzzle/godslayer
	name = "godslayer muzzle flash"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
	icon_state = "godslayer_muzzle"

/obj/effect/projectile/tracer/godslayer
	name = "godslayer tracer"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
	icon_state = "godslayer_tracer"

/obj/effect/projectile/impact/godslayer
	name = "godslayer warp site"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
	icon_state = "godslayer_impact"

/obj/projectile/bullet/godslayer/generate_hitscan_tracers(cleanup = TRUE, duration = 4 SECONDS, impacting = TRUE)
	duration = 4 SECONDS
	. = ..()

/obj/projectile/bullet/supergodslayer
	name = "supercharged godslayer slug"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
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

	var/supercharge_sound = 'maplestation_modules/story_content/deepred_shattering/sound/techexplosion.ogg'
	var/send_to_terry = 0

/obj/effect/projectile/muzzle/supergodslayer
	name = "supercharged godslayer warp site"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
	icon_state = "supergodslayer_muzzle"

/obj/effect/projectile/tracer/supergodslayer
	name = "supercharged godslayer tracer"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
	icon_state = "supergodslayer_tracer"

/obj/effect/projectile/impact/supergodslayer
	name = "supercharged godslayer impact"
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/projectiles.dmi'
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
		if(duster.client && send_to_terry)
			var/client/hopper = duster.client
			hopper << link("byond://terry.tgstation13.org:3336")
		duster.dust(just_ash = TRUE, drop_items = FALSE, force = TRUE)
	if(. == BULLET_ACT_HIT && !pierce_hit)
		explosion(src, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 2, flame_range = 2, flash_range = 3, adminlog = FALSE)
		new /obj/effect/temp_visual/cosmic_explosion(get_turf(src))
