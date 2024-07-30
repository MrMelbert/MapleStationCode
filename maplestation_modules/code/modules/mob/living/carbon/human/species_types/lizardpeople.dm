// -- Lizardperson species additions --
/datum/species/lizard
	mutantliver = /obj/item/organ/internal/liver/lizard

/datum/species/lizard/get_species_speech_sounds(sound_type)
	// These sounds have been ported from Goonstation.
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/lizard_1.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_2.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_3.ogg' = 80,
	))

/datum/species/lizard/replace_body(mob/living/carbon/target, datum/species/new_species)
	. = ..()
	if(target.dna?.features["lizard_has_hair"])
		var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
		head.head_flags |= (HEAD_HAIR|HEAD_FACIAL_HAIR)

/datum/species/lizard/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = COLOR_DARK_LIME

	var/obj/item/organ/external/frills/frills = human.get_organ_by_type(/obj/item/organ/external/frills)
	frills?.bodypart_overlay.set_appearance_from_name("Short")

	var/obj/item/organ/external/horns/horns = human.get_organ_by_type(/obj/item/organ/external/horns)
	horns?.bodypart_overlay.set_appearance_from_name("Simple")

	human.update_body(is_creating = TRUE)

// Same for the small ones
/datum/species/monkey/lizard/get_species_speech_sounds(sound_type)
	// These sounds have been ported from Goonstation.
	return string_assoc_list(list(
		'maplestation_modules/sound/voice/lizard_1.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_2.ogg' = 80,
		'maplestation_modules/sound/voice/lizard_3.ogg' = 80,
	))
