// -- Pain status effects. --

/atom/movable/screen/alert/status_effect/limp/pain
	name = "Pained Limping"
	desc = "The pain in your legs is unbearable, forcing you to limp!"

/datum/status_effect/limp/pain
	id = "limp_pain"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/limp/pain
	examine_text = "They're limping with every move."

/datum/status_effect/limp/pain/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/owner_human = owner
	if(!istype(owner_human) || !owner_human.pain_controller)
		return FALSE

	RegisterSignal(owner, list(COMSIG_CARBON_PAIN_GAINED, COMSIG_CARBON_PAIN_LOST), .proc/update_limp)
	examine_text = span_warning("[owner.p_theyre(TRUE)] limping with every move.")

/datum/status_effect/limp/pain/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_CARBON_PAIN_GAINED, COMSIG_CARBON_PAIN_LOST))
	to_chat(owner, span_green("Your pained limp stops!"))

/datum/status_effect/limp/pain/update_limp()
	var/mob/living/carbon/human/limping_human = owner
	if(!ishuman(owner) || !limping_human.pain_controller)
		limping_human.remove_status_effect(src)
		return

	left = limping_human.pain_controller.body_zones[BODY_ZONE_L_LEG]
	right = limping_human.pain_controller.body_zones[BODY_ZONE_R_LEG]

	if(!left && !right)
		limping_human.remove_status_effect(src)
		return

	slowdown_left = 0
	slowdown_right = 0

	if(left?.get_modified_pain() >= 30)
		slowdown_left = left.get_modified_pain() / 10

	if(right?.get_modified_pain() >= 30)
		slowdown_right = right.get_modified_pain() / 10

	// this handles losing your leg with the limp and the other one being in good shape as well
	if(slowdown_left < 3 && slowdown_right < 3)
		limping_human.remove_status_effect(src)

/atom/movable/screen/alert/status_effect/low_blood_pressure
	name = "Low blood pressure"
	desc = "Your blood pressure is low right now. Your organs aren't getting enough blood."
	icon_state = "highbloodpressure"

/datum/status_effect/low_blood_pressure
	id = "low_blood_pressure"
	tick_interval = -1
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/low_blood_pressure

/datum/status_effect/low_blood_pressure/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod *= 0.75

/datum/status_effect/low_blood_pressure/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod /= 0.75

/// Sharp pain. Used for a lot of pain at once, as a little of it is healed after the effect runs out.
/datum/status_effect/sharp_pain
	id = "sharp_pain"
	status_type = STATUS_EFFECT_MULTIPLE
	on_remove_on_mob_delete = TRUE
	alert_type = null
	/// Amount of pain being given
	var/pain_amount = 0
	/// Type of pain being given
	var/pain_type
	/// The amount of pain we had before recieving the sharp pain
	var/initial_pain_amount = 0
	/// The zone we're afflicting
	var/targeted_zone

/datum/status_effect/sharp_pain/on_creation(
		mob/living/carbon/human/new_owner,
		targeted_zone,
		pain_amount = 0,
		pain_type = BRUTE,
		duration = 0
	)

	src.duration = duration
	src.targeted_zone = targeted_zone
	src.pain_amount = pain_amount
	src.pain_type = pain_type
	return ..()

/datum/status_effect/sharp_pain/on_apply()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_owner = owner
	if(!human_owner.pain_controller)
		return FALSE

	if(!targeted_zone || pain_amount == 0 || duration <= 0)
		return FALSE

	var/obj/item/bodypart/afflicted_bodypart = human_owner.pain_controller.body_zones[targeted_zone]
	if(!afflicted_bodypart)
		return FALSE

	initial_pain_amount = afflicted_bodypart.pain
	human_owner.pain_controller.adjust_bodypart_pain(targeted_zone, pain_amount, pain_type)
	return TRUE

/datum/status_effect/sharp_pain/on_remove()
	var/mob/living/carbon/human/human_owner = owner
	var/obj/item/bodypart/afflicted_bodypart = human_owner.pain_controller?.body_zones[targeted_zone]
	if(!afflicted_bodypart)
		return

	var/healed_amount = pain_amount / -3
	if((afflicted_bodypart.pain + healed_amount) < initial_pain_amount)
		healed_amount = initial_pain_amount - afflicted_bodypart.pain

	human_owner.pain_controller.adjust_bodypart_pain(targeted_zone, healed_amount, pain_type)

