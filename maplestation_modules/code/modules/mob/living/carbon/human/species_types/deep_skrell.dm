// -- Modular deep skrell species --
/// GLOB list of head tentacle sprites / options
GLOBAL_LIST_EMPTY(deep_skrell_head_tentacles_list)

// The datum for deep_skrell.
/datum/species/deep_skrell
	name = "Deep Skrell"
	plural_form = "Deep Skrellian"
	id = SPECIES_DEEP_SKRELL
	inherent_traits = list(TRAIT_MUTANT_COLORS, TRAIT_LIGHT_DRINKER, TRAIT_EMPATH, TRAIT_BADTOUCH, TRAIT_NIGHT_VISION)
	external_organs = list(/obj/item/organ/external/head_tentacles = "Long")
	payday_modifier = 0.75
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/skrell
	exotic_bloodtype = /datum/blood_type/crew/skrell
	species_pain_mod = 1.2


	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/skrell,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/skrell,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/deep_skrell,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/skrell,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/skrell,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/deep_skrell,
	)

	mutanteyes = /obj/item/organ/internal/eyes/deep_skrell
	mutanttongue = /obj/item/organ/internal/tongue/deep_skrell
	mutantbrain = /obj/item/organ/internal/brain/skrell
	mutantlungs = /obj/item/organ/internal/lungs/skrell
	mutantheart = /obj/item/organ/internal/heart/skrell
	mutantliver = /obj/item/organ/internal/liver/skrell

/datum/species/skrell/get_species_speech_sounds(sound_type)
	switch(sound_type)
		if(SOUND_QUESTION)
			return string_assoc_list(list('maplestation_modules/sound/voice/huff_ask.ogg' = 120))
		if(SOUND_EXCLAMATION)
			return string_assoc_list(list('maplestation_modules/sound/voice/huff_exclaim.ogg' = 120))
		else
			return string_assoc_list(list('maplestation_modules/sound/voice/huff.ogg' = 120))

/datum/species/deep_skrell/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	C.missing_eye_file = 'maplestation_modules/icons/mob/skrell_eyes.dmi'

/datum/species/deep_skrell/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	C.missing_eye_file = initial(C.missing_eye_file)
	return ..()

/datum/species/deep_skrell/get_species_description()
	return "deep_skrell are a semi-aquatic species hailing from tropical worlds."

/datum/species/deep_skrell/get_species_lore()
	return list("deep_skrell lore.")

/datum/species/deep_skrell/create_pref_unique_perks()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "wine-bottle",
		SPECIES_PERK_NAME = "Light Drinkers",
		SPECIES_PERK_DESC = "skrell naturally don't get along with alcohol \
			and find themselves getting inebriated very easily.",
	))
	return perks

/datum/species/deep_skrell/create_pref_blood_perks()
	var/list/perks = list()

	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "tint",
		SPECIES_PERK_NAME = "Exotic Blood",
		SPECIES_PERK_DESC = "The Skrell have a unique \"S\" type blood. Instead of \
			regaining blood from iron, they regenerate it from copper.",
	))

	return perks

/datum/species/deep_skrell/prepare_human_for_preview(mob/living/carbon/human/human)
	human.dna.features["mcolor"] = COLOR_GRAY
	human.update_body(is_creating = TRUE)

// Preset deep_skrell species
/mob/living/carbon/human/species/deep_skrell
	race = /datum/species/deep_skrell

// Organ for deep_skrell head tentacles.
/obj/item/organ/external/head_tentacles
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_HEAD_TENTACLES
	dna_block = DNA_HEAD_TENTACLES_BLOCK
	preference = "feature_head_tentacles"
	bodypart_overlay = /datum/bodypart_overlay/mutant/head_tentacles

/datum/bodypart_overlay/mutant/head_tentacles
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	feature_key = "head_tentacles"

