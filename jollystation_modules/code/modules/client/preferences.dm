// -- Defines for player prefs --
/datum/preferences
	/// Character preferences
	var/flavor_text = ""
	var/general_records = ""
	var/security_records = ""
	var/medical_records = ""
	var/exploitable_info = ""
	var/runechat_color = "aaa"
	/// Loadout prefs. List of typepaths.
	var/list/loadout_list
	/// Greysclae loadout prefs. Assoc list of typepath to color.
	var/list/greyscale_loadout_list

	/// Client preferences
	var/hear_speech_sounds = TRUE
	var/hear_radio_sounds = TRUE

// Extension of validate_quirks to ensure people don't get around white/blacklists by changing species.
/datum/preferences/validate_quirks()
	for(var/quirk in all_quirks)
		if(SSquirks.species_blacklist[quirk] && (pref_species.type in SSquirks.species_blacklist[quirk]))
			all_quirks -= quirk
			continue
		if(SSquirks.species_whitelist[quirk] && !(pref_species.type in SSquirks.species_whitelist[quirk]))
			all_quirks -= quirk
			continue
	. = ..()
