#define NO_DISGUISE "(No Disguise)"

/datum/preference/choiced/synth_species
	savefile_key = "feature_synth_species"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_GENDER

/datum/preference/choiced/synth_species/init_possible_values()
	var/datum/species/synth/synth = new()
	. = synth.valid_species.Copy()
	. += NO_DISGUISE
	qdel(synth)
	return .

/datum/preference/choiced/synth_species/create_default_value()
	return SPECIES_HUMAN

/datum/preference/choiced/synth_species/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	if(value == NO_DISGUISE)
		synth.drop_disguise(target)
		return
	if(value in synth.valid_species)
		synth.disguise_as(target, GLOB.species_list[value])
		return

/datum/preference/numeric/synth_damage_threshold
	savefile_key = "feature_synth_damage_threshold"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_GENDER
	minimum = -100
	maximum = 75

/datum/preference/numeric/synth_damage_threshold/create_default_value()
	return 25

/datum/preference/numeric/synth_damage_threshold/apply_to_human(mob/living/carbon/human/target, value)
	var/datum/species/synth/synth = target.dna?.species
	if(!istype(synth))
		return
	synth.disuise_damage_threshold = value

#undef NO_DISGUISE
