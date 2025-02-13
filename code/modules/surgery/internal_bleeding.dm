/// Repair internal bleeding
/datum/surgery/internal_bleeding
	name = "Repair Internal Bleeding"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/bleed_internal
	target_mobtypes = list(/mob/living/carbon)
	possible_locs = list(
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
		BODY_ZONE_CHEST,
		BODY_ZONE_HEAD,
	)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/repair_veins,
		/datum/surgery_step/close,
	)

/datum/surgery_step/repair_veins
	name = "repair arterial bleeding (hemostat/blood filter)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_BLOODFILTER = 100,
		TOOL_WIRECUTTER = 40,
		/obj/item/stack/sticky_tape/surgical = 30,
		/obj/item/stack/cable_coil = 10,
		/obj/item/stack/sticky_tape = 10,
	)
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/organ2.ogg'
	time = 6 SECONDS
	repeatable = TRUE

/datum/surgery_step/repair_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/in_where = "[target]'s [parse_zone(target_zone)]"
	display_results(
		user,
		target,
		span_notice("You begin repair the arteries in [in_where]..."),
		span_notice("[user] begins to repair the arteries in [in_where] with [tool]."),
		span_notice("[user] begins to repair the arteries in [in_where]."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "You feel a horrible stabbing pain in your [parse_zone(target_zone)]!",
		pain_amount = SURGERY_PAIN_LOW,
	)

/datum/surgery_step/repair_veins/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/in_where = "[target]'s [parse_zone(target_zone)]"
	if((surgery.operated_wound?.severity - 1) <= WOUND_SEVERITY_TRIVIAL)
		qdel(surgery.operated_wound)
		display_results(
			user,
			target,
			span_green("You've finishes repairing all the arterial damage in [in_where]."),
			span_green("[user] finishes repaiing all the arterial damage in [in_where] with [tool]!"),
			span_green("[user] finishes repaiing all the arterial damage in [in_where]!"),
		)
		repeatable = FALSE
		return ..()

	surgery.operated_wound.severity--
	display_results(
		user,
		target,
		span_notice("You successfully repair some of the arteries in [in_where] with [tool]."),
		span_notice("[user] successfully repairs some of the arteries in [in_where] with [tool]!"),
		span_notice("[user] successfully repairs some of the arteries in [in_where]!"),
	)
	target.apply_damage(3, BRUTE, surgery.operated_bodypart, wound_bonus = CANT_WOUND, attacking_item = tool)
	return ..()

/datum/surgery_step/repair_veins/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	var/in_where = "[target]'s [parse_zone(target_zone)]"
	display_results(
		user,
		target,
		span_warning("You tear some of the arteries in [in_where]!"),
		span_warning("[user] tears some of the arteries in [in_where] with [tool]!"),
		span_warning("[user] tears some of the arteries in [in_where]!"),
	)
	target.apply_damage(rand(4, 8), BRUTE, surgery.operated_bodypart, wound_bonus = 10, sharpness = SHARP_EDGED, attacking_item = tool)
	return FALSE
