/// -- Outfit and mob helpers to equip our loadout items. --

/// An empty outfit we fill in with our loadout items to dress our dummy.
/datum/outfit/player_loadout
	name = "Player Loadout"

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
	var/datum/outfit/equipped_outfit

	if(ispath(outfit))
		equipped_outfit = new outfit()
	else if(istype(outfit))
		equipped_outfit = outfit
	else
		CRASH("Outfit passed to equip_outfit_and_loadout was neither a path nor an instantiated type!")

	var/list/loadout_datums = loadout_list_to_datums(preference_source?.read_preference(/datum/preference/loadout))
	// Place any loadout items into the outfit before going forward
	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.insert_path_into_outfit(equipped_outfit, src, visuals_only)
	// Equip the outfit loadout items included
	equipOutfit(equipped_outfit, visuals_only)
	// Handle any snowflake on_equips
	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.on_equip_item(preference_source, src, visuals_only)
	// On_equips may have changed our style so run another update
	// Equip outfit does its own update body so it's a waste to do this every time
	if(length(loadout_datums))
		update_body()
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
	. = list()

	if(!length(GLOB.all_loadout_datums))
		CRASH("No loadout datums in the global loadout list!")

	for(var/path in loadout_list)
		if(!istype(GLOB.all_loadout_datums[path], /datum/loadout_item))
			stack_trace("Could not find ([path]) loadout item in the global list of loadout datums!")
			continue

		. |= GLOB.all_loadout_datums[path]

/**
 * Removes all invalid paths from loadout lists.
 * This is a general sanitization for preference saving / loading.
 *
 * passed_list - the loadout list we're sanitizing.
 *
 * returns a list, or null if empty
 */
/proc/sanitize_loadout_list(list/passed_list)
	var/list/list_to_clean = LAZYLISTDUPLICATE(passed_list)
	for(var/path in list_to_clean)
		if(!ispath(path))
			// stack_trace("invalid path found in loadout list! (Path: [path])")
			LAZYREMOVE(list_to_clean, path)

		else if(!istype(GLOB.all_loadout_datums[path], /datum/loadout_item))
			// stack_trace("invalid loadout item found in loadout list! Path: [path]")
			LAZYREMOVE(list_to_clean, path)

	return list_to_clean
