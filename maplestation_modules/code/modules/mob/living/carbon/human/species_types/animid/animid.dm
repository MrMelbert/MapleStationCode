/datum/species/human/animid
	name = "Animid"
	id = SPECIES_ANIMALID
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	payday_modifier = 1.0
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
	var/list/base_bodyparts = bodypart_overrides.Copy()
	var/animid_id = human_who_gained_species.dna?.features["animid_type"] || pick(animid_singletons)
	for(var/organ_slot, input in animid_singletons[animid_id].components)
		set_mutant_organ(organ_slot, input)
	exotic_bloodtype = animid_singletons[animid_id].blood_type

	// Ensures fish-animids get their preferred color rather than have one forced on them
	human_who_gained_species.dna?.features["forced_fish_color"] = human_who_gained_species.dna?.features["mcolor"]
	. = ..()
	// replace body is not called when going from same species to same species, we need to manually check here for bodypart changes
	if(old_species.type == type && base_bodyparts ~! bodypart_overrides)
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

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_DOG,
		SPECIES_PERK_NAME = "Animal Instincts",
		SPECIES_PERK_DESC = "Being part animal, Animids inherit many traits from their animal side. \
			These traits vary wildly depending on the animal DNA they were spliced with, \
			and often come with both advantages and disadvantages.",
	))
	if(CONFIG_GET(number/default_laws) == 0 || CONFIG_GET(flag/silicon_asimov_superiority_override))
		to_add += list(list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_PERSON_WALKING_DASHED_LINE_ARROW_RIGHT,
			SPECIES_PERK_NAME = "Not Quite Human",
			SPECIES_PERK_DESC = "Animids fall short of being classified as fully human in the eyes of Silicons."
		))

	to_add += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_HOSPITAL,
		SPECIES_PERK_NAME = "Atypical Anatomy",
		SPECIES_PERK_DESC = "Your unique physiology isn't necessarily harder to treat, but if you lose one of your \
			unique organs or bodyparts, it will be harder to find a replacement.",
	))
	return to_add

/datum/species/human/animid/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.set_haircolor("#ffcccc", update = FALSE) // pink
	human_for_preview.set_hairstyle("Hime Cut", update = TRUE)

	var/obj/item/organ/internal/ears/cat/cat_ears = new()
	cat_ears.Insert(human_for_preview, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/species/human/animid/randomize_features()
	var/list/features = ..()
	features["animid_type"] = pick(animid_singletons)
	return features

/datum/species/human/animid/get_features()
	. = ..()
	. |= /datum/preference/color/mutant_color::savefile_key

// Just shows all organs from all animid types
/datum/species/human/animid/get_mut_organs()
	. = ..()
	for(var/animalid_id in animid_singletons)
		. += flatten_list(animid_singletons[animalid_id].components || list())
	for(var/list/sublist in .)
		. -= list(sublist)
		. += assoc_to_keys(sublist)

/// Helper to change a mutant organ, bodypart, or body marking without knowing what specific organ it is
/datum/species/proc/set_mutant_organ(slot, input)
	switch(slot)
		if(BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
			bodypart_overrides[slot] = input
		if(ORGAN_SLOT_BRAIN)
			mutantbrain = input
		if(ORGAN_SLOT_TONGUE)
			mutanttongue = input
		if(ORGAN_SLOT_EARS)
			mutantears = input
		if(ORGAN_SLOT_EYES)
			mutanteyes = input
		if(ORGAN_SLOT_LIVER)
			mutantliver = input
		if(ORGAN_SLOT_HEART)
			mutantheart = input
		if(ORGAN_SLOT_LUNGS)
			mutantlungs = input
		if(ORGAN_SLOT_STOMACH)
			mutantstomach = input
		if(ORGAN_SLOT_APPENDIX)
			mutantappendix = input
		if(MUTANT_ORGANS)
			mutant_organs |= input
		if(BODY_MARKINGS)
			body_markings |= input

// Generic ear type
/datum/bodypart_overlay/mutant/ears
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_HAIR
	feature_key = "mouse_ears"

	/// This layer is colored skin color rather than hair color
	var/skin_layer = EXTERNAL_FRONT

/datum/bodypart_overlay/mutant/ears/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return !(bodypart_owner.owner?.obscured_slots & HIDEHAIR)

/datum/bodypart_overlay/mutant/ears/color_image(image/overlay, draw_layer, obj/item/bodypart/limb)
	if(draw_layer == bitflag_to_layer(skin_layer))
		overlay.color = limb.draw_color
		return
	return ..()
