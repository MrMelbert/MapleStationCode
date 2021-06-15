// -- Pain effects from surgery. --
/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	. = ..()
	if(target.IsSleeping())
		SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/anesthetic)
	else
		SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/surgery)

/datum/surgery_step/incise/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(target.IsSleeping())
		SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/anesthetic)
	else
		SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/surgery/major)