/datum/bodypart_overlay/mutant/head_tentacles/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(istype(human.head) && (human.head.flags_inv & HIDEHAIR))
		return FALSE
	if(istype(human.wear_mask) && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE
	var/obj/item/bodypart/head/our_head = human.get_bodypart(BODY_ZONE_HEAD)
	if(!IS_ORGANIC_LIMB(our_head))
		return FALSE
	return TRUE

/datum/bodypart_overlay/mutant/head_tentacles/get_global_feature_list()
	return GLOB.head_tentacles_list

/obj/item/bodypart/arm/left/skrell
	limb_id = SPECIES_DEEP_SKRELL
	brute_modifier = 0.8
	burn_modifier = 1.5
	unarmed_attack_verb = "slash"
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
	icon_greyscale = 'maplestation_modules/icons/mob/skrell_parts_greyscale.dmi'

/obj/item/bodypart/arm/right/skrell
	limb_id = SPECIES_DEEP_SKRELL
	brute_modifier = 0.8
	burn_modifier = 1.5
	unarmed_attack_verb = "slash"
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'
	icon_greyscale = 'maplestation_modules/icons/mob/skrell_parts_greyscale.dmi'

/obj/item/bodypart/head/deep_skrell
	limb_id = SPECIES_DEEP_SKRELL
	brute_modifier = 0.8
	burn_modifier = 1.5
	icon_greyscale = 'maplestation_modules/icons/mob/skrell_parts_greyscale.dmi'
	head_flags = HEAD_LIPS|HEAD_EYESPRITES|HEAD_EYEHOLES|HEAD_DEBRAIN

/obj/item/bodypart/leg/left/skrell
	limb_id = SPECIES_DEEP_SKRELL
	brute_modifier = 0.8
	burn_modifier = 1.5
	icon_greyscale = 'maplestation_modules/icons/mob/skrell_parts_greyscale.dmi'

/obj/item/bodypart/leg/right/skrell
	limb_id = SPECIES_DEEP_SKRELL
	brute_modifier = 0.8
	burn_modifier = 1.5
	icon_greyscale = 'maplestation_modules/icons/mob/skrell_parts_greyscale.dmi'

/obj/item/bodypart/chest/deep_skrell
	limb_id = SPECIES_DEEP_SKRELL
	brute_modifier = 0.8
	burn_modifier = 1.
	is_dimorphic = 0
	icon_greyscale = 'maplestation_modules/icons/mob/skrell_parts_greyscale.dmi'

/obj/item/organ/internal/eyes/deep_skrell
	desc = "Gooey."
	eye_overlay_file = 'maplestation_modules/icons/mob/skrell_eyes.dmi'

/obj/item/organ/internal/brain/Skrell/on_mob_insert(mob/living/carbon/organ_owner, special)
	.=..()
	if(ishuman(organ_owner))
		return


	var/mob/living/carbon/human/human_owner = owner
	if (organ_owner.mob_mood)
		organ_owner.mob_mood.mood_modifier += 0.75

/obj/item/organ/internal/brain/Skrell/on_mob_remove(mob/living/carbon/organ_owner, special)
	.=..()
	if(ishuman(organ_owner) || QDELETED (organ_owner))
		return


	if (organ_owner.mob_mood)
		organ_owner.mob_mood.mood_modifier -= 0.75

/obj/item/organ/internal/liver/Skrell/on_mob_insert(mob/living/carbon/organ_owner, special)
	.=..()
	if(ishuman(organ_owner))
		return


	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.tox_mod *= 1.75

/obj/item/organ/internal/liver/Skrell/on_mob_remove(mob/living/carbon/organ_owner, special)
	.=..()
	if(ishuman(organ_owner) || QDELETED (organ_owner))
		return


	var/mob/living/carbon/human/human_owner = owner
	human_owner.physiology.tox_mod *= 0.75

/obj/item/organ/internal/eyes/deep_skrell
	name = "Deep Skrellian eyes"
	desc = "The four large eyes of a Deep Skrell."
	icon_state = "eyes_deep"
	icon = 'maplestation_modules/icons/mob/skrell_organs.dmi'
	visual = TRUE
	zone = BODY_ZONE_PRECISE_EYES
	slot = ORGAN_SLOT_EYES
	flash_protect = FLASH_PROTECTION_SENSITIVE
	tint = 1
