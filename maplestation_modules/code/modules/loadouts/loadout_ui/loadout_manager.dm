/// -- The loadout manager and UI --

/// Tracking when a client has an open loadout manager, to prevent funky stuff.
/client
	/// A ref to loadout_manager datum.
	var/datum/loadout_manager/open_loadout_ui = null

/// Proc for preferences to render an appearance without the job outfit
/// Future todo: Repurpose the proc itself to be given an outfit
/datum/preferences/proc/render_new_loadout_preview_appearance(mob/living/carbon/human/dummy/mannequin)
	var/datum/job/preview_job = get_highest_priority_job()

	if(preview_job)
		// Silicons only need a very basic preview since there is no customization for them.
		if (istype(preview_job,/datum/job/ai))
			return image('icons/mob/silicon/ai.dmi', icon_state = resolve_ai_icon(read_preference(/datum/preference/choiced/ai_core_display)), dir = SOUTH)
		if (istype(preview_job,/datum/job/cyborg))
			return image('icons/mob/silicon/robots.dmi', icon_state = "robot", dir = SOUTH)

	// Set up the dummy for its photoshoot
	apply_prefs_to(mannequin, TRUE)
	mannequin.equip_outfit_and_loadout(/datum/outfit/player_loadout, src, TRUE)
	return mannequin.appearance

// Subtype of character preview for the loadout UI specifically
/atom/movable/screen/map_view/char_preview/loadout
	/// Whether we see our favorite job's clothes on the dummy
	var/view_job_clothes = TRUE

// Crude copy paste but you gotta do what you gotta do
/atom/movable/screen/map_view/char_preview/loadout/update_body()
	if (isnull(body))
		create_body()
	else
		body.wipe_state()

	if(view_job_clothes)
		appearance = preferences.render_new_preview_appearance(body)
	else
		appearance = preferences.render_new_loadout_preview_appearance(body)

/atom/movable/screen/map_view/char_preview/loadout/Destroy()
	// Null out the ref before the parent call of destroy
	// Why? Parent destroy will set the pref's character preview to null
	// even if we're creating our own to use for loadouts,
	// and we don't want it to mess with that
	preferences = null
	return ..()

/// Datum holder for the loadout manager UI.
/// Future todo: Merge this entirely with the prefs UI
/datum/loadout_manager
	/// The client of the person using the UI
	var/client/owner
	/// Loadout preference singleton for easy access
	var/datum/preference/loadout/preference
	/// The current selected loadout list.
	var/list/loadout
	/// The preview dummy.
	/// We use a special subtype so we don't brick our preference menu preview when we're done.
	var/atom/movable/screen/map_view/char_preview/loadout/character_preview_view
	/// Whether we see tutorial text in the UI
	var/tutorial_status = FALSE
	/// Whether, on close, we save the list
	var/save_on_close = TRUE
	/// Our currently open greyscaling menu.
	var/datum/greyscale_modify_menu/menu

/datum/loadout_manager/New(user)
	owner = CLIENT_FROM_VAR(user)
	owner.open_loadout_ui = src
	loadout = owner.prefs.read_preference(/datum/preference/loadout)
	preference = GLOB.preference_entries[/datum/preference/loadout]

/datum/loadout_manager/Destroy(force, ...)
	QDEL_NULL(character_preview_view)
	QDEL_NULL(menu)
	owner = null
	preference = null
	return ..()

/datum/loadout_manager/ui_close(mob/user)
	if(menu)
		SStgui.close_uis(menu)
		menu = null
	if(save_on_close)
		owner.prefs.write_preference(preference, loadout)
	if(owner)
		owner.open_loadout_ui = null
		// Update our main menu when we're all done
		if(owner.prefs?.character_preview_view)
			INVOKE_ASYNC(owner.prefs.character_preview_view, TYPE_PROC_REF(/atom/movable/screen/map_view/char_preview, update_body))
	qdel(src)

/// Initialize our character dummy.
/datum/loadout_manager/proc/create_character_preview_view(mob/user)
	character_preview_view = new(null, owner.prefs)
	character_preview_view.generate_view("character_preview_[REF(character_preview_view)]")
	character_preview_view.update_body()
	character_preview_view.display_to(user)
	return character_preview_view

/datum/loadout_manager/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_LoadoutManager")
		ui.open()
		addtimer(CALLBACK(character_preview_view, TYPE_PROC_REF(/atom/movable/screen/map_view/char_preview, update_body)), 1 SECONDS)

