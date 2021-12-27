// Brass windows and windoors.
/obj/effect/temp_visual/brass/windoor
	icon_state = "ratvarwindoorglow"

/obj/effect/temp_visual/brass/windoor/Initialize(mapload, effect_dir)
	. = ..()
	if(effect_dir)
		setDir(effect_dir)

/obj/machinery/door/window/brass
	icon_state = "clockwork"
	base_state = "clockwork"
	damage_deflection = 12
	max_integrity = 300
	reinf = 1
	explosion_block = 1
	var/friendly = FALSE

/obj/machinery/door/window/brass/Initialize(mapload, set_dir)
	. = ..()
	ADD_CLOCKCULT_FILTER(src)
	new /obj/effect/temp_visual/brass/windoor(loc, set_dir || dir)

/obj/machinery/door/window/brass/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()

/obj/machinery/door/window/brass/hasPower()
	return TRUE

/obj/machinery/door/window/brass/allowed(mob/living/user)
	if(!isliving(user) || issilicon(user))
		return FALSE

	if(friendly || IS_CULTIST(user))
		return TRUE

	var/atom/throwtarget = get_edge_target_turf(user, turn(user.dir, 180))
	SEND_SOUND(user, sound('sound/weapons/resonator_blast.ogg', 0, 1, 30))
	flash_color(user, flash_color = "#bc00e2", flash_time = 20)
	user.Paralyze(20)
	user.throw_at(throwtarget, 2, 1)
	return FALSE

// Bronze windows, too
/obj/effect/temp_visual/brass/full_window
	icon_state = "ratvarwindowglow"

/obj/effect/temp_visual/brass/side_window
	icon_state = "ratvarwindowglow_s"

/obj/effect/temp_visual/brass/side_window/Initialize(mapload, effect_dir)
	. = ..()
	if(effect_dir)
		setDir(effect_dir)

/obj/structure/window/reinforced/bronze
	name = "engraved brass window"
	desc = "A paper-thin pane of translucent yet reinforced brass."
	icon = 'icons/obj/smooth_structures/clockwork_window.dmi'
	icon_state = "clockwork_window_single"
	glass_type = /obj/item/stack/sheet/brass
	max_integrity = 150
	damage_deflection = 12

/obj/structure/window/reinforced/bronze/proc/on_creation_effect()
	new /obj/effect/temp_visual/brass/side_window(loc, dir)

/obj/structure/window/reinforced/bronze/Initialize(mapload, direct)
	. = ..()
	ADD_CLOCKCULT_FILTER(src)
	on_creation_effect()

/obj/structure/window/reinforced/bronze/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()

/obj/structure/window/reinforced/bronze/fulltile
	icon_state = "clockwork_window-0"
	base_icon_state = "clockwork_window"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = list(SMOOTH_GROUP_WINDOW_FULLTILE, SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE)
	canSmoothWith = list(SMOOTH_GROUP_WINDOW_FULLTILE_BRONZE)
	fulltile = TRUE
	flags_1 = PREVENT_CLICK_UNDER_1
	max_integrity = 200
	glass_amount = 2

/obj/structure/window/reinforced/bronze/fulltile/on_creation_effect()
	new /obj/effect/temp_visual/brass/full_window(loc)

/obj/effect/temp_visual/brass/grille
	icon_state = "ratvargrilleglow"

/obj/effect/temp_visual/brass/grille_broken
	icon_state = "ratvarbrokengrilleglow"
