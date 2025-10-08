/datum/species/human/animid
	name = "Animid"
	id = SPECIES_ANIMALID
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	digitigrade_legs = list(
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/digitigrade/animal,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/digitigrade/animal,
	)
	/// A mapping of all animid ids to their singleton instances
	var/static/list/datum/animalid_type/animid_singletons

/datum/species/human/animid/New()
	. = ..()
	if(animid_singletons)
		return

	animid_singletons = list()
	for(var/datum/animalid_type/atype as anything in typesof(/datum/animalid_type))
		if(!atype::id)
			continue
		animid_singletons[atype::id] = new atype()

/datum/species/human/animid/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load)
	switch(human_who_gained_species.dna?.features["animid_skin_type"])
		if(SKIN_TYPE_FUR)
			inherent_traits |= TRAIT_MUTANT_COLORS
			inherent_traits -= TRAIT_USES_SKINTONES
			bodypart_overrides[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/furry
			bodypart_overrides[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/furry
			bodypart_overrides[BODY_ZONE_L_ARM] = /obj/item/bodypart/arm/left/furry
			bodypart_overrides[BODY_ZONE_R_ARM] = /obj/item/bodypart/arm/right/furry
			bodypart_overrides[BODY_ZONE_CHEST] = /obj/item/bodypart/chest/furry
			bodypart_overrides[BODY_ZONE_HEAD] = /obj/item/bodypart/head/furry
			digitigrade_legs[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/digitigrade/animal
			digitigrade_legs[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/digitigrade/animal
		if(SKIN_TYPE_SCALES)
			inherent_traits |= TRAIT_MUTANT_COLORS
			inherent_traits -= TRAIT_USES_SKINTONES
			bodypart_overrides[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/scaled
			bodypart_overrides[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/scaled
			bodypart_overrides[BODY_ZONE_L_ARM] = /obj/item/bodypart/arm/left/scaled
			bodypart_overrides[BODY_ZONE_R_ARM] = /obj/item/bodypart/arm/right/scaled
			bodypart_overrides[BODY_ZONE_CHEST] = /obj/item/bodypart/chest/scaled
			bodypart_overrides[BODY_ZONE_HEAD] = /obj/item/bodypart/head/scaled
			digitigrade_legs[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left/digitigrade/scaled
			digitigrade_legs[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right/digitigrade/scaled
		else
			inherent_traits |= TRAIT_USES_SKINTONES
			inherent_traits -= TRAIT_MUTANT_COLORS
			bodypart_overrides[BODY_ZONE_L_LEG] = /obj/item/bodypart/leg/left
			bodypart_overrides[BODY_ZONE_R_LEG] = /obj/item/bodypart/leg/right
			bodypart_overrides[BODY_ZONE_L_ARM] = /obj/item/bodypart/arm/left
			bodypart_overrides[BODY_ZONE_R_ARM] = /obj/item/bodypart/arm/right
			bodypart_overrides[BODY_ZONE_CHEST] = /obj/item/bodypart/chest
			bodypart_overrides[BODY_ZONE_HEAD] = /obj/item/bodypart/head
			digitigrade_legs.Cut()

	var/animid_id = human_who_gained_species.dna?.features["animid_type"] || pick(animid_singletons)
	for(var/organ_slot, organ_type_or_types in animid_singletons[animid_id].components)
		set_mutant_organ(organ_slot, organ_type_or_types)

	. = ..()
	// Call this anyways so we can update fur
	if(old_species.type == type)
		replace_body(human_who_gained_species, src)

/datum/species/human/animid/get_physical_attributes()
	return "Being a human hybrid, Animids are very similar to humans in almost all respects. \
		Depending on whichever animal DNA they were spliced with, they may have some \
		physical advantages or disadvantages, but nothing too extreme."

/datum/species/human/animid/get_species_description()
	return "Animids is a blanket term for a variety of genetic \
		modifications to come of humanity's mastery of genetic science. \
		These modifications involve splicing animal DNA into human DNA, \
		resulting in a humanoid with some animal traits."

/datum/species/human/animid/get_species_lore()
	return list(
		"For centuries, humans have been eager to splice their own DNA with animal DNA to create a more perfect lifeform: after all, \
			what could beat the fortitude of the human combined with the agility of a cat, the strength of a bear, or the sight of an eagle?",

		"Eventually, through decades upon decades of work, human bio-engineering progressed \
			to a point where such splices were not only possible, not only stable, but mass-applicable. \
			These new beings were dubbed \"Animids\", and were seen as a new step in human evolution - for a time.",

		"Following the honeymoon period, the general public soon grew wary of these new beings - \
			they were soon feared for a plethora of reasons, such as ethical grounds, over concerns of animal instincts taking over, \
			due to misuse by criminal elements, or simply an irrational prejudice against those who were different. \
			This growing distrust and agitation led many Animids to seek greener pastures out in the colonies, \
			where they could use their abilities to aid humanity's expansion into the stars without the threat of persecution.",

		"Many Animids grouped together into communities of their own kind, sometimes even forming their own settlements. \
			As a result, outer Human space has a high Animid population.",
	)

/datum/species/human/animid/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_DOG,
			SPECIES_PERK_NAME = "Animal Instincts",
			SPECIES_PERK_DESC = "Being part animal, Animids inherit many traits from their animal side. \
				These traits vary wildly depending on the animal DNA they were spliced with, \
				and often come with both advantages and disadvantages.",
		),
	)

	return to_add

/datum/species/human/animid/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.set_haircolor("#ffcccc", update = FALSE) // pink
	human_for_preview.set_hairstyle("Hime Cut", update = TRUE)

	var/obj/item/organ/internal/ears/cat/cat_ears = new()
	cat_ears.Insert(human_for_preview, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/species/human/animid/randomize_features()
	var/list/features = ..()
	features["animid_type"] = pick(animid_singletons)
	features["animid_skin_type"] = SKIN_TYPE_SKIN
	return features

/datum/species/human/animid/get_mut_organs()
	. = ..()
	for(var/animalid_id in animid_singletons)
		. += flatten_list(animid_singletons[animalid_id].components || list())
	for(var/list/sublist in .)
		. -= sublist
		. += assoc_to_keys(sublist)

/datum/species/human/animid/get_features()
	. = ..()
	. |= /datum/preference/color/mutant_color::savefile_key // mutant color for fur color, not always applied

/datum/species/proc/set_mutant_organ(organ_slot, organ_type_or_types)
	switch(organ_slot)
		if(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			bodypart_overrides[organ_slot] = organ_type_or_types
		if(ORGAN_SLOT_BRAIN)
			mutantbrain = organ_type_or_types
		if(ORGAN_SLOT_TONGUE)
			mutanttongue = organ_type_or_types
		if(ORGAN_SLOT_EARS)
			mutantears = organ_type_or_types
		if(ORGAN_SLOT_EYES)
			mutanteyes = organ_type_or_types
		if(ORGAN_SLOT_LIVER)
			mutantliver = organ_type_or_types
		if(ORGAN_SLOT_HEART)
			mutantheart = organ_type_or_types
		if(ORGAN_SLOT_LUNGS)
			mutantlungs = organ_type_or_types
		if(ORGAN_SLOT_STOMACH)
			mutantstomach = organ_type_or_types
		if(ORGAN_SLOT_APPENDIX)
			mutantappendix = organ_type_or_types
		if(MUTANT_ORGANS)
			mutant_organs |= organ_type_or_types
		if(BODY_MARKINGS)
			body_markings |= organ_type_or_types
