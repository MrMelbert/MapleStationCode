// -- The loadout item datum and related procs. --

/// Global list of ALL loadout datums instantiated.
GLOBAL_LIST_EMPTY(all_loadout_datums)

/*
 * Generate a list of singleton loadout_item datums from all subtypes of [type_to_generate]
 *
 * returns a list of singleton datums.
 */
/proc/generate_loadout_items(type_to_generate)
	RETURN_TYPE(/list)

	. = list()
	if(!ispath(type_to_generate))
		CRASH("generate_loadout_items(): called with an invalid or null path as an argument!")

	for(var/datum/loadout_item/found_type as anything in subtypesof(type_to_generate))
		/// Any item without a name is "abstract"
		if(isnull(initial(found_type.name)))
			continue

		if(!ispath(initial(found_type.item_path)))
			stack_trace("generate_loadout_items(): Attempted to instantiate a loadout item ([initial(found_type.name)]) with an invalid or null typepath! (got path: [initial(found_type.item_path)])")
			continue

		var/datum/loadout_item/spawned_type = new found_type()
		GLOB.all_loadout_datums[spawned_type.item_path] = spawned_type
		. |= spawned_type

/// Loadout item datum.
/// Holds all the information about each loadout items.
/// A list of singleton loadout items are generated on initialize.
/datum/loadout_item
	/// Displayed name of the loadout item.
	var/name
	/// Whether this item has greyscale support.
	var/can_be_greyscale = FALSE
	/// Whether this item can be renamed.
	var/can_be_named = FALSE
	/// Whether this item can be reskinned.
	var/can_be_reskinned = FALSE
	/// The category of the loadout item.
	var/category
	/// The actual item path of the loadout item.
	var/item_path
	/// List of additional text for the tooltip displayed on this item.
	var/list/additional_tooltip_contents

/datum/loadout_item/New()
	if(can_be_named)
		// If we're a renamable item, insert the "renamable" tooltip at the beginning of the list.
		add_tooltip(TOOLTIP_RENAMABLE, inverse_order = TRUE)

	if(can_be_greyscale)
		// Likewise, if we're greyscaleable, insert the "greyscaleable" tooltip at the beginning of the list (before renamable)
		add_tooltip(TOOLTIP_GREYSCALE, inverse_order = TRUE)

	if(can_be_reskinned)
		add_tooltip(TOOLTIP_RESKINNABLE)

/// Helper to add a tooltip to our tooltip list.
/// If inverse_order is TRUE, we will add to the front instead of the back.
/datum/loadout_item/proc/add_tooltip(tooltip, inverse_order = FALSE)
	if(!additional_tooltip_contents)
		additional_tooltip_contents = list()

	if(inverse_order)
		additional_tooltip_contents.Insert(1, tooltip)
	else
		additional_tooltip_contents.Add(tooltip)

/*
 * Place our [var/item_path] into [outfit].
 *
 * By default, just adds the item into the outfit's backpack contents, if non-visual.
 *
 * outfit - The outfit we're equipping our items into.
 * equipper - If we're equipping out outfit onto a mob at the time, this is the mob it is equipped on. Can be null.
 * visual - If TRUE, then our outfit is only for visual use (for example, a preview).
 */
/datum/loadout_item/proc/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(!visuals_only)
		LAZYADD(outfit.backpack_contents, item_path)

/*
 * Called When the item is equipped on [equipper].
 *
 * preference_source - the datum/preferences our loadout item originated from - cannot be null
 * equipper - the mob we're equipping this item onto - cannot be null
 * visuals_only - whether or not this is only concerned with visual things (not backpack, not renaming, etc)
 */
/datum/loadout_item/proc/on_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper, visuals_only = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!preference_source)
		return null

	var/obj/item/equipped_item = locate(item_path) in equipper.get_all_contents()
	if(!equipped_item)
		CRASH("[type] on_equip_item(): Could not locate clothing item (path: [item_path]) in [equipper]'s [visuals_only ? "visible":"all"] contents!")

	var/list/our_loadout = preference_source.read_preference(/datum/preference/loadout)
	if(can_be_greyscale && (INFO_GREYSCALE in our_loadout[item_path]))
		equipped_item.set_greyscale(our_loadout[item_path][INFO_GREYSCALE])

	if(can_be_named && (INFO_NAMED in our_loadout[item_path]) && !visuals_only)
		equipped_item.name = our_loadout[item_path][INFO_NAMED]

	if(can_be_reskinned && (INFO_RESKIN in our_loadout[item_path]))
		var/skin_chosen = our_loadout[item_path][INFO_RESKIN]
		if(skin_chosen in equipped_item.unique_reskin)
			equipped_item.current_skin = skin_chosen
			equipped_item.icon_state = equipped_item.unique_reskin[skin_chosen]
			equipper.update_inv_wear_suit()
		else
			our_loadout[item_path] -= INFO_RESKIN
			preference_source.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout)

	return equipped_item

/*
 * Called after the item is equipped on [equipper], at the end of character setup.
 *
 * preference_source - the datum/preferences our loadout item originated from - cannot be null
 * equipper - the mob we're equipping this item onto - cannot be null
 */
/datum/loadout_item/proc/post_equip_item(datum/preferences/preference_source, mob/living/carbon/human/equipper)
	return FALSE
