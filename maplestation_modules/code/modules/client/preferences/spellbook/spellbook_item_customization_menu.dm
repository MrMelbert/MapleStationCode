/datum/spellbook_customization_entry
	var/key
	var/name
	var/tooltip
	/// How the user will interface with this entry. E.g. BOOLEAN, SLIDER, INPUT
	var/interfacetype
	var/current_value

/datum/spellbook_customization_entry/slider
	var/max_value
	var/min_value

	var/min_increment

/datum/spellbook_customization_entry/slider/New(key, interfacetype, current_value, max_value, min_value, min_increment)
	. = ..()

	src.max_value = max_value
	src.min_value = min_value

	src.min_increment = min_increment

/datum/spellbook_customization_entry/New(key, interfacetype, current_value)
	. = ..()

	src.key = key
	src.interfacetype = interfacetype
	src.current_value = current_value

/datum/spellbook_item_customization_menu
	var/list/datum/spellbook_customization_entry/params
	var/datum/spellbook_item/item
	var/client/owner
	var/datum/spellbook_manager/manager

	/// Spellbook preference singleton for easy access
	var/datum/preference/spellbook/preference
	/// The current selected currently_selected list.
	var/list/currently_selected

/datum/spellbook_item_customization_menu/Destroy(force, ...)

	QDEL_LIST_ASSOC_VAL(params)
	params = null

	item = null
	manager.customization_menu = null
	manager = null

	. = ..()


/datum/spellbook_item_customization_menu/New(list/datum/spellbook_customization_entry/params, datum/spellbook_item/item, datum/spellbook_manager/manager)
	. = ..()

	src.params = params
	src.item = item
	src.manager = manager

/datum/spellbook_item_customization_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_spellbookCustomizationMenu")
		ui.open()

/datum/spellbook_item_customization_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/spellbook_item_customization_menu/ui_data(mob/user)
	var/list/data = list()
	var/list/entries = list()

	for (var/entry_key in params)
		var/datum/spellbook_customization_entry/entry = params[entry_key]
		entries += list(list("key" = entry.key, "name" = entry.name, "tooltip" = entry.tooltip, "interfacetype" = entry.interfacetype, "current_value" = entry.current_value))

		/*if (istype(entry, /datum/spellbook_customization_entry/slider))
			var/datum/spellbook_customization_entry/slider/slider_entry = entry
			entry_list["max_value"] = slider_entry.max_value
			entry_list["min_value"] = slider_entry.min_value
			entry_list["min_increment"] = slider_entry.max_value*/

	data["entries"] = entries

	return data

/datum/spellbook_item_customization_menu/ui_close(mob/user)
	manager.currently_selected?[item.type] = serialize()
	qdel(src)

/datum/spellbook_item_customization_menu/proc/serialize()
	. = list()
	for (var/entry_key in params)
		var/datum/spellbook_customization_entry/entry = params[entry_key]
		.[entry_key] = entry.current_value
