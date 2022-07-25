/// -- The loadout manager and UI --
/// Tracking when a client has an open loadout manager, to prevent funky stuff.
/client
	/// A ref to loadout_manager datum.
	var/datum/loadout_manager/open_loadout_ui = null

/// Datum holder for the loadout manager UI.
/datum/loadout_manager
	/// The client of the person using the UI
	var/client/owner
	/// The current selected loadout list.
	var/list/loadout_on_open
	/// The preview dummy. //TODO: closing makes the main menu wonky
	var/atom/movable/screen/character_preview_view/character_preview_view
	/// Whether we see our favorite job's clothes on the dummy
	var/view_job_clothes = TRUE
	/// Whether we see tutorial text in the UI
	var/tutorial_status = FALSE
	/// Our currently open greyscaling menu.
	var/datum/greyscale_modify_menu/menu

/datum/loadout_manager/New(user)
	owner = CLIENT_FROM_VAR(user)
	owner.open_loadout_ui = src
	var/list/our_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	loadout_on_open = LAZYLISTDUPLICATE(our_loadout_list)

/datum/loadout_manager/Destroy(force, ...)
	QDEL_NULL(character_preview_view)
	QDEL_NULL(menu)
	return ..()

/datum/loadout_manager/ui_close(mob/user)
	owner?.prefs.save_character()
	if(menu)
		SStgui.close_uis(menu)
		menu = null
	owner?.open_loadout_ui = null
	qdel(src)

/// Initialize our character dummy.
/datum/loadout_manager/proc/create_character_preview_view(mob/user)
	character_preview_view = new(null, owner?.prefs, user.client)
	reset_outfit()
	character_preview_view.register_to_client(user.client)

	return character_preview_view

/datum/loadout_manager/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_LoadoutManager")
		ui.open()

		addtimer(CALLBACK(character_preview_view, /atom/movable/screen/character_preview_view/proc/update_body), 1 SECONDS)

/datum/loadout_manager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/loadout_item/interacted_item
	if(params["path"])
		interacted_item = GLOB.all_loadout_datums[text2path(params["path"])]
		if(!interacted_item)
			stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
			return

	switch(action)
		// Turns the tutorial on and off.
		if("toggle_tutorial")
			tutorial_status = !tutorial_status
			return TRUE

		// Closes the UI, reverting our loadout to before edits if params["revert"] is set
		if("close_ui")
			if(params["revert"])
				owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], loadout_on_open)
			SStgui.close_uis(src)
			return FALSE

		// Future todo: This can be de-hardcoded and handled on loadout items themselves, may be neat.
		if("select_color")
			if(!interacted_item.can_be_greyscale)
				return

			select_item_color(interacted_item)
			return TRUE

		if("set_name")
			if(!interacted_item.can_be_named)
				return

			set_item_name(interacted_item)
			return TRUE

		if("set_skin")
			if(!interacted_item.can_be_reskinned)
				return

			set_skin(interacted_item)
			return TRUE

		if("set_layer")
			if(!istype(interacted_item, /datum/loadout_item/accessory))
				return
			var/datum/loadout_item/accessory/accessory = interacted_item
			if(!accessory.can_be_layer_adjusted)
				return

			set_layer(interacted_item)
			return TRUE

		if("select_item")
			if(params["deselect"])
				deselect_item(interacted_item)
			else
				select_item(interacted_item)

		// Clears the loadout list entirely.
		if("clear_all_items")
			owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], null)

		// Toggles between viewing favorite job clothes on the dummy.
		if("toggle_job_clothes")
			view_job_clothes = !view_job_clothes

		// Rotates the dummy left or right depending on params["dir"]
		if("rotate_dummy")
			rotate_model_dir(params["dir"])

	reset_outfit()
	return TRUE

/// Select [path] item to [category_slot] slot.
/datum/loadout_manager/proc/select_item(datum/loadout_item/selected_item)
	var/num_misc_items = 0
	var/datum/loadout_item/first_misc_found
	for(var/datum/loadout_item/item as anything in loadout_list_to_datums(owner.prefs.read_preference(/datum/preference/loadout)))
		if(item.category == selected_item.category)
			if(item.category == LOADOUT_ITEM_MISC && ++num_misc_items < MAX_ALLOWED_MISC_ITEMS)
				if(!first_misc_found)
					first_misc_found = item
				continue

			deselect_item(first_misc_found || item)
			continue

	var/list/new_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	LAZYSET(new_loadout_list, selected_item.item_path, list())
	owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], new_loadout_list)

