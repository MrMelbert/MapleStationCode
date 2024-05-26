/// -- Modular landmarks. --

// System for automatically placing modular landmarks somewhere on the map.
/datum/controller/subsystem/minor_mapping
	var/list/landmark_types_to_place = list(
		/obj/effect/landmark/start/xenobiologist,
		/obj/effect/landmark/start/ordnance_tech,
		/obj/effect/landmark/start/bridge_officer,
		/obj/effect/landmark/start/asset_protection,
		/obj/effect/landmark/start/noble_ambassador,
	)

/datum/controller/subsystem/minor_mapping/Initialize()
	. = ..()
	if(initialized)
		return

	for(var/mark_type in landmark_types_to_place)
		if(locate(mark_type) in GLOB.landmarks_list)
			continue
		var/obj/effect/landmark/to_place = new mark_type()
		to_place.find_spot_to_place()
		if(isnull(to_place.loc))
			log_world("Could not find a spot to place [mark_type]!")
			qdel(to_place)

/obj/effect/landmark/proc/find_spot_to_place()
	CRASH("[type] has not implemented find_spot_to_place()")

// XB start location
/obj/effect/landmark/start/xenobiologist
	name = "Xenobiologist"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "Xenobiologist"

/obj/effect/landmark/start/xenobiologist/find_spot_to_place()
	for(var/obj/machinery/computer/camera_advanced/xenobio/xb_cam as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/camera_advanced/xenobio))
		if(!is_station_level(xb_cam.z))
			continue
		if(!istype(get_area(xb_cam), /area/station/science/xenobiology))
			continue
		for(var/turf/nearby_turf as anything in get_adjacent_open_turfs(xb_cam))
			if(nearby_turf.is_blocked_turf())
				continue
			if(!(locate(/obj/structure/chair) in nearby_turf))
				continue
			forceMove(nearby_turf)
			return

// Toxins start location
/obj/effect/landmark/start/ordnance_tech
	name = "Ordnance Technician"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "Ordnance_Technician"

/obj/effect/landmark/start/ordnance_tech/find_spot_to_place()
	for(var/obj/machinery/computer/atmos_control/ordnancemix/ordnance_mix as anything in SSmachines.get_machines_by_type_and_subtypes(/obj/machinery/computer/atmos_control/ordnancemix))
		if(!is_station_level(ordnance_mix.z))
			continue
		if(!istype(get_area(ordnance_mix), /area/station/science))
			continue
		for(var/turf/nearby_turf as anything in get_adjacent_open_turfs(ordnance_mix))
			if(nearby_turf.is_blocked_turf())
				continue
			forceMove(nearby_turf)
			return

// BO start location
/obj/effect/landmark/start/bridge_officer
	name = "Bridge Officer"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "BridgeOfficer"

/obj/effect/landmark/start/bridge_officer/find_spot_to_place()
	var/area/station/command/bridge/bridge = locate() in GLOB.areas
	for(var/turf/open/open_turf in bridge?.get_turfs_from_all_zlevels())
		if(locate(/obj/structure/chair) in open_turf)
			forceMove(open_turf)
			return

// AP start location
/obj/effect/landmark/start/asset_protection
	name = "Asset Protection"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "AssetProtection"

/obj/effect/landmark/start/asset_protection/find_spot_to_place()
	var/area/station/command/bridge/bridge = locate() in GLOB.areas
	for(var/turf/open/open_turf in bridge?.get_turfs_from_all_zlevels())
		if(locate(/obj/structure/chair) in open_turf)
			forceMove(open_turf)
			return

// NA start location
/obj/effect/landmark/start/noble_ambassador
	name = "Noble Ambassador"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "NobleAmbassador"

/obj/effect/landmark/start/noble_ambassador/find_spot_to_place()
	var/area/station/command/bridge/bridge = locate() in GLOB.areas
	for(var/turf/open/open_turf in bridge?.get_turfs_from_all_zlevels())
		if(locate(/obj/structure/chair) in open_turf)
			forceMove(open_turf)
			return

// Global list for generic lockers
GLOBAL_LIST_EMPTY(locker_landmarks)

// Code for the custom job spawning lockers on maps w/o mapped lockers
/obj/effect/landmark/locker_spawner
	name = "A spawned locker"
	icon_state = "secequipment"
	var/spawn_anchored = FALSE
	var/spawned_path = /obj/structure/closet/secure_closet

/obj/effect/landmark/locker_spawner/Initialize(mapload)
	GLOB.locker_landmarks += src
	var/obj/structure/closet/secure_closet/spawned_locker = new spawned_path(drop_location())
	if(spawn_anchored)
		spawned_locker.set_anchored(TRUE)
	return ..()

/obj/effect/landmark/locker_spawner/Destroy()
	GLOB.locker_landmarks -= src
	return ..()

// Landmark for mapping in Bridge Officer equipment.
/obj/effect/landmark/locker_spawner/bridge_officer_equipment
	name = "bridge officer locker"
	spawned_path = /obj/structure/closet/secure_closet/bridge_officer

// Landmark for mapping in Asset Protection equipment.
/obj/effect/landmark/locker_spawner/asset_protection_equipment
	name = "asset protection locker"
	spawned_path = /obj/structure/closet/secure_closet/asset_protection

// Landmark for mapping in Noble Ambassador equipment.
/obj/effect/landmark/locker_spawner/noble_ambassador_equipment
	name = "noble ambassador locker"
	spawned_path = /obj/structure/closet/secure_closet/noble_ambassador
