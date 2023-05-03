/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gauss
	name = "\improper \"Highlander\" Mech Gauss Rifle"
	desc = "A weapon for combat exosuits. Uses magnetic propulsion to fire a metallic slug at extremely high velocities. \
	Surprisingly low on damage, but punches through armor. Marked on it is \"This machine kills Squaddies.\""
	icon = 'maplestation_modules/icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_gauss"
	equip_cooldown = 40
	projectile = /obj/projectile/bullet/gauss
	projectiles = 8
	projectiles_cache = 8
	projectiles_cache_max = 24
	fire_sound = 'maplestation_modules/sound/weapons/mecha/gauss.ogg'
	destroy_sound = 'maplestation_modules/sound/mecha/ammo_explosion.ogg'
	harmful = TRUE
	ammo_type = MECHA_AMMO_GAUSS

//If we're destroyed, do a fake explosion and damage the mech + pilot
/obj/item/mecha_parts/mecha_equipment/weapon/ballistic/gauss/Destroy()
	if(chassis)
		playsound(chassis, 'sound/effects/explosion2.ogg', 50)
		if(LAZYLEN(chassis.occupants))
			to_chat(chassis.occupants, "[icon2html(src, chassis.occupants)][span_danger("[src] has had a capacitor explosion! You get violently shaken and hurt by the explosion!")]")
			for(var/mob/living/carbon/affected_pilots in chassis.occupants)
				affected_pilots.apply_damage(damage = 55, damagetype = BRUTE, spread_damage = TRUE)
				shake_camera(affected_pilots, 1.5 SECONDS, 3)
		chassis.take_damage(75)
	return ..()
