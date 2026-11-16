// new meteor type that's literally just a missile thrown at you by the syndicate
// this thing still spins. i could make it not spin. but the spin is funny
/obj/effect/meteor/missile
	name = "syndicate missile"
	icon = 'maplestation_modules/icons/obj/meteor.dmi'
	icon_state = "missile"
	hits = 1
	heavy = TRUE
	meteordrop = list(/obj/item/stack/sheet/mineral/plastitanium)
	dropamt = 2
	threat = 35
	hitpwr = EXPLODE_DEVASTATE
	signature = "missile"

/obj/effect/meteor/missile/meteor_effect()
	..()
	explosion(src, devastation_range = 3, heavy_impact_range = 5, light_impact_range = 8, flash_range = 12, adminlog = FALSE)
