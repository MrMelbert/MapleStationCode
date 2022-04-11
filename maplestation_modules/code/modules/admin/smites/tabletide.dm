/// Smash the target across every possible table
/datum/smite/tabletide
	name = "Tabletide"

/datum/smite/tabletide/effect(client/user, mob/living/target)
	. = ..()
	priority_announce("[target] has brought the wrath of the gods upon themselves and is now being tableslammed across the station. Please stand by.")
	var/list/areas = list()
	for(var/area/area in world)
		if(area.z == SSmapping.station_start)
			areas += area
	SEND_SOUND(target, sound('maplestation_modules/sound/slamofthenorthstar.ogg',volume=40))
	for(var/area/area in areas)
		for(var/obj/structure/table/table in area)
			if(!istype(table, /obj/structure/table/glass))
				table.tablepush(target, target)
				sleep(1)
	do_teleport(target, get_safe_random_station_turf(list(/area/medical/treatment_center, /area/commons/lounge))) // Show 'em what happened.
