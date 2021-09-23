/// -- Outfit and mob helpers to equip our loadout items. --

/// An empty outfit we fill in with our loadout items to dress our dummy.
/datum/outfit/player_loadout
	name = "Player Loadout"

/*
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
	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.insert_path_into_outfit(equipped_outfit, src, visuals_only)

	equipOutfit(equipped_outfit, visuals_only) // equip the outfit
	w_uniform?.swap_to_modular_dmi(src) // change our uniform's icon if needed

	for(var/datum/loadout_item/item as anything in loadout_datums)
		item.on_equip_item(preference_source, src, visuals_only)

	regenerate_icons()
	return TRUE

/*
 * Post-loadout equipping, done after quirks are assigned. (TODO: FIND A BETTER WAY TO DO THIS, maybe.)
 *
 * Why in AssignQuirks?
 *
 * Because post loadout equipping needs to be done after quirks are assigned
 * for both latejoiners and roundstart players - this ensures that post-loadout equipping is done
 * after quirks are done for both types of players easily and modularly.
 *
 * Why not extend the other two relevant procs (equip_characters and AttemptLateSpawn)?
 *
 * AssignQuirks is passed the mob and the client, which are both needed for loadout equipping
 * If the procs were extended, it'd lose the relevant vars from the scope of those procs.
 */
/datum/controller/subsystem/processing/quirks/AssignQuirks(mob/living/user, client/cli)
	. = ..()
	after_loadout_equipped(user, cli?.prefs)

/*
 * Go through after the loadout item is equipped and call post_equip_item.
 *
 * equipper - the mob we're equipping the loadout item to
 * prefs - the preferences datum we're equipping from
 */
/proc/after_loadout_equipped(mob/living/carbon/human/equipper, datum/preferences/prefs)
	if(!prefs)
		CRASH("After_loadout_equipped called without a supplied preference datum.")
	if(!istype(equipper))
		return // Not a crash, 'cause this proc could be passed non-humans (AIs, etc) and that's fine

	for(var/datum/loadout_item/item as anything in loadout_list_to_datums(prefs.read_preference(/datum/preference/loadout)))
		item.post_equip_item(equipper.client?.prefs, equipper)

/*
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

	if(!GLOB.all_loadout_datums.len)
		CRASH("No loadout datums in the global loadout list!")

	for(var/path in loadout_list)
		if(!GLOB.all_loadout_datums[path])
			stack_trace("Could not find ([path]) loadout item in the global list of loadout datums!")
			continue

		. |= GLOB.all_loadout_datums[path]


/*
 * Removes all invalid paths from loadout lists.
 * This is for updating old loadout lists (pre-datumization)
 * to new loadout lists (the formatting was changed).
 *
 * If you're looking at loadouts fresh, you DON'T need this proc.
 *
 * passed_list - the loadout list we're sanitizing.
 *
 * returns a list, or null if empty
 */
/proc/update_loadout_list(list/passed_list)
	var/list/list_to_update = LAZYLISTDUPLICATE(passed_list)
	for(var/thing in list_to_update) //"thing", 'cause it could be a lot of things
		if(ispath(thing))
			continue
		var/our_path = text2path(list_to_update[thing])

		LAZYREMOVE(list_to_update, thing)
		if(ispath(our_path))
			LAZYSET(list_to_update, our_path, list())

	return list_to_update

/*
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
			stack_trace("invalid path found in loadout list! (Path: [path])")
			LAZYREMOVE(list_to_clean, path)

		else if(!(path in GLOB.all_loadout_datums))
			stack_trace("invalid loadout item found in loadout list! Path: [path]")
			LAZYREMOVE(list_to_clean, path)

	return list_to_clean
