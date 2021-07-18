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

/datum/loadout_manager/New(user)
	owner = CLIENT_FROM_VAR(user)
	custom_loadout = new()
	owner.open_loadout_ui = src
	LAZYINITLIST(owner.prefs.loadout_list)
	loadout_on_open = owner.prefs.loadout_list.Copy()
	loadout_to_outfit()

/datum/loadout_manager/ui_close(mob/user)
	sanitize_loadout_list(owner.prefs.loadout_list)
	sanitize_greyscale_list(owner.prefs.greyscale_loadout_list)
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

	switch(action)
		// Turns the tutorial on and off.
		if("toggle_tutorial")
			tutorial_status = !tutorial_status

		// Either equips or de-equips the params["path"] item into params["category"]
		if("select_item")
			if(params["deselect"])
				deselect_item(params["path"], params["category"], params["greyscale"])
			else
				select_item(params["path"], params["category"], params["greyscale"])

		if("select_color")
			select_item_color(params["path"], params["category"])

		// Clears the loadout list entirely.
		if("clear_all_items")
			owner.prefs.loadout_list.Cut()
			if(owner.prefs.greyscale_loadout_list)
				owner.prefs.greyscale_loadout_list = null

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
	return TRUE

/// Select [path] item to [category_slot] slot. If it's not a greyscale item, clear the corresponding greyscale slot too.
/datum/loadout_manager/proc/select_item(path, category_slot, greyscale)
	var/list/loadout_list = owner.prefs.loadout_list
	if(category_slot == LOADOUT_ITEM_MISC)
		if(!loadout_list[LOADOUT_ITEM_BACKPACK_1])
			category_slot = LOADOUT_ITEM_BACKPACK_1
		else if(!loadout_list[LOADOUT_ITEM_BACKPACK_2])
			category_slot = LOADOUT_ITEM_BACKPACK_2
		else
			category_slot = LOADOUT_ITEM_BACKPACK_3
	if(category_slot == LOADOUT_ITEM_INHAND)
		if(!loadout_list[LOADOUT_ITEM_LEFT_HAND])
			category_slot = LOADOUT_ITEM_LEFT_HAND
		else
			category_slot = LOADOUT_ITEM_RIGHT_HAND

	if(!greyscale)
		clear_slot_greyscale(category_slot)
	loadout_list[category_slot] = path

/// Deselect [path] item from [category_slot] slot. If it's not a greyscale item, clear the corresponding greyscale slot too.
/datum/loadout_manager/proc/deselect_item(path, category_slot, greyscale)
	if(category_slot == LOADOUT_ITEM_MISC || category_slot == LOADOUT_ITEM_INHAND)
		category_slot = find_path_in_list(path)

	if(!greyscale)
		// If we're not a greyscale item, clear any greyscale config associated with our slot
		clear_slot_greyscale(category_slot)

	owner.prefs.loadout_list[category_slot] = null
	loadout_to_outfit() // We call this here so we `null` the slot correctly
	owner.prefs.loadout_list -= category_slot

