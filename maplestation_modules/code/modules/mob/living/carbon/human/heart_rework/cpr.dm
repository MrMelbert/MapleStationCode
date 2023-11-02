
/mob/living/carbon/human/do_cpr(mob/living/carbon/human/target)
	if(target == src)
		return FALSE

	if (DOING_INTERACTION_WITH_TARGET(src, target))
		return FALSE

	cpr_process(target, beat = 1) // begin at beat 1, skip the first breath
	return TRUE

/// Number of "beats" per CPR cycle
/// This corresponds to N - 1 compressions and 1 breath
#define BEATS_PER_CPR_CYCLE 16

/mob/living/carbon/human/proc/cpr_process(mob/living/carbon/human/target, beat = 0, panicking = FALSE)
	set waitfor = FALSE

	if (!target.appears_alive())
		to_chat(src, span_warning("[target.name] is dead!"))
		return

	if(!panicking && target.stat != CONSCIOUS && beat >= BEATS_PER_CPR_CYCLE + 1)
		if(HAS_TRAIT(src, TRAIT_CPR_CERTIFIED))
			to_chat(src, span_notice("[target] still isn't up - you pick up the pace."))
		else
			to_chat(src, span_warning("[target] still isn't up! You try harder!"))
		panicking = TRUE

	var/doafter_mod = panicking ? 0.5 : 1

	var/doing_a_breath = FALSE
	if(beat % BEATS_PER_CPR_CYCLE == 0)
		if (is_mouth_covered())
			to_chat(src, span_warning("Your mouth is covered, so you can only perform compressions!"))

		else if (target.is_mouth_covered())
			to_chat(src, span_warning("[p_their(TRUE)] mouth is covered, so you can only perform compressions!"))

		else if (!get_organ_slot(ORGAN_SLOT_LUNGS))
			to_chat(src, span_warning("You have no lungs to breathe with, so you can only perform compressions!"))

		else if (HAS_TRAIT(src, TRAIT_NOBREATH))
			to_chat(src, span_warning("You do not breathe, so you can only perform compressions!"))

		else
			doing_a_breath = TRUE

	if(doing_a_breath)
		visible_message(
			span_notice("[src] attempts to give [target.name] a rescue breath!"),
			span_notice("You attempt to give [target.name] a rescue breath as a part of CPR... Hold still!"),
		)

		if(!do_after(user = src, delay = doafter_mod * 6 SECONDS, target = target))
			return

		add_mood_event("saved_life", /datum/mood_event/saved_life)
		visible_message(
			span_notice("[src] delivers a rescue breath on [target.name]!"),
			span_notice("You deliver  a rescue breath on [target.name]."),
		)

	else
		var/is_first_compression = beat % BEATS_PER_CPR_CYCLE == 1
		if(is_first_compression)
			visible_message(
				span_notice("[src] attempts to give [target.name] chest compressions!"),
				span_notice("You try to perform chest compressions as a part of CPR on [target.name]... Hold still!"),
			)

		if(!do_after(user = src, delay = doafter_mod * 1 SECONDS, target = target))
			return

		if(is_first_compression)
			visible_message(
				span_notice("[src] delivers chest compressions on [target.name]!"),
				span_notice("You deliver chest compressions on [target.name]."),
			)

		target.apply_status_effect(/datum/status_effect/cpr_applied)

	if(doing_a_breath)
		if(HAS_TRAIT(target, TRAIT_NOBREATH))
			to_chat(target, span_unconscious("You feel a breath of fresh air... which is a sensation you don't recognise..."))
		else if (!target.get_organ_slot(ORGAN_SLOT_LUNGS))
			to_chat(target, span_unconscious("You feel a breath of fresh air... but you don't feel any better..."))
		else
			target.adjustOxyLoss(-12)
			to_chat(target, span_unconscious("You feel a breath of fresh air enter your lungs... It feels good..."))

		// Breath relieves some of the pressure on the chest
		var/obj/item/bodypart/chest/chest = target.get_bodypart(BODY_ZONE_CHEST)
		if(IS_ORGANIC_LIMB(chest))
			to_chat(target, span_notice("You feel the pressure on your chest ease!"))
			chest.heal_damage(brute = 3)
			target.cause_pain(BODY_ZONE_CHEST, -2)

		log_combat(src, target, "CPRed", addition = "breath")

	else if(beat % (BEATS_PER_CPR_CYCLE / 4) == 0 && panicking && !HAS_TRAIT(src, TRAIT_CPR_CERTIFIED))
		// Apply damage directly to chest. I would use apply damage but I can't, kinda
		var/obj/item/bodypart/chest/chest = target.get_bodypart(BODY_ZONE_CHEST)
		if(IS_ORGANIC_LIMB(chest))
			if(prob(1) && target.undergoing_cardiac_arrest())
				target.set_heartattack(FALSE)
				to_chat(target, span_warning("You feel immense pressure on your chest, and a sudden wave of pain... then relief."))
				chest.receive_damage(brute = 6, wound_bonus = CANT_WOUND, damage_source = "chest compressions")
				target.cause_pain(BODY_ZONE_CHEST, 12)

			else
				to_chat(target, span_warning("You feel pressure on your chest!"))
				chest.receive_damage(brute = 3, wound_bonus = CANT_WOUND, damage_source = "chest compressions")
				target.cause_pain(BODY_ZONE_CHEST, 2)

			to_chat(src, span_warning("You bruise [target.name]'s chest with the pressure!"))

		log_combat(src, target, "CPRed", addition = "compression")

	if(target.body_position != LYING_DOWN)
		return
	if(target.stat == CONSCIOUS)
		return

	cpr_process(target, beat + 1, panicking)

#undef BEATS_PER_CPR_CYCLE

/datum/status_effect/cpr_applied
	id = "cpr"
	alert_type = null
	duration = 1 SECONDS
	tick_interval = -1
	status_type = STATUS_EFFECT_REFRESH
