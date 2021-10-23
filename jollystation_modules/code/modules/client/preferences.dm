// -- Defines for player prefs --
/datum/preferences/update_preferences(current_version, savefile/S)
	. = ..()
	// Update old loadout lists to new loadout lists.
	if (current_version < 41)
		// We basically perform a read on /datum/preference/loadout without deserializing.
		// If the list is deserealized, the sanitization proc removes
		// all the values we want to update, defeating the point of trying to update.
		var/datum/preference/preference_entry = GLOB.preference_entries[/datum/preference/loadout]
		var/savefile/our_file = get_savefile_for_savefile_identifier(preference_entry.savefile_identifier)
		var/list/loadout_list

		if (!isnull(our_file))
			READ_FILE(our_file[preference_entry.savefile_key], loadout_list)

		if (LAZYLEN(loadout_list))
			write_preference(preference_entry, update_loadout_list(loadout_list))
