// -- Lizardperson species additions --
/datum/species/lizard
	species_speech_sounds = list('jollystation_modules/sound/voice/lizard_1.ogg' = 80, \
						'jollystation_modules/sound/voice/lizard_2.ogg' = 80, \
						'jollystation_modules/sound/voice/lizard_3.ogg' = 80)
	species_speech_sounds_ask = list()
	species_speech_sounds_exclaim = list()

/datum/species/lizard/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	if(C.client?.prefs?.read_preference(/datum/preference/toggle/hair_lizard))
		species_traits |= HAIR
	. = ..()

/datum/species/lizard/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = sanitize_hexcolor(COLOR_DARK_LIME)
	// These 3 don't work and I don't know why or care
	human.dna.features["horns"] = "Simple"
	human.dna.features["frills"] = "Short"
	human.eye_color = COLOR_DARK_RED

	human.update_body()
	human.update_body_parts()
