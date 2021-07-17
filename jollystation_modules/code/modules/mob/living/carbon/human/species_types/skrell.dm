// -- Modular Skrell species --
// The datum for Skrell.
/datum/species/skrell
	name = "Skrell"
	id = SPECIES_SKRELL
	default_color = "4B4B4B"
	species_traits = list(MUTCOLORS, EYECOLOR, LIPS, HAS_FLESH, HAS_BONE)
	external_organs = list(/obj/item/organ/external/head_tentacles = "Short")
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

// Preset Skrell species
/mob/living/carbon/human/species/skrell
	race = /datum/species/skrell

// Skrell bloodbag, for S type blood
/obj/item/reagent_containers/blood/skrell
	blood_type = "S"

// Skrell Tongue. Could use a sprite.
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

// Copper restores blood for Skrell instead of iron.
/datum/reagent/copper/on_mob_life(mob/living/carbon/C, delta_time)
	if((isskrell(C)) && (C.blood_volume < BLOOD_VOLUME_NORMAL))
		C.blood_volume += 0.5 * delta_time
	..()

// Organ for Skrell head tentacles.
/obj/item/organ/external/head_tentacles
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEAD_TENTACLES
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	dna_block = DNA_HEAD_TENTACLES_BLOCK
	preference = "head_tentacles"

/obj/item/organ/external/head_tentacles/can_draw_on_bodypart(mob/living/carbon/human/human)
	. = TRUE
	if(human.head?.flags_inv & HIDEHAIR)
		. = FALSE
	if(human.wear_mask?.flags_inv & HIDEHAIR)
		. = FALSE
	var/obj/item/bodypart/head/our_head = human.get_bodypart(BODY_ZONE_HEAD)
	if(our_head?.status == BODYPART_ROBOTIC)
		. = FALSE

/obj/item/organ/external/head_tentacles/get_global_feature_list()
	return GLOB.head_tentacles_list
