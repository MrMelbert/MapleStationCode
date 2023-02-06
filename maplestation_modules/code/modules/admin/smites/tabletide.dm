/// Smash the target across every possible table
/datum/smite/tabletide
	name = "Tabletide"

/datum/smite/tabletide/effect(client/user, mob/living/target)
	. = ..()
	priority_announce("[target] has brought the wrath of the gods upon themselves \
		and is now being tableslammed across the station. Please stand by.")

	SEND_SOUND(target, sound('maplestation_modules/sound/slamofthenorthstar.ogg', volume = 40))
	for(var/area/station_area as anything in GLOB.areas)
		if(station_area.z == 0 || !is_station_level(station_area.z))
			continue
		for(var/turf/area_turf as anything in station_area.get_contained_turfs())
			var/obj/structure/table/slam_jam = locate() in area_turf
			if(!QDELETED(slam_jam) && !istype(slam_jam, /obj/structure/table/glass))
				slam_jam.tablepush(target, target)
				stoplag(0.1 SECONDS)
		CHECK_TICK

	var/turf/deposit = get_safe_random_station_turf(list(/area/station/medical/treatment_center, /area/station/commons/lounge, /area/station/service/bar))
	do_teleport(target, deposit, forced = TRUE) // Show 'em what happened.
