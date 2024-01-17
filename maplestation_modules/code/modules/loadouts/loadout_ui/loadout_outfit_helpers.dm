/// -- Outfit and mob helpers to equip our loadout items. --

/// An empty outfit we fill in with our loadout items to dress our dummy.
/datum/outfit/player_loadout
	name = "Player Loadout (Dont Select This)"

/**
 * Actually equip our mob with our job outfit and our loadout items.
 * Loadout items override the pre-existing item in the corresponding slot of the job outfit.
 * Some job items are preserved after being overridden - belt items, ear items, and glasses.
 * The rest of the slots, the items are overridden completely and deleted.
 *
 * Plasmamen are snowflaked to not have any envirosuit pieces removed just in case.
 * Their loadout items for those slots will be added to their backpack on spawn.
 *
 * outfit - the job outfit we're equipping
 * visuals_only - whether we call special equipped procs, or if we just look like we equipped it
 * preference_source - the preferences of the thing we're equipping
 */
/mob/living/carbon/human/proc/equip_outfit_and_loadout(datum/outfit/outfit, datum/preferences/preference_source, visuals_only = FALSE)
	if(isnull(outfit))
		return
	if(isnull(preference_source))
		return equipOutfit(outfit, visuals_only)

	var/datum/outfit/equipped_outfit

	if(ispath(outfit))
		equipped_outfit = new outfit()
	else if(istype(outfit))
		equipped_outfit = outfit
	else
		CRASH("Outfit passed to equip_outfit_and_loadout was neither a path nor an instantiated type!")

	var/list/preference_list = get_active_loadout(preference_source)
	var/list/loadout_datums = loadout_list_to_datums(preference_list)
	// Place any loadout items into the outfit before going forward
	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.insert_path_into_outfit(equipped_outfit, src, visuals_only)
	// Equip the outfit loadout items included
	if(!equipped_outfit.equip(src, visuals_only))
		return FALSE
	// Handle any snowflake on_equips
	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.on_equip_item(preference_source, src, visuals_only, preference_list)

	return TRUE

/**
 * Takes a list of paths (such as a loadout list)
 * and returns a list of their singleton loadout item datums
 *
 * loadout_list - the list being checked
 *
 * returns a list of singleton datums
 */
/proc/loadout_list_to_datums(list/loadout_list)
	RETURN_TYPE(/list)
	var/list/datums = list()

	if(!length(GLOB.all_loadout_datums))
		CRASH("No loadout datums in the global loadout list!")

	for(var/path in loadout_list)
		var/actual_datum = GLOB.all_loadout_datums[path]
		if(!istype(actual_datum, /datum/loadout_item))
			stack_trace("Could not find ([path]) loadout item in the global list of loadout datums!")
			continue

		datums += actual_datum

	return datums

/**
 * Gets the active loadout of the passed preference source.
 *
 * Returns a loadout lazylist
 */
/proc/get_active_loadout(datum/preferences/preferences)
	RETURN_TYPE(/list)
	var/slot = preferences.read_preference(/datum/preference/numeric/active_loadout)
	var/list/all_loadouts = preferences.read_preference(/datum/preference/loadout)
	if(slot > length(all_loadouts))
		return null
	return all_loadouts[slot]

/**
 * Calls update_preference on the passed preference datum with the passed loadout list
 */
/proc/update_loadout(datum/preferences/preferences, list/loadout_list)
	preferences.update_preference(GLOB.preference_entries[/datum/preference/loadout], get_updated_loadout_list(preferences, loadout_list))

/**
 * Calls write_preference on the passed preference datum with the passed loadout list
 */
/proc/save_loadout(datum/preferences/preferences, list/loadout_list)
	preferences.write_preference(GLOB.preference_entries[/datum/preference/loadout], get_updated_loadout_list(preferences, loadout_list))

/**
 * Returns a list of all loadouts belonging to the passed preference source,
 * and appends the passed loadout list to the proper index of the list.
 */
/proc/get_updated_loadout_list(datum/preferences/preferences, list/loadout_list)
	RETURN_TYPE(/list)
	var/slot = preferences.read_preference(/datum/preference/numeric/active_loadout)
	var/list/new_list = list()
	for(var/list/loadout in preferences.read_preference(/datum/preference/loadout))
		UNTYPED_LIST_ADD(new_list, loadout)
	while(length(new_list) < slot)
		new_list += null

	new_list[slot] = loadout_list
	return new_list
