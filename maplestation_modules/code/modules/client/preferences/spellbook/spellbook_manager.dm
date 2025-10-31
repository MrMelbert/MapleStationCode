/// Tracking when a client has an open spellbook manager, to prevent funky stuff.
/client
	/// A ref to spellbook_manager datum.
	var/datum/spellbook_manager/open_spellbook_ui = null

/// The "spellbook" - a character creation window that allows people to select spells for their characters.
/datum/spellbook_manager
	var/datum/preferences/owner_preferences
	/// The client of the person using the UI
	var/client/owner
	/// Spellbook preference singleton for easy access
	var/datum/preference/spellbook/preference
	/// The current selected entries.
	var/list/currently_selected
	/// Is the disclaimer text open?
	var/disclaimer_open = TRUE
	/// Is the magic system explanation open?
	var/explanation_open = FALSE
	/// Whether, on close, we save the list
	var/save_on_close = TRUE
	/// Our currently open customization customization_menu.
	var/datum/spellbook_item_customization_menu/customization_menu

/datum/spellbook_manager/New(user)
	owner = CLIENT_FROM_VAR(user)
	owner_preferences = owner.prefs
	owner.open_spellbook_ui = src
	currently_selected = owner.prefs.read_preference(/datum/preference/spellbook)
	preference = GLOB.preference_entries[/datum/preference/spellbook]

/datum/spellbook_manager/Destroy(force, ...)
	currently_selected = null
	owner = null
	owner_preferences = null
	preference = null

	if (isdatum(customization_menu)) //avoid bad del
		QDEL_NULL(customization_menu)
	return ..()

/datum/spellbook_manager/ui_state(mob/user)
	return GLOB.always_state

/datum/spellbook_manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_spellbookManager")
		ui.open()

/datum/spellbook_manager/ui_close(mob/user)
	if(istype(customization_menu))
		customization_menu.ui_close(user)
	if(save_on_close)
		owner.prefs.write_preference(preference, currently_selected)
	if(owner)
		owner.open_spellbook_ui = null
	qdel(src)

/datum/spellbook_manager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/spellbook_item/interacted_item
	if(params["path"])
		interacted_item = GLOB.all_spellbook_datums[text2path(params["path"])]
		if(isnull(interacted_item))
			stack_trace("Failed to locate desired spellbook item (path: [params["path"]]) in the global list of spellbook item datums!")
			return

		if(interacted_item.handle_spellbook_action(src, action))
			return TRUE

	switch(action)

		if("toggle_disclaimer")
			toggle_disclaimer()
			return TRUE
		if ("toggle_explanation")
			explanation_open = !explanation_open
			return TRUE

		// Closes the UI
		if("close_ui")
			save_on_close = FALSE
			SStgui.close_uis(src)
			return FALSE

		if("select_item")
			if(params["deselect"])
				deselect_item(interacted_item)
			else
				select_item(interacted_item)

		// Clears the selected items entirely.
		if("clear_all_items")
			owner.prefs.update_preference(preference, null)
	return TRUE

/// Open a new customization menu and pass our args to it.
/datum/spellbook_manager/proc/customize_item(datum/spellbook_item/item, datum/spellbook_item_customization_menu/typepath, list/menu_params)
	if(customization_menu)
		to_chat(owner, span_warning("You're already customizing an entry!"))
		return

	customization_menu = new typepath(params = menu_params, item = item, manager = src)

	RegisterSignal(customization_menu, COMSIG_QDELETING, TYPE_PROC_REF(/datum/spellbook_manager, cleanup_customization_menu))
	customization_menu.ui_interact(usr)

/datum/spellbook_manager/proc/cleanup_customization_menu()
	customization_menu = null

/datum/spellbook_manager/proc/toggle_disclaimer()
	disclaimer_open = !disclaimer_open

/datum/spellbook_manager/ui_data(mob/user)
	var/list/data = list()

	var/list/all_selected_paths = list()
	for(var/path in owner.prefs.read_preference(/datum/preference/spellbook))
		all_selected_paths += path

	data["selected_items"] = all_selected_paths
	data["disclaimer_status"] = disclaimer_open
	if(disclaimer_open)
		data["disclaimer_text"] = get_disclaimer_text()
	data["explanation_status"] = explanation_open
	if (explanation_open)
		data["explanation_text"] = get_explanation_text()

	return data

