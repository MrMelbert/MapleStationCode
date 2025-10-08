//Subtype of human
/datum/species/human/felinid
	name = "Felinid"
	id = SPECIES_FELINE
	mutant_bodyparts = list("ears" = "Cat", "wings" = "None")
	mutantbrain = /obj/item/organ/internal/brain/felinid
	mutanttongue = /obj/item/organ/internal/tongue/cat
	mutantears = /obj/item/organ/internal/ears/cat
	mutantliver = /obj/item/organ/internal/liver/felinid
	external_organs = list(
		/obj/item/organ/external/tail/cat = "Cat",
	)
	inherent_traits = list(
		TRAIT_USES_SKINTONES,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	species_language_holder = /datum/language_holder/felinid
	payday_modifier = 1.0
	family_heirlooms = list(/obj/item/toy/cattoy)

/datum/species/human/felinid/on_species_gain(mob/living/carbon/carbon_being, datum/species/old_species, pref_load)
	if(carbon_being.dna.features["ears"] == "None")
		mutantears = /obj/item/organ/internal/ears
	return ..()

/datum/species/human/felinid/randomize_features(mob/living/carbon/human/human_mob)
	var/list/features = ..()
	features["ears"] = pick("None", "Cat")
	return features

/datum/species/human/felinid/prepare_human_for_preview(mob/living/carbon/human/human_for_preview)
	human_for_preview.set_haircolor("#ffcccc", update = FALSE) // pink
	human_for_preview.set_hairstyle("Hime Cut", update = TRUE)

	var/obj/item/organ/internal/ears/cat/cat_ears = human_for_preview.get_organ_by_type(/obj/item/organ/internal/ears/cat)
	if (cat_ears)
		cat_ears.color = human_for_preview.hair_color
		human_for_preview.update_body()

/datum/species/human/felinid/get_physical_attributes()
	return "Felinids are very similar to humans in almost all respects, with their biggest differences being the ability to lick their wounds, \
		and an increased sensitivity to noise, which is often detrimental. They are also rather fond of eating oranges."

/datum/species/human/felinid/get_species_description()
	return "Felinids are one of the many types of bespoke genetic \
		modifications to come of humanity's mastery of genetic science, and are \
		also one of the most common. Meow?"

/datum/species/human/felinid/get_species_lore()
	return list(
		"Bio-engineering at its felinest, Felinids are the peak example of humanity's mastery of genetic code. \
			One of many \"Animalid\" variants, Felinids are the most popular and common, as well as one of the \
			biggest points of contention in genetic-modification.",

		"Body modders were eager to splice human and feline DNA in search of the holy trifecta: ears, eyes, and tail. \
			These traits were in high demand, with the corresponding side effects of vocal and neurochemical changes being seen as a minor inconvenience.",

		"Sadly for the Felinids, they were not minor inconveniences. Shunned as subhuman and monstrous by many, Felinids (and other Animalids) \
			sought their greener pastures out in the colonies, cloistering in communities of their own kind. \
			As a result, outer Human space has a high Animalid population.",
	)

// Felinids are subtypes of humans.
// This shouldn't call parent or we'll get a buncha human related perks (though it doesn't have a reason to).
/datum/species/human/felinid/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = "grin-tongue",
			SPECIES_PERK_NAME = "Grooming",
			SPECIES_PERK_DESC = "Felinids can lick wounds to reduce bleeding.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_PERSON_FALLING,
			SPECIES_PERK_NAME = "Catlike Grace",
			SPECIES_PERK_DESC = "Felinids have catlike instincts allowing them to land upright on their feet.  \
				Instead of being knocked down from falling, you only recieve a short slowdown. \
				However, they do not have catlike legs, and the fall will deal additional damage.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "assistive-listening-systems",
			SPECIES_PERK_NAME = "Sensitive Hearing",
			SPECIES_PERK_DESC = "Felinids are more sensitive to loud sounds, such as flashbangs.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = "shower",
			SPECIES_PERK_NAME = "Hydrophobia",
			SPECIES_PERK_DESC = "Felinids don't like getting soaked with water.",
		),
	)

	return to_add