/datum/loadout_manager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/loadout_item/interacted_item
	if(params["path"])
		interacted_item = GLOB.all_loadout_datums[text2path(params["path"])]
		if(isnull(interacted_item))
			stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
			return

		if(interacted_item.handle_loadout_action(src, action))
			return TRUE

	switch(action)
		// Turns the tutorial on and off.
		if("toggle_tutorial")
			tutorial_status = !tutorial_status
			return TRUE

		// Closes the UI, reverting our loadout to before edits if params["revert"] is set
		if("close_ui")
			save_on_close = FALSE
			SStgui.close_uis(src)
			return FALSE

		if("select_item")
			if(params["deselect"])
				deselect_item(interacted_item)
			else
				select_item(interacted_item)

		// Clears the loadout list entirely.
		if("clear_all_items")
			owner.prefs.update_preference(preference, null)

		// Toggles between viewing favorite job clothes on the dummy.
		if("toggle_job_clothes")
			character_preview_view.view_job_clothes = !character_preview_view.view_job_clothes

		// Rotates the dummy left or right depending on params["dir"]
		if("rotate_dummy")
			rotate_model_dir(params["dir"])
			return TRUE

	// Default try to update
	character_preview_view.update_body()
	return TRUE

/// Select [path] item to [category_slot] slot.
/datum/loadout_manager/proc/select_item(datum/loadout_item/selected_item)
	var/num_misc_items = 0
	var/datum/loadout_item/first_misc_found
	// Future todo:
	// It's icky that we have to iterate over the global loadout list to convert it to datums
	// every time an item is selected, it really should be cached in some way
	for(var/datum/loadout_item/item as anything in loadout_list_to_datums(loadout))
		if(item.category == selected_item.category)
			if(item.category == LOADOUT_ITEM_MISC && ++num_misc_items < MAX_ALLOWED_MISC_ITEMS)
				first_misc_found ||= item
				continue

			deselect_item(first_misc_found || item)
			continue

	LAZYSET(loadout, selected_item.item_path, list())
	owner.prefs.update_preference(preference, loadout)

/// Deselect [deselected_item].
/datum/loadout_manager/proc/deselect_item(datum/loadout_item/deselected_item)
	LAZYREMOVE(loadout, deselected_item.item_path)
	owner.prefs.update_preference(preference, loadout)

/// Select [path] item to [category_slot] slot, and open up the greyscale UI to customize [path] in [category] slot.
/datum/loadout_manager/proc/select_item_color(datum/loadout_item/item)
	if(menu)
		to_chat(owner, span_warning("You already have a greyscaling window open!"))
		return

	var/obj/item/colored_item = item.item_path

	var/list/allowed_configs = list()
	if(initial(colored_item.greyscale_config))
		allowed_configs += "[initial(colored_item.greyscale_config)]"
	if(initial(colored_item.greyscale_config_worn))
		allowed_configs += "[initial(colored_item.greyscale_config_worn)]"
	if(initial(colored_item.greyscale_config_inhand_left))
		allowed_configs += "[initial(colored_item.greyscale_config_inhand_left)]"
	if(initial(colored_item.greyscale_config_inhand_right))
		allowed_configs += "[initial(colored_item.greyscale_config_inhand_right)]"

	var/slot_starting_colors = loadout?[colored_item]?[INFO_GREYSCALE] || initial(colored_item.greyscale_colors)

	menu = new(
		src,
		usr,
		allowed_configs,
		CALLBACK(src, PROC_REF(set_slot_greyscale), item),
		starting_icon_state = initial(colored_item.icon_state),
		starting_config = initial(colored_item.greyscale_config),
		starting_colors = slot_starting_colors,
	)
	RegisterSignal(menu, COMSIG_PARENT_PREQDELETED, TYPE_PROC_REF(/datum/loadout_manager, cleanup_greyscale_menu))
	menu.ui_interact(usr)

/// A proc to make sure our menu gets null'd properly when it's deleted.
/// If we delete the greyscale menu from the greyscale datum, we don't null it correctly here, it harddels.
/datum/loadout_manager/proc/cleanup_greyscale_menu(datum/source)
	SIGNAL_HANDLER

	menu = null

