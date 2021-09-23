//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN 32

//This is the current version, anything below this will attempt to update (if it's not obsolete)
// You do not need to raise this if you are adding new values that have sane defaults.
// Only raise this value when changing the meaning/format/name/layout of an existing value
// where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX 41

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd=="/" is preferences, S.cd=="/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/savefile_needs_update(savefile/S)
	var/savefile_version
	READ_FILE(S["version"], savefile_version)

	if(savefile_version < SAVEFILE_VERSION_MIN)
		S.dir.Cut()
		return -2
	if(savefile_version < SAVEFILE_VERSION_MAX)
		return savefile_version
	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, savefile/S)
	if(current_version < 33)
		toggles |= SOUND_ENDOFROUND

	if(current_version < 34)
		write_preference(/datum/preference/toggle/auto_fit_viewport, TRUE)

	if(current_version < 35) //makes old keybinds compatible with #52040, sets the new default
		var/newkey = FALSE
		for(var/list/key in key_bindings)
			for(var/bind in key)
				if(bind == "quick_equipbelt")
					key -= "quick_equipbelt"
					key |= "quick_equip_belt"

				if(bind == "bag_equip")
					key -= "bag_equip"
					key |= "quick_equip_bag"

				if(bind == "quick_equip_suit_storage")
					newkey = TRUE
		if(!newkey && !key_bindings["ShiftQ"])
			key_bindings["ShiftQ"] = list("quick_equip_suit_storage")

	if(current_version < 36)
		if(key_bindings["ShiftQ"] == "quick_equip_suit_storage")
			key_bindings["ShiftQ"] = list("quick_equip_suit_storage")

	if(current_version < 37)
		if(read_preference(/datum/preference/numeric/fps) == 0)
			write_preference(GLOB.preference_entries[/datum/preference/numeric/fps], -1)

	if (current_version < 38)
		var/found_block_movement = FALSE

		for (var/list/key in key_bindings)
			for (var/bind in key)
				if (bind == "block_movement")
					found_block_movement = TRUE
					break
			if (found_block_movement)
				break

		if (!found_block_movement)
			LAZYADD(key_bindings["Ctrl"], "block_movement")

	if (current_version < 39)
		LAZYADD(key_bindings["F"], "toggle_combat_mode")
		LAZYADD(key_bindings["4"], "toggle_combat_mode")
	if (current_version < 40)
		LAZYADD(key_bindings["Space"], "hold_throw_mode")

	if (current_version < 41)
		migrate_preferences_to_tgui_prefs_menu()

/datum/preferences/proc/update_character(current_version, savefile/savefile)
	if (current_version < 41)
		migrate_character_to_tgui_prefs_menu()

