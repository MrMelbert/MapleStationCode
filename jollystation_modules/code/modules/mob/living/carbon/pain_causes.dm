// -- Causes of pain, from non-modular actions --
// Surgeries
/datum/surgery_step/saw/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results)
	. = ..()
	if(target.stat == CONSCIOUS)
		if(target.IsSleeping())
			SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/anesthetic)
		else
			SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/surgery)
			target.flash_pain_overlay(2)

/datum/surgery_step/incise/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(target.stat == CONSCIOUS)
		if(target.IsSleeping())
			SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/anesthetic)
		else
			SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/surgery/major)
			target.flash_pain_overlay(1)

// Disease symptoms
/datum/symptom/headache/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	switch(A.stage)
		if(4)
			A.affected_mob.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 3 * power)
			A.affected_mob.flash_pain_overlay(1)
		if(5)
			A.affected_mob.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 5 * power)
			A.affected_mob.flash_pain_overlay(2)

/datum/symptom/flesh_eating/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	switch(A.stage)
		if(2, 3)
			A.affected_mob.pain_controller?.adjust_bodypart_pain(BODY_ZONES_ALL, 3 * (pain ? 2 : 1))
			A.affected_mob.flash_pain_overlay(1, 2 SECONDS)
		if(4, 5)
			A.affected_mob.pain_controller?.adjust_bodypart_pain(BODY_ZONES_ALL, 12 * (pain ? 2 : 1))
			A.affected_mob.flash_pain_overlay(2, 2 SECONDS)

/datum/symptom/fire/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	switch(A.stage)
		if(4)
			A.affected_mob.pain_controller?.adjust_bodypart_pain(BODY_ZONES_ALL, 5)
			A.affected_mob.flash_pain_overlay(1)
		if(5)
			A.affected_mob.pain_controller?.adjust_bodypart_pain(BODY_ZONES_ALL, 10)
			A.affected_mob.flash_pain_overlay(2)

/datum/symptom/youth/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	switch(A.stage)
		if(5)
			A.affected_mob.pain_controller?.set_pain_modifier(PAIN_MOD_YOUTH, 0.8)

/datum/symptom/youth/End(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	A.affected_mob.pain_controller?.unset_pain_modifier(PAIN_MOD_YOUTH)

// Traumas
/datum/brain_trauma/mild/concussion/on_life(delta_time, times_fired)
	if(DT_PROB(1, delta_time))
		owner.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 10)

	. = ..()

// Near death
/mob/living/carbon/human/set_health(new_value)
	. = ..()
	if(HAS_TRAIT_FROM(src, TRAIT_SIXTHSENSE, "near-death"))
		SEND_SIGNAL(src, COMSIG_ADD_MOOD_EVENT, "near-death", /datum/mood_event/deaths_door)
		pain_controller.set_pain_modifier(PAIN_MOD_NEAR_DEATH, 0.1)
	else
		SEND_SIGNAL(src, COMSIG_CLEAR_MOOD_EVENT, "near-death")
		pain_controller.unset_pain_modifier(PAIN_MOD_NEAR_DEATH)
