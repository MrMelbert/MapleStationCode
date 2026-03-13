/datum/map_template/ruin/space/spades_shattering
	id = "spades_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "spadesshattering.dmm"
	name = "Space-Ruin The Shattering Of Spades"
	description = "The wreckage of a redtech server room, now smeared across space and time."

	allow_duplicates = FALSE
	cost = 2

/datum/map_template/ruin/lavaland/diamonds_shattering
	id = "diamonds_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "diamondsshattering.dmm"
	name = "Lava-Ruin The Shattering Of Diamonds"
	description = "The wreckage of a redtech cargo hold, now smeared across space and time."

	allow_duplicates = FALSE
	cost = 2
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering, /datum/map_template/ruin/lavaland/genericengine, /datum/map_template/ruin/lavaland/genericheatsink, /datum/map_template/ruin/lavaland/genericculminationone, /datum/map_template/ruin/lavaland/genericautofactory)

/datum/map_template/ruin/lavaland/hearts_shattering
	id = "hearts_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "heartsshattering.dmm"
	name = "Lava-Ruin The Shattering Of Hearts"
	description = "The wreckage of the redtech Bunker Ring, now smeared across space and time."

	allow_duplicates = FALSE
	cost = 8
	never_spawn_with = list(/datum/map_template/ruin/lavaland/diamonds_shattering, /datum/map_template/ruin/lavaland/genericengine, /datum/map_template/ruin/lavaland/genericheatsink, /datum/map_template/ruin/lavaland/genericculminationone, /datum/map_template/ruin/lavaland/genericautofactory)

/datum/map_template/ruin/icemoon/clubs_shattering
	id = "clubs_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "clubsshattering.dmm"
	name = "Ice-Ruin The Shattering Of Clubs"
	description = "The wreckage of the redtech sensor array, now smeared across space and time."

	allow_duplicates = FALSE

/datum/map_template/ruin/lavaland/genericengine
	id = "engine_generic"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "genericengine.dmm"
	name = "Lava-Ruin Redtech Engine"
	description = "The wreckage of a redtech engine, now smeared across space and time."

	allow_duplicates = FALSE
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering, /datum/map_template/ruin/lavaland/diamonds_shattering, /datum/map_template/ruin/lavaland/genericheatsink, /datum/map_template/ruin/lavaland/genericculminationone, /datum/map_template/ruin/lavaland/genericautofactory)

/datum/map_template/ruin/lavaland/genericheatsink
	id = "heatsink_generic"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "genericheatsink.dmm"
	name = "Lava-Ruin Redtech Heatsink"
	description = "The wreckage of a redtech heatsink, now smeared across space and time."

	allow_duplicates = FALSE
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering, /datum/map_template/ruin/lavaland/diamonds_shattering, /datum/map_template/ruin/lavaland/genericengine, /datum/map_template/ruin/lavaland/genericculminationone, /datum/map_template/ruin/lavaland/genericautofactory)

/datum/map_template/ruin/lavaland/genericculminationone
	id = "culminationone_generic"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "genericculminationone.dmm"
	name = "Lava-Ruin Redtech Culmination One"
	description = "The first piece of the wreckage of the redtech Culmination, now smeared across space and time."

	allow_duplicates = FALSE
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering, /datum/map_template/ruin/lavaland/diamonds_shattering, /datum/map_template/ruin/lavaland/genericengine, /datum/map_template/ruin/lavaland/genericheatsink, /datum/map_template/ruin/lavaland/genericautofactory)

/datum/map_template/ruin/lavaland/genericautofactory
	id = "autofactory_generic"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "genericautofactory.dmm"
	name = "Lava-Ruin Redtech Auto Factory"
	description = "The wreckage of a redtech auto factory, now smeared across space and time."

	allow_duplicates = FALSE
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering, /datum/map_template/ruin/lavaland/diamonds_shattering, /datum/map_template/ruin/lavaland/genericengine, /datum/map_template/ruin/lavaland/genericheatsink, /datum/map_template/ruin/lavaland/genericculminationone)
