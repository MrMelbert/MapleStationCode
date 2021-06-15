// -- Misc. events that hook into pain. --
/mob/living/carbon/human/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/pain)

/mob/living/carbon/set_health(new_value)
	. = ..()
	if(HAS_TRAIT_FROM(src, TRAIT_SIXTHSENSE, "near-death"))
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "near-death", /datum/mood_event/deaths_door)
		SEND_SIGNAL(src, COMSIG_CARBON_ADD_PAIN_MODIFIER, PAIN_MOD_NEAR_DEATH, 0.1)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "near-death")
		SEND_SIGNAL(src, COMSIG_CARBON_REMOVE_PAIN_MODIFIER, PAIN_MOD_NEAR_DEATH)
