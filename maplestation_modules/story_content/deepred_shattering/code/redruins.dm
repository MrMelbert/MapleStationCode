/datum/map_template/ruin/space/spades_shattering
	id = "spades_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "spadesshattering.dmm"
	name = "Space-Ruin The Shattering Of Spades"
	description = "The wreckage of a redtech server room, now smeared across space and time."

	allow_duplicates = FALSE
	placement_weight = 4
	cost = 2

/datum/map_template/ruin/lavaland/diamonds_shattering
	id = "diamonds_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "diamondsshattering.dmm"
	name = "Lava-Ruin The Shattering Of Diamonds"
	description = "The wreckage of a redtech cargo hold, now smeared across space and time."

	allow_duplicates = FALSE
	placement_weight = 2
	cost = 2
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering)

/datum/map_template/ruin/lavaland/hearts_shattering
	id = "hearts_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "heartsshattering.dmm"
	name = "Lava-Ruin The Shattering Of Hearts"
	description = "The wreckage of a redtech Bunker Ring, now smeared across space and time."

	allow_duplicates = FALSE
	placement_weight = 2
	cost = 8
	never_spawn_with = list(/datum/map_template/ruin/lavaland/diamonds_shattering)
