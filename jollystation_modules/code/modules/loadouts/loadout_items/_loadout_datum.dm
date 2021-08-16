/// -- A ton of global lists that hold singletons of all loadout items. --
/proc/generate_loadout_items(type_to_generate)
	. = list()
	if(!ispath(type_to_generate))
		CRASH("generate_loadout_items(): called with an invalid or null path as an argument!")

	for(var/found_type in subtypesof(type_to_generate))
		var/datum/loadout_item/item = new found_type()
		if(!istype(item))
			stack_trace("generate_loadout_items(): Instantiated a loadout item ([item]) that isn't of type /datum/loadout_item! (got type: [item.type])")
			qdel(item)
			continue

		if(!ispath(item.item_path))
			stack_trace("generate_loadout_items(): Instantiated a loadout item ([item.name]) with an invalid or null typepath! (got path: [item.item_path])")
			qdel(item)
			continue

		. |= item

/// Global list of ALL loadout datums instantiated.
GLOBAL_LIST_EMPTY(all_loadout_datums)

/// Loadoit item datum.
/// Holds all the information about each loadout items.
/// A list of singleton loadout items are generated on initialize.
/datum/loadout_item
	var/name
	var/is_greyscale = TRUE
	var/category
	var/item_path
	var/list/additional_tooltip_contents

/datum/loadout_item/New()
	if(is_greyscale)
		if(LAZYLEN(additional_tooltip_contents))
			additional_tooltip_contents.Insert(1, TOOLTIP_GREYSCALE)
		else
			LAZYADD(additional_tooltip_contents, TOOLTIP_GREYSCALE)

	GLOB.all_loadout_datums[item_path] = src

/datum/loadout_item/Destroy()
	GLOB.all_loadout_datums -= src
	return ..()

/*
 * Place our [var/item_path] into [outfit].
 *
 * equipper - If we're equipping out outfit onto a mob at the time, this is the mob it is equipped on. Can be null.
 * outfit - The outfit we're equipping our items into.
 * visual - If TRUE, then our outfit is only for visual use (for example, a preview).
 */
/datum/loadout_item/proc/insert_path_into_outfit(datum/outfit/outfit, mob/living/equipper, visual)
	if(!visual)
		LAZYADD(outfit.backpack_contents, item_path)

/*
 * Called after the item is equipped on [equipper].
 */
/datum/loadout_item/proc/post_equip_item(mob/living/equipper, datum/preferences/preference_source, visual)
	if(!visual)
		var/list/greyscale_colors = preference_source?.greyscale_loadout_list
		if(is_greyscale && LAZYLEN(greyscale_colors))
			var/obj/item/equipped_item = locate(item_path) in equipper.GetAllContents()
			equipped_item.set_greyscale(greyscale_colors[item_path])
