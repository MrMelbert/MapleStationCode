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
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SECURITY
	associated_department = DEPARTMENT_COMMAND

//AP Office, possibly going unused? We're adding it anyway, fuck you
/area/station/command/ap_office
	name = "Asset Protection's Office"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "ap_office"

//Noble Ambassador's Office, currently unused
/area/station/command/noble_ambassador_office
	name = "Noble Ambassador's Office"
	icon = 'maplestation_modules/icons/turf/areas.dmi'
	icon_state = "na_office"

/area/station/service/hydroponics/park
	name = "Park"
	associated_department_flags = NONE
	associated_department = null

/area/station/service/bar/lower
	name = "Lower Bar"
	sound_environment = SOUND_AREA_WOODFLOOR

/area/station/science/robotics/abandoned
	name = "\improper Abandoned Robotics"
	icon_state = "abandoned_sci"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	associated_department_flags = NONE
	associated_department = null

/area/station/service/kitchen/abandoned
	name = "\improper Abandoned Kitchen"
	icon_state = "kitchen"
	sound_environment = SOUND_AREA_SMALL_ENCLOSED
	associated_department_flags = NONE
	associated_department = null

/area/station/maintenance/starboard/lower
	name = "Lower Starboard Maintenance"

/area/station/maintenance/port/lower
	name = "Lower Port Maintenance"

/area/station/maintenance/old_rec
	name = "\improper Abandoned Recreation Room"
	icon_state = "maint_dorms"
	sound_environment = SOUND_AREA_LARGE_ENCLOSED

/area/station/tcommsat/oldaisat/stationside
	name = "\improper Abandoned AI Satellite"

/area/station/cargo/break_room
	name = "\improper Cargo Break Room"
	sound_environment = SOUND_AREA_SMALL_SOFTFLOOR

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

/area/station
	/// All department flags that are associated with this department
	var/associated_department_flags = NONE
	/// The PRIMARY department this area may be located in
	var/associated_department

/area/station/security
	associated_department_flags = DEPARTMENT_BITFLAG_SECURITY
	associated_department = DEPARTMENT_SECURITY

/area/station/security/checkpoint/medical
	associated_department_flags = DEPARTMENT_BITFLAG_SECURITY|DEPARTMENT_BITFLAG_MEDICAL
	associated_department = DEPARTMENT_MEDICAL

/area/station/security/checkpoint/medical/medsci
	associated_department_flags = DEPARTMENT_BITFLAG_SECURITY|DEPARTMENT_BITFLAG_MEDICAL|DEPARTMENT_BITFLAG_SCIENCE

/area/station/security/checkpoint/science
	associated_department_flags = DEPARTMENT_BITFLAG_SECURITY|DEPARTMENT_BITFLAG_SCIENCE
	associated_department = DEPARTMENT_SCIENCE

/area/station/security/checkpoint/engineering
	associated_department_flags = DEPARTMENT_BITFLAG_SECURITY|DEPARTMENT_BITFLAG_ENGINEERING
	associated_department = DEPARTMENT_ENGINEERING

/area/station/security/checkpoint/supply
	associated_department_flags = DEPARTMENT_BITFLAG_SECURITY|DEPARTMENT_BITFLAG_COMMAND
	associated_department = DEPARTMENT_COMMAND

/area/station/medical
	associated_department_flags = DEPARTMENT_BITFLAG_MEDICAL
	associated_department = DEPARTMENT_MEDICAL

/area/station/medical/abandoned
	associated_department_flags = NONE
	associated_department = null

/area/station/science
	associated_department_flags = DEPARTMENT_BITFLAG_SCIENCE
	associated_department = DEPARTMENT_SCIENCE

/area/station/science/research/abandoned
	associated_department_flags = NONE
	associated_department = null

/area/station/service
	associated_department_flags = DEPARTMENT_BITFLAG_SERVICE
	associated_department = DEPARTMENT_SERVICE

/area/station/service/electronic_marketing_den
	associated_department_flags = NONE
	associated_department = null

/area/station/service/abandoned_gambling_den
	associated_department_flags = NONE
	associated_department = null

/area/station/service/abandoned_gambling_den/gaming
	associated_department_flags = NONE
	associated_department = null

/area/station/service/theater/abandoned
	associated_department_flags = NONE
	associated_department = null

/area/station/service/library/abandoned
	associated_department_flags = NONE
	associated_department = null

/area/station/service/hydroponics/garden/abandoned
	associated_department_flags = NONE
	associated_department = null

/area/station/engineering
	associated_department_flags = DEPARTMENT_BITFLAG_ENGINEERING
	associated_department = DEPARTMENT_ENGINEERING

/area/station/supply
	associated_department_flags = DEPARTMENT_BITFLAG_CARGO
	associated_department = DEPARTMENT_CARGO

/area/station/command
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND
	associated_department = DEPARTMENT_COMMAND

/area/station/command/heads_quarters/captain
	associated_department_flags = DEPARTMENT_BITFLAG_CAPTAIN

/area/station/command/heads_quarters/cmo
	associated_department = DEPARTMENT_MEDICAL

/area/station/command/heads_quarters/ce
	associated_department = DEPARTMENT_ENGINEERING

/area/station/command/heads_quarters/rd
	associated_department = DEPARTMENT_SCIENCE

/area/station/command/heads_quarters/hos
	associated_department = DEPARTMENT_SECURITY

/area/station/ai_monitored
	associated_department_flags = DEPARTMENT_BITFLAG_SILICON

/area/station/ai_monitored/command
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_COMMAND

/area/station/ai_monitored/security
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SECURITY
	associated_department = DEPARTMENT_BITFLAG_SECURITY

/area/station/ai_monitored/aisat
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_SILICON

/area/station/ai_monitored/turret_protected/ai
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_SILICON

/area/station/ai_monitored/turret_protected/aisat
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_SILICON

/area/station/ai_monitored/turret_protected/aisat_interior
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_SILICON

/area/station/ai_monitored/turret_protected/ai_upload
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_SILICON

/area/station/ai_monitored/turret_protected/ai_upload_foyer
	associated_department_flags = DEPARTMENT_BITFLAG_COMMAND|DEPARTMENT_BITFLAG_SILICON
	associated_department = DEPARTMENT_SILICON
