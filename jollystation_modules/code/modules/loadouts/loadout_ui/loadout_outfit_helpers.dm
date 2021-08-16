/// -- Outfit and mob helpers to equip our loadout items. --

/// An empty outfit we fill in with our loadout items to dress our dummy.
/datum/outfit/player_loadout
	name = "Player Loadout"

/* Actually equip our mob with our job outfit and our loadout items.
 * Loadout items override the pre-existing item in the corresponding slot of the job outfit.
 * Some job items are preserved after being overridden - belt items, ear items, and glasses.
 * The rest of the slots, the items are overridden completely and deleted.
 *
 * Plasmamen are snowflaked to not have any envirosuit pieces removed just in case.
 * Their loadout items for those slots will be added to their backpack on spawn.
 *
 * outfit - the job outfit we're equipping
 * visuals_only - whether we call special equipped procs, or if we just look like we equipped it
 * preference_source - the client belonging to the thing we're equipping
 */
/mob/living/carbon/human/proc/equip_outfit_and_loadout(datum/outfit/outfit, visuals_only = FALSE, datum/preferences/preference_source)
	var/datum/outfit/equipped_outfit

	if(ispath(outfit))
		equipped_outfit = new outfit()
	else if(istype(outfit))
		equipped_outfit = outfit
	else
		CRASH("Outfit passed to equip_outfit_and_loadout was neither a path nor an instantiated type!")

	var/list/loadout_datums = list()
	for(var/path in preference_source.loadout_list)
		if(!GLOB.all_loadout_datums[path])
			stack_trace("Could not find ([path]) loadout item in the global list of loadout datums!")
			continue

		loadout_datums += GLOB.all_loadout_datums[path]

	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.insert_path_into_outfit(outfit, src, visuals_only)

	/*
		switch(slot)

			if(LOADOUT_ITEM_UNIFORM)
				if(isplasmaman(src))
					to_chat(src, "Your loadout jumpsuit was not equipped directly due to your envirosuit.")
					move_to_backpack = loadout[slot]
				else
					equipped_outfit.uniform = loadout[slot]

		if(!visuals_only && move_to_backpack)
			LAZYADD(equipped_outfit.backpack_contents, move_to_backpack)
	*/

	equipped_outfit.equip(src, visuals_only)
	w_uniform?.swap_to_modular_dmi(src)

	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.post_equip_item(src, preference_source, visuals_only)

	regenerate_icons()
	return TRUE


/* Removes all invalid paths from loadout lists.
 *
 * list_to_clean - the loadout list we're sanitizing.
 */
/proc/update_loadout_list(list/passed_list)
	var/list/list_to_update = LAZYLISTDUPLICATE(passed_list)
	for(var/thing in list_to_update)
		if(ispath(thing))
			break

		LAZYREMOVE(thing, list_to_update)
		var/our_path = text2path(list_to_update[thing])
		if(ispath(our_path))
			LAZYADD(our_path, list_to_update)

	return list_to_update

/* Removes all invalid paths from loadout lists.
 *
 * list_to_clean - the loadout list we're sanitizing.
 */
/proc/sanitize_loadout_list(list/passed_list)
	var/list/list_to_clean = LAZYLISTDUPLICATE(passed_list)
	for(var/path in list_to_clean)
		if(!ispath(path))
			stack_trace("invalid path found in loadout list! (Path: [path])")
			LAZYREMOVE(list_to_clean, path)

		else if(!(path in GLOB.all_loadout_datums))
			stack_trace("invalid loadout slot found in loadout list! Path: [path]")
			LAZYREMOVE(list_to_clean, path)

	return list_to_clean

/* Removes all invalid paths from greyscale loadout lists and any paths without colors assigned.
 *
 * list_to_clean - the greyscale loadout list we're sanitizing.
 */
/proc/sanitize_greyscale_list(list/passed_list)
	var/list/list_to_clean = sanitize_loadout_list(passed_list) // run basic sanitization, first
	for(var/path in list_to_clean)
		if (!list_to_clean[path])
			stack_trace("path found in greyscale loadout list without color assigned! (Path: [path])")
			LAZYREMOVE(list_to_clean, path)

	return list_to_clean
