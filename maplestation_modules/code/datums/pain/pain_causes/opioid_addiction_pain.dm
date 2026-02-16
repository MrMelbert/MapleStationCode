/datum/addiction/opioids
	name = "painkiller"
	withdrawal_stage_messages = list(
		"My body aches all over...",
		"I need some pain relief...",
		"It hurts all over...I need some painkillers!",
	)
	/// Multipliers to apply to pain on each withdrawal stage, compounded multiplicatively
	var/list/pain_multipliers = list(
		1.25, // Stage 1
		1.60, // Stage 2
		2.50, // Stage 3
	)
	/// Lazylist of refs to all modified bodyparts to prevent double-dipping
	var/list/modified_bodyparts
	/// Minimum pain to add to bodyparts during withdrawal
	var/min_pain = 12.5

/datum/addiction/opioids/process_addiction(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	// constantly resets pain loss cooldown
	COOLDOWN_MINIMUM(affected_carbon.pain_controller, time_since_last_pain_loss, seconds_per_tick * 1.5 SECONDS)

/datum/addiction/opioids/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	RegisterSignal(affected_carbon, COMSIG_CARBON_POST_ATTACH_LIMB, PROC_REF(modify_bodypart))
	RegisterSignal(affected_carbon, COMSIG_CARBON_POST_REMOVE_LIMB, PROC_REF(unmodify_bodypart))
	for(var/obj/item/bodypart/to_hurt as anything in affected_carbon.bodyparts)
		modify_bodypart(affected_carbon, to_hurt)
	affected_carbon.pain_controller.refresh_pain_attributes()

/datum/addiction/opioids/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon)
	. = ..()
	for(var/obj/item/bodypart/to_hurt as anything in affected_carbon.bodyparts)
		to_hurt.bodypart_pain_modifier *= pain_multipliers[2]

/datum/addiction/opioids/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	for(var/obj/item/bodypart/to_hurt as anything in affected_carbon.bodyparts)
		to_hurt.bodypart_pain_modifier *= pain_multipliers[3]

/datum/addiction/opioids/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	UnregisterSignal(affected_carbon, COMSIG_CARBON_POST_ATTACH_LIMB)
	UnregisterSignal(affected_carbon, COMSIG_CARBON_POST_REMOVE_LIMB)
	for(var/obj/item/bodypart/to_hurt as anything in affected_carbon.bodyparts)
		unmodify_bodypart(affected_carbon, to_hurt)
	affected_carbon.pain_controller.refresh_pain_attributes()

/datum/addiction/opioids/proc/modify_bodypart(mob/living/carbon/affected_carbon, obj/item/bodypart/new_limb)
	SIGNAL_HANDLER

	if(REF(new_limb) in modified_bodyparts)
		return // already modified, don't double-dip

	LAZYADD(modified_bodyparts, REF(new_limb))
	// adds a very low base pain, so they always feel something
	new_limb.min_pain += min_pain
	new_limb.pain = max(new_limb.pain, new_limb.min_pain)

	// then make the bodypart feel more hurt than it actually is
	// so they can get more severe feedback effects without being in a dangerous threshold
	for(var/i in 1 to get_withdrawal_stage(affected_carbon))
		new_limb.bodypart_pain_modifier *= pain_multipliers[i]

	new_limb.on_gain_pain_effects(min_pain, STAMINA)

/datum/addiction/opioids/proc/unmodify_bodypart(mob/living/carbon/affected_carbon, obj/item/bodypart/removed_limb)
	SIGNAL_HANDLER

	if(!(REF(removed_limb) in modified_bodyparts))
		return // wasn't modified, nothing to do

	LAZYREMOVE(modified_bodyparts, REF(removed_limb))
	removed_limb.min_pain -= min_pain

	for(var/i in 1 to get_withdrawal_stage(affected_carbon))
		removed_limb.bodypart_pain_modifier /= pain_multipliers[i]