/// Adjusting a limb's minimum bodypart pain for a time.
/datum/status_effect/minimum_bodypart_pain
	id = "min_bodypart_pain"
	status_type = STATUS_EFFECT_MULTIPLE
	on_remove_on_mob_delete = TRUE
	alert_type = null
	/// The min pain we're setting the bodypart to
	var/min_amount = 0
	/// The zone we're afflicting
	var/targeted_zone = BODY_ZONE_CHEST

/datum/status_effect/minimum_bodypart_pain/on_creation(
		mob/living/carbon/human/new_owner,
		targeted_zone,
		min_amount = 0,
		duration = 0
	)

	src.duration = duration
	src.targeted_zone = targeted_zone
	src.min_amount = min_amount
	return ..()

/datum/status_effect/minimum_bodypart_pain/on_apply()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_owner = owner
	if(!human_owner.pain_controller)
		return FALSE

	if(!targeted_zone || min_amount == 0 || duration <= 0)
		return FALSE

	var/obj/item/bodypart/afflicted_bodypart = human_owner.pain_controller.body_zones[targeted_zone]
	if(!afflicted_bodypart)
		return FALSE

	human_owner.pain_controller.adjust_bodypart_min_pain(targeted_zone, min_amount)
	return TRUE

/datum/status_effect/minimum_bodypart_pain/on_remove()
	var/mob/living/carbon/human/human_owner = owner
	var/obj/item/bodypart/afflicted_bodypart = human_owner.pain_controller?.body_zones[targeted_zone]
	if(!afflicted_bodypart)
		return

	human_owner.pain_controller.adjust_bodypart_min_pain(targeted_zone, -min_amount)

/// Status effect for pressing a hot or cold item onto a bodypart, to soothe pain.
/datum/status_effect/temperature_pack
	id = "temp_pack"
	status_type = STATUS_EFFECT_MULTIPLE
	on_remove_on_mob_delete = TRUE
	tick_interval = 5 SECONDS
	processing_speed = STATUS_EFFECT_NORMAL_PROCESS
	alert_type = null
	examine_text = "They're holding a pack to a limb."
	/// The item we're using to heal pain.
	var/obj/item/pressed_item
	/// The mob holding the [pressed_item] to [owner]. Can be [owner].
	var/mob/living/holder
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
		temperature_change = 0
	)

	src.holder = holder
	src.pressed_item = pressed_item
	src.targeted_zone = targeted_zone
	src.pain_heal_amount = pain_heal_amount
	src.pain_modifier = pain_modifier
	src.temperature_change = temperature_change
	return ..()

/datum/status_effect/temperature_pack/on_apply()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/human_owner = owner
	if(!human_owner.pain_controller || human_owner.stat == DEAD)
		return FALSE

	if(QDELETED(pressed_item))
		return FALSE

	if(QDELETED(holder))
		return FALSE

	for(var/datum/status_effect/temperature_pack/pre_existing_effect in owner.status_effects)
		if(pre_existing_effect == src)
			continue
		if(pre_existing_effect.targeted_zone == targeted_zone)
			return FALSE

	var/obj/item/bodypart/held_bodypart = human_owner.pain_controller.body_zones[targeted_zone]
	if(!held_bodypart)
		return FALSE

	held_bodypart.bodypart_pain_modifier *= pain_modifier
	pressed_item.AddComponent(/datum/component/make_item_slow)
	RegisterSignal(pressed_item, list(COMSIG_PARENT_QDELETING, COMSIG_ITEM_DROPPED, COMSIG_TEMPERATURE_PACK_EXPIRED), .proc/stop_effects)
	if(holder != owner)
		RegisterSignal(holder, COMSIG_MOVABLE_MOVED, .proc/check_adjacency)
	return TRUE

