/// Repair internal bleeding
/datum/surgery_operation/limb/internal_bleeding
	name = "repair internal bleeding"
	desc = "Repair arterial damage which is causing internal bleeding in a limb."
	rnd_desc = "A surgery that repairs internal bleeding in a limb caused by severe trauma / arterial damage."
	required_bodytype = ~BODYTYPE_ROBOTIC
	time = 5 SECONDS
	operation_flags = OPERATION_IGNORE_CLOTHES | OPERATION_NOTABLE | OPERATION_LOOPING
	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_BLOODFILTER = 1,
		TOOL_WIRECUTTER = 2,
		/obj/item/stack/sticky_tape/surgical = 5,
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sticky_tape = 10,
	)
	all_surgery_states_required = SURGERY_SKIN_OPEN

	var/damage_descriptor = "arterial damage"
	var/fixing_descriptor = "arteries"

/datum/surgery_operation/limb/internal_bleeding/state_check(obj/item/bodypart/limb)
	for(var/datum/wound/bleed_internal/wound in limb.wounds)
		if(wound.severity >= WOUND_SEVERITY_TRIVIAL)
			return TRUE
	return FALSE

/datum/surgery_operation/limb/internal_bleeding/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to repair the [damage_descriptor] within [limb.owner]'s [limb.plaintext_zone]..."),
		span_notice("[surgeon] begins to repair the [damage_descriptor] within [limb.owner]'s [limb.plaintext_zone] with [tool]."),
		span_notice("[surgeon] begins to repair the [damage_descriptor] within [limb.owner]'s [limb.plaintext_zone]."),
	)
	display_pain(
		target = limb.owner,
		affected_locations = limb,
		pain_message = "You feel a horrible stabbing pain in your [limb.plaintext_zone]!",
		pain_amount = (operation_args?[OPERATION_TOOL_QUALITY] || 1) * SURGERY_PAIN_LOW,
	)

/datum/surgery_operation/limb/internal_bleeding/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/datum/wound/bleed_internal/target_wound = locate() in limb.wounds
	target_wound.severity--
	if(target_wound.severity <= WOUND_SEVERITY_TRIVIAL)
		qdel(target_wound)
		display_results(
			surgeon,
			limb.owner,
			span_green("You've finished repairing all the [damage_descriptor] within [limb.owner]'s [limb.plaintext_zone]."),
			span_green("[surgeon] finished repairing all the [damage_descriptor] within [limb.owner]'s [limb.plaintext_zone] with [tool]!"),
			span_green("[surgeon] finished repairing all the [damage_descriptor] within [limb.owner]'s [limb.plaintext_zone]!"),
		)
		return

	display_results(
		surgeon,
		limb.owner,
		span_notice("You successfully repair some of the [fixing_descriptor] within [limb.owner]'s [limb.plaintext_zone] with [tool]."),
		span_notice("[surgeon] successfully repairs some of the [fixing_descriptor] within [limb.owner]'s [limb.plaintext_zone] with [tool]!"),
		span_notice("[surgeon] successfully repairs some of the [fixing_descriptor] within [limb.owner]'s [limb.plaintext_zone]!"),
	)
	limb.receive_damage(3, BRUTE, wound_bonus = CANT_WOUND, damage_source = tool)

/datum/surgery_operation/limb/internal_bleeding/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args, fail_prob = 0)
	var/datum/wound/bleed_internal/target_wound = locate() in limb.wounds
	target_wound?.severity++
	display_results(
		surgeon,
		limb.owner,
		span_warning("You tear some of the [fixing_descriptor] within [limb.owner]'s [limb.plaintext_zone]!"),
		span_warning("[surgeon] tears some of the [fixing_descriptor] within [limb.owner]'s [limb.plaintext_zone] with [tool]!"),
		span_warning("[surgeon] tears some of the [fixing_descriptor] within [limb.owner]'s [limb.plaintext_zone]!"),
	)
	limb.receive_damage(rand(4, 8), BRUTE, wound_bonus = 10, sharpness = SHARP_EDGED, damage_source = tool)

/datum/surgery_operation/limb/internal_bleeding/mechanic
	name = "repair hydraulics leak"
	desc = "Repair a leak in the hydraulics of a robotic limb."
	rnd_desc = "A surgery that repairs a leak in the hydraulics of a robotic limb caused by severe trauma."
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
	implements = list(
		TOOL_HEMOSTAT = 1,
		TOOL_WIRECUTTER = 1,
		/obj/item/stack/sticky_tape/surgical = 2,
		/obj/item/stack/sticky_tape = 3,
		/obj/item/stack/cable_coil = 5,
	)
	damage_descriptor = "hydraulics leak"
	fixing_descriptor = "hydraulic tubes"