/// checks through keybindings for outdated unbound keys and updates them
/datum/preferences/proc/check_keybindings()
	if(!parent)
		return
	var/list/binds_by_key = get_key_bindings_by_key(key_bindings)
	var/list/notadded = list()
	for (var/name in GLOB.keybindings_by_name)
		var/datum/keybinding/kb = GLOB.keybindings_by_name[name]
		if(kb.name in key_bindings)
			continue // key is unbound and or bound to something

		var/addedbind = FALSE
		key_bindings[kb.name] = list()

		if(parent.hotkeys)
			for(var/hotkeytobind in kb.hotkey_keys)
				if(!length(binds_by_key[hotkeytobind]) && hotkeytobind != "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					key_bindings[kb.name] |= hotkeytobind
					addedbind = TRUE
		else
			for(var/classickeytobind in kb.classic_keys)
				if(!length(binds_by_key[classickeytobind]) && classickeytobind != "Unbound") //Only bind to the key if nothing else is bound expect for Unbound
					key_bindings[kb.name] |= classickeytobind
					addedbind = TRUE

		if(!addedbind)
			notadded += kb
	save_preferences() //Save the players pref so that new keys that were set to Unbound as default are permanently stored
	if(length(notadded))
		addtimer(CALLBACK(src, .proc/announce_conflict, notadded), 5 SECONDS)

/datum/preferences/proc/announce_conflict(list/notadded)
	to_chat(parent, "<span class='warningplain'><b><u>Keybinding Conflict</u></b></span>\n\
					<span class='warningplain'><b>There are new <a href='?src=[REF(src)];open_keybindings=1'>keybindings</a> that default to keys you've already bound. The new ones will be unbound.</b></span>")
	for(var/item in notadded)
		var/datum/keybinding/conflicted = item
		to_chat(parent, span_danger("[conflicted.category]: [conflicted.full_name] needs updating"))


/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[ckey[1]]/[ckey]/[filename]"

/*
 * MELBERT TODO IN THIS PROC:
 *
 * load and sanitize hear_speech_sounds
 * load and sanitize hear_radio_sounds
 */
/datum/preferences/proc/load_preferences()
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2) //fatal, can't load any data
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if (fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(S, bacpath) //byond helpfully lets you use a savefile for the first arg.
		return FALSE

	apply_all_client_preferences()

	//general preferences
	READ_FILE(S["lastchangelog"], lastchangelog)

	READ_FILE(S["be_special"] , be_special)


	READ_FILE(S["default_slot"], default_slot)
	READ_FILE(S["chat_toggles"], chat_toggles)
	READ_FILE(S["toggles"], toggles)
	READ_FILE(S["ignoring"], ignoring)

	// OOC commendations
	READ_FILE(S["hearted_until"], hearted_until)
	if(hearted_until > world.realtime)
		hearted = TRUE
	//favorite outfits
	READ_FILE(S["favorite_outfits"], favorite_outfits)

	var/list/parsed_favs = list()
	for(var/typetext in favorite_outfits)
		var/datum/outfit/path = text2path(typetext)
		if(ispath(path)) //whatever typepath fails this check probably doesn't exist anymore
			parsed_favs += path
	favorite_outfits = uniqueList(parsed_favs)

	// Custom hotkeys
	READ_FILE(S["key_bindings"], key_bindings)

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		var/bacpath = "[path].updatebac" //todo: if the savefile version is higher then the server, check the backup, and give the player a prompt to load the backup
		if (fexists(bacpath))
			fdel(bacpath) //only keep 1 version of backup
		fcopy(S, bacpath) //byond helpfully lets you use a savefile for the first arg.
		update_preferences(needs_update, S) //needs_update = savefile_version if we need an update (positive integer)

	check_keybindings() // this apparently fails every time and overwrites any unloaded prefs with the default values, so don't load anything after this line or it won't actually save
	key_bindings_by_key = get_key_bindings_by_key(key_bindings)

	//Sanitize
	lastchangelog = sanitize_text(lastchangelog, initial(lastchangelog))
	default_slot = sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
	toggles = sanitize_integer(toggles, 0, (2**24)-1, initial(toggles))
	be_special = SANITIZE_LIST(be_special)
	key_bindings = sanitize_keybindings(key_bindings)
	favorite_outfits = SANITIZE_LIST(favorite_outfits)

	if(needs_update >= 0) //save the updated version
		var/old_default_slot = default_slot
		var/old_max_save_slots = max_save_slots

		for (var/slot in S.dir) //but first, update all current character slots.
			if (copytext(slot, 1, 10) != "character")
				continue
			var/slotnum = text2num(copytext(slot, 10))
			if (!slotnum)
				continue
			max_save_slots = max(max_save_slots, slotnum) //so we can still update byond member slots after they lose memeber status
			default_slot = slotnum
			if (load_character())
				save_character()
		default_slot = old_default_slot
		max_save_slots = old_max_save_slots
		save_preferences()

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX) //updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date

	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		if (preference.savefile_identifier != PREFERENCE_PLAYER)
			continue

		if (!(preference.type in recently_updated_keys))
			continue

		recently_updated_keys -= preference.type

		if (preference_type in value_cache)
			write_preference(preference, preference.serialize(value_cache[preference_type]))

	//general preferences
	WRITE_FILE(S["lastchangelog"], lastchangelog)
	WRITE_FILE(S["be_special"], be_special)
	WRITE_FILE(S["default_slot"], default_slot)
	WRITE_FILE(S["toggles"], toggles)
	WRITE_FILE(S["chat_toggles"], chat_toggles)
	WRITE_FILE(S["ignoring"], ignoring)
	WRITE_FILE(S["key_bindings"], key_bindings)
	WRITE_FILE(S["hearted_until"], (hearted_until > world.realtime ? hearted_until : null))
	WRITE_FILE(S["favorite_outfits"], favorite_outfits)
	return TRUE

