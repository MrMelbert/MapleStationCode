/turf/open/indestructible/redtech
	name = "redtech plating"
	desc = "Fairly smooth, redtech floor plating. Its strange construction seems to be currently inactive."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/turfs.dmi'
	icon_state = "offplating"
	footstep = FOOTSTEP_PLATING

/turf/open/indestructible/redtech/alt
	icon_state = "offplating_alt"

/turf/open/indestructible/redtech/altalt
	icon_state = "offplating_altalt"

/turf/closed/indestructible/redtech
	name = "redtech hull"
	desc = "A huge, impervious construction of redtech plating. It seems to be currently inactive."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/offwalls.dmi'
	icon_state = "redwalloff-0"
	base_icon_state = "redwalloff"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_WALLS
