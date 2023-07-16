/datum/preference/toggle/hair_lizard
	savefile_key = "hair_lizard"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_NAMES
	can_randomize = FALSE
	default_value = FALSE

/datum/preference/toggle/hair_lizard/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/preference/toggle/hair_lizard/apply_to_human(mob/living/carbon/human/target, value)
	if(!islizard(target))
		return

	// Adding directly here is primarily so the dummy updates
	if(value)
		target.dna.species.species_traits |= HAIR
	else
		target.dna.species.species_traits -= HAIR

	// Hate using dna features but it's really convenient to stick things
	// No I'm not adding it to genetics, don't even ask
	target.dna.features["lizard_has_hair"] = value
	target.update_body_parts()

// Hair appears as a "feature", even if not visible to lizards that do not have the trait selected
/datum/species/lizard/get_features()
	species_traits |= HAIR
	. = ..()
	species_traits -= HAIR
