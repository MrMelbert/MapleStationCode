///Opioids
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
	ADD_TRAIT(affected_carbon, TRAIT_VASOCONSTRICTED, "low_[type]")

/datum/addiction/opioids/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	for(var/obj/item/bodypart/to_hurt as anything in affected_carbon.bodyparts)
		to_hurt.bodypart_pain_modifier *= pain_multipliers[3]
	ADD_TRAIT(affected_carbon, TRAIT_VASOCONSTRICTED, "high_[type]")

/datum/addiction/opioids/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	UnregisterSignal(affected_carbon, COMSIG_CARBON_POST_ATTACH_LIMB)
	UnregisterSignal(affected_carbon, COMSIG_CARBON_POST_REMOVE_LIMB)
	for(var/obj/item/bodypart/to_hurt as anything in affected_carbon.bodyparts)
		unmodify_bodypart(affected_carbon, to_hurt)
	affected_carbon.pain_controller.refresh_pain_attributes()
	REMOVE_TRAIT(affected_carbon, TRAIT_VASOCONSTRICTED, "low_[type]")
	REMOVE_TRAIT(affected_carbon, TRAIT_VASOCONSTRICTED, "high_[type]")

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

///Stimulants

/datum/addiction/stimulants
	name = "stimulant"
	withdrawal_stage_messages = list("You feel a bit tired...You could really use a pick me up.", "You are getting a bit woozy...", "So...Tired...")

/datum/addiction/stimulants/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.add_actionspeed_modifier(/datum/actionspeed_modifier/stimulants)

/datum/addiction/stimulants/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.apply_status_effect(/datum/status_effect/woozy)

/datum/addiction/stimulants/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.add_movespeed_modifier(/datum/movespeed_modifier/stimulants)

/datum/addiction/stimulants/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.remove_actionspeed_modifier(ACTIONSPEED_ID_STIMULANTS)
	affected_carbon.remove_status_effect(/datum/status_effect/woozy)
	affected_carbon.remove_movespeed_modifier(MOVESPEED_ID_STIMULANTS)

///Alcohol
/datum/addiction/alcohol
	name = "alcohol"
	withdrawal_stage_messages = list("I could use a drink...", "Maybe the bar is still open?..", "God I need a drink!")

/datum/addiction/alcohol/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(10 SECONDS * seconds_per_tick)

/datum/addiction/alcohol/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(20 SECONDS * seconds_per_tick)
	affected_carbon.set_hallucinations_if_lower(10 SECONDS)

/datum/addiction/alcohol/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(30 SECONDS * seconds_per_tick)
	affected_carbon.set_hallucinations_if_lower(10 SECONDS)
	if(SPT_PROB(4, seconds_per_tick) && !HAS_TRAIT(affected_carbon, TRAIT_ANTICONVULSANT))
		affected_carbon.apply_status_effect(/datum/status_effect/seizure)

/datum/addiction/hallucinogens
	name = "hallucinogen"
	withdrawal_stage_messages = list("I feel so empty...", "I wonder what the machine elves are up to?..", "I need to see the beautiful colors again!!")

/datum/addiction/hallucinogens/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon)
	. = ..()
	var/atom/movable/plane_master_controller/game_plane_master_controller = affected_carbon.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.add_filter("hallucinogen_wave", 10, wave_filter(300, 300, 3, 0, WAVE_SIDEWAYS))
	game_plane_master_controller.add_filter("hallucinogen_blur", 10, angular_blur_filter(0, 0, 3))


/datum/addiction/hallucinogens/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.apply_status_effect(/datum/status_effect/trance, 40 SECONDS, TRUE)

/datum/addiction/hallucinogens/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	var/atom/movable/plane_master_controller/game_plane_master_controller = affected_carbon.hud_used.plane_master_controllers[PLANE_MASTERS_GAME]
	game_plane_master_controller.remove_filter("hallucinogen_blur")
	game_plane_master_controller.remove_filter("hallucinogen_wave")
	affected_carbon.remove_status_effect(/datum/status_effect/trance, 40 SECONDS, TRUE)

