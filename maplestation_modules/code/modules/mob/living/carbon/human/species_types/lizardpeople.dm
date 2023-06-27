// -- Lizardperson species additions --
/datum/species/lizard

/datum/species/lizard/get_species_speech_sounds(sound_type)
	// These sounds have been ported from Goonstation.
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/lizard_1.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_2.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_3.ogg' = 80,
	))

// adds hair to the lizards.
/datum/species/lizard/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	if(C.client?.prefs?.read_preference(/datum/preference/toggle/hair_lizard))
		species_traits |= HAIR
	return ..()

/datum/species/lizard/prepare_human_for_preview(mob/living/carbon/human/human) // this is used to generate the previews in the species menu of the prefs tab.
	human.dna.features["mcolor"] = COLOR_DARK_LIME

	var/obj/item/organ/external/frills/frills = human.get_organ_by_type(/obj/item/organ/external/frills)
	frills?.bodypart_overlay.set_appearance_from_name("Short")

	var/obj/item/organ/external/horns/horns = human.get_organ_by_type(/obj/item/organ/external/horns)
	horns?.bodypart_overlay.set_appearance_from_name("Simple")

	human.update_body(is_creating = TRUE)