/// Deselect [deselected_item].
/datum/loadout_manager/proc/deselect_item(datum/loadout_item/deselected_item)
	var/list/new_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	LAZYREMOVE(new_loadout_list, deselected_item.item_path)
	owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], new_loadout_list)

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

	var/slot_starting_colors = initial(colored_item.greyscale_colors)
	var/list/our_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	if(INFO_GREYSCALE in our_loadout_list)
		slot_starting_colors = our_loadout_list[colored_item][INFO_GREYSCALE]

	menu = new(
		src,
		usr,
		allowed_configs,
		CALLBACK(src, .proc/set_slot_greyscale, colored_item),
		starting_icon_state = initial(colored_item.icon_state),
		starting_config = initial(colored_item.greyscale_config),
		starting_colors = slot_starting_colors,
	)
	RegisterSignal(menu, COMSIG_PARENT_PREQDELETED, /datum/loadout_manager.proc/cleanup_greyscale_menu)
	menu.ui_interact(usr)

/// A proc to make sure our menu gets null'd properly when it's deleted.
/// If we delete the greyscale menu from the greyscale datum, we don't null it correctly here, it harddels.
/datum/loadout_manager/proc/cleanup_greyscale_menu(datum/source)
	SIGNAL_HANDLER

	menu = null

/// Sets [category_slot]'s greyscale colors to the colors in the currently opened [open_menu].
/datum/loadout_manager/proc/set_slot_greyscale(path, datum/greyscale_modify_menu/open_menu)
	if(!open_menu)
		CRASH("set_slot_greyscale called without a greyscale menu!")

	var/list/our_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	if(!(path in our_loadout_list))
		to_chat(owner, span_warning("Select the item before attempting to apply greyscale to it!"))
		return

	var/list/colors = open_menu.split_colors
	if(colors)
		our_loadout_list[path][INFO_GREYSCALE] = colors.Join("")
		owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout_list)
		reset_outfit()

/// Set [item]'s name to input provided.
/datum/loadout_manager/proc/set_item_name(datum/loadout_item/item)
	var/current_name = ""
	var/list/our_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	if(INFO_NAMED in our_loadout_list)
		current_name = our_loadout_list[item.item_path][INFO_NAMED]

	var/input_name = stripped_input(owner, "What name do you want to give [item.name]? Leave blank to clear.", "[item.name] name", current_name, MAX_NAME_LEN)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(owner.prefs))
		return

	if(!(item.item_path in our_loadout_list))
		to_chat(owner, span_warning("Select the item before attempting to name to it!"))
		return

	if(input_name)
		our_loadout_list[item.item_path][INFO_NAMED] = input_name
		owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout_list)

	else if(INFO_NAMED in our_loadout_list[item.item_path])
		our_loadout_list[item.item_path] -= INFO_NAMED
		owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout_list)

/// Set [item]'s skin.
/datum/loadout_manager/proc/set_skin(datum/loadout_item/item)
	var/current_reskin = ""
	var/list/our_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	if(INFO_RESKIN in our_loadout_list)
		current_reskin = our_loadout_list[item.item_path][INFO_RESKIN]

	var/obj/item/item_template = new item.item_path()
	var/list/choices = item_template.unique_reskin.Copy()
	choices["Default"] = 1
	qdel(item_template)

	var/input_skin = tgui_input_list(owner, "What skin do you want this to be?", "Reskin", choices, current_reskin)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(owner.prefs))
		return

	if(!(item.item_path in our_loadout_list))
		to_chat(owner, span_warning("Select the item before attempting to reskin to it!"))
		return

	if(!input_skin || input_skin == "Default")
		if(INFO_RESKIN in our_loadout_list[item.item_path])
			our_loadout_list[item.item_path] -= INFO_RESKIN
			owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout_list)

	else
		our_loadout_list[item.item_path][INFO_RESKIN] = input_skin
		owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout_list)