/datum/addiction/maintenance_drugs
	name = "maintenance drug"
	withdrawal_stage_messages = list("", "", "")

/datum/addiction/maintenance_drugs/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)

/datum/addiction/maintenance_drugs/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	if(SPT_PROB(7.5, seconds_per_tick))
		affected_carbon.emote("growls")

/datum/addiction/maintenance_drugs/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon)
	. = ..()
	if(!ishuman(affected_carbon))
		return
	var/mob/living/carbon/human/affected_human = affected_carbon
	if(affected_human.gender == MALE)
		to_chat(affected_human, span_warning("Your chin itches."))
		affected_human.set_facial_hairstyle("Beard (Full)", update = TRUE)
	//Only like gross food
	var/obj/item/organ/tongue/tongue = affected_carbon.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!tongue)
		return
	tongue.liked_foodtypes = GROSS
	tongue.disliked_foodtypes = NONE
	tongue.toxic_foodtypes = ~GROSS

/datum/addiction/maintenance_drugs/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	if(!ishuman(affected_carbon))
		return
	to_chat(affected_carbon, span_warning("You feel yourself adapt to the darkness."))
	var/mob/living/carbon/human/affected_human = affected_carbon
	var/obj/item/organ/eyes/empowered_eyes = affected_human.get_organ_by_type(/obj/item/organ/eyes)
	if(empowered_eyes)
		ADD_TRAIT(affected_human, TRAIT_NIGHT_VISION, "maint_drug_addiction")
		empowered_eyes?.refresh()

/datum/addiction/maintenance_drugs/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	if(!ishuman(affected_carbon))
		return
	var/mob/living/carbon/human/affected_human = affected_carbon
	var/turf/T = get_turf(affected_human)
	var/lums = T.get_lumcount()
	if(lums > 0.5)
		affected_human.add_mood_event("too_bright", /datum/mood_event/bright_light)
		affected_human.adjust_dizzy_up_to(6 SECONDS, 80 SECONDS)
		affected_human.adjust_confusion_up_to(0.5 SECONDS * seconds_per_tick, 20 SECONDS)
	else
		affected_carbon.clear_mood_event("too_bright")

/datum/addiction/maintenance_drugs/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	//restore tongue's tastes
	var/obj/item/organ/tongue/tongue = affected_carbon.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(tongue)
		tongue.liked_foodtypes = initial(tongue.liked_foodtypes)
		tongue.disliked_foodtypes = initial(tongue.disliked_foodtypes)
		tongue.toxic_foodtypes = initial(tongue.toxic_foodtypes)
	if(!ishuman(affected_carbon))
		return
	var/mob/living/carbon/human/affected_human = affected_carbon
	REMOVE_TRAIT(affected_human, TRAIT_NIGHT_VISION, "maint_drug_addiction")
	var/obj/item/organ/eyes/eyes = affected_human.get_organ_by_type(/obj/item/organ/eyes)
	eyes?.refresh()

///Makes you a hypochondriac - I'd like to call it hypochondria, but "I could use some hypochondria" doesn't work
/datum/addiction/medicine
	name = "medicine"
	withdrawal_stage_messages = list("", "", "")
	/// Weakref to the "fake alert" hallucination we're giving to the addicted
	var/datum/weakref/fake_alert_ref
	/// Weakref to the "health doll screwup" hallucination we're giving to the addicted
	var/datum/weakref/health_doll_ref

/datum/addiction/medicine/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon)
	. = ..()
	if(!ishuman(affected_carbon))
		return
	var/datum/hallucination/health_doll = affected_carbon.cause_hallucination( \
		/datum/hallucination/fake_health_doll, \
		"medicine addiction", \
		severity = 1, \
		duration = 120 MINUTES, \
	)
	if(!health_doll)
		return
	health_doll_ref = WEAKREF(health_doll)

/datum/addiction/medicine/withdrawal_stage_1_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	if(SPT_PROB(1, seconds_per_tick))
		affected_carbon.emote("cough")

