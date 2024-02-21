/obj/effect/meteor/shell
	name = "generic artillery shell"
	desc = "A generic artillery shell."
	icon = 'icons/obj/arty_shell.dmi'
	icon_state = "rocket_ap_big"
	//I'd expect shells to made out of plasteel or something.
	meteordrop = list(/obj/item/stack/sheet/plasteel)
	//Mostly everything about this is the same as the meteor.
	//Except for the fact that it's not a meteor.

/obj/effect/meteor/shell/Initialize(mapload, turf/target)
	. = ..()
	z_original = z
	GLOB.meteor_list += src
	SSaugury.register_doom(src, threat)
	//No spinning.
	chase_target(target)

/obj/effect/meteor/shell/examine(mob/user)
	//No achievement because this isn't a meteor.
	. = ..()

/obj/effect/meteor/shell/big_ap
	name = "460mm rocket assisted AP shell"
	desc = "A rocket assisted armour piercing shell, designed to cut through the heaviest of armour. You should probably get out of the way."
	icon_state = "rocket_ap_big"
	//Pierces a lot of hull.
	hits = 20
	//Will fuck you up if you get hit by it.
	hitpwr = EXPLODE_DEVASTATE
	//Scary.
	heavy = TRUE

/obj/effect/meteor/shell/big_ap/Move()
	. = ..()
	if(.)
		//Fire trail, because it's rocket assisted.
		new /obj/effect/temp_visual/fire(get_turf(src))