/// Set [item]'s layer, for accessories.
/datum/loadout_manager/proc/set_layer(datum/loadout_item/accessory/item)
	var/list/our_loadout_list = owner.prefs.read_preference(/datum/preference/loadout)
	if(!(item.item_path in our_loadout_list))
		to_chat(owner, span_warning("Select the item before attempting to modify its layer to it!"))
		return

	our_loadout_list[item.item_path][INFO_LAYER] = !our_loadout_list[item.item_path][INFO_LAYER]
	to_chat(owner, span_boldnotice("[item] will now appear [our_loadout_list[item.item_path][INFO_LAYER] ? "above" : "below"] suits."))
	owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/loadout], our_loadout_list)

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
	else if (character_preview_view.client != owner)
		character_preview_view.register_to_client(owner)

	var/list/all_selected_paths = list()
	for(var/path in owner.prefs.read_preference(/datum/preference/loadout))
		all_selected_paths += path

	data["selected_loadout"] = all_selected_paths
	data["mob_name"] = owner.prefs.read_preference(/datum/preference/name/real_name)
	data["job_clothes"] = view_job_clothes
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
	loadout_tabs += list(list("name" = "Misc. Under", "title" = "Uniform Slot Items (cont)", "contents" = list_to_data(GLOB.loadout_miscunders)))
	loadout_tabs += list(list("name" = "Accessory", "title" = "Uniform Accessory Slot Items", "contents" = list_to_data(GLOB.loadout_accessory)))
	loadout_tabs += list(list("name" = "Inhand", "title" = "In-hand Items", "contents" = list_to_data(GLOB.loadout_inhand_items)))
	loadout_tabs += list(list("name" = "Other", "title" = "Backpack Items (3 max)", "contents" = list_to_data(GLOB.loadout_pocket_items)))

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

/// Reset our displayed loadout and re-load all its items from the bottom up.
/datum/loadout_manager/proc/reset_outfit()
	var/datum/outfit/job/default_outfit
	if(view_job_clothes)
		var/datum/job/fav_job = owner.prefs.get_highest_priority_job() || SSjob.GetJobType(SSjob.overflow_role)

		if(istype(owner.prefs.read_preference(/datum/preference/choiced/species), /datum/species/plasmaman) && fav_job.plasmaman_outfit)
			default_outfit = new fav_job.plasmaman_outfit()
		else
			default_outfit = new fav_job.outfit()
			if(owner.prefs.read_preference(/datum/preference/choiced/jumpsuit) == PREF_SKIRT)
				default_outfit.uniform = text2path("[default_outfit.uniform]/skirt")

			switch(owner.prefs.read_preference(/datum/preference/choiced/backpack))
				if(GBACKPACK)
					default_outfit.back = /obj/item/storage/backpack //Grey backpack
				if(GSATCHEL)
					default_outfit.back = /obj/item/storage/backpack/satchel //Grey satchel
				if(GDUFFELBAG)
					default_outfit.back = /obj/item/storage/backpack/duffelbag //Grey Duffel bag
				if(LSATCHEL)
					default_outfit.back = /obj/item/storage/backpack/satchel/leather //Leather Satchel
				if(DSATCHEL)
					default_outfit.back = default_outfit.satchel //Department satchel
				if(DDUFFELBAG)
					default_outfit.back = default_outfit.duffelbag //Department duffel bag
				else
					default_outfit.back = default_outfit.backpack //Department backpack
	else
		default_outfit = new /datum/outfit()

	character_preview_view.update_body_from_loadout(default_outfit)
	qdel(default_outfit)

/*
 * Similar to the update_body() proc, but accepts a [/datum/outfit] to be equipped onto the dummy
 * instead of using the highest priority job of the preferences.
 *
 * loadout - an instantiated outfit datum to be applied to the dummy
 */
/atom/movable/screen/character_preview_view/proc/update_body_from_loadout(datum/outfit/loadout)
	var/datum/job/preview_job = preferences.get_highest_priority_job()
	if(preview_job)
		if (istype(preview_job,/datum/job/ai) || istype(preview_job,/datum/job/cyborg))
			return update_body()

	if (isnull(body))
		create_body()
	else
		body.wipe_state()

	// Set up the dummy for its photoshoot
	preferences.apply_prefs_to(body, TRUE)
	body.equip_outfit_and_loadout(loadout, preferences, TRUE)

	COMPILE_OVERLAYS(body)
	appearance = body.appearance

/*
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
