// -- Defines for player prefs --
/datum/preferences/update_preferences(current_version, savefile/S)
	. = ..()
	if (current_version < 41)
		write_preference(GLOB.preference_entries[/datum/preference/loadout], update_loadout_list(read_preference(/datum/preference/loadout)))
