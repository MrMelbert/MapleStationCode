// -- Lizardperson species additions --
/datum/species/lizard
	species_speech_sounds = list(
		'maplestation_modules/sound/voice/lizard_1.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_2.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_3.ogg' = 80,
	)
	species_speech_sounds_ask = list()
	species_speech_sounds_exclaim = list()

// adds hair to the lizards.
/datum/species/lizard/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	if(C.client?.prefs?.read_preference(/datum/preference/toggle/hair_lizard))
		species_traits |= HAIR
	. = ..()

/datum/species/lizard/prepare_human_for_preview(mob/living/carbon/human/human) // this is used to generate the previews in the species menu of the prefs tab.
	human.dna.features["mcolor"] = COLOR_DARK_LIME

	var/obj/item/organ/external/frills/frills = human.getorgan(/obj/item/organ/external/frills)
	frills?.set_sprite("Short") //Update this! this causes an error! "frills?." is no longer used/got repathed

	var/obj/item/organ/external/horns/horns = human.getorgan(/obj/item/organ/external/horns)
	horns?.set_sprite("Simple") //Update this! this also causes an error! "horns?." is no longer used.

	human.update_body(is_creating = TRUE)
