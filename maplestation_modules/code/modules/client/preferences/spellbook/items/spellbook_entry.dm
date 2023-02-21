// -- The spellbook item datum and related procs. --

/// Global list of ALL spellbook datums instantiated.
GLOBAL_LIST_EMPTY(all_spellbook_datums)

/**
 * Generate a list of singleton spellbook_item datums from all subtypes of [type_to_generate]
 *
 * returns a list of singleton datums.
 */
/proc/generate_spellbook_items(category)
	RETURN_TYPE(/list)

	. = list()

	for(var/datum/spellbook_item/found_type as anything in subtypesof(/datum/spellbook_item))
		/// Any item without a name is "abstract"
		if(isnull(initial(found_type.name)))
			continue
		if (initial(found_type.category) != category)
			continue

		var/datum/spellbook_item/spawned_type = new found_type()
		. += spawned_type

/// A entry in the spellbook. Can add anything/adjust anything, but should be themed after magic.
/// Only one instance of any given type should exist at a time. These are singleton instances, and are stored in GLOB.all_spellbook_datums, in a assoc list of (entry.type -> entry singleton).
/datum/spellbook_item
	/// Displayed name of the spellbook entry.
	var/name
	/// The description of the entry to be displayed under the name.
	var/description
	/// This entry's place in the world. Should include it's importance, how people see it, what it's related to, etc. general worldbuilding.
	/// Should also include what and who typically has this entry. Note: NEVER make a HARD limit without good reason. Creativity is key,
	/// and people should be able to make up reasons for whatever they want.
	var/lore
	/// The category of the item. Should use a define from spellbook_categories.dm.
	var/category
	/// Returns the type of entry this is. Uses defines from spellbook_entry_types.dm.
	var/entry_type
	/// Controls if this item can actually ever be picked by anyone. Useful for purely visual things.
	var/can_be_picked = TRUE
	/// Does this entry have parameters for customization?
	/// If this is set to true, you MUST override generate_customization_params.
	var/has_params

/datum/spellbook_item/New()
	. = ..()

	if(GLOB.all_spellbook_datums[type])
		stack_trace("Spellbook item [type] instantiated with a instance already instantiated")
	GLOB.all_spellbook_datums[type] = src

/datum/spellbook_item/Destroy(force, ...)
	stack_trace("Singleton spellbook item instance [src], [src.type] destroyed! Why! The fuck!")
	if (!force)
		return QDEL_HINT_LETMELIVE
	GLOB.all_spellbook_datums -= type
	return ..()

/// Called before apply() in spellbook_manager.dm. Used for determining if a specific entry should be enabled/applied.
/datum/spellbook_item/proc/can_apply(mob/living/carbon/human/target, list/params)
	SHOULD_CALL_PARENT(TRUE)
	return can_be_picked

/// The effect of the item on the person that picked it. Called when a character spawns in and has this as an enabled entry.
/datum/spellbook_item/proc/apply(mob/living/carbon/human/target, list/params)
	return

/**
 * Takes in an action from a spellbook manager and applies it
 *
 * Useful for subtypes of spellbook items with unique actions
 */
/datum/spellbook_item/proc/handle_spellbook_action(datum/spellbook_manager/manager, action)
	SHOULD_CALL_PARENT(TRUE)

	switch(action)
		if("customize_item")
			if(!has_params)
				return FALSE

			manager.customize_item(src, get_customization_menu_path(), get_customization_params(manager.owner))
			return FALSE

	return FALSE

/// In the case that a item wants to return a custom menu, this proc exists. Should return a typepath of /datum/spellbook_item_customization_menu
/datum/spellbook_item/proc/get_customization_menu_path()
	return /datum/spellbook_item_customization_menu

/// Returns an assoc list of (key: String -> spellbook_customization_entry instance), and applies existing values associated with said key to those instances.
/datum/spellbook_item/proc/get_customization_params(client/owner)
	SHOULD_CALL_PARENT(TRUE) // otherwise, we dont apply the existing params

	var/list/datum/spellbook_customization_entry/entries = generate_customization_params()
	if (!entries)
		return
	var/list/existing_params = get_existing_params(owner)
	if (existing_params)
		for (var/key in existing_params)
			entries[key]?.change_value(existing_params[key])

	return entries

/// Should always return the existing parameters associated with this type. Can be null.
/datum/spellbook_item/proc/get_existing_params(client/owner)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/list/prefs = owner.prefs.read_preference(/datum/preference/spellbook)
	return prefs?[type]

/// Generates the assoc list of (key: String -> spellbook_customization_entry instance) entries for use in entry customization.
/// See spellbook_customization_entry for documentation on the variables you need to set.
/// This MUST be overridden, but not parent-called, if you use params.
/datum/spellbook_item/proc/generate_customization_params()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("[src], [src.type] has has_params set to [has_params] but didn't implement generate_customization_params!")
