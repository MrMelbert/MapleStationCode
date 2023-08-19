/datum/component/uses_mana/story_spell/pointed/freeze_person
	var/freeze_person_attunement = 0.5
	var/freeze_person_cost = 50

/datum/component/uses_mana/story_spell/pointed/freeze_person/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/ice] = freeze_person_attunement

/datum/action/cooldown/spell/pointed/freeze_person
	name = "Freeze Person"
	desc = "Temporarily freeze your target inside solid ice."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "illusion"
	sound = 'sound/weapons/ionrifle.ogg'

	cooldown_time = 2 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	school = SCHOOL_CONJURATION

	active_msg = "You prepare to freeze someone."
	deactive_msg = "You stop preparing to freeze someone."
	aim_assist = FALSE
	cast_range = 8
