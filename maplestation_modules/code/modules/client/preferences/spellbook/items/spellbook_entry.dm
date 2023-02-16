// -- The loadout item datum and related procs. --

/// Global list of ALL loadout datums instantiated.
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
		if (initial(found_type.category)!= category)
			continue

		var/datum/spellbook_item/spawned_type = new found_type()
		. += spawned_type

/datum/spellbook_item
	/// Displayed name of the loadout item.
	var/name
	/// The description to be displayed under the name.
	var/description
	/// This item's place in the world, how people think of it, usually. Displayed under description.
	var/lore
	/// The category of the loadout item.
	var/category
	/// The icon that will be displayed next to the entry in the spellbook.
	var/icon
	/// Lazylist of additional text for the tooltip displayed on this item.
	var/list/additional_tooltip_contents
	/// Controls if this item can actually ever be picked by anyone. Useful for purely visual things.
	var/can_be_picked = TRUE

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

/datum/spellbook_item/proc/can_apply(mob/living/carbon/human/target, list/params)
	return TRUE

/datum/spellbook_item/proc/apply(mob/living/carbon/human/target, list/params)
	return

/datum/spellbook_item/proc/should_apply(client/target)
	return TRUE

/datum/spellbook_item/proc/get_entry_type()
	SHOULD_CALL_PARENT(FALSE)
	CRASH("'get_entry_type' not implemented on [src.type]!")

/**
 * Takes in an action from a spellbook manager and applies it
 *
 * Useful for subtypes of spellbook items with unique actions
 */
/datum/spellbook_item/proc/handle_spellbook_action(datum/spellbook_manager/manager, action)
	SHOULD_CALL_PARENT(TRUE)

	return FALSE
