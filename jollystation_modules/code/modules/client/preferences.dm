// -- Defines for player prefs --
/datum/preferences
	/// Character preferences
	var/flavor_text = ""
	var/general_records = ""
	var/security_records = ""
	var/medical_records = ""
	var/exploitable_info = ""
	/// Loadout prefs. Assoc list of [typepaths] to [associated list of item info].
	var/list/loadout_list

/datum/preferences/load_character(slot)
	. = ..()
	if(!.)
		return

	READ_FILE(S["loadout_list"] , loadout_list)
	loadout_list = sanitize_loadout_list(loadout_list)

/datum/preferences/save_character()
	. = ..()
	if(!.)
		return

	WRITE_FILE(S["loadout_list"], loadout_list)

/datum/preferences/update_preferences(current_version, savefile/S)
	. = ..()
	if (current_version < 41)
		loadout_list = update_loadout_list(loadout_list)