/// Select [path] item to [category_slot] slot, and open up the greyscale UI to customize [path] in [category] slot.
/datum/loadout_manager/proc/select_item_color(path, category_slot)
	if(menu)
		to_chat(owner, span_warning("You already have a greyscaling window open!"))
		return

	var/obj/item/colored_item = new path

	var/list/allowed_configs = list()
	if(colored_item.greyscale_config)
		allowed_configs += "[colored_item.greyscale_config]"
	if(colored_item.greyscale_config_worn)
		allowed_configs += "[colored_item.greyscale_config_worn]"
	if(colored_item.greyscale_config_inhand_left)
		allowed_configs += "[colored_item.greyscale_config_inhand_left]"
	if(colored_item.greyscale_config_inhand_right)
		allowed_configs += "[colored_item.greyscale_config_inhand_right]"

	if(category_slot == LOADOUT_ITEM_MISC || category_slot == LOADOUT_ITEM_INHAND)
		category_slot = find_path_in_list(path)

	var/slot_starting_colors = colored_item.greyscale_colors
	if(owner.prefs.greyscale_loadout_list && owner.prefs.greyscale_loadout_list[category_slot])
		slot_starting_colors = owner.prefs.greyscale_loadout_list[category_slot]

	var/datum/greyscale_config/current_config = SSgreyscale.configurations[colored_item.greyscale_config]
	if(current_config && !current_config.icon_states)
		to_chat(owner, span_warning("This item isn't properly configured for greyscaling! Complain to a coder!"))
		CRASH("Loadout manager attempted to pass greyscale item without icon_states into greyscale modification menu!")

	menu = new(
		src,
		usr,
		allowed_configs,
		CALLBACK(src, .proc/set_slot_greyscale, category_slot),
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
/datum/loadout_manager/proc/set_slot_greyscale(category_slot, datum/greyscale_modify_menu/open_menu)
	if(!open_menu)
		CRASH("set_slot_greyscale called without a greyscale menu!")

	var/list/loadout = owner.prefs.loadout_list

	if(!loadout[category_slot])
		to_chat(owner, span_warning("Select the item before attempting to apply greyscale to it!"))
		return

	var/list/colors = open_menu.split_colors
	if(colors)
		if(!owner.prefs.greyscale_loadout_list)
			owner.prefs.greyscale_loadout_list = list()
		owner.prefs.greyscale_loadout_list[category_slot] = colors.Join("")

/// Clears [category_slot]'s greyscale colors.
/datum/loadout_manager/proc/clear_slot_greyscale(category_slot)
	if(!owner.prefs.greyscale_loadout_list)
		return
	if(!owner.prefs.greyscale_loadout_list[category_slot])
		return

	owner.prefs.greyscale_loadout_list[category_slot] = null
	owner.prefs.greyscale_loadout_list -= category_slot
	if(!owner.prefs.greyscale_loadout_list.len)
		owner.prefs.greyscale_loadout_list = null

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
	if(!dummy_key)
		init_dummy()

	var/icon/dummysprite = get_flat_human_icon(null,
		dummy_key = dummy_key,
		outfit_override = custom_loadout,
		showDirs = dummy_dir,
		prefs = owner.prefs,
		)
	data["icon64"] = icon2base64(dummysprite)

	var/list/all_selected_paths = list()
	for(var/path_id in owner.prefs.loadout_list)
		all_selected_paths += owner.prefs.loadout_list[path_id]

	data["selected_loadout"] = all_selected_paths
	data["mob_name"] = owner.prefs.real_name
	data["ismoth"] = istype(owner.prefs.pref_species, /datum/species/moth) // Moth's humanflaticcon isn't the same dimensions for some reason
	data["job_clothes"] = view_job_clothes
	data["tutorial_status"] = tutorial_status
	if(tutorial_status)
		data["tutorial_text"] = get_tutorial_text()

	return data

/datum/loadout_manager/ui_static_data()
	var/list/data = list()

	// [ID] is the displayed name of the slot.
	// [slot] is the internal name of the slot.
	// [contents] is a formatted list of all the possible items for that slot.
	//  - [contents.name] is the key of the item in the global assoc list.
	//  - [contents.path] is the typepath of the item in the global assoc list.
	var/list/loadout_tabs = list()
	loadout_tabs += list(list("id" = "Belt", "slot" = LOADOUT_ITEM_BELT, "contents" = list_to_data(GLOB.loadout_belts)))
	loadout_tabs += list(list("id" = "Ears", "slot" = LOADOUT_ITEM_EARS, "contents" = list_to_data(GLOB.loadout_ears)))
	loadout_tabs += list(list("id" = "Glasses", "slot" = LOADOUT_ITEM_GLASSES, "contents" = list_to_data(GLOB.loadout_glasses)))
	loadout_tabs += list(list("id" = "Gloves", "slot" = LOADOUT_ITEM_GLOVES, "contents" = list_to_data(GLOB.loadout_gloves)))
	loadout_tabs += list(list("id" = "Head", "slot" = LOADOUT_ITEM_HEAD, "contents" = list_to_data(GLOB.loadout_helmets)))
	loadout_tabs += list(list("id" = "Mask", "slot" = LOADOUT_ITEM_MASK, "contents" = list_to_data(GLOB.loadout_masks)))
	loadout_tabs += list(list("id" = "Neck", "slot" = LOADOUT_ITEM_NECK, "contents" = list_to_data(GLOB.loadout_necks)))
	loadout_tabs += list(list("id" = "Shoes", "slot" = LOADOUT_ITEM_SHOES, "contents" = list_to_data(GLOB.loadout_shoes)))
	loadout_tabs += list(list("id" = "Suit", "slot" = LOADOUT_ITEM_SUIT, "contents" = list_to_data(GLOB.loadout_exosuits)))
	loadout_tabs += list(list("id" = "Jumpsuit", "slot" = LOADOUT_ITEM_UNIFORM, "contents" = list_to_data(GLOB.loadout_jumpsuits)))
	loadout_tabs += list(list("id" = "Formal", "slot" = LOADOUT_ITEM_UNIFORM, "contents" = list_to_data(GLOB.loadout_undersuits)))
	loadout_tabs += list(list("id" = "Misc. Under", "slot" = LOADOUT_ITEM_UNIFORM, "contents" = list_to_data(GLOB.loadout_miscunders)))
	loadout_tabs += list(list("id" = "Inhand (2 max)", "slot" = LOADOUT_ITEM_INHAND, "contents" = list_to_data(GLOB.loadout_inhand_items)))
	loadout_tabs += list(list("id" = "Misc. (3 max)", "slot" = LOADOUT_ITEM_MISC, "contents" = list_to_data(GLOB.loadout_pocket_items)))

	data["loadout_tabs"] = loadout_tabs

	return data

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

	var/list/loadout = owner.prefs.loadout_list
	if(!LAZYLEN(loadout))
		return

	for(var/slot in loadout)
		switch(slot)
			if(LOADOUT_ITEM_BELT)
				custom_loadout.belt = loadout[slot]
			if(LOADOUT_ITEM_EARS)
				custom_loadout.ears = loadout[slot]
			if(LOADOUT_ITEM_GLASSES)
				custom_loadout.glasses = loadout[slot]
			if(LOADOUT_ITEM_GLOVES)
				custom_loadout.gloves = loadout[slot]
			if(LOADOUT_ITEM_HEAD)
				custom_loadout.head = loadout[slot]
			if(LOADOUT_ITEM_MASK)
				custom_loadout.mask = loadout[slot]
			if(LOADOUT_ITEM_NECK)
				custom_loadout.neck = loadout[slot]
			if(LOADOUT_ITEM_SHOES)
				custom_loadout.shoes = loadout[slot]
			if(LOADOUT_ITEM_SUIT)
				custom_loadout.suit = loadout[slot]
			if(LOADOUT_ITEM_UNIFORM)
				custom_loadout.uniform = loadout[slot]
			if(LOADOUT_ITEM_LEFT_HAND)
				custom_loadout.l_hand = loadout[slot]
			if(LOADOUT_ITEM_RIGHT_HAND)
				custom_loadout.r_hand = loadout[slot]

/// Finds [path] in the loadout list and returns the key it's associated to.
/datum/loadout_manager/proc/find_path_in_list(path)
	var/list/loadout_list = owner.prefs.loadout_list
	for(var/slot_key in loadout_list)
		if(loadout_list[slot_key] == path)
			return slot_key

/* Takes an assoc list of [string]s to [typepaths]s
 * (Such as the global assoc lists of loadout items)
 * And formats it into an object for TGUI.
 *
 *  - list[name] is the string / key of the item.
 *  - list[path] is the typepath of the item.
 */
/proc/list_to_data(assoc_item_list)
	if(!LAZYLEN(assoc_item_list))
		return null

	var/list/formatted_list = new(length(assoc_item_list))

	var/array_index = 1
	for(var/path_id in assoc_item_list)
		var/list/formatted_item = list()
		var/list/split_path_id = splittext(path_id, "_")

		formatted_item["path"] = assoc_item_list[path_id]
		formatted_item["name"] = split_path_id[1]


		if(split_path_id.len > 1)
			split_path_id.Cut(1, 2)
			formatted_item["extra_info"] = get_info_instructions(split_path_id)

		formatted_list[array_index++] = formatted_item

	return formatted_list

/*
 * Used to pass additional instructions for certain loadout items.
 * If a loadout item has a defined identifier in the front, it is passed here.
 *
 * Then, we return a list telling the UI what special things to do with this item.
 */
/proc/get_info_instructions(list/identifiers)
	var/list/instructions = list()
	var/list/tooltip_contents = list()
	for(var/found_identifier in identifiers)
		switch(found_identifier)
			if(PRESCRIPTION_GLASSES)
				tooltip_contents += "[PRESCRIPTION_GLASSES] - These glasses function with the 'nearsighted' quirk."
			if(MATCHES_EYE_COLOR)
				tooltip_contents += "[MATCHES_EYE_COLOR] - The color of this item matches your character's eye color on spawn."
			if(NO_ARMOR)
				tooltip_contents += "[NO_ARMOR] - This item has no armor and is entirely cosmetic."
			if(NO_DAMAGE)
				tooltip_contents += "[NO_DAMAGE] - This item deals no damage and is entirely cosmetic."
			if(NO_SHOCK)
				tooltip_contents += "[NO_SHOCK] - This item provides no shock protection and is entirely cosmetic."
			if(GREYSCALE)
				instructions["is_greyscale"] = TRUE
				tooltip_contents += "[GREYSCALE] - This item can be customized with greyscaling."
			if(SETS_NAME)
				tooltip_contents += "[SETS_NAME] - The name on this item matches your character's name on spawn."
			if(RANDOM_COLOR)
				tooltip_contents += "[RANDOM_COLOR] - This item's color is randomized on spawn."
			if(ACCESSORY)
				tooltip_contents += "[ACCESSORY] - This item is an accessory, and will attempt to be attached to your jumpsuit on spawn."
			if(IMPORTANT_SLOT)
				tooltip_contents += "[IMPORTANT_SLOT] - This item occupies a slot where important items spawn, any job items replaced will be moved to your backpack on spawn."

	if(tooltip_contents.len)
		instructions["tooltip"] = TRUE
		instructions["tooltip_text"] = tooltip_contents.Join("\n")

	return instructions
