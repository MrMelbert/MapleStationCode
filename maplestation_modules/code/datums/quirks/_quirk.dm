// somehow i stumbled accross the first case of needing to add a power via quirks. Funny
// also potentially overkill but honestly i fully anticipate this having more cases

/datum/quirk/power_granting
	var/datum/action/action_type
	abstract_parent_type = /datum/quirk/power_granting

/datum/quirk/power_granting/add_unique(client/client_source)
	var/datum/action/new_action = new action_type(src)
	// failsafe incase the power granted is somehow already owned by the quirk holder
	var/datum/action/duplicate_check = locate(action_type) in quirk_holder.actions
	if(duplicate_check)
		return
	new_action.Grant(quirk_holder)

