// -- Causes of pain, from non-modular actions --
// Surgeries cause pain.
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

// Some diseases cause pain.
/datum/symptom/headache/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/affected_living = A.affected_mob
	switch(A.stage)
		if(4)
			affected_living.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 3 * power)
		if(5)
			affected_living.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 5 * power)

// Pain modifier on low death.
/mob/living/carbon/human/set_health(new_value)
	. = ..()
	if(HAS_TRAIT_FROM(src, TRAIT_SIXTHSENSE, "near-death"))
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "near-death", /datum/mood_event/deaths_door)
		pain_controller?.set_pain_modifier(PAIN_MOD_NEAR_DEATH, 0.1)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "near-death")
		pain_controller?.unset_pain_modifier(PAIN_MOD_NEAR_DEATH)
