/// -- Modular landmarks. --

// Global list for generic lockers
GLOBAL_LIST_EMPTY(locker_landmark)
/// Global list of all our bridge officer locker landmarks
GLOBAL_LIST_EMPTY(bridge_officer_lockers)
/// Global list of all our asset protection locker landmarks
GLOBAL_LIST_EMPTY(asset_protection_lockers)
/// Global list of all heretic sacrifice landmarks (contains all 4 subtypes of landmarks)
GLOBAL_LIST_EMPTY(heretic_sacrifice_landmarks)

// XB start location
/obj/effect/landmark/start/xenobiologist
	name = "Xenobiologist"
	icon = 'jollystation_modules/icons/mob/landmarks.dmi'
	icon_state = "Xenobiologist"

// Toxins start location
/obj/effect/landmark/start/toxicologist
	name = "Toxicologist"
	icon = 'jollystation_modules/icons/mob/landmarks.dmi'
	icon_state = "Toxicologist"

// BO start location
/obj/effect/landmark/start/bridge_officer
	name = "Bridge Officer"
	icon = 'jollystation_modules/icons/mob/landmarks.dmi'
	icon_state = "BridgeOfficer"

// AP start location
/obj/effect/landmark/start/asset_protection
	name = "Asset Protection"
	icon = 'jollystation_modules/icons/mob/landmarks.dmi'
	icon_state = "AssetProtection"

// Code for the custom job spawning lockers on maps w/o mapped lockers
/obj/effect/landmark/locker_spawner
	name = "A spawned locker"
	icon_state = "secequipment"
	var/spawn_anchored = FALSE
	var/spawned_path = /obj/structure/closet/secure_closet

/obj/effect/landmark/locker_spawner/Initialize(mapload)
	GLOB.locker_landmark += src
	var/obj/structure/closet/secure_closet/spawned_locker = new spawned_path(drop_location())
	if(spawn_anchored)
		spawned_locker.set_anchored(TRUE)
	return ..()

/obj/effect/landmark/locker_spawner/Destroy()
	GLOB.locker_landmark -= src
	return ..()

// Subtype that spawns anchored.
/obj/effect/landmark/locker_spawner/spawn_anchored
	spawn_anchored = TRUE

// Landmark for mapping in Bridge Officer equipment.
/obj/effect/landmark/locker_spawner/bridge_officer_equipment
	name = "bridge officer locker"
	spawned_path = /obj/structure/closet/secure_closet/bridge_officer

// Landmark for mapping in Asset Protection equipment.
/obj/effect/landmark/locker_spawner/asset_protection_equipment
	name = "asset protection locker"
	spawned_path = /obj/structure/closet/secure_closet/asset_protection

/obj/effect/landmark/heretic
	name = "heretic sacrifice landmark"
	icon_state = "x"

/obj/effect/landmark/heretic/Initialize()
	. = ..()
	GLOB.heretic_sacrifice_landmarks += src

/obj/effect/landmark/heretic/Destroy()
	GLOB.heretic_sacrifice_landmarks -= src
	return ..()

/obj/effect/landmark/heretic/ash
	name = "ash heretic sacrifice landmark"

/obj/effect/landmark/heretic/flesh
	name = "flesh heretic sacrifice landmark"

/obj/effect/landmark/heretic/void
	name = "void heretic sacrifice landmark"

/obj/effect/landmark/heretic/rust
	name = "rust heretic sacrifice landmark"
