/mob/living/carbon/human/dummy/wipe_state()
	. = ..()
	// Gets rid of prosthetics and stuff that may have been added
	for(var/obj/item/bodypart/whatever as anything in bodyparts)
		whatever.change_exempt_flags &= ~BP_BLOCK_CHANGE_SPECIES
	dna?.species?.replace_body(src)

/atom/movable/screen/map_view/char_preview/limb_viewer

/atom/movable/screen/map_view/char_preview/limb_viewer/update_body()
	if (isnull(body))
		create_body()
	else
		body.wipe_state()

	preferences.apply_prefs_to(body, TRUE) // no clothes, no quirks, no nothing.
	appearance = body.appearance

/atom/movable/screen/map_view/char_preview/limb_viewer/Destroy()
	/// See [/atom/movable/screen/map_view/char_preview/loadout] for why this is needed.
	preferences = null
	return ..()

/client/var/datum/limb_editor/open_limb_editor = null

/datum/limb_editor
	/// The client of the person using the UI
	var/client/owner
	/// The preview dummy
	var/atom/movable/screen/map_view/char_preview/limb_viewer/character_preview_view
	/// Assoc list of all selected paths, keyed by their body zones
	var/list/selected_paths
	/// Records all paths that were selected the last time we updated the preview icon
	/// This is done because we have to use getflat icon (very laggy) rather than byondui
	/// as byondUI doesn't really allow layering other UI elements such as SVGs above it
	var/list/paths_on_last_ui_update
	/// Caches the last icon we generated, see above
	var/cached_icon
	/// Debug verb to regenerate all static limb data
	var/regenerate_limb_data = FALSE

/datum/limb_editor/New(user)
	owner = CLIENT_FROM_VAR(user)
	owner.open_limb_editor = src
	selected_paths = owner.prefs.read_preference(/datum/preference/limbs) || list()

/datum/limb_editor/Destroy(force, ...)
	QDEL_NULL(character_preview_view)
	owner.open_limb_editor = null
	owner = null
	return ..()

/datum/limb_editor/ui_close(mob/user)
	if(owner?.prefs)
		owner.prefs.write_preference(GLOB.preference_entries[/datum/preference/limbs], selected_paths)
		if(owner.prefs.character_preview_view)
			INVOKE_ASYNC(owner.prefs.character_preview_view, TYPE_PROC_REF(/atom/movable/screen/map_view/char_preview, update_body))
	qdel(src)

/// Initialize our character dummy.
/datum/limb_editor/proc/create_character_preview_view(mob/user)
	character_preview_view = new(null, owner.prefs)
	character_preview_view.generate_view("character_preview_[REF(character_preview_view)]")
	character_preview_view.update_body()
	character_preview_view.display_to(user)
	return character_preview_view

/datum/limb_editor/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("select_path")
			var/obj/item/path_selecting = text2path(params["path_to_use"])
			var/datum/limb_option_datum/selecting_datum = GLOB.limb_loadout_options[path_selecting]
			if(isnull(selecting_datum))
				return

			selected_paths[selecting_datum.pref_list_slot] = path_selecting
			. = TRUE

		if("deselect_path")
			var/obj/item/path_deselecting = text2path(params["path_to_use"])
			var/datum/limb_option_datum/deselecting_datum = GLOB.limb_loadout_options[path_deselecting]
			if(isnull(deselecting_datum))
				return

			selected_paths -= deselecting_datum.pref_list_slot
			. = TRUE

	if(.)
		owner.prefs.update_preference(GLOB.preference_entries[/datum/preference/limbs], selected_paths)
		character_preview_view.update_body()

/datum/limb_editor/ui_state(mob/user)
	return GLOB.always_state

/datum/limb_editor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/body_zones),
	)

/datum/limb_editor/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_LimbManager")
		ui.open()
		addtimer(CALLBACK(character_preview_view, TYPE_PROC_REF(/atom/movable/screen/map_view/char_preview, update_body)), 1 SECONDS)

/datum/limb_editor/ui_data(mob/user)
	var/list/data = list()
	data["selected_limbs"] = flatten_list(selected_paths)

	if(isnull(character_preview_view))
		character_preview_view = create_character_preview_view(user)
	if(isnull(cached_icon) || length(selected_paths ^ paths_on_last_ui_update) >= 1)
		paths_on_last_ui_update = selected_paths.Copy()
		cached_icon = icon2base64(getFlatIcon(character_preview_view.body, no_anim = TRUE))

	data["preview_flat_icon"] = cached_icon
	return data

/datum/limb_editor/ui_static_data(mob/user)
	var/list/data = list()

	var/static/list/limbs_data
	if(isnull(limbs_data) || regenerate_limb_data)
		var/list/raw_data = list(
			BODY_ZONE_HEAD = list(),
			BODY_ZONE_CHEST = list(),
			BODY_ZONE_L_ARM = list(),
			BODY_ZONE_R_ARM = list(),
			BODY_ZONE_L_LEG = list(),
			BODY_ZONE_R_LEG = list(),
		)

		for(var/limb_type in GLOB.limb_loadout_options)
			var/datum/limb_option_datum/limb_datum = GLOB.limb_loadout_options[limb_type]
			var/limb_zone = limb_datum.ui_zone

			if(isnull(limb_zone) || !islist(raw_data[limb_zone]))
				stack_trace("Invalid limb zone found in limb datums: [limb_zone || "null"]. (From: [limb_type])")
				continue

			var/list/limb_data = list(
				"name" = limb_datum.name,
				"tooltip" = limb_datum.desc,
				"path" = limb_type,
			)

			UNTYPED_LIST_ADD(raw_data[limb_zone], limb_data)

		limbs_data = list()
		for(var/raw_list_key in raw_data)
			var/list/ui_formatted_raw_list = list(
				"category_name" = raw_list_key,
				"category_data" = raw_data[raw_list_key],
			)
			UNTYPED_LIST_ADD(limbs_data, ui_formatted_raw_list)


	data["limbs"] = limbs_data
	return data

/// Gets a body zone from a typepath given.
/datum/limb_editor/proc/zone_from_path(path_given)
	if(ispath(path_given, /obj/item/bodypart))
		var/obj/item/bodypart/limb_path = path_given
		return initial(limb_path.body_zone)

	if(ispath(path_given, /obj/item/organ))
		var/obj/item/organ/organ_path = path_given
		return deprecise_zone(initial(organ_path.zone))

	CRASH("Invalid path given to zone_from_path(): [path_given]")
