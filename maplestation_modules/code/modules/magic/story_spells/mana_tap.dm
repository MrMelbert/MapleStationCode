/datum/action/cooldown/spell/touch/mana_tap
	name = "Mana Tap"
	desc = "Extend a psychic tap to allow you to manipulate mana without a simple object."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "spark_psi"
	sound = null
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED
	school = SCHOOL_CONJURATION
	cooldown_time = 10 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	hand_path = /obj/item/magic_wand/temporary/psionic
	draw_message = null
	drop_message = null