/datum/preferences/proc/load_character(slot)
	SHOULD_NOT_SLEEP(TRUE)

	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE

	character_savefile = null

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		WRITE_FILE(S["default_slot"] , slot)

	S.cd = "/character[slot]"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2) //fatal, can't load any data
		return FALSE

<<<<<<< HEAD
	//Species
	var/species_id
	READ_FILE(S["species"], species_id)
	if(species_id)
		var/newtype = GLOB.species_list[species_id]
		if(newtype)
			pref_species = new newtype


	//Character
	READ_FILE(S["real_name"], real_name)
	READ_FILE(S["gender"], gender)
	READ_FILE(S["body_type"], body_type)
	READ_FILE(S["age"], age)
	READ_FILE(S["hair_color"], hair_color)
	READ_FILE(S["facial_hair_color"], facial_hair_color)
	READ_FILE(S["eye_color"], eye_color)
	READ_FILE(S["skin_tone"], skin_tone)
	READ_FILE(S["hairstyle_name"], hairstyle)
	READ_FILE(S["facial_style_name"], facial_hairstyle)
	READ_FILE(S["underwear"], underwear)
	READ_FILE(S["underwear_color"], underwear_color)
	READ_FILE(S["undershirt"], undershirt)
	READ_FILE(S["socks"], socks)
	READ_FILE(S["backpack"], backpack)
	READ_FILE(S["jumpsuit_style"], jumpsuit_style)
	READ_FILE(S["uplink_loc"], uplink_spawn_loc)
	READ_FILE(S["playtime_reward_cloak"], playtime_reward_cloak)
	READ_FILE(S["phobia"], phobia)
	READ_FILE(S["randomise"],  randomise)
	READ_FILE(S["feature_mcolor"], features["mcolor"])
	READ_FILE(S["feature_ethcolor"], features["ethcolor"])
	READ_FILE(S["feature_lizard_tail"], features["tail_lizard"])
	READ_FILE(S["feature_lizard_snout"], features["snout"])
	READ_FILE(S["feature_lizard_horns"], features["horns"])
	READ_FILE(S["feature_lizard_frills"], features["frills"])
	READ_FILE(S["feature_lizard_spines"], features["spines"])
	READ_FILE(S["feature_lizard_body_markings"], features["body_markings"])
	READ_FILE(S["feature_lizard_legs"], features["legs"])
	READ_FILE(S["feature_moth_wings"], features["moth_wings"])
	READ_FILE(S["feature_moth_antennae"], features["moth_antennae"])
	READ_FILE(S["feature_moth_markings"], features["moth_markings"])
	READ_FILE(S["persistent_scars"] , persistent_scars)

	// NON-MODULE CHANGES:
	READ_FILE(S["feature_head_tentacles"], features["head_tentacles"])
	READ_FILE(S["runechat_color"] , runechat_color)
	READ_FILE(S["flavor_text"] , flavor_text)
	READ_FILE(S["security_records"] , security_records)
	READ_FILE(S["medical_records"] , medical_records)
	READ_FILE(S["general_records"] , general_records)
	READ_FILE(S["exploitable_info"] , exploitable_info)
	READ_FILE(S["loadout_list"] , loadout_list)
	// NON-MODULE CHANGES END

	if(!CONFIG_GET(flag/join_with_mutant_humans))
		features["tail_human"] = "none"
		features["ears"] = "none"
	else
		READ_FILE(S["feature_human_tail"], features["tail_human"])
		READ_FILE(S["feature_human_ears"], features["ears"])

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		READ_FILE(S[savefile_slot_name], custom_names[custom_name_id])

	READ_FILE(S["preferred_ai_core_display"], preferred_ai_core_display)
	READ_FILE(S["prefered_security_department"], prefered_security_department)

	// This is the version when the random security department was removed.
	// When the minimum is higher than that version, it's impossible for someone to have the "Random" department.
	#if SAVEFILE_VERSION_MIN > 40
	#warn The prefered_security_department check in preferences_savefile.dm is no longer necessary.
	#endif

	if (!(prefered_security_department in GLOB.security_depts_prefs))
		prefered_security_department = SEC_DEPT_NONE

	//Jobs
	READ_FILE(S["joblessrole"], joblessrole)
