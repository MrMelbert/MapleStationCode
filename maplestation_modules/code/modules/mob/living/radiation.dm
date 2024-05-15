/datum/status_effect/irradiated
	id = "mob_irradiated"
	alert_type = /atom/movable/screen/alert/status_effect/irradiated
	var/beginning_of_irradiation
	var/burn_splotch_timer_id
	COOLDOWN_DECLARE(clean_cooldown)
	COOLDOWN_DECLARE(last_tox_damage)
	COOLDOWN_DECLARE(last_burn)

/datum/status_effect/irradiated/on_apply()
	if(!ishuman(owner))
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_RADIMMUNE))
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_IRRADIATED))
		return FALSE

	ADD_TRAIT(owner, TRAIT_IRRADIATED, REF(src))

	create_glow()

	beginning_of_irradiation = world.time

	owner.apply_damage(RADIATION_IMMEDIATE_TOX_DAMAGE, TOX)
	COOLDOWN_START(src, last_tox_damage, 30 SECONDS)
	COOLDOWN_START(src, last_burn, rand(30 SECONDS, 60 SECONDS))

	RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(on_clean))
	RegisterSignal(owner, COMSIG_GEIGER_COUNTER_SCAN, PROC_REF(on_geiger_counter_scan))
	RegisterSignal(owner, SIGNAL_ADDTRAIT(TRAIT_RADIMMUNE), PROC_REF(radimmune_gained))
	return TRUE

/datum/status_effect/irradiated/on_remove()
	owner.remove_filter("rad_glow")
	REMOVE_TRAIT(owner, TRAIT_IRRADIATED, REF(src))
	deltimer(burn_splotch_timer_id)
	UnregisterSignal(owner, list(
		COMSIG_COMPONENT_CLEAN_ACT,
		COMSIG_GEIGER_COUNTER_SCAN,
		SIGNAL_ADDTRAIT(TRAIT_RADIMMUNE),
	))
	return ..()

/datum/status_effect/irradiated/tick(seconds_between_ticks)
	if(owner.getToxLoss() == 0)
		qdel(src)
		return

	if(HAS_TRAIT(owner, TRAIT_STASIS) || HAS_TRAIT(owner, TRAIT_HALT_RADIATION_EFFECTS) || !COOLDOWN_FINISHED(src, clean_cooldown))
		return

	if(owner.stat != DEAD)
		random_effects(world.time - beginning_of_irradiation, seconds_between_ticks)

	if(COOLDOWN_FINISHED(src, last_tox_damage))
		tox_effects(seconds_between_ticks)
		COOLDOWN_START(src, last_tox_damage, 10 SECONDS)

	if(COOLDOWN_FINISHED(src, last_burn))
		burn_effects(seconds_between_ticks)
		COOLDOWN_START(src, last_burn, rand(30 SECONDS, 60 SECONDS))

/datum/status_effect/irradiated/proc/tox_effects(seconds_per_tick)
	owner.apply_damage(1, TOX)
	if(!SPT_PROB(10, seconds_per_tick))
		return

	var/mob/living/carbon/human/human_owner = owner
	var/list/valid_organs = list()
	for(var/obj/item/organ/internal/organ in shuffle(human_owner.organs))
		if(!HAS_TRAIT(organ, TRAIT_IRRADIATED))
			organ.AddComponent(/datum/component/irradiated)
			break
		if(!IS_ORGANIC_ORGAN(organ))
			continue
		organ.apply_organ_damage(5 * seconds_between_ticks)
		owner.apply_damage(3 * seconds_between_ticks, TOX)
		break

/datum/status_effect/irradiated/proc/burn_effects(seconds_per_tick)
	var/obj/item/bodypart/affected_limb = owner.get_bodypart(owner.get_random_valid_zone())
	owner.visible_message(
		span_boldwarning("[owner]'s [affected_limb.plaintext_zone] bubbles unnaturally, then bursts into blisters!"),
		span_boldwarning("Your [affected_limb.plaintext_zone] bubbles unnaturally, then bursts into blisters!"),
	)
	if(owner.is_blind()) // melbert todo replace with visible message flag
		to_chat(owner, span_boldwarning("Your [affected_limb.plaintext_zone] feels like it's bubbling, then burns like hell!"))

	owner.apply_damage(RADIATION_BURN_SPLOTCH_DAMAGE, BURN, affected_limb)
	playsound(owner, pick('sound/effects/wounds/sizzle1.ogg', 'sound/effects/wounds/sizzle2.ogg'), 50, vary = TRUE)

