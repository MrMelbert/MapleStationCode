
/obj/effect/meteor/shell
    name = "generic artillery shell"
    desc = "A generic artillery shell."
    icon = 'icons/obj/arty_shell.dmi'
    icon_state = "rocket_ap_big"
    //I'd expect shells to made out of plasteel or something.
    var/list/meteordrop = list(/obj/item/stack/sheet/plasteel)
    //Mostly everything about this is the same as the meteor.
    //Except for the fact that it's not a meteor.

/obj/effect/meteor/shell/Initialize(mapload, turf/target)
    //I think that . = ..() might cause issues.
    //I wonder if . = ...() would work?
    . = ..()
	z_original = z
    //Fuck it, we can add it to the meteor list so meteor satellites can shoot em down.
	GLOB.meteor_list += src
    //Yeah, I guess ghosts can watch the carnage too.
	SSaugury.register_doom(src, threat)
    //No spinning.
	chase_target(target)
