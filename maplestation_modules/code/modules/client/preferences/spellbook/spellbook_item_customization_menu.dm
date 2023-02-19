/// NOT SERIALIZED - The data provided by these entries are instead extracted and serialized into lists of (string -> any) values,
/// that are then associated in the spellbook preference as (item.type -> list).
/datum/spellbook_customization_entry
	/// The savefile key that this entry is associated with. This will be the "key" of the serialization. This specific
	/// parameter will save to, and take from, this key. Ex. "damage_amount" will look for the "damage_amount" parameter assocaited with item.type,
	/// and apply the value of that to this entry. When we are done, we will save the value of this entry to the "damage_amount" parameter.
	var/key
	/// The name that will be displayed to the left of the interface (e.g. button, input, slider, etc.)
	var/name
	/// The tooltip to be displayed when you hover over the interface. Optional.
	var/tooltip
	/// How the user will interface with this entry.
	/// Accepted types:
	///		SPELLBOOK_CUSTOMIZATION_BOOLEAN - Creates a checkbox
	///		SPELLBOOK_CUSTOMIZATION_ANY_INPUT - Creates a text field that can have anything put in it
	///		SPELLBOOK_CUSTOMIZATION_SLIDER - Creates a numeric slider, with min/max associated with min/max_value
	/// 	SPELLBOOK_CUSTOMIZATION_NUMERIC_INPUT - Creates a text field that only accepts numbers
	/// Uses defines from spellbook_customization_interfaces.dm
	var/interfacetype
	/// The stored value of this key. This is what will be serialized into a list, and displayed to the user. Should be updated
	/// every time the value changes. Do not access directly - use get_value and change_value()
	VAR_PRIVATE/current_value
	/// In the case that no current value is provided in construction, or a pre-sanitized value cannot be converted into the correct format,
	/// default_value will be used.
	var/default_value

/datum/spellbook_customization_entry/New(key, name, tooltip, default_value, current_value = default_value)
	. = ..()

	src.key = key
	src.name = name
	src.tooltip = tooltip
	src.default_value = sanitize_value(default_value)
	change_value(current_value)

/// Generates the data to be supplies to the TGUI window. Should be in list(key -> value) format.
/datum/spellbook_customization_entry/proc/generate_ui_data()
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)
	. = list("key" = key,
			"name" = name,
			"tooltip" = tooltip,
			"interfacetype" = interfacetype,
			"current_value" = get_value())

/// Setter for current_value. Sanitizes new_value before setting current_value to it.
/datum/spellbook_customization_entry/proc/change_value(new_value)
	SHOULD_CALL_PARENT(TRUE)
	current_value = sanitize_value(new_value)

/// Getter for current_value. Sanitizes it before returning it.
/datum/spellbook_customization_entry/proc/get_value()
	SHOULD_CALL_PARENT(TRUE)
	return sanitize_value(current_value)

/// Ensures the provided value is correctly formatted for this entry. If it isn't, it will convert it into a correct format.
/// Ex. numeric entries will clamp numbers to the max and min, booleans will default to FALSE if the value isn't a boolean.
/datum/spellbook_customization_entry/proc/sanitize_value(value)
	return value

/datum/spellbook_customization_entry/any_input
	interfacetype = SPELLBOOK_CUSTOMIZATION_ANY_INPUT

/datum/spellbook_customization_entry/boolean
	interfacetype = SPELLBOOK_CUSTOMIZATION_BOOLEAN
	default_value = FALSE

/datum/spellbook_customization_entry/boolean/sanitize_value(value)
	if (!isboolean(value)) return default_value
	return value

/datum/spellbook_customization_entry/numeric
	/// For numeric (slider, numeric input) interfaces, this is the maximum value that the user can set.
	var/max_value
	/// For numeric (slider, numeric input) interfaces, this is the minimum value that the user can set.
	var/min_value

	/// For numeric (slider, numeric input) interfaces, this is the minimum amount the user can increment it via clickdragging.
	/// This is also the number that the value will be rounded to for sanitization purposes.
	var/min_increment

	default_value = 0

/datum/spellbook_customization_entry/numeric/New(key, name, tooltip, default_value, current_value = default_value, max_value, min_value, min_increment)
	src.max_value = max_value
	src.min_value = min(min_value, max_value)

	src.min_increment = min_increment

	. = ..()

/datum/spellbook_customization_entry/numeric/generate_ui_data()
	. = ..()
	.["max_value"] = max_value
	.["min_value"] = min_value
	.["min_increment"] = min_increment

/datum/spellbook_customization_entry/numeric/sanitize_value(value)
	if (!isnum(value)) return default_value

	. = clamp(value, min_value, max_value)
	return round(., min_increment)

/datum/spellbook_customization_entry/numeric/slider
	interfacetype = SPELLBOOK_CUSTOMIZATION_SLIDER

/datum/spellbook_customization_entry/numeric/numeric_input
	interfacetype = SPELLBOOK_CUSTOMIZATION_NUMERIC_INPUT

/// The TGUI manager for the spellbook item customization menu.
/datum/spellbook_item_customization_menu
	/// Assoc list of (key: String -> spellbook_customization_entry instance)
	var/list/datum/spellbook_customization_entry/params
	/// The spellbook item we are modifying the params for.
	var/datum/spellbook_item/item
	/// The client of the person customizing the item.
	var/client/owner
	/// The manager that summoned us for easy access
	var/datum/spellbook_manager/manager

	/// Spellbook preference singleton for easy access
	var/datum/preference/spellbook/preference

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

/datum/spellbook_item_customization_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)

		if("change_value")
			change_value(arglist(params))
			return TRUE
	return TRUE

/// Simple wrapper for entry.change_value()
/datum/spellbook_item_customization_menu/proc/change_value(key, new_value)
	var/datum/spellbook_customization_entry/entry = params[key]
	if (!istype(entry))
		CRASH("[entry], [entry?.type] is not a spellbook customization entry during change_value! value: [new_value]")
	entry.change_value(new_value)
	return

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

	for (var/entry_key as anything in params)
		var/datum/spellbook_customization_entry/entry = params[entry_key]
		entries += list(entry.generate_ui_data())
	data["entries"] = entries

	return data

/datum/spellbook_item_customization_menu/ui_close(mob/user)
	manager.currently_selected?[item.type] = serialize()
	qdel(src)

/// Transform the values of our entries into data we can store in association with item.type.
/datum/spellbook_item_customization_menu/proc/serialize()
	. = list()
	for (var/entry_key in params)
		var/datum/spellbook_customization_entry/entry = params[entry_key]
		.[entry_key] = entry.get_value()
