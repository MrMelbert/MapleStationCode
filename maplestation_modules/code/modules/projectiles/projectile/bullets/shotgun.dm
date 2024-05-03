///Overrides to shotgun projectiles and any new projectiles go here
//Overrides frag12 to not have innate damage and stunning
/obj/projectile/bullet/shotgun_frag12
	damage = 0
	paralyze = 0

//Overrides meteorslug to have no stun, lower knockdown but also causes a lot of PAIN
/obj/projectile/bullet/shotgun_meteorslug
	paralyze = 0
	knockdown = 5 SECONDS

/obj/projectile/bullet/shotgun_meteorslug/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return
	if(!iscarbon(target))
		return
	var/mob/living/carbon/unfortunate_soul = target
	unfortunate_soul.sharp_pain(BODY_ZONES_ALL, 50) //OW MY BONES
