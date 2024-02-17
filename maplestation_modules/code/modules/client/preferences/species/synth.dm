/datum/preference/choiced/synth_species
	savefile_key = "feature_synth_species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_GENDER

/datum/preference/choiced/synth_species/init_possible_values()
	var/datum/species/synth/synth = new()
	. = synth.valid_species.Copy()
	qdel(synth)
	return .

/datum/preference/choiced/synth_species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/synth_species/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	if(!(value in synth.valid_species))
		return

	synth.disguise_as(target, GLOB.species_list[value])