/datum/spellbook_manager/ui_static_data()
	var/list/data = list()

	// Generate the tabs that will contain the entries
	// [name] is the name of the tab that contains all the corresponding contents.
	// [title] is the name at the top of the list of corresponding contents.
	// [contents] is a formatted list of all the items under this category.
	//  - Read the spellbook_item documentation to see what the entries do

	var/list/spellbook_tabs = list()
	spellbook_tabs += list(list("name" = "Cantrips", "title" = "Simple spells that require little preparation or components to cast", "contents" = list_to_data(GLOB.spellbook_cantrip_items)))
	spellbook_tabs += list(list("name" = "Manipulation", "title" = "Capabilities that typically involve the manipulation of or other use of mana", "contents" = list_to_data(GLOB.spellbook_manipulation_items)))

	data["spellbook_tabs"] = spellbook_tabs

	return data

/**
 * Takes an assoc list of [typepath]s to [singleton datum]
 * And formats it into an object for TGUI.
 *
 */
/datum/spellbook_manager/proc/list_to_data(list_of_datums)
	if(!LAZYLEN(list_of_datums))
		return

	var/list/formatted_list = new(length(list_of_datums))

	var/array_index = 1
	for(var/datum/spellbook_item/item as anything in list_of_datums)
		var/list/formatted_item = list()
		formatted_item["type"] = item.type
		formatted_item["name"] = item.name
		formatted_item["description"] = item.description
		formatted_item["lore"] = item.lore
		formatted_item["entry_type"] = item.entry_type
		formatted_item["can_be_picked"] = item.can_be_picked
		formatted_item["has_params"] = item.has_params

		formatted_list[array_index++] = formatted_item
	return formatted_list

/// Returns a formatted string for use in the UI.
/datum/spellbook_manager/proc/get_disclaimer_text()
	return {"This is the spellbook.
The spellbook is a character customization customization menu that allows you to add magical attributes to your character.
This operates first and foremost as a way to add a mechanical uniqueness to your characters, in the form of magic.

It operates on an honor system, meaning you're allowed to take whatever you want bar a few restrictions.
This DOES NOT MEAN YOU CAN TAKE ABSOLUTELY EVERYTHING. This DOES NOT MEAN YOU ARE ALLOWED TO POWERGAME THIS.
When thinking about what to take, you are expected to think in terms of what your character would have. This is not meant to be a
power boost - and is instead meant to enrich your character with abilities fitting for them.
You may use the small italicized text under each entry to determine feasibility.

Don't feel like you must strictly abide by the guidelines provided by the entries - they are just that, guidelines. All that is asked is that
you avoid taking items for the sake of taking them, and that you don't abuse them in a way your character shouldn't."}

/// Returns a formatted string for use in the UI.
/datum/spellbook_manager/proc/get_explanation_text()
	return {"All/most entries in the spellbook interact with the magic system in one way or another.

Magic is powered by mana - which is supplied from mana pools. There are various mana pools around you - such as mana crystals, transmutation magic, leylines -
but all are often inconvenient to use in one way or another, preventing magic from overtaking traditional mechanics in most cases.
Leylines are accessable to all - and have high overall mana capacity, are often unattuned, and have low recharge.
This is the primary way magic is powered, and the shared nature makes it very inconsistant to use.
Mana crystals and transmutation magic is unimplemented.

Mana also often has "attunements" to a given element, as do things that consume mana, such as spells. Mana cost will be multiplied
by an inverse amount to the amount of attunement between x and y. E.g. If you use a leyline's mana, with attunement of fire -> 1, and apply it to say, firebolt,
which has an attunement of fire -> 1, your mana cost may be halved, or something like that.
The inverse happens if attunements contradict, such as fire -> 1 mana going into a frostbolt, which has fire -> -1. This doubles casting cost.

Elements also have intrinsic biases towards certain things, such as fire having a bias towards lizards, allowing them to cast fire magic for less cost."}

/// Set selected item -> params.
/datum/spellbook_manager/proc/select_item(datum/spellbook_item/selected_item, list/params)
	if (!selected_item.can_apply(owner))
		return FALSE

	LAZYSET(currently_selected, selected_item.type, params)
	owner.prefs.update_preference(preference, currently_selected)
	return TRUE

/// Deselect [deselected_item].
/datum/spellbook_manager/proc/deselect_item(datum/spellbook_item/deselected_item)
	LAZYREMOVE(currently_selected, deselected_item.type)
	owner.prefs.update_preference(preference, currently_selected)