/datum/status_effect/temperature_pack/tick()
	if(QDELETED(holder) || QDELETED(pressed_item) || owner.stat == DEAD || !holder.is_holding(pressed_item))
		stop_effects(silent = TRUE)
		return

	var/mob/living/carbon/human/human_owner = owner
	if(!human_owner.get_bodypart_pain(targeted_zone, TRUE))
		stop_effects(silent = FALSE)
		return

	if(temperature_change)
		owner.adjust_bodytemperature(temperature_change, human_owner.get_body_temp_cold_damage_limit() + 5, human_owner.get_body_temp_heat_damage_limit() - 5)
	var/obj/item/bodypart/held_bodypart = human_owner.pain_controller.body_zones[targeted_zone]
	if(held_bodypart && prob(66))
		human_owner.cause_pain(targeted_zone, -pain_heal_amount)
		if(prob(10))
			to_chat(human_owner, span_italics(span_notice("[pressed_item] dulls the pain in your [held_bodypart.name] a little.")))

/*
 * Check on move whether [holder] is still adjacent to [owner].
 */
/datum/status_effect/temperature_pack/proc/check_adjacency(datum/source)
	SIGNAL_HANDLER

	if(!in_range(holder, owner))
		stop_effects(silent = FALSE)

/*
 * Stop the effects of this status effect, deleting it, and sending a message if [silent] is TRUE.
 */
/datum/status_effect/temperature_pack/proc/stop_effects(datum/source, silent = FALSE)
	SIGNAL_HANDLER

	if(!silent && !QDELETED(holder) && !QDELETED(pressed_item))
		to_chat(holder, span_notice("You stop pressing [pressed_item] against [owner == holder ? "yourself":"[owner]"]."))
	qdel(src)

/datum/status_effect/temperature_pack/on_remove()
	var/mob/living/carbon/human/human_owner = owner
	var/obj/item/bodypart/held_bodypart = human_owner.pain_controller?.body_zones[targeted_zone]
	held_bodypart?.bodypart_pain_modifier /= pain_modifier
	qdel(pressed_item.GetComponent(/datum/component/make_item_slow))
	UnregisterSignal(pressed_item, list(COMSIG_PARENT_QDELETING, COMSIG_ITEM_DROPPED, COMSIG_TEMPERATURE_PACK_EXPIRED))
	UnregisterSignal(holder, COMSIG_MOVABLE_MOVED)

	pressed_item = null
	holder = null

// Cold stuff needs to stay cold.
/datum/status_effect/temperature_pack/cold
	id = "cold_pack"
	temperature_change = -2

/datum/status_effect/temperature_pack/cold/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/human_owner = owner
	var/obj/item/bodypart/held_bodypart = human_owner.pain_controller.body_zones[targeted_zone]
	examine_text = span_danger("[holder == owner ? "[owner.p_theyre(TRUE)]" : "[holder] is"] pressing a cold [pressed_item.name] against [owner.p_their()] [held_bodypart.name].")
	to_chat(human_owner, span_green("You wince as [owner == holder ? "you press" : "[holder] presses"] [pressed_item] against your [held_bodypart.name], but eventually the chill starts to dull the pain."))
	human_owner.pain_emote("wince", 3 SECONDS)

/datum/status_effect/temperature_pack/cold/tick()
	if(pressed_item.resistance_flags & ON_FIRE)
		stop_effects(silent = TRUE)
		return

	. = ..()

// And warm stuff needs to stay warm.
/datum/status_effect/temperature_pack/heat
	id = "heat_pack"
	temperature_change = 2

/datum/status_effect/temperature_pack/heat/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/human_owner = owner
	var/obj/item/bodypart/held_bodypart = human_owner.pain_controller.body_zones[targeted_zone]
	examine_text = span_danger("[holder == owner ? "[owner.p_theyre(TRUE)]" : "[holder] is"] pressing a warm [pressed_item.name] against [owner.p_their()] [held_bodypart.name].")
	to_chat(human_owner, span_green("You gasp as [owner == holder ? "you press" : "[holder] presses"] [pressed_item] against your [held_bodypart.name], but eventually the warmth starts to dull the pain."))
	human_owner.pain_emote("gasp", 3 SECONDS)

/datum/status_effect/temperature_pack/heat/tick()
	if(pressed_item.obj_flags & FROZEN)
		stop_effects(silent = TRUE)
		return

	. = ..()
