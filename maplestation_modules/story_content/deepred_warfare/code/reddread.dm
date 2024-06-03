/mob/living/basic/redtechdread
	name = "Redtech Dreadnought"
	desc = "A terrifying robotic multi-limbed monstrosity, covered in armour plating. It would be wise to start running."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/reddreadnought64.dmi'
	icon_state = "dreadnought_active"
	icon_living = "dreadnought_active"
	icon_dead = "dreadnought_dead"
	health = 450
	maxHealth = 450
	unsuitable_atmos_damage = 0
	unsuitable_cold_damage = 0
	unsuitable_heat_damage = 0
	speed = 1 // Change later, maybe.
	density = TRUE
	pass_flags = NONE
	sight = SEEMOBS | SEE_TURFS | SEE_OBJS
	status_flags = NONE
	gender = NEUTER
	mob_biotypes = MOB_ROBOTIC
	speak_emote = list("grinds")
	speech_span = SPAN_ROBOT
	bubble_icon = "machine"

/datum/language_holder/redtech
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/uncommon = list(LANGUAGE_ATOM),
		/datum/language/machine = list(LANGUAGE_ATOM),
		/datum/language/draconic = list(LANGUAGE_ATOM),
		/datum/language/moffic = list(LANGUAGE_ATOM),
		/datum/language/calcic = list(LANGUAGE_ATOM),
		/datum/language/voltaic = list(LANGUAGE_ATOM),
		/datum/language/nekomimetic = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/uncommon = list(LANGUAGE_ATOM),
		/datum/language/machine = list(LANGUAGE_ATOM),
		/datum/language/draconic = list(LANGUAGE_ATOM),
		/datum/language/moffic = list(LANGUAGE_ATOM),
		/datum/language/calcic = list(LANGUAGE_ATOM),
		/datum/language/voltaic = list(LANGUAGE_ATOM),
		/datum/language/nekomimetic = list(LANGUAGE_ATOM),
	)
