/// -- Modular areas, for ruins/modular maps/etc --
// Drone Bay Area
/area/cargo/drone_boy
	name = "Drone Bay"
	icon_state = "cargo_warehouse"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/engineering/atmos/control_center
	name = "Atmospherics Control Center"

/area/engineering/atmos/experiment_room
	name = "Atmospherics Experimentation Room"

/area/security/detectives_office/bridge_officer_office //This should inherient det offices ambient?
	name = "Bridge Officer's Office"
	icon = 'jollystation_modules/icons/turf/areas.dmi'
	icon_state = "bo_office"

//Berry Physics Space Ruin
/area/ruin/space/has_grav/powered/berry_physics
	name = "Berry Physics"
	icon_state = "red"

//NERVA Station
/area/ruin/space/has_grav/nerva
	name = "NERVA Beacon"
	icon_state = "green"

/area/solars/nerva
	name = "NERVA Beacon Solar Array"
	icon_state = "panelsP"

// Rooms for where heretic sacrifices send people.
/area/heretic_sacrifice
	name = "Mansus"
	icon_state = "away"
	has_gravity = STANDARD_GRAVITY
	ambience_index = AMBIENCE_SPOOKY
	sound_environment = SOUND_ENVIRONMENT_CAVE
	area_flags = UNIQUE_AREA | NOTELEPORT | HIDDEN_AREA | BLOCK_SUICIDE

/area/heretic_sacrifice/Initialize(mapload)
	if(!ambientsounds)
		ambientsounds = GLOB.ambience_assoc[ambience_index]
		ambientsounds += 'sound/ambience/ambiatm1.ogg'
	. = ..()

/area/heretic_sacrifice/ash //also, default
	name = "Mansus Ash Gate"

/area/heretic_sacrifice/void
	name = "Mansus Void Gate"
	sound_environment = SOUND_ENVIRONMENT_UNDERWATER

/area/heretic_sacrifice/flesh
	name = "Mansus Flesh Gate"
	sound_environment = SOUND_ENVIRONMENT_STONEROOM

/area/heretic_sacrifice/rust
	name = "Mansus Rust Gate"
	ambience_index = AMBIENCE_REEBE
	sound_environment = SOUND_ENVIRONMENT_SEWER_PIPE
