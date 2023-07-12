/datum/loadout_category
	var/category_name = ""
	var/ui_title = ""

/datum/loadout_category/proc/get_items()
	CRASH("[type] has not implemented get_items().")

/datum/loadout_category/proc/items_to_ui_data()
	var/list/list_of_datums = get_items()
	if(!length(list_of_datums))
		return list()

	var/list/formatted_list = list()

	for(var/datum/loadout_item/item as anything in list_of_datums)
		UNTYPED_LIST_ADD(formatted_list, item.to_ui_data())

	// Alphebetize
	sortTim(formatted_list, /proc/cmp_assoc_list_name)
	return formatted_list
