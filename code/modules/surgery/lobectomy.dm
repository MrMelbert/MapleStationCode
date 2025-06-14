/datum/surgery/lobectomy
	name = "Lobectomy" //not to be confused with lobotomy
	organ_to_manipulate = ORGAN_SLOT_LUNGS
	possible_locs = list(BODY_ZONE_CHEST)
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/lobectomy,
		/datum/surgery_step/close,
	)

/datum/surgery/lobectomy/can_start(mob/user, mob/living/carbon/target)
	var/obj/item/organ/internal/lungs/target_lungs = target.get_organ_slot(ORGAN_SLOT_LUNGS)
	if(isnull(target_lungs) || target_lungs.damage < 60 || target_lungs.operated)
		return FALSE
	return ..()


//lobectomy, removes the most damaged lung lobe with a 95% base success chance
/datum/surgery_step/lobectomy
	name = "excise damaged lung node (scalpel)"
	implements = list(
		TOOL_SCALPEL = 95,
		/obj/item/melee/energy/sword = 65,
		/obj/item/knife = 45,
		/obj/item/shard = 35)
	time = 42
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	failure_sound = 'sound/surgery/organ2.ogg'

/datum/surgery_step/lobectomy/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(
		user,
		target,
		span_notice("You begin to make an incision in [target]'s lungs..."),
		span_notice("[user] begins to make an incision in [target]."),
		span_notice("[user] begins to make an incision in [target]."),
	)
	display_pain(
		target = target,
		target_zone = target_zone,
		pain_message = "You feel a stabbing pain in your [parse_zone(target_zone)]!",
		pain_amount = SURGERY_PAIN_HIGH,
		surgery_moodlet = /datum/mood_event/surgery/major,
	)

/datum/surgery_step/lobectomy/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		var/obj/item/organ/internal/lungs/target_lungs = human_target.get_organ_slot(ORGAN_SLOT_LUNGS)
		target_lungs.operated = TRUE
		human_target.setOrganLoss(ORGAN_SLOT_LUNGS, 60)
		display_results(
			user,
			target,
			span_notice("You successfully excise [human_target]'s most damaged lobe."),
			span_notice("Successfully removes a piece of [human_target]'s lungs."),
			"",
		)
		display_pain(
			target = target,
			target_zone = target_zone,
			pain_message = "Your [parse_zone(target_zone)] hurts like hell, but breathing becomes slightly easier.",
			surgery_moodlet = /datum/mood_event/surgery/major,
		)
	return ..()

/datum/surgery_step/lobectomy/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	if(ishuman(target))
		var/mob/living/carbon/human/human_target = target
		display_results(
			user,
			target,
			span_warning("You screw up, failing to excise [human_target]'s damaged lobe!"),
			span_warning("[user] screws up!"),
			span_warning("[user] screws up!"),
		)
		display_pain(
			target = target,
			target_zone = target_zone,
			pain_message = "You feel a sharp stab in your [parse_zone(target_zone)]; the wind is knocked out of you and it hurts to catch your breath!",
			pain_amount = SURGERY_PAIN_HIGH,
			surgery_moodlet = /datum/mood_event/surgery/major,
		)
		human_target.losebreath += 4
		human_target.adjustOrganLoss(ORGAN_SLOT_LUNGS, 10)
	return FALSE
