
//--A gift from CaLE to Dances! CaLE had fun making it!
//disc shooter
/obj/item/gun/ballistic/shotgun/toy/disc_launcher
	name = "Prototype disc launcher for rapid! firing™️"
	desc = "A small toy disc launcher. Copyright Dances-in-Dreams."
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shot/toy/disc_launcher
	semi_auto = TRUE
	pb_knockback = 3

/obj/item/ammo_box/magazine/internal/shot/toy/disc_launcher
	name = "Prototype disc launcher for rapid! firing™️ Novelty flying disc firing mechanism"
	icon_state = "9x19p"
	max_ammo = 3
	multiple_sprites = AMMO_BOX_FULL_EMPTY
	ammo_type = /obj/item/ammo_casing/foam_dart/novelty_flying_disc

/obj/item/ammo_casing/foam_dart/novelty_flying_disc
	name = "\improper MICRO prototype Dances-In-Dreams' Novelty flying disc made of cold wrought iron that fits in your hand and you can launch! over 200 feet as you grip it skip it curve it or jam it™️"
	desc = "A small shining metal disc. Copyright Dances-in-Dreams."
	projectile_type = /obj/projectile/bullet/foam_dart/novelty_flying_disc
	caliber = CALIBER_FOAM
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foamdart"
	base_icon_state = "foamdart"
	custom_materials = list(/datum/material/cold_iron = SMALL_MATERIAL_AMOUNT)
	harmful = FALSE

/obj/projectile/bullet/foam_dart/novelty_flying_disc
	name = "MICRO prototype Dances-In-Dreams' Novelty flying disc made of cold wrought iron that fits in your hand and you can launch! over 200 feet as you grip it skip it curve it or jam it™️"
	desc = "A small shining metal disc. Copyright Dances-in-Dreams."
	damage = 0 // It's a toy.
	damage_type = OXY
	icon = 'icons/obj/weapons/guns/toy.dmi'
	icon_state = "foamdart_proj"
	base_icon_state = "foamdart"
	shrapnel_type = null
	embed_type = null
	ricochets_max = 5
	ricochet_chance = 700 //BOUNCY
	ricochet_incidence_leeway = 0
	range = 70 //assuming each tile is 3 feet this should be about 210 feet, aka, over 200 feet. Yes this is big.


