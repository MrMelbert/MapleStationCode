/datum/surgery_operation/limb/amputate
	name = "amputate limb"
	rnd_name = "Disarticulation (Amputation)"
	desc = "Sever a limb from a patient's body."
	operation_flags = OPERATION_MORBID | OPERATION_AFFECTS_MOOD | OPERATION_NOTABLE
	required_bodytype = ~(BODYTYPE_ROBOTIC|BODYTYPE_PEG)
	implements = list(
		/obj/item/shears = 0.33,
		TOOL_SAW = 1,
		TOOL_SCALPEL = 1,
		/obj/item/melee/arm_blade = 1.25,
		/obj/item/shovel/serrated = 1.33,
		/obj/item/fireaxe = 2,
		/obj/item/hatchet = 2.5,
		/obj/item/knife/butcher = 4,
	)
	time = 6.4 SECONDS
	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item = 'sound/surgery/scalpel1.ogg',
	)
	success_sound = 'sound/surgery/organ2.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN|SURGERY_BONE_SAWED|SURGERY_VESSELS_CLAMPED

/datum/surgery_operation/limb/amputate/get_recommended_tool()
	return TOOL_SAW

/datum/surgery_operation/limb/amputate/get_default_radial_image()
	return image(/obj/item/shears)

/datum/surgery_operation/limb/amputate/state_check(obj/item/bodypart/limb)
	if(limb.body_zone == BODY_ZONE_CHEST)
		return FALSE
	if(limb.bodypart_flags & BODYPART_UNREMOVABLE)
		return FALSE
	if(HAS_TRAIT(limb.owner, TRAIT_NODISMEMBER))
		return FALSE
	return TRUE

/datum/surgery_operation/limb/amputate/on_preop(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin to sever [limb.owner]'s [limb.plaintext_zone]..."),
		span_notice("[surgeon] begins to sever [limb.owner]'s [limb.plaintext_zone]."),
		span_notice("[surgeon] begins to sever [limb.owner]'s [limb.plaintext_zone] with [tool]."),
	)
	// NON-MODULE CHANGE
	display_pain(
		target = limb.owner,
		affected_locations = limb,
		pain_message = "You feel a gruesome pain in your [limb.plaintext_zone]'s joint!",
		pain_amount = (operation_args?[OPERATION_TOOL_QUALITY] || 1) * SURGERY_PAIN_MEDIUM, // loss of the limb also applies pain to the chest, so we can afford to make this a bit lower
		pain_overlay_severity = 2,
	)

/datum/surgery_operation/limb/amputate/on_success(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You successfully amputate [limb.owner]'s [limb.plaintext_zone]!"),
		span_notice("[surgeon] successfully amputates [limb.owner]'s [limb.plaintext_zone]!"),
		span_notice("[surgeon] finishes severing [limb.owner]'s [limb.plaintext_zone]."),
	)
	// NON-MODULE CHANGE
	display_pain(
		target = limb.owner,
		affected_locations = limb,
		pain_message = "You can no longer feel your [limb.plaintext_zone]!",
		pain_amount = (operation_args?[OPERATION_TOOL_QUALITY] || 1) * SURGERY_PAIN_MEDIUM,
		pain_overlay_severity = 2,
	)
	if(HAS_MIND_TRAIT(surgeon, TRAIT_MORBID))
		surgeon.add_mood_event("morbid_dissection_success", /datum/mood_event/morbid_dissection_success)
	limb.drop_limb()

/datum/surgery_operation/limb/amputate/mechanic
	name = "disassemble limb"
	rnd_name = "Dissassembly (Amputation)"
	required_bodytype = BODYTYPE_ROBOTIC
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
	implements = list(
		/obj/item/shovel/giant_wrench = 0.33,
		TOOL_WRENCH = 1,
		TOOL_CROWBAR = 1,
		TOOL_SCALPEL = 2,
		TOOL_SAW = 2,
	)
	time = 2 SECONDS //WAIT I NEED THAT!!
	preop_sound = 'sound/items/ratchet.ogg'
	preop_sound = 'sound/machines/doorclick.ogg'
	all_surgery_states_required = SURGERY_SKIN_OPEN

/datum/surgery_operation/limb/amputate/mechanic/state_check(obj/item/bodypart/limb)
	// added requirement for bone sawed to prevent accidental head removals.
	return ..() && (limb.body_zone != BODY_ZONE_HEAD || LIMB_HAS_SURGERY_STATE(limb, SURGERY_BONE_SAWED))

/datum/surgery_operation/limb/amputate/mechanic/any_required_strings()
	return ..() + list(
		"if operating on the head, the bone MUST be sawed",
		"otherwise, the state of the bone doesn't matter",
	)

/datum/surgery_operation/limb/amputate/mechanic/get_recommended_tool()
	return "[TOOL_WRENCH] / [TOOL_SAW]"

/datum/surgery_operation/limb/amputate/pegleg
	name = "detach wooden limb"
	rnd_name = "Detach Wooden Limb (Amputation)"
	required_bodytype = BODYTYPE_PEG
	operation_flags = parent_type::operation_flags | OPERATION_MECHANIC
	implements = list(
		TOOL_SAW = 1,
		/obj/item/shovel/serrated = 1,
		/obj/item/fireaxe = 1.15,
		/obj/item/hatchet = 1.33,
		TOOL_SCALPEL = 4,
	)
	time = 3 SECONDS
	preop_sound = list(
		/obj/item/circular_saw = 'sound/surgery/saw.ogg',
		/obj/item = 'sound/weapons/bladeslice.ogg',
	)
	success_sound = 'sound/items/wood_drop.ogg'
	all_surgery_states_required = NONE

/datum/surgery_operation/limb/amputate/pegleg/all_required_strings()
	. = ..()
	. += "the limb must be wooden"