=======
	// Read everything into cache
	for (var/preference_type in GLOB.preference_entries)
		var/datum/preference/preference = GLOB.preference_entries[preference_type]
		if (preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		value_cache -= preference_type
		read_preference(preference_type)

	//Character
	READ_FILE(S["randomise"],  randomise)
	READ_FILE(S["persistent_scars"] , persistent_scars)

>>>>>>> remotes/tg/master
	//Load prefs
	READ_FILE(S["job_preferences"], job_preferences)

	//Quirks
	READ_FILE(S["all_quirks"], all_quirks)

	//try to fix any outdated data if necessary
	//preference updating will handle saving the updated data for us.
	if(needs_update >= 0)
		update_character(needs_update, S) //needs_update == savefile_version if we need an update (positive integer)

	//Sanitize
<<<<<<< HEAD
	real_name = reject_bad_name(real_name)
	gender = sanitize_gender(gender)
	body_type = sanitize_gender(body_type, FALSE, FALSE, gender)
	if(!real_name)
		real_name = random_unique_name(gender)

	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/namedata = GLOB.preferences_custom_names[custom_name_id]
		custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
		if(!custom_names[custom_name_id])
			custom_names[custom_name_id] = get_default_name(custom_name_id)

	if(!features["mcolor"] || features["mcolor"] == "#000")
		features["mcolor"] = pick("FFFFFF","7F7F7F", "7FFF7F", "7F7FFF", "FF7F7F", "7FFFFF", "FF7FFF", "FFFF7F")

	if(!features["ethcolor"] || features["ethcolor"] == "#000")
		features["ethcolor"] = GLOB.color_list_ethereal[pick(GLOB.color_list_ethereal)]

	randomise = SANITIZE_LIST(randomise)

	hairstyle = sanitize_inlist(hairstyle, GLOB.hairstyles_list)
	facial_hairstyle = sanitize_inlist(facial_hairstyle, GLOB.facial_hairstyles_list)
	underwear = sanitize_inlist(underwear, GLOB.underwear_list)
	undershirt = sanitize_inlist(undershirt, GLOB.undershirt_list)
	socks = sanitize_inlist(socks, GLOB.socks_list)
	age = sanitize_integer(age, AGE_MIN, AGE_MAX, initial(age))
	hair_color = sanitize_hexcolor(hair_color, 3, 0)
	facial_hair_color = sanitize_hexcolor(facial_hair_color, 3, 0)
	underwear_color = sanitize_hexcolor(underwear_color, 3, 0)
	eye_color = sanitize_hexcolor(eye_color, 3, 0)
	skin_tone = sanitize_inlist(skin_tone, GLOB.skin_tones)
	backpack = sanitize_inlist(backpack, GLOB.backpacklist, initial(backpack))
	jumpsuit_style = sanitize_inlist(jumpsuit_style, GLOB.jumpsuitlist, initial(jumpsuit_style))
	uplink_spawn_loc = sanitize_inlist(uplink_spawn_loc, GLOB.uplink_spawn_loc_list_save, initial(uplink_spawn_loc))
	playtime_reward_cloak = sanitize_integer(playtime_reward_cloak)
	features["mcolor"] = sanitize_hexcolor(features["mcolor"], 3, 0)
	features["ethcolor"] = copytext_char(features["ethcolor"], 1, 7)
	features["tail_lizard"] = sanitize_inlist(features["tail_lizard"], GLOB.tails_list_lizard)
	features["tail_human"] = sanitize_inlist(features["tail_human"], GLOB.tails_list_human, "None")
	features["snout"] = sanitize_inlist(features["snout"], GLOB.snouts_list)
	features["horns"] = sanitize_inlist(features["horns"], GLOB.horns_list)
	features["ears"] = sanitize_inlist(features["ears"], GLOB.ears_list, "None")
	features["frills"] = sanitize_inlist(features["frills"], GLOB.frills_list)
	features["spines"] = sanitize_inlist(features["spines"], GLOB.spines_list)
	features["body_markings"] = sanitize_inlist(features["body_markings"], GLOB.body_markings_list)
	features["feature_lizard_legs"] = sanitize_inlist(features["legs"], GLOB.legs_list, "Normal Legs")
	features["moth_wings"] = sanitize_inlist(features["moth_wings"], GLOB.moth_wings_list, "Plain")
	features["moth_antennae"] = sanitize_inlist(features["moth_antennae"], GLOB.moth_antennae_list, "Plain")
	features["moth_markings"] = sanitize_inlist(features["moth_markings"], GLOB.moth_markings_list, "None")

	// NON-MODULE CHANGE: -- Pref Sanitization --
	//features["head_tentacles"] = sanitize_inlist(features["head_tentacles"], GLOB.head_tentacles_list, "Long")

	//runechat_color = sanitize_hexcolor(runechat_color)
	flavor_text = STRIP_HTML_SIMPLE(sanitize_text(flavor_text), MAX_MESSAGE_LEN)
	security_records = STRIP_HTML_SIMPLE(sanitize_text(security_records), MAX_FLAVOR_LEN)
	medical_records = STRIP_HTML_SIMPLE(sanitize_text(medical_records), MAX_FLAVOR_LEN)
	general_records = STRIP_HTML_SIMPLE(sanitize_text(general_records), MAX_FLAVOR_LEN)
	exploitable_info = STRIP_HTML_SIMPLE(sanitize_text(exploitable_info), MAX_FLAVOR_LEN)

	loadout_list = sanitize_loadout_list(update_loadout_list(loadout_list))
	// NON-MODULE CHANGE END

	persistent_scars = sanitize_integer(persistent_scars)

	joblessrole = sanitize_integer(joblessrole, 1, 3, initial(joblessrole))
=======
	randomise = SANITIZE_LIST(randomise)

	persistent_scars = sanitize_integer(persistent_scars)

>>>>>>> remotes/tg/master
	//Validate job prefs
	for(var/j in job_preferences)
		if(job_preferences[j] != JP_LOW && job_preferences[j] != JP_MEDIUM && job_preferences[j] != JP_HIGH)
			job_preferences -= j

	all_quirks = SSquirks.filter_invalid_quirks(SANITIZE_LIST(all_quirks), src) // NON-MODULE CHANGE
	validate_quirks()

	return TRUE

/datum/preferences/proc/save_character()
	SHOULD_NOT_SLEEP(TRUE)

	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/character[default_slot]"

<<<<<<< HEAD
	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX) //load_character will sanitize any bad data, so assume up-to-date.)

	//Character
	WRITE_FILE(S["real_name"] , real_name)
	WRITE_FILE(S["gender"] , gender)
	WRITE_FILE(S["body_type"] , body_type)
	WRITE_FILE(S["age"] , age)
	WRITE_FILE(S["hair_color"] , hair_color)
	WRITE_FILE(S["facial_hair_color"] , facial_hair_color)
	WRITE_FILE(S["eye_color"] , eye_color)
	WRITE_FILE(S["skin_tone"] , skin_tone)
	WRITE_FILE(S["hairstyle_name"] , hairstyle)
	WRITE_FILE(S["facial_style_name"] , facial_hairstyle)
	WRITE_FILE(S["underwear"] , underwear)
	WRITE_FILE(S["underwear_color"] , underwear_color)
	WRITE_FILE(S["undershirt"] , undershirt)
	WRITE_FILE(S["socks"] , socks)
	WRITE_FILE(S["backpack"] , backpack)
	WRITE_FILE(S["jumpsuit_style"] , jumpsuit_style)
	WRITE_FILE(S["uplink_loc"] , uplink_spawn_loc)
	WRITE_FILE(S["playtime_reward_cloak"] , playtime_reward_cloak)
	WRITE_FILE(S["randomise"] , randomise)
	WRITE_FILE(S["species"] , pref_species.id)
	WRITE_FILE(S["phobia"], phobia)
	WRITE_FILE(S["feature_mcolor"] , features["mcolor"])
	WRITE_FILE(S["feature_ethcolor"] , features["ethcolor"])
	WRITE_FILE(S["feature_lizard_tail"] , features["tail_lizard"])
	WRITE_FILE(S["feature_human_tail"] , features["tail_human"])
	WRITE_FILE(S["feature_lizard_snout"] , features["snout"])
	WRITE_FILE(S["feature_lizard_horns"] , features["horns"])
	WRITE_FILE(S["feature_human_ears"] , features["ears"])
	WRITE_FILE(S["feature_lizard_frills"] , features["frills"])
	WRITE_FILE(S["feature_lizard_spines"] , features["spines"])
	WRITE_FILE(S["feature_lizard_body_markings"] , features["body_markings"])
	WRITE_FILE(S["feature_lizard_legs"] , features["legs"])
	WRITE_FILE(S["feature_moth_wings"] , features["moth_wings"])
	WRITE_FILE(S["feature_moth_antennae"] , features["moth_antennae"])
	WRITE_FILE(S["feature_moth_markings"] , features["moth_markings"])
	WRITE_FILE(S["persistent_scars"] , persistent_scars)

	// NON-MODULE CHANGES:
	//WRITE_FILE(S["feature_head_tentacles"], features["head_tentacles"])
	//WRITE_FILE(S["runechat_color"] , runechat_color)
	WRITE_FILE(S["flavor_text"] , flavor_text)
	WRITE_FILE(S["general_records"] , general_records)
	WRITE_FILE(S["security_records"] , security_records)
	WRITE_FILE(S["medical_records"] , medical_records)
	WRITE_FILE(S["exploitable_info"] , exploitable_info)
	WRITE_FILE(S["loadout_list"], loadout_list)
	// NON-MODULE CHANGES END

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		WRITE_FILE(S[savefile_slot_name],custom_names[custom_name_id])

	WRITE_FILE(S["preferred_ai_core_display"] ,  preferred_ai_core_display)
	WRITE_FILE(S["prefered_security_department"] , prefered_security_department)

	//Jobs
	WRITE_FILE(S["joblessrole"] , joblessrole)
