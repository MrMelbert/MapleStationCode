// -- Luciferium addiction. --
// Cannnot ever be removed, and eventually kills you if you do not consume luciferium. Progresses slightly slower

#define PAIN_MOD_LUCIFERIUM_ADDICT "luciferium_addict"

/datum/addiction/luciferium
	name = "luciferium"
	addiction_gain_threshold = 100
	addiction_loss_threshold = -1 // Impossible to clear the addiction
	addiction_loss_per_stage = list(0, 0, 0, 0)
	high_sanity_addiction_loss = 0
	withdrawal_stage_messages = list(
		"I feel weak... I need some Luciferium.",
		"I'd punch someone if I don't get some Luciferium!",
		"It hurts all over! I'd kill for Luciferium!"
		)
	light_withdrawal_moodlet = /datum/mood_event/luciferium_light
	medium_withdrawal_moodlet = /datum/mood_event/luciferium_medium
	severe_withdrawal_moodlet = /datum/mood_event/luciferium_heavy

/datum/addiction/luciferium/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.set_pain_mod(PAIN_MOD_LUCIFERIUM_ADDICT, 1.2)
	to_chat(affected_carbon, span_userdanger("Your [name] withdrawal has begun to set in... You feel ill."))

/datum/addiction/luciferium/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(affected_carbon.pain_controller.get_average_pain() <= 33 && DT_PROB(8, delta_time))
		affected_carbon.cause_pain(pick(BODY_ZONES_ALL), 3)

	var/current_addiction_cycle = LAZYACCESS(affected_carbon.mind.active_addictions, type)
	if(current_addiction_cycle >= (WITHDRAWAL_STAGE1_START_CYCLE + 3) && DT_PROB(33, delta_time))
		affected_carbon.mind.active_addictions[type] -= delta_time

/datum/addiction/luciferium/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.set_pain_mod(PAIN_MOD_LUCIFERIUM_ADDICT, 1.3)
	to_chat(affected_carbon, span_userdanger("Your [name] withdrawal progresses... Your body feels heavy."))

/datum/addiction/luciferium/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(affected_carbon.pain_controller.get_average_pain() <= 66 && DT_PROB(8, delta_time))
		affected_carbon.cause_pain(pick(BODY_ZONES_ALL), 5)
	affected_carbon.adjustCloneLoss(0.2 * delta_time, FALSE)

	var/current_addiction_cycle = LAZYACCESS(affected_carbon.mind.active_addictions, type)
	if(current_addiction_cycle >= (WITHDRAWAL_STAGE2_START_CYCLE + 3) && DT_PROB(33, delta_time))
		affected_carbon.mind.active_addictions[type] -= delta_time

/datum/addiction/luciferium/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	affected_carbon.set_pain_mod(PAIN_MOD_LUCIFERIUM_ADDICT, 1.4)
	to_chat(affected_carbon, span_userdanger("Your [name] withdrawal is killing you!"))

/datum/addiction/luciferium/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, delta_time)
	. = ..()
	if(DT_PROB(12, delta_time))
		affected_carbon.cause_pain(pick(BODY_ZONES_ALL), 8)

	var/current_addiction_cycle = LAZYACCESS(affected_carbon.mind.active_addictions, type)

	affected_carbon.adjustBruteLoss(clamp(round(0.00002 * (current_addiction_cycle ** 2), 0.1), 0.5, 8) * delta_time, FALSE)
	affected_carbon.adjustCloneLoss(clamp(round(0.00002 * (current_addiction_cycle ** 2), 0.1), 0.5, 8) * delta_time, FALSE)

	if(current_addiction_cycle >= (WITHDRAWAL_STAGE3_START_CYCLE + 3) && DT_PROB(33, delta_time))
		affected_carbon.mind.active_addictions[type] -= delta_time

/datum/addiction/luciferium/end_withdrawal(mob/living/carbon/affected_carbon)
	var/current_addiction_cycle = LAZYACCESS(affected_carbon.mind.active_addictions, type)
	if(current_addiction_cycle >= WITHDRAWAL_STAGE1_START_CYCLE)
		to_chat(affected_carbon, span_green("Your [name] withdrawal subsides... You have bought yourself time."))
	affected_carbon.unset_pain_mod(PAIN_MOD_LUCIFERIUM_ADDICT)
	. = ..()
