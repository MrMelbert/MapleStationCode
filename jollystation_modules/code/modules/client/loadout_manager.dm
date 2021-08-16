/// -- The loadout manager and UI --
/// Tracking when a client has an open loadout manager, to prevent funky stuff.
/client
	/// A ref to loadout_manager datum.
	var/datum/loadout_manager/open_loadout_ui = null

/// Datum holder for the loadout manager UI.
/datum/loadout_manager
	/// The client of the person using the UI
	var/client/owner
	/// The loadout list we had when we opened the UI.
	var/list/loadout_on_open
	/// The key of the dummy we use to generate sprites
	var/dummy_key
	/// The dir the dummy is facing.
	var/list/dummy_dir = list(SOUTH)
	/// A ref to the dummy outfit we're using
	var/datum/outfit/player_loadout/custom_loadout
	/// Whether we see our favorite job's clothes on the dummy
	var/view_job_clothes = TRUE
	/// Whether we see tutorial text in the UI
	var/tutorial_status = FALSE
	/// Our currently open greyscaling menu.
	var/datum/greyscale_modify_menu/menu
	/// Whether we need to update our dummy sprite next ui_data or not.
	var/update_dummysprite = TRUE
	/// Our preview sprite.
	var/icon/dummysprite

/datum/loadout_manager/New(user)
	owner = CLIENT_FROM_VAR(user)
	custom_loadout = new()
	owner.open_loadout_ui = src
	loadout_on_open = LAZYLISTDUPLICATE(owner.prefs.loadout_list)
	loadout_to_outfit()

/datum/loadout_manager/ui_close(mob/user)
	owner.prefs.loadout_list = sanitize_loadout_list(owner.prefs.loadout_list)
	owner.prefs.greyscale_loadout_list = sanitize_greyscale_list(owner.prefs.greyscale_loadout_list)
	if(menu)
		SStgui.close_uis(menu)
		menu = null
	owner.open_loadout_ui = null
	clear_human_dummy(dummy_key)
	qdel(custom_loadout)
	qdel(src)

/// Initialize our dummy and dummy_key.
/datum/loadout_manager/proc/init_dummy()
	dummy_key = "loadoutmanagerUI_[owner.mob]"
	generate_dummy_lookalike(dummy_key, owner.mob)
	unset_busy_human_dummy(dummy_key)
	return

/datum/loadout_manager/ui_state(mob/user)
	return GLOB.always_state

/datum/loadout_manager/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_LoadoutManager")
		ui.open()

/datum/loadout_manager/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/loadout_item/interacted_item
	if(params["path"])
		interacted_item = GLOB.all_loadout_datums[params["path"]]
		if(!interacted_item)
			stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
			return

	switch(action)
		// Turns the tutorial on and off.
		if("toggle_tutorial")
			tutorial_status = !tutorial_status
			return TRUE

		// Either equips or de-equips the params["path"] item into params["category"]
		if("select_item")
			if(params["deselect"])
				deselect_item(interacted_item)
			else
				select_item(interacted_item)

		if("select_color")
			select_item_color(interacted_item)

		// Clears the loadout list entirely.
		if("clear_all_items")
			LAZYNULL(owner.prefs.loadout_list)
			LAZYNULL(owner.prefs.greyscale_loadout_list)

		// Toggles between viewing favorite job clothes on the dummy.
		if("toggle_job_clothes")
			view_job_clothes = !view_job_clothes

		// Rotates the dummy left or right depending on params["dir"]
		if("rotate_dummy")
			rotate_model_dir(params["dir"])

		// Toggles between showing all dirs of the dummy at once.
		if("show_all_dirs")
			toggle_model_dirs()

		// Closes the UI, reverting our loadout to before edits if params["revert"] is set
		if("close_ui")
			if(params["revert"])
				owner.prefs.loadout_list = loadout_on_open
			SStgui.close_uis(src)
			return

	// Always update our loadout after we do something.
	loadout_to_outfit()
	update_dummysprite = TRUE
	return TRUE

/// Select [path] item to [category_slot] slot. If it's not a greyscale item, clear the corresponding greyscale slot too.
/datum/loadout_manager/proc/select_item(datum/loadout_item/selected_item)
	if(!selected_item.is_greyscale)
		clear_slot_greyscale(selected_item.category_slot)
	LAZYADD(selected_item.item_path)

/// Deselect [delected_item] item. If it's not a greyscale item, clear the corresponding greyscale slot too.
/datum/loadout_manager/proc/deselect_item(datum/loadout_item/delected_item)
	if(!delected_item.is_greyscale)
		// If we're not a greyscale item, clear any greyscale config associated with our slot
		clear_slot_greyscale(delected_item.item_path)

	LAZYREMOVE(owner.prefs.loadout_list, delected_item.item_path)
	loadout_to_outfit() // We call this here so we `null` the slot correctly

