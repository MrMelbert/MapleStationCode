
// Brass airlock assembly...
/obj/structure/door_assembly/door_assembly_brass
	name = "brass airlock assembly"
	icon = 'icons/obj/doors/airlocks/clockwork/pinion_airlock.dmi'
	base_name = "bronze airlock"
	airlock_type = /obj/machinery/door/airlock/cult/brass
	glass_type = /obj/machinery/door/airlock/cult/brass/glass
	material_type = /obj/item/stack/sheet/brass
	material_amt = 1 //Costs only one brass to make, no duplication here!

/obj/structure/door_assembly/door_assembly_brass/narsie_act()
	return

// Door effects.
/obj/effect/temp_visual/brass/door
	icon_state = "ratvardoorglow"

/obj/effect/temp_visual/clock/disable/door_opening
	layer = ABOVE_MOB_LAYER

// And brass airlock.
/obj/machinery/door/airlock/cult/brass
	name = "engraved brass airlock"
	icon = 'icons/obj/doors/airlocks/clockwork/pinion_airlock.dmi'
	overlays_file = 'icons/obj/doors/airlocks/clockwork/overlays.dmi'
	assemblytype = /obj/structure/door_assembly/door_assembly_brass
	openingoverlaytype = /obj/effect/temp_visual/clock/disable/door_opening

/obj/machinery/door/airlock/cult/brass/Initialize(mapload)
	. = ..()
	new /obj/effect/temp_visual/brass/door(loc)
	ADD_CLOCKCULT_FILTER(src)

/obj/machinery/door/airlock/cult/brass/Destroy()
	REMOVE_CLOCKCULT_FILTER(src)
	return ..()

/obj/machinery/door/airlock/cult/brass/allowed(mob/living/user)
	if(!density)
		return TRUE
	if(friendly || IS_CULTIST(user))
		if(!stealthy)
			new openingoverlaytype(loc)
		return TRUE

	if(!stealthy)
		new openingoverlaytype(loc)
		var/atom/throwtarget = get_edge_target_turf(user, turn(user.dir, 180))
		SEND_SOUND(user, sound('sound/weapons/resonator_blast.ogg', 0, 1, 30))
		flash_color(user, flash_color = "#bc00e2", flash_time = 20)
		user.Paralyze(40)
		user.throw_at(throwtarget, 5, 1)
	return FALSE


/obj/machinery/door/airlock/cult/brass/friendly
	friendly = TRUE

/obj/machinery/door/airlock/cult/brass/glass
	glass = TRUE
	opacity = FALSE

/obj/machinery/door/airlock/cult/brass/glass/friendly
	friendly = TRUE
