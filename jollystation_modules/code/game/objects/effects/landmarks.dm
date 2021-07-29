/// -- Modular landmarks. --

/// Global list of all our bridge officer locker landmarks
GLOBAL_LIST_EMPTY(bridge_officer_lockers)
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
	icon_state = "Bridgeofficer"

// Landmark for mapping in Bridge Officer equipment.
// Use this in place of manually mapping it in - this allows us to track all Bridge Officer lockers in the world.
// We do this so we can detect if a map doesn't have a Bridge Officer locker, so we can allow the player to spawn one in manually.
/obj/effect/landmark/bridge_officer_equipment
	name = "bridge officer locker"
	icon_state = "secequipment"
	var/spawn_anchored = FALSE

/obj/effect/landmark/bridge_officer_equipment/Initialize(mapload)
	GLOB.bridge_officer_lockers += src
	var/obj/structure/closet/secure_closet/bridge_officer/spawned_locker = new(drop_location())
	if(spawn_anchored)
		spawned_locker.set_anchored(TRUE)
	return ..()

/obj/effect/landmark/bridge_officer_equipment/Destroy()
	GLOB.bridge_officer_lockers -= src
	return ..()

// Subtype that spawns anchored.
/obj/effect/landmark/bridge_officer_equipment/spawn_anchored
	spawn_anchored = TRUE

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