/// Select [path] item to [category_slot] slot, and open up the greyscale UI to customize [path] in [category] slot.
/datum/loadout_manager/proc/select_item_color(datum/loadout_item/item)
	if(menu)
		to_chat(owner, span_warning("You already have a greyscaling window open!"))
		return

	var/obj/item/colored_item = new item.item_path

	var/list/allowed_configs = list()
	if(colored_item.greyscale_config)
		allowed_configs += "[colored_item.greyscale_config]"
	if(colored_item.greyscale_config_worn)
		allowed_configs += "[colored_item.greyscale_config_worn]"
	if(colored_item.greyscale_config_inhand_left)
		allowed_configs += "[colored_item.greyscale_config_inhand_left]"
	if(colored_item.greyscale_config_inhand_right)
		allowed_configs += "[colored_item.greyscale_config_inhand_right]"

	var/slot_starting_colors = colored_item.greyscale_colors
	if(owner.prefs.greyscale_loadout_list && owner.prefs.greyscale_loadout_list[delected_item.item_path])
		slot_starting_colors = owner.prefs.greyscale_loadout_list[delected_item.item_path]

	var/datum/greyscale_config/current_config = SSgreyscale.configurations[colored_item.greyscale_config]
	if(current_config && !current_config.icon_states)
		to_chat(owner, span_warning("This item isn't properly configured for greyscaling! Complain to a coder!"))
		CRASH("Loadout manager attempted to pass greyscale item without icon_states into greyscale modification menu!")

	menu = new(
		src,
		usr,
		allowed_configs,
		CALLBACK(src, .proc/set_slot_greyscale, item),
		starting_icon_state=colored_item.icon_state,
		starting_config=colored_item.greyscale_config,
		starting_colors=slot_starting_colors,
	)
	RegisterSignal(menu, COMSIG_PARENT_PREQDELETED, /datum/loadout_manager.proc/cleanup_greyscale_menu)
	menu.ui_interact(usr)
	qdel(colored_item)

/// A proc to make sure our menu gets null'd properly when it's deleted.
/// If we delete the greyscale menu from the greyscale datum, we don't null it correctly here, and it harddels.
/datum/loadout_manager/proc/cleanup_greyscale_menu(datum/source)
	SIGNAL_HANDLER

	menu = null

/// Sets [category_slot]'s greyscale colors to the colors in the currently opened [open_menu].
/datum/loadout_manager/proc/set_slot_greyscale(datum/loadout_item/item, datum/greyscale_modify_menu/open_menu)
	if(!open_menu)
		CRASH("set_slot_greyscale called without a greyscale menu!")

	if(!(item in owner.prefs.loadout_list))
		to_chat(owner, span_warning("Select the item before attempting to apply greyscale to it!"))
		return

	var/list/colors = open_menu.split_colors
	if(colors)
		LAZYSET(owner.prefs.greyscale_loadout_list, item.path, colors.Join(""))
	update_dummysprite = TRUE

/// Clears [category_slot]'s greyscale colors.
/datum/loadout_manager/proc/clear_slot_greyscale(path)
	LAZYREMOVE(owner.prefs.greyscale_loadout_list, path)

/// Rotate the dummy [DIR] direction, or reset it to SOUTH dir if we're showing all dirs at once.
/datum/loadout_manager/proc/rotate_model_dir(dir)
	if(dummy_dir.len > 1)
		dummy_dir = list(SOUTH)
	else
		if(dir == "left")
			switch(dummy_dir[1])
				if(SOUTH)
					dummy_dir[1] = WEST
				if(EAST)
					dummy_dir[1] = SOUTH
				if(NORTH)
					dummy_dir[1] = EAST
				if(WEST)
					dummy_dir[1] = NORTH
		else
			switch(dummy_dir[1])
				if(SOUTH)
					dummy_dir[1] = EAST
				if(EAST)
					dummy_dir[1] = NORTH
				if(NORTH)
					dummy_dir[1] = WEST
				if(WEST)
					dummy_dir[1] = SOUTH

/// Toggle between showing all the dirs and just the front dir of the dummy.
/datum/loadout_manager/proc/toggle_model_dirs()
	if(dummy_dir.len > 1)
		dummy_dir = list(SOUTH)
	else
		dummy_dir = GLOB.cardinals

/datum/loadout_manager/ui_data(mob/user)
	var/list/data = list()

	data["icon64"] = generate_preview()

	data["selected_loadout"] = owner.prefs.loadout_list
	data["mob_name"] = owner.prefs.real_name
	data["ismoth"] = istype(owner.prefs.pref_species, /datum/species/moth) // Moth's humanflaticcon isn't the same dimensions for some reason
	data["job_clothes"] = view_job_clothes
	data["tutorial_status"] = tutorial_status
	if(tutorial_status)
		data["tutorial_text"] = get_tutorial_text()

	return data