/datum/status_effect/irradiated/proc/random_effects(time_since_irradiated, seconds_per_tick)
	if(time_since_irradiated > 2 MINUTES && SPT_PROB(0.5, seconds_per_tick))
		if(!source.IsParalyzed())
			source.emote("collapse")
		source.Paralyze(0.3 SECONDS)
		to_chat(source, span_danger("You feel weak."))

	if(time_since_irradiated > 2 MINUTES && SPT_PROB(0.5, seconds_per_tick))
		source.vomit(VOMIT_CATEGORY_BLOOD, lost_nutrition = 10)

	if(time_since_irradiated > 2 MINUTES && SPT_PROB(0.5, seconds_per_tick) && owner.can_mutate())
		to_chat(source, span_danger("You mutate!"))
		source.easy_random_mutate(NEGATIVE | MINOR_NEGATIVE)
		source.emote("gasp")
		source.domutcheck()

	if(time_since_irradiated > RAD_MOB_HAIRLOSS && SPT_PROB(RAD_MOB_HAIRLOSS_PROB, seconds_per_tick))
		var/obj/item/bodypart/head/head = source.get_bodypart(BODY_ZONE_HEAD)
		if(!isnul(head) && head.hairstyle != "Bald" && (head.head_flags & (HEAD_HAIR|HEAD_FACIAL_HAIR)))
			to_chat(source, span_danger("Your hair starts to fall out in clumps..."))
			addtimer(CALLBACK(src, PROC_REF(go_bald), source), 5 SECONDS, TIMER_DELETE_ME)

/datum/status_effect/irradiated/proc/go_bald()
	owner.set_facial_hairstyle("Shaved", update = FALSE)
	owner.set_hairstyle("Bald", update = FALSE)
	owner.update_body_parts()

/datum/status_effect/irradiated/proc/create_glow()
	owner.add_filter("rad_glow", 2, list("type" = "outline", "color" = "#39ff1430", "size" = 2))
	addtimer(CALLBACK(src, PROC_REF(start_glow_loop)), rand(0.1 SECONDS, 1.9 SECONDS), TIMER_DELETE_ME) // Things should look uneven

/datum/status_effect/irradiated/proc/start_glow_loop()
	var/filter = owner.get_filter("rad_glow")
	if (!filter)
		return

	animate(filter, alpha = 110, time = 1.5 SECONDS, loop = -1)
	animate(alpha = 40, time = 2.5 SECONDS)

/datum/status_effect/irradiated/proc/on_clean(datum/source, clean_types)
	SIGNAL_HANDLER

	if (clean_types & CLEAN_TYPE_RADIATION)
		COOLDOWN_START(src, clean_cooldown, RADIATION_CLEAN_IMMUNITY_TIME)

/datum/status_effect/irradiated/proc/on_geiger_counter_scan(datum/source, mob/user, obj/item/geiger_counter/geiger_counter)
	SIGNAL_HANDLER

	to_chat(user, span_boldannounce("[icon2html(geiger_counter, user)] Subject is irradiated. \
		Contamination traces back to roughly [DisplayTimeText(world.time - beginning_of_irradiation, 5)] ago. \
		Current toxin levels: [owner.getToxLoss()]."))

	return COMSIG_GEIGER_COUNTER_SCAN_SUCCESSFUL

/datum/status_effect/irradiated/proc/radimmune_gained(...)
	SIGNAL_HANDLER
	qdel(src)

/atom/movable/screen/alert/status_effect/irradiated
	name = "Irradiated"
	desc = "You're irradiated! Heal your toxins quick, and stand under a shower to halt the incoming damage."
	icon_state = ALERT_IRRADIATED
