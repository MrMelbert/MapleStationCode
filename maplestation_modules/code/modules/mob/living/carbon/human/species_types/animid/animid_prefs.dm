// Prefernece for animid type
/datum/preference/choiced/animid_type
	savefile_key = "animid_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/animid_type/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["animid_type"] = value

/datum/preference/choiced/animid_type/init_possible_values()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	pass(animid) // linter trips up on static accesses
	return assoc_to_keys(animid.animid_singletons)

/datum/preference/choiced/animid_type/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)

/datum/preference/choiced/animid_type/compile_constant_data()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	var/list/data = list()
	data["animid_customization"] = list()
	for(var/animalid_id in animid.animid_singletons)
		var/datum/animalid_type/atype = animid.animid_singletons[animalid_id]

		data["animid_customization"][animalid_id] = list(
			"id" = animalid_id,
			"name" = atype.name,
			"icon" = atype.icon,
			"components" = atype.get_readable_features(),
			"pros" = atype.pros || list("No notable advantages"),
			"cons" = atype.cons || list("No notable disadvantages"),
			"neuts" = atype.neuts || list(),
			"diet" = animid.get_diet_from_tongue(atype.components[ORGAN_SLOT_TONGUE] || animid.mutanttongue),
		)
	return data