/// Sets [category_slot]'s greyscale colors to the colors in the currently opened [open_menu].
/datum/loadout_manager/proc/set_slot_greyscale(datum/loadout_item/item, datum/greyscale_modify_menu/open_menu)
	if(!open_menu)
		CRASH("set_slot_greyscale called without a greyscale menu!")

	var/raw_path = item.item_path
	if(!loadout?[raw_path])
		select_item(item)

	var/list/colors = open_menu.split_colors
	if(!colors)
		return

	loadout[raw_path][INFO_GREYSCALE] = colors.Join("")
	owner.prefs.update_preference(preference, loadout)
	character_preview_view.update_body()

/// Set [item]'s name to input provided.
/datum/loadout_manager/proc/set_item_name(datum/loadout_item/item)
	var/current_name = loadout?[item.item_path]?[INFO_NAMED]
	var/raw_path = item.item_path
	var/input_name = stripped_input(owner, "What name do you want to give [item.name]? Leave blank to clear.", "[item.name] name", current_name, MAX_NAME_LEN)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(owner.prefs))
		return

	if(!loadout?[raw_path])
		select_item(item)

	if(input_name)
		loadout[raw_path][INFO_NAMED] = input_name
	else
		loadout[raw_path] -= INFO_NAMED

	owner.prefs.update_preference(preference, loadout)

/// Set [item]'s skin.
/datum/loadout_manager/proc/set_skin(datum/loadout_item/item)
	var/raw_path = item.item_path
	var/current_reskin = loadout?[raw_path]?[INFO_RESKIN]
	var/obj/item/item_template = new raw_path()
	var/list/choices = item_template.unique_reskin.Copy()
	choices["Default"] = 1
	qdel(item_template)

	var/input_skin = tgui_input_list(owner, "What skin do you want this to be?", "Reskin", choices, current_reskin)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(owner.prefs))
		return

	if(!loadout?[raw_path])
		select_item(item)

	if(!input_skin || input_skin == "Default")
		loadout[raw_path] -= INFO_RESKIN
	else
		loadout[raw_path][INFO_RESKIN] = input_skin

	owner.prefs.update_preference(preference, loadout)

/// Set [item]'s layer, for accessories.
/datum/loadout_manager/proc/set_layer(datum/loadout_item/accessory/item)
	var/raw_path = item.item_path
	if(!loadout?[raw_path])
		select_item(item)

	if(isnull(loadout[raw_path][INFO_LAYER]))
		loadout[raw_path][INFO_LAYER] = FALSE

	loadout[raw_path][INFO_LAYER] = !loadout[raw_path][INFO_LAYER]
	to_chat(owner, span_boldnotice("[item] will now appear [loadout[raw_path][INFO_LAYER] ? "above" : "below"] suits."))
	owner.prefs.update_preference(preference, loadout)

/// Rotate the preview [dir_string] direction.
/datum/loadout_manager/proc/rotate_model_dir(dir_string)
	if(dir_string == "left")
		character_preview_view.dir = turn(character_preview_view.dir, -90)
	else
		character_preview_view.dir = turn(character_preview_view.dir, 90)

/datum/loadout_manager/ui_data(mob/user)
	var/list/data = list()

	if (isnull(character_preview_view))
		character_preview_view = create_character_preview_view(user)

	var/list/all_selected_paths = list()
	for(var/path in owner.prefs.read_preference(/datum/preference/loadout))
		all_selected_paths += path

	data["selected_loadout"] = all_selected_paths
	data["mob_name"] = owner.prefs.read_preference(/datum/preference/name/real_name)
	data["job_clothes"] = character_preview_view.view_job_clothes
	data["tutorial_status"] = tutorial_status
	if(tutorial_status)
		data["tutorial_text"] = get_tutorial_text()

	return data

