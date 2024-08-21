/datum/action/proc/get_owner()
	return owner

/datum/action/cooldown/spell/proc/spell_cannot_activate()
	return SPELL_CANCEL_CAST

/datum/action/cooldown/spell/pointed/spell_cannot_activate()
	unset_click_ability(owner)
	return ..()
