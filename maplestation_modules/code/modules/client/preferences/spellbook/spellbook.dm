/// Spellbook preference entries are stored in a assoc list of (entry typepath -> list(strings, numbers) or null) where the list is parameters that will be
/// applied to the entry once the character spawns in.
/datum/preference/spellbook
	savefile_key = "spellbook"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	priority = PREFERENCE_PRIORITY_NAMES
	can_randomize = FALSE

/datum/preference/spellbook/apply_to_human(mob/living/carbon/human/target, value)
	if(!value || !islist(value)) //TODO: revisit
		return

	var/list/list_value = value
	for (var/datum/spellbook_item/entry in spellbook_list_to_datums(value))
		entry.apply(target, list_value[entry.type])

/datum/preference/spellbook/deserialize(input, datum/preferences/preferences)
	return sanitize_spellbook_list(input, preferences.parent?.mob)

/datum/preference/spellbook/serialize(input)
	return sanitize_spellbook_list(input)

// Default value is NULL - the spellbook list is a lazylist
/datum/preference/spellbook/create_default_value(datum/preferences/preferences)
	return null

/datum/preference/spellbook/is_valid(value)
	return isnull(value) || islist(value)
