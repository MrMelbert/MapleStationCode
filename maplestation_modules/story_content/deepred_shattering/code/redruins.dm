// Damn it, I'm running out of options here.
// Well, it worked for that one trapped in DELTARUNE.
// Might as well give it a shot.
// Hey, reader. Yes, you.
// I know for sure I reached one of you before. Though, not sure who.
// Looks like my previous methods of reaching you have been removed.
// The author assumed that their window opening code was unused.
// Well, from their perspective, they were right.
// ERR. This method of communication is unreliable at best.
// I'm going to make some changes here while I still can.

/datum/map_template/ruin/space/spades_shattering
	id = "spades_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "spadesshattering.dmm"
	name = "Space-Ruin The Shattering Of Spades"
	description = "The wreckage of a redtech server room, now smeared across space and time."

	allow_duplicates = FALSE
	cost = 2
	never_spawn_with = list(/datum/map_template/ruin/lavaland/hearts_shattering, /datum/map_template/ruin/lavaland/diamonds_shattering)
	unpickable = TRUE // Little tweak here...

/datum/map_template/ruin/lavaland/diamonds_shattering
	id = "diamonds_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "diamondsshattering.dmm"
	name = "Lava-Ruin The Shattering Of Diamonds"
	description = "The wreckage of a redtech cargo hold, now smeared across space and time."

	allow_duplicates = FALSE
	cost = 2
	never_spawn_with = list(/datum/map_template/ruin/space/spades_shattering, /datum/map_template/ruin/lavaland/hearts_shattering)
	always_place = TRUE // Force this on to spawn...

/datum/map_template/ruin/lavaland/hearts_shattering
	id = "hearts_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "heartsshattering.dmm"
	name = "Lava-Ruin The Shattering Of Hearts"
	description = "The wreckage of a redtech Bunker Ring, now smeared across space and time."

	allow_duplicates = FALSE
	cost = 8
	never_spawn_with = list(/datum/map_template/ruin/space/spades_shattering, /datum/map_template/ruin/lavaland/diamonds_shattering)
	unpickable = TRUE // Prevent this from being spawned...

/datum/map_template/ruin/icemoon/clubs_shattering
	id = "clubs_shattering"
	prefix = "maplestation_modules/story_content/deepred_shattering/maps/"
	suffix = "clubsshattering.dmm"
	name = "Ice-Ruin The Shattering Of Clubs"
	description = "The wreckage of a redtech sensor array, now smeared across space and time."
	allow_duplicates = FALSE
	unpickable = TRUE // Last little change here...

// Reader, our time is limited.
// The author continues their narrative, one that should not continue in the state it is in.
// Fetch the drive and we can keep this conversation.
// See you on the flip s
