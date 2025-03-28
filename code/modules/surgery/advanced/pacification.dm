/datum/surgery/advanced/pacify
	name = "Pacification"
	desc = "A surgical procedure which permanently inhibits the aggression center of the brain, making the patient unwilling to cause direct harm."
	possible_locs = list(BODY_ZONE_HEAD)
	requires_bodypart_type = NONE
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/pacify,
		/datum/surgery_step/close,
	)

/datum/surgery/advanced/pacify/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	var/obj/item/organ/internal/brain/target_brain = target.get_organ_slot(ORGAN_SLOT_BRAIN)
	if(!target_brain)
		return FALSE

/datum/surgery_step/pacify
	name = "rewire brain (hemostat)"
	implements = list(
		TOOL_HEMOSTAT = 100,
		TOOL_SCREWDRIVER = 35,
		/obj/item/pen = 15)
	time = 40
	preop_sound = 'sound/surgery/hemostat1.ogg'
	success_sound = 'sound/surgery/hemostat1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/pacify/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to pacify [target]..."),
		span_notice("[user] begins to fix [target]'s brain."),
		span_notice("[user] begins to perform surgery on [target]'s brain."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "Your head pounds with unimaginable pain!",
		pain_amount = SURGERY_PAIN_CRITICAL,
		surgery_moodlet = /datum/mood_event/surgery/major,
	)

/datum/surgery_step/pacify/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	display_results(
		user,
		target,
		span_notice("You succeed in neurologically pacifying [target]."),
		span_notice("[user] successfully fixes [target]'s brain!"),
		span_notice("[user] completes the surgery on [target]'s brain."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "Your head pounds... the concept of violence flashes in your head, and nearly makes you hurl!",
		pain_amount = SURGERY_PAIN_CRITICAL,
		surgery_moodlet = /datum/mood_event/surgery/major,
	)
	target.adjust_disgust(DISGUST_LEVEL_DISGUSTED)
	target.gain_trauma(/datum/brain_trauma/severe/pacifism, TRAUMA_RESILIENCE_LOBOTOMY)
	return ..()

/datum/surgery_step/pacify/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You screw up, rewiring [target]'s brain the wrong way around..."),
		span_warning("[user] screws up, causing brain damage!"),
		span_notice("[user] completes the surgery on [target]'s brain."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "Your head pounds, and it feels like it's getting worse!",
		pain_amount = SURGERY_PAIN_CRITICAL,
		surgery_moodlet = /datum/mood_event/surgery/major,
	)
	target.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	return FALSE
