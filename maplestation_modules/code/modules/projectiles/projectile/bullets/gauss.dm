/obj/projectile/bullet/gauss
	name = "ferromagnetic slug"
	icon_state = "gauss"
	damage = 30
	armour_penetration = 65 //you'll need more than bulletproof armor for this one
	wound_bonus = -30
	speed = 0.3
	range = 80

/obj/projectile/bullet/gauss/penetrator //upgraded penetration gauss for silly use. it's basically an upgraded penetrator round.
	name = "hypervelocity ferromagnetic slug"
	damage = 75
	wound_bonus = 0
	range = 100
	projectile_piercing = PASSMOB|PASSVEHICLE
	projectile_phasing = ~(PASSMOB|PASSVEHICLE)
	phasing_ignore_direct_target = TRUE
