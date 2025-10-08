// Prefernece for animid type
/datum/preference/choiced/animid_type
	savefile_key = "animid_type"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES

/datum/preference/choiced/animid_type/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["animid_type"] = value

/datum/preference/choiced/animid_type/init_possible_values()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	pass(animid) // linter thinks it's unused
	return assoc_to_keys(animid.animid_singletons)

/datum/preference/choiced/animid_type/is_accessible(datum/preferences/preferences)
	if(!..())
		return FALSE

	return ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/human/animid)

/datum/preference/choiced/animid_type/compile_constant_data()
	var/datum/species/human/animid/animid = GLOB.species_prototypes[__IMPLIED_TYPE__]
	pass(animid) // linter thinks it's unused

	var/list/data = list()
	data["animid_customization"] = list()
	for(var/animalid_id in animid.animid_singletons)
		var/datum/animalid_type/atype = animid.animid_singletons[animalid_id]

		data["animid_customization"][animalid_id] = list(
			"id" = animalid_id,
			"name" = atype.name,
			"icon" = atype.icon,
			"components" = all_readable_organ_types(atype),
			"pros" = atype.pros || list("No notable advantages"),
			"cons" = atype.cons || list("No notable disadvantages"),
			"neuts" = atype.neuts || list(),
		)
	return data

/datum/preference/choiced/animid_type/proc/all_readable_organ_types(datum/animalid_type/atype)
	var/list/names = list()
	for(var/organ_slot, organ_type_or_types in atype.components)
		names += readable_organ_type(organ_type_or_types)
	list_clear_nulls(names)
	return names

/datum/preference/choiced/animid_type/proc/readable_organ_type(organ_type_or_types)
	if(islist(organ_type_or_types))
		var/list/names = list()
		for(var/organ_type in organ_type_or_types)
			names += readable_organ_type(organ_type)
		return names

	if(ispath(organ_type_or_types, /datum/bodypart_overlay/simple/body_marking))
		return "Body markings"

	if(ispath(organ_type_or_types, /obj/item/organ))
		var/obj/item/organ/organ_type = organ_type_or_types
		if(!organ_type::bodypart_overlay)
			return null // internal organs that don't alter appearance
		return organ_type::name

	return null
