/**
 * Takes a list of paths (such as a spellbook list)
 * and returns a list of their singleton spellbook item datums
 *
 * spellbook_list - the list being checked
 *
 * returns a list of singleton datums
 */
/proc/spellbook_list_to_datums(list/spellbook_list)
	RETURN_TYPE(/list)
	var/list/datums = list()

	if(!length(GLOB.all_spellbook_datums))
		CRASH("No spellbook datums in the global spellbook list!")

	for(var/path in spellbook_list)
		var/actual_datum = GLOB.all_spellbook_datums[path]
		if(!istype(actual_datum, /datum/spellbook_item))
			stack_trace("Could not find ([path]) spellbook item in the global list of spellbook datums!")
			continue

		datums += actual_datum

	return datums

/**
 * Removes all invalid paths from spellbook lists.
 * This is a general sanitization for preference saving / loading.
 *
 * passed_list - the spellbook list we're sanitizing.
 *
 * returns a list, or null if empty
 */
/proc/sanitize_spellbook_list(list/passed_list, mob/optional_spellbook_owner)
	var/list/sanitized_list
	for(var/path in passed_list)
		// Saving to json has each path in the list as a typepath that will be converted to string
		// Loading from json has each path in the list as a string that we need to convert back to typepath
		var/obj/item/real_path = istext(path) ? text2path(path) : path
		if(!ispath(real_path))
			#ifdef TESTING
			// These stack traces are only useful in testing to find out why items aren't being saved when they should be
			// In a production setting it should be OKAY for the sanitize proc to pick out invalid paths
			stack_trace("invalid path found in spellbook list! (Path: [path])")
			#endif
			to_chat(optional_spellbook_owner, span_boldnotice("The following invalid item path was found in your spellbook: [real_path || "null"]. \
				It has been removed, renamed, or is otherwise missing - You may want to check your spellbook settings."))
			continue

		else if(!istype(GLOB.all_spellbook_datums[real_path], /datum/spellbook_item))
			#ifdef TESTING
			// Same as above, stack trace only useful in testing to find out why items aren't being saved when they should be
			stack_trace("invalid spellbook item found in spellbook list! Path: [path]")
			#endif
			to_chat(optional_spellbook_owner, span_boldnotice("The following invalid spellbook item was found in your spellbook: [real_path || "null"]. \
				It has been removed, renamed, or is otherwise missing - You may want to check your spellbook settings."))
			continue

		// Grab data using real path key
		var/list/data = passed_list[path]
		// Set into sanitize list using converted path key
		LAZYSET(sanitized_list, real_path, LAZYCOPY(data))

	return sanitized_list
