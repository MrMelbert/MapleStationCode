/datum/component/uses_mana/story_spell/pointed

/datum/component/uses_mana/story_spell/pointed/Initialize(...)
	. = ..()

	if (!istype(parent, /datum/action/cooldown/spell/pointed))
		return . | COMPONENT_INCOMPATIBLE

/datum/component/uses_mana/story_spell/pointed/can_activate_check_failure(give_feedback, atom/cast_on)
	. = ..()
	var/datum/action/cooldown/spell/spell_parent = parent

	spell_parent.unset_click_ability(spell_parent.owner)
