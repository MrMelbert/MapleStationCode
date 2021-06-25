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
	target.pain_controller.adjust_bodypart_pain(target_zone, 12) // incise doesn't actually deal any direct dmg, unlike saw
	if(target.stat == CONSCIOUS)
		if(target.IsSleeping())
			SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/anesthetic)
		else
			SEND_SIGNAL(target, COMSIG_ADD_MOOD_EVENT, "surgery", /datum/mood_event/surgery/major)
			target.flash_pain_overlay(1)

/datum/surgery_step/replace_limb/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/bodypart/tool, datum/surgery/surgery, default_display_results = FALSE)
	. = ..()
	if(target.pain_controller && (tool in target.bodyparts))
		// We have to snowflake this because replace_limb uses SPECIAL = TRUE when replacing limbs (which doesn't cause pain because I hate limb code)
		target.pain_controller.adjust_bodypart_pain(target_zone, initial(tool.pain))
		target.pain_controller.adjust_bodypart_pain(BODY_ZONE_CHEST, initial(tool.pain) / 3)
		//TODO: make this a status effect (post augment fatigue?)
		target.pain_controller.adjust_bodypart_min_pain(target_zone, 15)
		addtimer(CALLBACK(target.pain_controller, /datum/pain.proc/adjust_bodypart_min_pain, target_zone, -15), 2 MINUTES)

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
	. = ..()
	if(DT_PROB(1, delta_time))
		owner.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 10)

/datum/brain_trauma/special/tenacity/on_gain()
	. = ..()
	owner.pain_controller?.set_pain_modifier(PAIN_MOD_TENACITY, 0)

/datum/brain_trauma/special/tenacity/on_lose()
	owner.pain_controller?.unset_pain_modifier(PAIN_MOD_TENACITY)
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

// Shocks
/mob/living/carbon/human/electrocute_act(shock_damage, source, siemens_coeff = 1, flags = NONE)
	. = ..()
	if(!.)
		return

	var/pain = . / max(bodyparts.len, 2)
	pain_controller?.adjust_bodypart_pain(BODY_ZONES_ALL, pain)
	pain_controller?.set_pain_modifier(PAIN_MOD_RECENT_SHOCK, 0.5)
	addtimer(CALLBACK(pain_controller, /datum/pain.proc/unset_pain_modifier, PAIN_MOD_RECENT_SHOCK), 30 SECONDS)

/obj/machinery/stasis/chill_out(mob/living/carbon/target)
	. = ..()
	if(target != occupant)
		return
	if(!istype(target))
		return

	target.pain_controller?.set_pain_modifier(PAIN_MOD_STASIS, 0)

/obj/machinery/stasis/thaw_them(mob/living/carbon/target)
	. = ..()
	if(!istype(target))
		return

	target.pain_controller?.unset_pain_modifier(PAIN_MOD_STASIS)