/datum/loadout_manager/ui_static_data()
	var/list/data = list()

	data["character_preview_view"] = character_preview_view.assigned_map

	// [name] is the name of the tab that contains all the corresponding contents.
	// [title] is the name at the top of the list of corresponding contents.
	// [contents] is a formatted list of all the possible items for that slot.
	//  - [contents.path] is the path the singleton datum holds
	//  - [contents.name] is the name of the singleton datum
	//  - [contents.is_renamable], whether the item can be renamed in the UI
	//  - [contents.is_greyscale], whether the item can be greyscaled in the UI
	//  - [contents.tooltip_text], any additional tooltip text that hovers over the item's select button

	var/list/loadout_tabs = list()
	loadout_tabs += list(list("name" = "Belt", "title" = "Belt Slot Items", "contents" = list_to_data(GLOB.loadout_belts)))
	loadout_tabs += list(list("name" = "Ears", "title" = "Ear Slot Items", "contents" = list_to_data(GLOB.loadout_ears)))
	loadout_tabs += list(list("name" = "Glasses", "title" = "Glasses Slot Items", "contents" = list_to_data(GLOB.loadout_glasses)))
	loadout_tabs += list(list("name" = "Gloves", "title" = "Glove Slot Items", "contents" = list_to_data(GLOB.loadout_gloves)))
	loadout_tabs += list(list("name" = "Head", "title" = "Head Slot Items", "contents" = list_to_data(GLOB.loadout_helmets)))
	loadout_tabs += list(list("name" = "Mask", "title" = "Mask Slot Items", "contents" = list_to_data(GLOB.loadout_masks)))
	loadout_tabs += list(list("name" = "Neck", "title" = "Neck Slot Items", "contents" = list_to_data(GLOB.loadout_necks)))
	loadout_tabs += list(list("name" = "Shoes", "title" = "Shoe Slot Items", "contents" = list_to_data(GLOB.loadout_shoes)))
	loadout_tabs += list(list("name" = "Suit", "title" = "Suit Slot Items", "contents" = list_to_data(GLOB.loadout_exosuits)))
	loadout_tabs += list(list("name" = "Jumpsuit", "title" = "Uniform Slot Items", "contents" = list_to_data(GLOB.loadout_jumpsuits)))
	loadout_tabs += list(list("name" = "Formal", "title" = "Uniform Slot Items (cont)", "contents" = list_to_data(GLOB.loadout_undersuits)))
	loadout_tabs += list(list("name" = "Accessory", "title" = "Uniform Accessory Slot Items", "contents" = list_to_data(GLOB.loadout_accessory)))
	loadout_tabs += list(list("name" = "Inhand", "title" = "In-hand Items", "contents" = list_to_data(GLOB.loadout_inhand_items)))
	loadout_tabs += list(list("name" = "Other", "title" = "Backpack Items ([MAX_ALLOWED_MISC_ITEMS] max)", "contents" = list_to_data(GLOB.loadout_pocket_items)))

	data["loadout_tabs"] = loadout_tabs

	return data

/// Returns a formatted string for use in the UI.
/datum/loadout_manager/proc/get_tutorial_text()
	return {"This is the Loadout Manager.
It allows you to customize what your character will wear on shift start in addition to their job's uniform.

Only one item can be selected per tab, with the exception of backpack items (three items are allowed in total).

Some items have tooltips displaying additional information about how they work.
Some items are compatible with greyscale coloring! You can choose what color they spawn as
by selecting the item, then by pressing the paint icon next to it and using the greyscaling UI.

Your loadout items will override the corresponding item in your job's outfit,
with the exception being BELT, EAR, and GLASSES items,
which will be placed in your backpack to prevent important items being deleted.

Additionally, UNDERSUITS, HELMETS, MASKS, and GLOVES loadout items
selected by plasmamen will spawn in their backpack instead of overriding their clothes
to avoid an untimely and sudden death by fire or suffocation at the start of the shift."}

/**
 * Takes an assoc list of [typepath]s to [singleton datum]
 * And formats it into an object for TGUI.
 *
 * - list[name] is the name of the datum.
 * - list[path] is the typepath of the item.
 */
/datum/loadout_manager/proc/list_to_data(list_of_datums)
	if(!LAZYLEN(list_of_datums))
		return

	var/list/formatted_list = new(length(list_of_datums))

	var/array_index = 1
	for(var/datum/loadout_item/item as anything in list_of_datums)
		var/list/formatted_item = list()
		formatted_item["name"] = item.name
		formatted_item["path"] = item.item_path
		formatted_item["is_greyscale"] = item.can_be_greyscale
		formatted_item["is_renamable"] = item.can_be_named
		formatted_item["is_reskinnable"] = item.can_be_reskinned

		// This pains me on a deep level
		formatted_item["is_layer_adjustable"] = FALSE
		if(istype(item, /datum/loadout_item/accessory))
			var/datum/loadout_item/accessory/accessory = item
			formatted_item["is_layer_adjustable"] = accessory.can_be_layer_adjusted

		if(LAZYLEN(item.additional_tooltip_contents))
			formatted_item["tooltip_text"] = item.additional_tooltip_contents.Join("\n")

		formatted_list[array_index++] = formatted_item

	return formatted_list
