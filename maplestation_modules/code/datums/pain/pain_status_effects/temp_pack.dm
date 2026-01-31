/// Status effects applied when pressing a hot or cold item onto a bodypart, to soothe pain.
/datum/status_effect/temperature_pack
	id = "temp_pack"
	status_type = STATUS_EFFECT_MULTIPLE
	on_remove_on_mob_delete = TRUE
	tick_interval = 3 SECONDS
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	alert_type = null
	/// The item we're using to heal pain.
	VAR_FINAL/obj/item/pressed_item
	/// The mob holding the [pressed_item] to [owner]. Can be [owner].
	VAR_FINAL/mob/living/holder
	/// The zone we're healing.
	var/targeted_zone = BODY_ZONE_CHEST
	/// The amount we heal per tick. Positive number.
	var/pain_heal_amount = 0
	/// The pain modifier placed on the limb.
	var/pain_modifier = 1
	/// The change in temperature while applied.
	var/temperature_change = 0

/datum/status_effect/temperature_pack/on_creation(
	mob/living/new_owner,
	mob/living/holder,
	obj/item/pressed_item,
	targeted_zone = BODY_ZONE_CHEST,
	pain_heal_amount = 0,
	pain_modifier = 1,
	temperature_change = 0,
)

	src.holder = holder
	src.pressed_item = pressed_item
	src.targeted_zone = targeted_zone
	src.pain_heal_amount = pain_heal_amount
	src.pain_modifier = pain_modifier
	src.temperature_change = temperature_change
	return ..()

/datum/status_effect/temperature_pack/on_apply()
	if(!owner.pain_controller || owner.stat == DEAD)
		return FALSE

	if(QDELETED(pressed_item))
		return FALSE

	if(QDELETED(holder))
		return FALSE

	for(var/datum/status_effect/temperature_pack/pre_existing_effect in owner.status_effects)
		if(pre_existing_effect.targeted_zone == targeted_zone)
			return FALSE

	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	if(!held_bodypart || !IS_ORGANIC_BODYPART(held_bodypart))
		return FALSE

	held_bodypart.bodypart_pain_modifier *= pain_modifier
	pressed_item.AddComponent(/datum/component/make_item_slow)
	RegisterSignals(pressed_item, list(COMSIG_QDELETING, COMSIG_ITEM_DROPPED, COMSIG_TEMPERATURE_PACK_EXPIRED), PROC_REF(stop_effects_comsig))
	if(holder != owner)
		RegisterSignal(holder, COMSIG_MOVABLE_MOVED, PROC_REF(check_adjacency))
	return TRUE

/datum/status_effect/temperature_pack/tick(seconds_between_ticks)
	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	if(QDELETED(holder) || QDELETED(pressed_item) || owner.stat == DEAD || !holder.is_holding(pressed_item) || QDELETED(held_bodypart))
		stop_effects(silent = TRUE)
		return

	if(temperature_change != 0)
		owner.adjust_body_temperature(temperature_change * seconds_between_ticks, owner.bodytemp_cold_damage_limit + 5 KELVIN, owner.bodytemp_heat_damage_limit - 5 KELVIN)
		if(temperature_change < 0)
			held_bodypart.heal_damage(1 * seconds_between_ticks)
	if(pain_heal_amount > 0)
		owner.heal_pain(pain_heal_amount * seconds_between_ticks, targeted_zone)
	if(SPT_PROB(10, seconds_between_ticks) && held_bodypart.get_modified_pain() > 0)
		to_chat(owner, span_smallnoticeital("[pressed_item] dulls the pain in your [held_bodypart.name] a little."))

/**
 * Check on move whether [holder] is still adjacent to [owner].
 */
/datum/status_effect/temperature_pack/proc/check_adjacency(datum/source)
	SIGNAL_HANDLER

	if(!in_range(holder, owner))
		stop_effects(silent = FALSE)

/**
 * Signal handler to stop effects when [pressed_item] is deleted, dropped, or expired.
 */
/datum/status_effect/temperature_pack/proc/stop_effects_comsig(datum/source)
	SIGNAL_HANDLER
	stop_effects(silent = FALSE)

/**
 * Stop the effects of this status effect, deleting it, and sending a message if [silent] is TRUE.
 */
/datum/status_effect/temperature_pack/proc/stop_effects(datum/source, silent = FALSE)
	if(!silent && !QDELETED(holder) && !QDELETED(pressed_item))
		to_chat(holder, span_notice("You stop pressing [pressed_item] against [owner == holder ? "yourself":"[owner]"]."))
	qdel(src)

/datum/status_effect/temperature_pack/on_remove()
	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	held_bodypart?.bodypart_pain_modifier /= pain_modifier
	qdel(pressed_item.GetComponent(/datum/component/make_item_slow))
	UnregisterSignal(pressed_item, list(COMSIG_QDELETING, COMSIG_ITEM_DROPPED, COMSIG_TEMPERATURE_PACK_EXPIRED))
	UnregisterSignal(holder, COMSIG_MOVABLE_MOVED)

	pressed_item = null
	holder = null

/// Cold stuff needs to stay cold.
/datum/status_effect/temperature_pack/cold
	id = "cold_pack"
	temperature_change = -2

/datum/status_effect/temperature_pack/cold/on_apply()
	. = ..()
	if(!.)
		return

	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	if(held_bodypart.get_modified_pain() > 0)
		to_chat(owner, span_green("You wince as [owner == holder ? "you press" : "[holder] presses"] [pressed_item] against your [held_bodypart.plaintext_zone], but eventually the chill starts to dull the pain."))
		owner.pain_emote("wince", 3 SECONDS)

/datum/status_effect/temperature_pack/cold/get_examine_text()
	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	return span_danger("[holder == owner ? "[owner.p_Theyre()]" : "[holder] is"] pressing a cold [pressed_item.name] against [owner.p_their()] [held_bodypart.plaintext_zone].")

/datum/status_effect/temperature_pack/cold/tick()
	if(pressed_item.resistance_flags & ON_FIRE)
		stop_effects(silent = TRUE)
		return

	return ..()

/// And warm stuff needs to stay warm.
/datum/status_effect/temperature_pack/heat
	id = "heat_pack"
	temperature_change = 2

/datum/status_effect/temperature_pack/heat/on_apply()
	. = ..()
	if(!.)
		return

	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	if(held_bodypart.get_modified_pain() > 0)
		to_chat(owner, span_green("You gasp as [owner == holder ? "you press" : "[holder] presses"] [pressed_item] against your [held_bodypart.plaintext_zone], but eventually the warmth starts to dull the pain."))
		owner.pain_emote("gasp", 3 SECONDS)

/datum/status_effect/temperature_pack/head/get_examine_text()
	var/obj/item/bodypart/held_bodypart = owner.get_bodypart(targeted_zone)
	return span_danger("[holder == owner ? "[owner.p_Theyre()]" : "[holder] is"] pressing a warm [pressed_item.name] against [owner.p_their()] [held_bodypart.plaintext_zone].")

/datum/status_effect/temperature_pack/heat/tick()
	if(HAS_TRAIT(pressed_item, TRAIT_FROZEN))
		stop_effects(silent = TRUE)
		return

	return ..()
