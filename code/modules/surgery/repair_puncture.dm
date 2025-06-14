
/////BURN FIXING SURGERIES//////

//the step numbers of each of these two, we only currently use the first to switch back and forth due to advancing after finishing steps anyway
#define REALIGN_INNARDS 1
#define WELD_VEINS 2

///// Repair puncture wounds
/datum/surgery/repair_puncture
	name = "Repair puncture"
	surgery_flags = SURGERY_REQUIRE_RESTING | SURGERY_REQUIRE_LIMB | SURGERY_REQUIRES_REAL_LIMB
	targetable_wound = /datum/wound/pierce/bleed
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
		/datum/surgery_step/repair_innards,
		/datum/surgery_step/seal_veins,
		/datum/surgery_step/close,
	)

/datum/surgery/repair_puncture/is_valid_wound(datum/wound/wound)
	return ..() && wound.blood_flow > 0

//SURGERY STEPS

///// realign the blood vessels so we can reweld them
/datum/surgery_step/repair_innards
	name = "realign blood vessels (hemostat)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCALPEL = 85,
		TOOL_WIRECUTTER = 40)
	time = 3 SECONDS
	preop_sound = 'sound/surgery/hemostat1.ogg'

/datum/surgery_step/repair_innards/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		user.visible_message(span_notice("[user] looks for [target]'s [parse_zone(target_zone)]."), span_notice("You look for [target]'s [parse_zone(target_zone)]..."))
		return

	if(pierce_wound.blood_flow <= 0)
		to_chat(user, span_notice("[target]'s [parse_zone(target_zone)] has no puncture to repair!"))
		surgery.status++
		return

	display_results(
		user,
		target,
		span_notice("You begin to realign the torn blood vessels in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to realign the torn blood vessels in [target]'s [parse_zone(target_zone)] with [tool]."),
		span_notice("[user] begins to realign the torn blood vessels in [target]'s [parse_zone(target_zone)]."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "You feel a horrible stabbing pain in your [parse_zone(target_zone)]!",
		pain_amount = SURGERY_PAIN_MEDIUM,
	)

/datum/surgery_step/repair_innards/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		to_chat(user, span_warning("[target] has no puncture wound there!"))
		return ..()

	display_results(
		user,
		target,
		span_notice("You successfully realign some of the blood vessels in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] successfully realigns some of the blood vessels in [target]'s [parse_zone(target_zone)] with [tool]!"),
		span_notice("[user] successfully realigns some of the blood vessels in  [target]'s [parse_zone(target_zone)]!"),
	)
	log_combat(user, target, "excised infected flesh in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	target.apply_damage(3, BRUTE, surgery.operated_bodypart, wound_bonus = CANT_WOUND, attacking_item = tool)
	pierce_wound.adjust_blood_flow(-0.25)
	return ..()

/datum/surgery_step/repair_innards/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob = 0)
	. = ..()
	display_results(
		user,
		target,
		span_notice("You jerk apart some of the blood vessels in [target]'s [parse_zone(target_zone)]."),
		span_notice("[user] jerks apart some of the blood vessels in [target]'s [parse_zone(target_zone)] with [tool]!"),
		span_notice("[user] jerk apart some of the blood vessels in [target]'s [parse_zone(target_zone)]!"),
	)
	target.apply_damage(rand(4, 8), BRUTE, surgery.operated_bodypart, wound_bonus = 10, sharpness = SHARP_EDGED, attacking_item = tool)

///// Sealing the vessels back together
/datum/surgery_step/seal_veins
	name = "weld veins (cautery)" // if your doctor says they're going to weld your blood vessels back together, you're either A) on SS13, or B) in grave mortal peril
	implements = list(
		TOOL_CAUTERY = 100,
		/obj/item/gun/energy/laser = 90,
		TOOL_WELDER = 70,
		/obj/item = 30)
	time = 4 SECONDS
	preop_sound = 'sound/surgery/cautery1.ogg'
	success_sound = 'sound/surgery/cautery2.ogg'

/datum/surgery_step/seal_veins/tool_check(mob/user, obj/item/tool)
	if(implement_type == TOOL_WELDER || implement_type == /obj/item)
		return tool.get_temperature()

	return TRUE

/datum/surgery_step/seal_veins/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		user.visible_message(span_notice("[user] looks for [target]'s [parse_zone(target_zone)]."), span_notice("You look for [target]'s [parse_zone(target_zone)]..."))
		return
	display_results(
		user,
		target,
		span_notice("You begin to meld some of the split blood vessels in [target]'s [parse_zone(target_zone)]..."),
		span_notice("[user] begins to meld some of the split blood vessels in [target]'s [parse_zone(target_zone)] with [tool]."),
		span_notice("[user] begins to meld some of the split blood vessels in [target]'s [parse_zone(target_zone)]."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "You're being burned inside your [parse_zone(target_zone)]!",
		pain_amount = SURGERY_PAIN_MEDIUM,
		pain_type = BURN,
	)

/datum/surgery_step/seal_veins/success(mob/living/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	var/datum/wound/pierce/bleed/pierce_wound = surgery.operated_wound
	if(!pierce_wound)
		to_chat(user, span_warning("[target] has no puncture there!"))
		return ..()

	display_results(
		user,
		target,
		span_notice("You successfully meld some of the split blood vessels in [target]'s [parse_zone(target_zone)] with [tool]."),
		span_notice("[user] successfully melds some of the split blood vessels in [target]'s [parse_zone(target_zone)] with [tool]!"),
		span_notice("[user] successfully melds some of the split blood vessels in [target]'s [parse_zone(target_zone)]!"),
	)
	log_combat(user, target, "dressed burns in", addition="COMBAT MODE: [uppertext(user.combat_mode)]")
	pierce_wound.adjust_blood_flow(-0.5)
	if(!QDELETED(pierce_wound) && pierce_wound.blood_flow > 0)
		surgery.status = REALIGN_INNARDS
		to_chat(user, span_notice("<i>There still seems to be misaligned blood vessels to finish...</i>"))
	else
		to_chat(user, span_green("You've repaired all the internal damage in [target]'s [parse_zone(target_zone)]!"))
	return ..()

#undef REALIGN_INNARDS
#undef WELD_VEINS
