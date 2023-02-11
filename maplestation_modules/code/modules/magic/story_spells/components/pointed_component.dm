/datum/component/uses_mana/story_spell/pointed

/datum/component/uses_mana/story_spell/pointed/Initialize(datum/action/cooldown/spell/pointed/our_spell)
	. = ..()

	if (!istype(our_spell))
		return . | COMPONENT_INCOMPATIBLE

/datum/component/uses_mana/story_spell/pointed/can_activate_check_failure(give_feedback, atom/cast_on)
	. = ..()
	var/datum/action/cooldown/spell/spell_parent = parent

	spell_parent.unset_click_ability(spell_parent.owner)
