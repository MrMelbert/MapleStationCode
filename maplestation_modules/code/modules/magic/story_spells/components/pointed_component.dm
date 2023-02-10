/datum/component/uses_mana/story_spell/pointed

/datum/component/uses_mana/story_spell/pointed/can_activate_check_failure(give_feedback, atom/cast_on)
	. = ..()

	spell_parent.unset_click_ability(spell_parent.owner)
