/// -- The loadout manager and UI --

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

	if(SSquirks?.initialized)
		// And yes we need to clean all the quirk datums every time
		mannequin.cleanse_quirk_datums()
		for(var/quirk_name as anything in all_quirks)
			var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
			if(!(initial(quirk_type.quirk_flags) & QUIRK_CHANGES_APPEARANCE))
				continue
			mannequin.add_quirk(quirk_type, parent)

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

/// Global list of all loadout categories singletons
/// This is global (rather than just static on the loadout middleware datum)
/// just so we can ensure it is loaded regardless of whether someone opens the loadout UI
/// (because it also inits our loadout datums)
GLOBAL_LIST_INIT(loadout_categories, init_loadout_categories())

/// Inits the loadout categories list
/proc/init_loadout_categories()
	. = list()
	for(var/category_type in subtypesof(/datum/loadout_category))
		. += new category_type()

/// Datum holder for the loadout manager UI.
/// Future todo: Merge this entirely with the prefs UI
/datum/preference_middleware/loadout
	action_delegations = list(
		"select_item" = PROC_REF(action_select_item),
		"clear_all_items" = PROC_REF(action_clear_all),
		"toggle_job_clothes" = PROC_REF(action_toggle_job_outfit),
		"rotate_dummy" = PROC_REF(action_rotate_model_dir),
		"pass_to_loadout_item" = PROC_REF(action_pass_to_loadout_item),
		"select_slot" = PROC_REF(select_slot),
	)

	/// The preview dummy.
	/// We use a special subtype so we don't brick our preference menu preview when we're done.
	VAR_FINAL/atom/movable/screen/map_view/char_preview/loadout/character_preview_view
	/// Our currently open greyscaling menu.
	VAR_FINAL/datum/greyscale_modify_menu/menu

/datum/preference_middleware/loadout/Destroy(force, ...)
	QDEL_NULL(character_preview_view)
	QDEL_NULL(menu)
	return ..()

/// Initialize our character dummy.
/datum/preference_middleware/loadout/proc/create_character_preview_view(mob/user)
	character_preview_view = new(null, preferences)
	character_preview_view.generate_view("loadout_preview_[REF(character_preview_view)]")
	character_preview_view.update_body()
	character_preview_view.display_to(user)
	return character_preview_view

/datum/preference_middleware/loadout/on_new_character(mob/user)
	character_preview_view?.update_body()

/datum/preference_middleware/loadout/proc/action_select_item(list/params, mob/user)
	var/path_to_use = text2path(params["path"])
	var/datum/loadout_item/interacted_item = GLOB.all_loadout_datums[path_to_use]
	if(!istype(interacted_item))
		stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
		return TRUE // update

	if(params["deselect"])
		deselect_item(interacted_item)
	else
		select_item(interacted_item)
	character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_clear_all(list/params, mob/user)
	update_loadout(preferences, null)
	character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_toggle_job_outfit(list/params, mob/user)
	character_preview_view.view_job_clothes = !character_preview_view.view_job_clothes
	character_preview_view.update_body()
	return TRUE

/datum/preference_middleware/loadout/proc/action_rotate_model_dir(list/params, mob/user)
	switch(params["dir"])
		if("left")
			character_preview_view.setDir(turn(character_preview_view.dir, -90))
		if("right")
			character_preview_view.setDir(turn(character_preview_view.dir, 90))

/datum/preference_middleware/loadout/proc/action_pass_to_loadout_item(list/params, mob/user)
	var/path_to_use = text2path(params["path"])
	var/datum/loadout_item/interacted_item = GLOB.all_loadout_datums[path_to_use]
	if(!istype(interacted_item))
		stack_trace("Failed to locate desired loadout item (path: [params["path"]]) in the global list of loadout datums!")
		return TRUE // update

	if(interacted_item.handle_loadout_action(src, user, params["subaction"]))
		character_preview_view.update_body()
		return TRUE

	return FALSE

/// Select [path] item to [category_slot] slot.
/datum/preference_middleware/loadout/proc/select_item(datum/loadout_item/selected_item)
	var/list/loadout = get_active_loadout(preferences)
	var/list/datum/loadout_item/loadout_datums = loadout_list_to_datums(loadout)
	for(var/datum/loadout_item/item as anything in loadout_datums)
		if(item.category != selected_item.category)
			continue

		if(!item.category.handle_duplicate_entires(src, item, selected_item, loadout_datums))
			return

	LAZYSET(loadout, selected_item.item_path, list())
	update_loadout(preferences, loadout)

/// Deselect [deselected_item].
/datum/preference_middleware/loadout/proc/deselect_item(datum/loadout_item/deselected_item)
	var/list/loadout = get_active_loadout(preferences)
	LAZYREMOVE(loadout, deselected_item.item_path)
	update_loadout(preferences, loadout)

/datum/preference_middleware/loadout/proc/register_greyscale_menu(datum/greyscale_modify_menu/open_menu)
	src.menu = open_menu
	RegisterSignal(menu, COMSIG_QDELETING, PROC_REF(cleanup_greyscale_menu))

/datum/preference_middleware/loadout/proc/cleanup_greyscale_menu()
	SIGNAL_HANDLER
	menu = null

/datum/preference_middleware/loadout/proc/select_slot(list/params, mob/user)
	preferences.write_preference(GLOB.preference_entries[/datum/preference/numeric/active_loadout], text2num(params["new_slot"]))
	character_preview_view.update_body()
	preferences.character_preview_view?.update_body()
	preferences.update_static_data(user)

/datum/preference_middleware/loadout/get_ui_data(mob/user)
	var/list/data = list()

	if (isnull(character_preview_view))
		character_preview_view = create_character_preview_view(user)

	var/list/all_selected_paths = list()
	for(var/path in get_active_loadout(preferences))
		all_selected_paths += path

	data["selected_loadout"] = all_selected_paths
	data["mob_name"] = preferences.read_preference(/datum/preference/name/real_name)
	data["job_clothes"] = character_preview_view.view_job_clothes
	data["current_slot"] = preferences.read_preference(/datum/preference/numeric/active_loadout)

	return data

/datum/preference_middleware/loadout/get_ui_static_data(mob/user)
	var/list/data = list()
	data["loadout_preview_view"] = character_preview_view.assigned_map
	return data

/datum/preference_middleware/loadout/get_constant_data()
	var/list/data = list()
	var/list/loadout_tabs = list()
	for(var/datum/loadout_category/category as anything in GLOB.loadout_categories)
		UNTYPED_LIST_ADD(loadout_tabs, list(
			"name" = category.category_name,
			"title" = category.ui_title,
			"contents" = category.items_to_ui_data(),
		))

	data["loadout_tabs"] = loadout_tabs
	data["tutorial_text"] = get_tutorial_text()
	data["max_loadout_slots"] = MAX_LOADOUTS
	return data

/// Returns a formatted string for use in the UI.
/datum/preference_middleware/loadout/proc/get_tutorial_text()
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
