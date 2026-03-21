/// Extension of preferences/ui_act to do more actions when new preferences are added.
/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	var/mob/user = usr
	switch (action)
		// Spellbook UI
		if ("open_spellbook")
			if(parent.open_spellbook_ui)
				parent.open_spellbook_ui.ui_interact(user)
			else
				var/datum/spellbook_manager/tgui = new(user)
				tgui.ui_interact(user)
			return TRUE