/datum/addiction/medicine/withdrawal_enters_stage_2(mob/living/carbon/affected_carbon)
	. = ..()
	var/list/possibilities = list()

	if(!HAS_TRAIT(affected_carbon, TRAIT_RESISTHEAT))
		possibilities += /datum/hallucination/fake_alert/hot
	if(!HAS_TRAIT(affected_carbon, TRAIT_RESISTCOLD))
		possibilities += /datum/hallucination/fake_alert/cold

	var/obj/item/organ/lungs/lungs = affected_carbon.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(lungs)
		if(lungs.safe_oxygen_min)
			possibilities += /datum/hallucination/fake_alert/need_oxygen
		if(lungs.safe_oxygen_max)
			possibilities += /datum/hallucination/fake_alert/bad_oxygen

	if(!length(possibilities))
		return

	var/datum/hallucination/fake_alert = affected_carbon.cause_hallucination( \
		pick(possibilities), \
		"medicine addiction", \
		duration = 120 MINUTES, \
	)
	if(!fake_alert)
		return
	fake_alert_ref = WEAKREF(fake_alert)

/datum/addiction/medicine/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	if(SPT_PROB(2, seconds_per_tick))
		affected_carbon.emote("cough")

	var/datum/hallucination/fake_health_doll/hallucination = health_doll_ref?.resolve()
	if(QDELETED(hallucination))
		health_doll_ref = null
		return

	if(SPT_PROB(10, seconds_per_tick))
		hallucination.add_fake_limb(severity = 1)
		return

	if(SPT_PROB(5, seconds_per_tick))
		hallucination.increment_fake_damage()
		return

/datum/addiction/medicine/withdrawal_enters_stage_3(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_crit, type)

/datum/addiction/medicine/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	if(SPT_PROB(5, seconds_per_tick))
		affected_carbon.emote("cough")

	var/datum/hallucination/fake_health_doll/hallucination = health_doll_ref?.resolve()
	if(!QDELETED(hallucination) && SPT_PROB(5, seconds_per_tick))
		hallucination.increment_fake_damage()
		return

	if(SPT_PROB(65, seconds_per_tick))
		return

	if(affected_carbon.stat >= SOFT_CRIT)
		return

	var/obj/item/organ/organ = pick(affected_carbon.organs)
	if(organ.low_threshold)
		to_chat(affected_carbon, organ.low_threshold_passed)
		return

	else if (organ.high_threshold_passed)
		to_chat(affected_carbon, organ.high_threshold_passed)
		return

	to_chat(affected_carbon, span_warning("You feel a dull pain in your [organ.name]."))

/datum/addiction/medicine/end_withdrawal(mob/living/carbon/affected_carbon)
	. = ..()
	affected_carbon.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_crit, type)
	QDEL_NULL(fake_alert_ref)
	QDEL_NULL(health_doll_ref)

///Nicotine
/datum/addiction/nicotine
	name = "nicotine"
	addiction_relief_treshold = MIN_NICOTINE_ADDICTION_REAGENT_AMOUNT //much less because your intake is probably from ciggies
	withdrawal_stage_messages = list("Feel like having a smoke...", "Getting antsy. Really need a smoke now.", "I can't take it! Need a smoke NOW!")

	medium_withdrawal_moodlet = /datum/mood_event/nicotine_withdrawal_moderate
	severe_withdrawal_moodlet = /datum/mood_event/nicotine_withdrawal_severe

/datum/addiction/nicotine/withdrawal_enters_stage_1(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(10 SECONDS * seconds_per_tick)

/datum/addiction/nicotine/withdrawal_stage_2_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(20 SECONDS * seconds_per_tick)
	if(SPT_PROB(2, seconds_per_tick))
		affected_carbon.emote("cough")

/datum/addiction/nicotine/withdrawal_stage_3_process(mob/living/carbon/affected_carbon, seconds_per_tick)
	. = ..()
	affected_carbon.set_jitter_if_lower(30 SECONDS * seconds_per_tick)
	if(SPT_PROB(5, seconds_per_tick))
		affected_carbon.emote("cough")
