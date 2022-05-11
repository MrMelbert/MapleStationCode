///Overrides to shotgun projectiles and any new projectiles go here
//Overrides frag12 to not have innate damage and stunning
/obj/projectile/bullet/shotgun_frag12
	damage = 0
	paralyze = 0

//New laser scatter projectile type, 11 damage for 6 pellets doing 66 damage in total
/obj/projectile/beam/weak/laser_scatter
	damage = 11

//Overrides meteorslug to have no stun, lower knockdown but also causes a lot of PAIN
/obj/projectile/bullet/shotgun_meteorslug
	paralyze = 0
	knockdown = 50

/obj/projectile/bullet/shotgun_meteorslug/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/unfortunate_soul = target
		if(unfortunate_soul.pain_controller)
			unfortunate_soul.sharp_pain(BODY_ZONES_ALL, 50) //OW MY BONES
