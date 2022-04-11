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

	if(value)
		target.dna.species.species_traits |= HAIR
		target.update_hair()
	else
		target.dna.species.species_traits -= HAIR
		target.update_hair()

/* TODO: This doesn't work, make it work later but it's not that important

// Extending hairstyle and haircolor is_accessible procs.
// If the parent returned FALSE (due to HAIR not being in SPECIES TRAITS) but should show on the window,
// Then we check if they're a lizard with hairlizard enabled - if so then they're valid
// maybe this will work one day
/datum/preference/choiced/hairstyle/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!. && should_show_on_page(preferences.current_window))
		return (ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/lizard) && preferences.read_preference(/datum/preference/toggle/hair_lizard))

/datum/preference/color_legacy/hair_color/is_accessible(datum/preferences/preferences)
	. = ..()
	if (!. && should_show_on_page(preferences.current_window))
		return (ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/lizard) && preferences.read_preference(/datum/preference/toggle/hair_lizard))

*/
