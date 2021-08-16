/// -- A ton of global lists that hold singletons of all loadout items. --
/proc/generate_loadout_items(type_to_generate)
	RETURN_TYPE(/list)

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

		/// Any item without a name is "abstract"
		if(isnull(item.name))
			qdel(item)
			continue

		. |= item

/// Global list of ALL loadout datums instantiated.
GLOBAL_LIST_EMPTY(all_loadout_datums)

/// Loadoit item datum.
/// Holds all the information about each loadout items.
/// A list of singleton loadout items are generated on initialize.
/datum/loadout_item
	/// Displayed name of the loadout item.
	var/name
	/// Whether this item has greyscale support.
	var/can_be_greyscale = FALSE
	/// Whether this item can be renamed.
	var/can_be_named = FALSE
	/// The category of the loadout item.
	var/category
	/// The actual item path of the loadout item.
	var/item_path
	/// List of additional text for the tooltip displayed on this item.
	var/list/additional_tooltip_contents

/datum/loadout_item/New()
	if(can_be_named)
		if(LAZYLEN(additional_tooltip_contents))
			additional_tooltip_contents.Insert(1, TOOLTIP_RENAMABLE)
		else
			LAZYADD(additional_tooltip_contents, TOOLTIP_RENAMABLE)

	if(can_be_greyscale)
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
 * By default, just adds the item into the outfit's backpack contents, if non-visual.
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
/datum/loadout_item/proc/post_equip_item(datum/preferences/preference_source, mob/living/equipper, visual)
	var/list/greyscale_colors = preference_source?.greyscale_loadout_list
	if(can_be_greyscale && LAZYLEN(greyscale_colors))
		if(ispath(item_path, /obj/item/clothing))
			var/obj/item/clothing/equipped_item = locate(item_path) in equipper.get_equipped_items()
			equipped_item?.set_greyscale(greyscale_colors[item_path])
		else if(!visual)
			var/obj/item/other_item = locate(item_path) in equipper.GetAllContents()
			other_item?.set_greyscale(greyscale_colors[item_path])

	if(!visual)
		var/list/loadout_names = preference_source?.name_loadout_list
		if(LAZYLEN(loadout_names))
			var/obj/item/equipped_item = locate(item_path) in equipper.GetAllContents()
			equipped_item.name = loadout_names[item_path]