=======
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		if (!(preference.type in recently_updated_keys))
			continue

		recently_updated_keys -= preference.type

		if (preference.type in value_cache)
			write_preference(preference, preference.serialize(value_cache[preference.type]))

	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX) //load_character will sanitize any bad data, so assume up-to-date.)

	// This is the version when the random security department was removed.
	// When the minimum is higher than that version, it's impossible for someone to have the "Random" department.
	#if SAVEFILE_VERSION_MIN > 40
	#warn The prefered_security_department check in code/modules/client/preferences/security_department.dm is no longer necessary.
	#endif

	//Character
	WRITE_FILE(S["randomise"] , randomise)
	WRITE_FILE(S["persistent_scars"] , persistent_scars)

>>>>>>> remotes/tg/master
	//Write prefs
	WRITE_FILE(S["job_preferences"] , job_preferences)

	//Quirks
	WRITE_FILE(S["all_quirks"] , all_quirks)

	return TRUE

/proc/sanitize_keybindings(value)
	var/list/base_bindings = sanitize_islist(value,list())
	for(var/keybind_name in base_bindings)
		if (!(keybind_name in GLOB.keybindings_by_name))
			base_bindings -= keybind_name
	return base_bindings

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

#ifdef TESTING
//DEBUG
//Some crude tools for testing savefiles
//path is the savefile path
/client/verb/savefile_export(path as text)
	var/savefile/S = new /savefile(path)
	S.ExportText("/",file("[path].txt"))
//path is the savefile path
/client/verb/savefile_import(path as text)
	var/savefile/S = new /savefile(path)
	S.ImportText("/",file("[path].txt"))

#endif
