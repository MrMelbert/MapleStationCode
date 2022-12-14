/datum/preference/loadout
	savefile_key = "loadout_list"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE

// Loadouts are applied with job equip code.
/datum/preference/loadout/apply_to_human(mob/living/carbon/human/target, value)
	return

// But after everything is applied, we need to call [post_equip_item] on all of our loadout items.
/datum/preference/loadout/after_apply_to_human(mob/living/carbon/human/target, datum/preferences/prefs, value)
	if(!prefs)
		CRASH("loadout preference after_apply_to_human called without a preference datum.")

	if(!istype(target))
		return // Not a crash, 'cause this proc could be passed non-humans (AIs, etc) and that's fine

	for(var/datum/loadout_item/item as anything in loadout_list_to_datums(value))
		item.post_equip_item(prefs, target)

/datum/preference/loadout/serialize(input, datum/preferences/preferences)
	return sanitize_loadout_list(input)

/datum/preference/loadout/deserialize(input, datum/preferences/preferences)
	var/pre_length = length(input)
	. = sanitize_loadout_list(input)
	if(length(.) == pre_length)
		return
	// Let the client know that their loadout list has been stripped of a few things that we aren't sure of
	to_chat(preferences.parent?.mob, span_boldannounce("Hey! Your loadout list had some invalid items - \
		They have been removed from your loadout, please double check it now."))

// Default value is NULL - the loadout list is a lazylist
/datum/preference/loadout/create_default_value(datum/preferences/preferences)
	return null

/datum/preference/loadout/is_valid(value)
	return isnull(value) || islist(value)

/// Extension of preferences/ui_act to open the loadout manager.
/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	switch (action)
		if ("open_loadout_manager")
			if(parent.open_loadout_ui)
				parent.open_loadout_ui.ui_interact(usr)
			else
				var/datum/loadout_manager/tgui = new(usr)
				tgui.ui_interact(usr)
			return TRUE
		if ("open_language_picker")
			var/datum/language_picker/tgui = new(src)
			tgui.ui_interact(usr)
			return TRUE
