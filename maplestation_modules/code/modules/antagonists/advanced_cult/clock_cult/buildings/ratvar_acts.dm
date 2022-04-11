/// Ratvar acts, for turning things into brass.
/atom/proc/ratvar_act()
	return

/obj/machinery/door/airlock/ratvar_act()
	var/turf/our_turf = get_turf(src)
	var/obj/machinery/door/airlock/cult/created_airlock
	if(glass)
		created_airlock = new /obj/machinery/door/airlock/cult/brass/glass(our_turf)
	else
		created_airlock = new /obj/machinery/door/airlock/cult/brass(our_turf)
	created_airlock.name = name
	qdel(src)

/obj/structure/door_assembly/ratvar_act()
	new /obj/structure/door_assembly/door_assembly_brass(loc)
	qdel(src)

/obj/structure/door_assembly/narsie_act()
	new /obj/structure/door_assembly/door_assembly_cult(loc)
	qdel(src)

/obj/structure/door_assembly/door_assembly_cult/ratvar_act()
	return

/obj/machinery/door/window/ratvar_act()
	var/obj/machinery/door/window/brass/new_windoor = new(loc, dir)
	new_windoor.name = name
	qdel(src)

/obj/item/stack/sheet/iron/ratvar_act()
	new /obj/item/stack/sheet/brass(loc, amount)
	qdel(src)

/obj/structure/girder/ratvar_act()
	new /obj/structure/girder/brass(loc)
	qdel(src)

/obj/structure/girder/cult/ratvar_act()
	return

/obj/structure/table/ratvar_act()
	new /obj/structure/table/reinforced/brass(loc)
	qdel(src)

/obj/structure/window/ratvar_act()
	if(fulltile)
		new /obj/structure/window/reinforced/bronze/fulltile(loc)
	else
		new /obj/structure/window/reinforced/bronze(loc, dir)
	qdel(src)

/obj/structure/grille/ratvar_act() // just visual
	if(broken)
		new /obj/effect/temp_visual/brass/grille_broken(loc)
	else
		new /obj/effect/temp_visual/brass/grille(loc)

/obj/structure/chair/ratvar_act()
	var/obj/structure/chair/brass/new_chair = new(loc)
	new_chair.setDir(dir)
	qdel(src)

/obj/item/chair/ratvar_act()
	new /obj/item/stack/sheet/brass(loc, 2)
	qdel(src)

/turf/ratvar_act(all_contents = TRUE, ignore_mobs = FALSE)
	if(all_contents)
		for(var/atom/thing as anything in src)
			if(ignore_mobs && ismob(thing))
				continue
			thing.ratvar_act()

/turf/closed/wall/ratvar_act(all_contents = TRUE, ignore_mobs = FALSE)
	. = ..()
	ChangeTurf(/turf/closed/wall/mineral/brass)

/turf/closed/wall/mineral/cult/ratvar_act(all_contents = TRUE, ignore_mobs = FALSE)
	return

/turf/open/floor/ratvar_act(all_contents = TRUE, ignore_mobs = FALSE)
	. = ..()
	ChangeTurf(/turf/open/floor/engine/cult/brass, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/cult/ratvar_act(all_contents = TRUE, ignore_mobs = FALSE)
	return
