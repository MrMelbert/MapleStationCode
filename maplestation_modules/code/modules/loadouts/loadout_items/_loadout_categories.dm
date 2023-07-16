/**
 * # Loadout categories
 *
 * Loadout categories are used to group loadout items together in the loadout screen.
 */
/datum/loadout_category
	/// The name of the category, shown in the tabs
	var/category_name
	/// The title of the category, shown at the top of the list
	var/ui_title

/// Return a list of all /datum/loadout_items in this category.
/datum/loadout_category/proc/get_items()
	RETURN_TYPE(/list)
	CRASH("[type] has not implemented get_items().")

/// Returns a list of all /datum/loadout_items in this category, formatted for UI use.
/datum/loadout_category/proc/items_to_ui_data()
	RETURN_TYPE(/list)
	var/list/list_of_datums = get_items()
	if(!length(list_of_datums))
		return list()

	var/list/formatted_list = list()

	for(var/datum/loadout_item/item as anything in list_of_datums)
		UNTYPED_LIST_ADD(formatted_list, item.to_ui_data())

	sortTim(formatted_list, /proc/cmp_assoc_list_name) // Alphebetizig
	return formatted_list
