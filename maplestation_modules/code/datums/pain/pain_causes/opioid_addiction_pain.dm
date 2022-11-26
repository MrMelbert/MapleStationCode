/datum/addiction/opioids
	withdrawal_stage_messages = list(
		"My body aches all over...",
		"I need some pain relief...",
		"It hurts all over...I need some opioids!",
	)

/datum/addiction/opioids/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(!affected_carbon.pain_controller)
		return
	if(affected_carbon.pain_controller.get_average_pain() <= 20 && DT_PROB(8, delta_time))
		affected_carbon.cause_pain(BODY_ZONES_ALL, 0.5 * delta_time)

/datum/addiction/opioids/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(!affected_carbon.pain_controller)
		return
	if(affected_carbon.pain_controller.get_average_pain() <= 35 && DT_PROB(8, delta_time))
		affected_carbon.cause_pain(BODY_ZONES_ALL, 1 * delta_time)

/datum/addiction/opioids/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(!affected_carbon.pain_controller)
		return
	if(affected_carbon.pain_controller.get_average_pain() <= 50 && DT_PROB(8, delta_time))
		affected_carbon.cause_pain(BODY_ZONES_ALL, 1.5 * delta_time)
