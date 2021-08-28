/datum/addiction/psychite
	name = "psychoid"
	withdrawal_stage_messages = list(
		"Some Psychoid would be great right now...",
		"Ugh, I need some Psychoid!",
		"Get me some Psychoid! I can't take this!"
		)
	light_withdrawal_moodlet = /datum/mood_event/psychite_addiction_light
	medium_withdrawal_moodlet = /datum/mood_event/psychite_addiction_medium
	severe_withdrawal_moodlet = /datum/mood_event/psychite_addiction_heavy

/datum/addiction/psychite/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.add_movespeed_modifier(/datum/movespeed_modifier/reagent/psychite_addiction)

/datum/addiction/psychite/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(DT_PROB(8, delta_time))
		affected_carbon.add_confusion(5)
	if(DT_PROB(10, delta_time))
		affected_carbon.stuttering = min(affected_carbon.stuttering + 3 * delta_time, 15)

/datum/addiction/psychite/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(DT_PROB(8, delta_time))
		affected_carbon.add_confusion(12)
	if(DT_PROB(15, delta_time))
		affected_carbon.stuttering = min(affected_carbon.stuttering + 5 * delta_time, 25)

/datum/addiction/psychite/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/psychite_addiction)
