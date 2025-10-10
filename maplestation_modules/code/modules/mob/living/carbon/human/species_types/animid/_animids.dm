/datum/animalid_type
	/// Bespoke ID for this animalid type. Must be unique.
	var/id

	/// Organs and limbs applied with this animalid type
	var/list/components = list()

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
	if(preference.relevant_external_organ && (preference.relevant_external_organ in get_organs()))
		return TRUE
	if(preference.relevant_head_flag)
		// if there's no animid specific head, use whatever is set by default, so we still have something to check for head flags
		var/obj/item/bodypart/head/head = components[BODY_ZONE_HEAD] || GLOB.species_prototypes[/datum/species/human/animid].bodypart_overrides[BODY_ZONE_HEAD]
		if(preference.relevant_head_flag && head::head_flags)
			return TRUE
	if(preference.relevant_body_markings && (preference.relevant_body_markings in components[BODY_MARKINGS]))
		return TRUE
	return FALSE

/// Gets only organ typepaths in the components list
/datum/animalid_type/proc/get_organs()
	var/list/all_organs = list()
	for(var/slot, input in components)
		if(ispath(input, /obj/item/organ))
			all_organs |= input

		else if(islist(input))
			for(var/sub_input in input)
				if(ispath(sub_input, /obj/item/organ))
					all_organs |= sub_input

	return all_organs

/// Returns a list of human-readable names for the features this animid type has.
/datum/animalid_type/proc/get_readable_features()
	var/list/names = list()
	for(var/organ_slot, organ_type_or_types in components)
		names += readable_organ_type(organ_type_or_types)
	list_clear_nulls(names)
	return names

/// Used in construction of the animid type preference UI
/datum/animalid_type/proc/readable_organ_type(organ_type_or_types)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(islist(organ_type_or_types))
		var/list/names = list()
		for(var/organ_type in organ_type_or_types)
			names += readable_organ_type(organ_type)
		return names

	if(ispath(organ_type_or_types, /datum/bodypart_overlay/simple/body_marking))
		return "Body markings"

	if(ispath(organ_type_or_types, /obj/item/organ))
		var/obj/item/organ/organ_type = organ_type_or_types
		if(organ_type::bodypart_overlay)
			return organ_type::name

	return null
