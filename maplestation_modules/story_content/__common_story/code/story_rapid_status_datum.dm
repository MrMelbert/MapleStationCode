// These datums are automatically added into the story rapid status list
// So yes this is where you make your amazing admin event status for an antag that has stun immunity, health regen and can instantly kill people

/datum/story_rapid_status
	var/name = "If you see this, something broke"
	/// If FALSE, doesn't appear in the story rapid status menu
	var/selectable = TRUE

// Override with what you want to happen to the mob.
/datum/story_rapid_status/proc/apply(mob/living/carbon/human/selected)
	return FALSE

/datum/story_rapid_status/proc/grant_spell_list(mob/living/carbon/human/selected, list/list_of_spells, robeless)
	for(var/spell_type as anything in list_of_spells)
		if(!ispath(spell_type, /datum/action/cooldown/spell))
			CRASH("Non-spell [spell_type] given to story_rapid_status/grant_spell_list")
		var/datum/action/cooldown/spell/new_spell = new spell_type(selected.mind || selected)
		if(robeless)
			new_spell.spell_requirements &= ~SPELL_REQUIRES_WIZARD_GARB
		new_spell.Grant(selected)

	return TRUE
