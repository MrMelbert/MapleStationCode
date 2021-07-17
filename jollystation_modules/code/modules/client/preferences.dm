// -- Defines for player prefs --
/datum/preferences
	/// Character preferences
	var/flavor_text = ""
	var/general_records = ""
	var/security_records = ""
	var/medical_records = ""
	var/exploitable_info = ""
	var/runechat_color = "aaa"
	/// Loadout prefs. Assoc list of slot to typepath.
	var/list/loadout_list
	var/list/greyscale_loadout_list

	/// Client preferences
	var/hear_speech_sounds = TRUE
	var/hear_radio_sounds = TRUE

/datum/preferences/validate_quirks() // TODO: test
	. = ..()
	for(var/quirk in all_quirks)
		if(SSquirks.species_blacklist[quirk] && (pref_species.type in SSquirks.species_blacklist[quirk]))
			all_quirks -= quirk
			continue
		if(SSquirks.species_whitelist[quirk] && !(pref_species.type in SSquirks.species_whitelist[quirk]))
			all_quirks -= quirk
			continue
