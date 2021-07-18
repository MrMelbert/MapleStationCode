// -- Modular Skrell species --
/datum/species/skrell
	name = "Skrell"
	id = SPECIES_SKRELL
	default_color = "4B4B4B"
	species_traits = list(MUTCOLORS,EYECOLOR,LIPS,HAS_FLESH,HAS_BONE)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	mutant_bodyparts = list("skrell_headtentacles" = "Male")
	toxic_food = MEAT | RAW | DAIRY | TOXIC
	disliked_food = GROSS
	liked_food = VEGETABLES | FRUIT
	payday_modifier = 0.75
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/skrell
	inherent_traits = list(TRAIT_ADVANCEDTOOLUSER, TRAIT_LIGHT_DRINKER)
	say_mod = "warbles"
	exotic_bloodtype = "S"
	mutanttongue = /obj/item/organ/tongue/skrell
	species_speech_sounds = list('jollystation_modules/sound/voice/huff.ogg' = 120)
	species_speech_sounds_exclaim = list('jollystation_modules/sound/voice/huff_ask.ogg' = 120)
	species_speech_sounds_ask = list('jollystation_modules/sound/voice/huff_exclaim.ogg' = 120)
	species_pain_mod = 0.85
	limbs_id = "skrell"

//Adding their bloodbag here as well.
/obj/item/reagent_containers/blood/skrell
    blood_type = "S"

//Adding the Skrell tongue here for now, could use a sprite for it. This probably should be cleaned up if another race is ported.
/obj/item/organ/tongue/skrell
	name = "skrellian tongue"
	desc = "The source of the Skrellian people's warbling voice."
	say_mod = "warbles"
	var/static/list/languages_possible_skrell = typecacheof(list(
		/datum/language/common,
		/datum/language/uncommon,
		/datum/language/draconic,
		/datum/language/codespeak,
		/datum/language/monkey,
		/datum/language/narsie,
		/datum/language/beachbum,
		/datum/language/aphasia,
		/datum/language/piratespeak,
		/datum/language/moffic,
		/datum/language/sylvan,
		/datum/language/shadowtongue,
		/datum/language/terrum,
		/datum/language/nekomimetic,
		/datum/language/skrell
	))

/obj/item/organ/tongue/skrell/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_skrell

//Moving the copper -> blood for skrell into here.
/datum/reagent/copper/on_mob_life(mob/living/carbon/C)
	if((isSkrell(C)) && (C.blood_volume < BLOOD_VOLUME_NORMAL))
		C.blood_volume += 0.5
	..()
