// -- Synth Species preferences --
// This file is unticked because synths need more work before other species can be allowed.
/datum/preference/choiced/synth_species
	savefile_key = "synth_species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_NAMES // happens after species
	can_randomize = FALSE

/datum/preference/choiced/synth_species/is_accessible(datum/preferences/preferences)
	if (!..(preferences))
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/synth)

/datum/preference/choiced/synth_species/deserialize(input, datum/preferences/preferences)
	return sanitize_inlist(input, get_choices_serialized(), SPECIES_HUMAN)

/datum/preference/choiced/synth_species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/synth_species/init_possible_values()
	return list(SPECIES_HUMAN, SPECIES_LIZARD, SPECIES_SKRELL, SPECIES_FELINE, SPECIES_MOTH)

/datum/preference/choiced/synth_species/apply_to_human(mob/living/carbon/human/target, value)
	if(!istype(target.dna.species, /datum/species/synth))
		CRASH("applying synth species pref to a non-synth!")

	var/datum/species/synth/our_species = target.dna.species
	our_species.assume_disguise(new GLOB.species_list[value], target)
