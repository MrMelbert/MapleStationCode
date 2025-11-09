// Adds some modular languages to tongue languages
// also speech sounds
/obj/item/organ/tongue
	// Sounds weird BUT we need dummies to have their tongues for speech sound preview
	visual = TRUE

	/// Use speech sounds, if false, well, dont.
	var/speech_sounds_enabled = TRUE
	var/list/speech_sound_list = list(
		'goon/sound/voice/speak_1.ogg' = 120,
		'goon/sound/voice/speak_2.ogg' = 120,
		'goon/sound/voice/speak_3.ogg' = 120,
		'goon/sound/voice/speak_4.ogg' = 120,
	)
	var/list/speech_sound_list_question = list(
		'goon/sound/voice/speak_1_ask.ogg' = 120,
		'goon/sound/voice/speak_2_ask.ogg' = 120,
		'goon/sound/voice/speak_3_ask.ogg' = 120,
		'goon/sound/voice/speak_4_ask.ogg' = 120,
	)
	var/list/speech_sound_list_exclamation = list(
		'goon/sound/voice/speak_1_exclaim.ogg' = 120,
		'goon/sound/voice/speak_2_exclaim.ogg' = 120,
		'goon/sound/voice/speak_3_exclaim.ogg' = 120,
		'goon/sound/voice/speak_4_exclaim.ogg' = 120,
	)

/obj/item/organ/tongue/get_possible_languages()
	return ..() + list(
		/datum/language/isatoa,
		/datum/language/ratvarian,
		/datum/language/skrell,
		/datum/language/yangyu,
		/datum/language/kuiperian,
	)

// Skrell Tongue. Could use a sprite.
/obj/item/organ/tongue/high_skrell
	name = "High Skrellian tongue"
	desc = "The source of the High Skrellian people's warbling voice."
	say_mod = "warbles"
	languages_native = /datum/language/skrell
	liked_foodtypes = VEGETABLES | FRUIT | SUGAR
	disliked_foodtypes = FRIED | BUGS
	toxic_foodtypes = MEAT | RAW | DAIRY | GROSS | GORE | TOXIC

	speech_sound_list = list('maplestation_modules/sound/voice/huff.ogg' = 120)
	speech_sound_list_question = list('maplestation_modules/sound/voice/huff_ask.ogg' = 120)
	speech_sound_list_exclamation = list('maplestation_modules/sound/voice/huff_exclaim.ogg' = 120)

/obj/item/organ/tongue/high_skrell/get_possible_languages()
	return ..() + /datum/language/skrell

/obj/item/organ/tongue/deep_skrell
	name = "Deep Skrellian tongue"
	desc = "The source of the Deep Skrellian people's warbling voice."
	say_mod = "warbles"
	languages_native = /datum/language/skrell
	liked_foodtypes = MEAT | SEAFOOD | GORE | RAW | BUGS
	disliked_foodtypes = SUGAR | FRIED | NUTS
	toxic_foodtypes = FRUIT | TOXIC | DAIRY | GROSS

	speech_sound_list = list('maplestation_modules/sound/voice/huff.ogg' = 120)
	speech_sound_list_question = list('maplestation_modules/sound/voice/huff_ask.ogg' = 120)
	speech_sound_list_exclamation = list('maplestation_modules/sound/voice/huff_exclaim.ogg' = 120)

/obj/item/organ/tongue/deep_skrell/get_possible_languages()
	return ..() + /datum/language/skrell

/obj/item/organ/tongue/ornithid
	name = "avian tongue"
	desc = "A seemingly normal looking tongue which causes ones voice to caw. However that works."
	say_mod = "caws"
	liked_foodtypes = FRUIT | SEAFOOD | NUTS | BUGS // birds like dice(d) nuts. Also bugs.
	disliked_foodtypes = DAIRY | CLOTH | GROSS
	toxic_foodtypes = SUGAR // chocolate is toxic to birds.

// High Draconic for lizard tongues
/obj/item/organ/tongue/lizard
	languages_native = list(/datum/language/draconic, /datum/language/impdraconic)

/obj/item/organ/tongue/lizard/get_possible_languages()
	return ..() + /datum/language/impdraconic

/obj/item/organ/tongue/shadow
	name = "umbral tongue"
	desc = "A dark fleshy muscle mostly used to tell scary stories."
	color = "#333333" // too lazy to make a sprite? just color it!

	speech_sound_list = list('maplestation_modules/sound/voice/shad1.ogg' = 55, 'maplestation_modules/sound/voice/shad2.ogg' = 55)
	speech_sound_list_question = null // same as regular speech sounds
	speech_sound_list_exclamation = list('maplestation_modules/sound/voice/shad_exclaim.ogg' = 55)
