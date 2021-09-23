/datum/preference/loadout
	savefile_key = "loadout_list"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE

/datum/preference/loadout/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/loadout/deserialize(input, datum/preferences/preferences)
	return sanitize_loadout_list(input)

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
