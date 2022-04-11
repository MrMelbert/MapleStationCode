/// -- Modular landmarks. --

// Global list for generic lockers
GLOBAL_LIST_EMPTY(locker_landmarks)

// XB start location
/obj/effect/landmark/start/xenobiologist
	name = "Xenobiologist"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "Xenobiologist"

// Toxins start location
/obj/effect/landmark/start/ordnance_tech
	name = "Ordnance Technician"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "Ordnance_Technician"

// BO start location
/obj/effect/landmark/start/bridge_officer
	name = "Bridge Officer"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "BridgeOfficer"

// AP start location
/obj/effect/landmark/start/asset_protection
	name = "Asset Protection"
	icon = 'maplestation_modules/icons/mob/landmarks.dmi'
	icon_state = "AssetProtection"

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
