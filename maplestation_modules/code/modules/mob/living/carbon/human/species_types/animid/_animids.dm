/datum/animalid_type
	/// Bespoke ID for this animalid type. Must be unique.
	var/id

	/// Organs and limbs applied with this animalid type
	var/list/components

	/// Used in the UI - name of this animalid type
	var/name
	/// Fontawesome icon for this animalid type
	var/icon = FA_ICON_QUESTION
	/// Used in the UI - pros of this animalid type
	var/list/pros
	/// Used in the UI - cons of this animalid type
	var/list/cons
	/// Used in the UI - neutral traits of this animalid type
	var/list/neuts

	/// Cached list of all feature keys this animid type uses
	VAR_FINAL/list/all_feature_keys

/// Called when a species of this animid type is applied to a human.
/datum/animalid_type/proc/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	return

/// Returns a list of strings representing features this animalid type has.
/datum/animalid_type/proc/get_feature_keys()
	if(all_feature_keys)
		return all_feature_keys

	all_feature_keys = list()
	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		if (is_applicable_to_preference(preference))
			all_feature_keys += preference.savefile_key

	all_feature_keys |= extra_feature_keys()
	return all_feature_keys

/// Any feature keys that you might want included regardless
/datum/animalid_type/proc/extra_feature_keys()
	return list()

/// Checks if the passed preference datum is applicable to this animid type.
/datum/animalid_type/proc/is_applicable_to_preference(datum/preference/preference)
	var/list/all_organs = get_organs()
	if(preference.relevant_external_organ && (preference.relevant_external_organ in all_organs))
		return TRUE
	if(preference.relevant_head_flag && ispath(components?[BODY_ZONE_HEAD], /obj/item/bodypart/head))
		var/obj/item/bodypart/head/head = components[BODY_ZONE_HEAD]
		if(preference.relevant_head_flag && head::head_flags)
			return TRUE
	if(preference.relevant_body_markings && (preference.relevant_body_markings in all_organs))
		return TRUE
	return FALSE

/// Flattens the components list, returning a list of all organs types used by this animid type.
/datum/animalid_type/proc/get_organs()
	var/list/all_organs = list()
	for(var/slot, input in components)
		all_organs |= (islist(input) ? assoc_to_keys(input) : input)

	return all_organs