/datum/loadout_manager/ui_static_data()
	var/list/data = list()

	// [name] is the displayed name of the slot.
	// [contents] is a formatted list of all the possible items for that slot.
	//  - [contents.ref] is the reference to the singleton datums
	//  - [contents.name] is the name of the singleton datums

	var/list/loadout_tabs = list()
	loadout_tabs += list(list("name" = "Belt", "contents" = list_to_data(GLOB.loadout_belts)))
	loadout_tabs += list(list("name" = "Ears", "contents" = list_to_data(GLOB.loadout_ears)))
	loadout_tabs += list(list("name" = "Glasses", "contents" = list_to_data(GLOB.loadout_glasses)))
	loadout_tabs += list(list("name" = "Gloves", "contents" = list_to_data(GLOB.loadout_gloves)))
	loadout_tabs += list(list("name" = "Head", "contents" = list_to_data(GLOB.loadout_helmets)))
	loadout_tabs += list(list("name" = "Mask", "contents" = list_to_data(GLOB.loadout_masks)))
	loadout_tabs += list(list("name" = "Neck", "contents" = list_to_data(GLOB.loadout_necks)))
	loadout_tabs += list(list("name" = "Shoes", "contents" = list_to_data(GLOB.loadout_shoes)))
	loadout_tabs += list(list("name" = "Suit", "contents" = list_to_data(GLOB.loadout_exosuits)))
	loadout_tabs += list(list("name" = "Jumpsuit", "contents" = list_to_data(GLOB.loadout_jumpsuits)))
	loadout_tabs += list(list("name" = "Formal", "contents" = list_to_data(GLOB.loadout_undersuits)))
	loadout_tabs += list(list("name" = "Misc. Under", "contents" = list_to_data(GLOB.loadout_miscunders)))
	loadout_tabs += list(list("name" = "Accessory", "contents" = list_to_data(GLOB.loadout_accessory)))
	loadout_tabs += list(list("name" = "Inhand (2 max)", "contents" = list_to_data(GLOB.loadout_inhand_items)))
	loadout_tabs += list(list("name" = "Misc. (3 max)", "contents" = list_to_data(GLOB.loadout_pocket_items)))

	data["loadout_tabs"] = loadout_tabs

	return data

/// Generate a flat icon preview of our user, if we need to update it.
/datum/loadout_manager/proc/generate_preview()
	if(!dummy_key)
		init_dummy()

	if(update_dummysprite)
		dummysprite = get_flat_human_icon(
			null,
			dummy_key = dummy_key,
			outfit_override = custom_loadout,
			showDirs = dummy_dir,
			prefs = owner.prefs,
			)
		update_dummysprite = FALSE

	return icon2base64(dummysprite)

/// Returns a formatted string for use in the UI.
/datum/loadout_manager/proc/get_tutorial_text()
	return {"This is the Loadout Manager.
It allows you to customize what your character will wear on shift start in addition to their job's uniform.

Only one item can be selected per tab, with some exceptions.
Inhand items (one item is allowed per hand)
Miscellaneous items (three items are allowed in total - they will spawn in your backpack or attached to your jumpsuit).

Some items have tooltips displaying additional information about how they work.
Some items are compatible with greyscale coloring! You can choose what color they spawn as
by selecting the item, then by pressing the paint icon next to it and using the greyscaling UI.

Your loadout items will override the corresponding item in your job's outfit,
with the exception being BELT, EAR, and GLASSES items,
which will be placed in your backpack to prevent important items being deleted.

Additionally, UNDERSUITS, HELMETS, MASKS, and GLOVES loadout items
selected by plasmamen will spawn in their backpack instead of overriding their clothes
to avoid an untimely and sudden death by fire or suffocation at the start of the shift."}

/// Turns our client's assoc list of loadout items into actual items on our dummy outfit.
/// Also loads job clothes into our custom list to show what gets overriden.
/datum/loadout_manager/proc/loadout_to_outfit()
	var/datum/outfit/default_outfit
	if(view_job_clothes)
		var/datum/job/fav_job = SSjob.GetJobType(SSjob.overflow_role)
		for(var/selected_job in owner.prefs.job_preferences)
			if(owner.prefs.job_preferences[selected_job] == JP_HIGH)
				fav_job = SSjob.GetJob(selected_job)
				break

		if(istype(owner.prefs.pref_species, /datum/species/plasmaman) && fav_job.plasmaman_outfit)
			default_outfit = new fav_job.plasmaman_outfit()
		else
			default_outfit = new fav_job.outfit()
	else
		default_outfit = new()

	custom_loadout.copy_from(default_outfit)
	qdel(default_outfit)

	for(var/path in owner.prefs.loadout_list)
		var/datum/loadout_item/item = GLOB.all_loadout_datums[path]
		if(!item)
			continue

		item.insert_path_into_outfit(custom_loadout, visual = TRUE)

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

		formatted_item["name"] = item.name
		formatted_item["path"] = item.item_path
		formatted_item["is_greyscale"] = item.is_greyscale
		if(LAZYLEN(item.additional_tooltip_contents))
			formatted_item["tooltip_text"] = item.additional_tooltip_contents.Join("\n")

		formatted_list[array_index++] = formatted_item

	return formatted_list
