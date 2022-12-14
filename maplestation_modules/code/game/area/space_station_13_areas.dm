/// -- Modular areas, for ruins/modular maps/etc --
// Drone Bay Area
/area/station/engineering/atmos/control_center
	name = "Atmospherics Control Center"

/area/station/engineering/atmos/experiment_room
	name = "Atmospherics Experimentation Room"

//BO Office
/area/station/security/detectives_office/bridge_officer_office //This should inherient det offices ambient?
	name = "Bridge Officer's Office"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "bo_office"

//AP Office, possibly going unused? We're adding it anyway, fuck you
/area/station/command/ap_office
	name = "Asset Protection's Office"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "ap_office"

/area/station/service/hydroponics/park
	name = "Park"

/area/station/service/bar/lower
	name = "Lower Bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/science/robotics/abandoned
	name = "\improper Abandoned Robotics"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/service/kitchen/abandoned
	name = "\improper Abandoned Kitchen"
	icon_state = "kitchen"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED

/area/station/maintenance/starboard/lower
	name = "Lower Starboard Maintenance"
	icon_state = "smaint"

/area/station/maintenance/port/lower
	name = "Lower Port Maintenance"
	icon_state = "pmaint"

/area/station/tcommsat/oldaisat/stationside
	name = "\improper Abandoned AI Satellite"

//Berry Physics Space Ruin
/area/ruin/space/has_grav/powered/berry_physics
	name = "Berry Physics"
	icon_state = "red"

//NERVA Station
/area/ruin/space/has_grav/nerva
	name = "NERVA Beacon"
	icon_state = "green"

/area/station/solars/nerva
	name = "NERVA Beacon Solar Array"
	icon_state = "panelsP"

//Commons - Baseball
/area/station/commons/baseball
	name = "\improper Baseball Field"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "baseball"
	mood_bonus = 5
	mood_message = "<span class='nicegreen'>Nothing like coming to see a ball game!</span>\n"
	mood_trait = TRAIT_EXTROVERT

/area/station/commons/baseball/view
	name = "\improper Baseball Viewing Area"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "baseball_view"

/area/station/commons/baseball/locker
	name = "\improper Baseball Locker Room"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "baseball_locker"
