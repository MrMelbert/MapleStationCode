/// Neutered changeling surgery.

/*
 * Neuter changeling surgery.
 * - locked behind experimental surgery (uncommon to get)
 * - requires them to be headless
 *
 * - if the target is a changeling, neuters them on success
 * - if the target is not a changeling, screws all their internal chest organs
 */

// The design of the surgery.
/datum/design/surgery/neuter_changeling
	name = "Neuter Changeling"
	desc = "An dangerous experimental surgery that can potentially neuter a changeling's hostile abilities \
		- but massively harms the internal organs of non-changelings."
	id = "surgery_neuter_ling"
	surgery = /datum/surgery/advanced/lobotomy
	research_icon_state = "surgery_chest"

// The surgery itself.
/datum/surgery/advanced/neuter_ling
	name = "Neuter Changeling"
	desc = "An experimental surgery designed to neuter the abilities of a changeling by crippling the headslug within. \
		Can only be done on unconscious patients who have had their head removed prior. \
		If the patient was not a changeling, causes massive internal organ damage."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/retract_skin,
		/datum/surgery_step/saw,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/drill, // yes drill!
		/datum/surgery_step/neuter_ling,
		/datum/surgery_step/clamp_bleeders,
		/datum/surgery_step/close,
		)

	target_mobtypes = list(/mob/living/carbon/human)
	possible_locs = list(BODY_ZONE_CHEST)
	requires_bodypart_type = 0
	ignore_clothes = TRUE

/datum/surgery/advanced/neuter_ling/can_start(mob/user, mob/living/carbon/target)
	. = ..()
	if(!.)
		return
	if(target.stat <= UNCONSCIOUS)
		return FALSE
	if(target.get_bodypart(BODY_ZONE_HEAD))
		return FALSE

// The surgical step behind the surgery.
/datum/surgery_step/neuter_ling
	name = "neuter headslug"
	time = 10 SECONDS
	implements = list(
		TOOL_RETRACTOR = 70, // Even a retractor is not too good at it, better get sterile
		TOOL_HEMOSTAT = 60,
		TOOL_SCREWDRIVER = 20,
		TOOL_WIRECUTTER = 15
		)

/// MELBERT TODO: This acts a bit strangely the way it's called in the surgery chain.
/datum/surgery_step/neuter_ling/try_op(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, try_to_fail)
	var/obj/item/other_item = user.get_inactive_held_item()
	if(!other_item?.get_sharpness())
		to_chat(user, span_warning("You need a sharp object in your inactive hand to do this step!"))
		return FALSE
	. = ..()

/datum/surgery_step/neuter_ling/preop(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	display_results(user, target,
		span_notice("You begin operate within [target]'s chest, looking for a changeling headslug..."),
		span_notice("[user] begins to operate within [target]'s chest, looking for a changeling headslug."),
		span_notice("[user] begins to work within [target]'s chest."))

/// Successfully neutering the changeling removes the changeling datum and gives them the neutered changelings datum.
/datum/surgery_step/neuter_ling/success(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = FALSE)
	if(is_neutered_changeling(target))
		to_chat(user, span_notice("The changeling headslug inside has already been neutered!"))
		return TRUE
	if(is_fallen_changeling(target))
		to_chat(user, span_notice("The changeling headslug inside is dead!"))
		return TRUE

	var/datum/antagonist/changeling/old_ling_datum = is_any_changeling(target)
	if(old_ling_datum)
		// It was a ling, good job bucko! The changeling is neutered.
		display_results(user, target,
			span_notice("You locate and succeed in neutering the headslug within [target]'s chest."),
			span_notice("[user] successfully locates and neuters the headslug within [target]'s chest!"),
			span_notice("[user] finishes working within [target]'s chest."))

		var/ling_id = old_ling_datum.changeling_id

		target.mind.remove_antag_datum(/datum/antagonist/changeling)
		var/datum/antagonist/changeling/new_ling_datum = target.mind.add_antag_datum(/datum/antagonist/changeling/neutered)
		new_ling_datum.changeling_id = ling_id

		target.do_jitter_animation(30)

		var/revival_message_end = "and limply"
		if(target.getorganslot(ORGAN_SLOT_HEART))
			revival_message_end = "as their heart beats once more"
		if(target.heal_and_revive((target.stat == DEAD ? 50 : 75), span_danger("[target] begins to write unnaturally [revival_message_end], their body struggling to regenerate!")))
			new_ling_datum.chem_charges += 15
			var/datum/action/changeling/regenerate/regenerate_action = locate() in target.actions
			regenerate_action?.sting_action(target) // Regenerate ourselves after revival, for heads / organs / whatever
			target.AdjustUnconscious(15 SECONDS, TRUE)
			target.cause_pain(BODY_ZONE_CHEST, 60)
			target.cause_pain(BODY_ZONE_HEAD, 40)
			target.cause_pain(BODY_ZONES_LIMBS, 25)
		to_chat(target, span_big(span_green("Our headslug has been neutered! Our powers are lost... The hive screams in agony before going silent.")))

		message_admins("[ADMIN_LOOKUPFLW(user)] neutered [ADMIN_LOOKUPFLW(target)]'s changeling abilities via surgery.")
		target.log_message("has has their changeling abilities neutered by [key_name(user)] via surgery", LOG_ATTACK)
		log_game("[key_name(user)] neutered [key_name(target)]'s changeling abilities via surgery.")
	else
		// It wasn't a ling, idiot! Now you have a headless, all-chest-organs-destroyed body of an innocent person to fix up!
		display_results(user, target,
			span_danger("You succeed in operating within [target]'s chest...but find no headslug, causing heavy internal damage!"),
			span_danger("[user] finishes operating within [target]'s chest...but finds no headslug, causing heavy internal damage!"),
			span_notice("[user] finishes working within [target]'s chest."), TRUE)

		target.cause_pain(BODY_ZONE_CHEST, 60)
		target.cause_pain(BODY_ZONES_LIMBS, 25)
		for(var/obj/item/organ/stabbed_organ as anything in target.internal_organs)
			if(stabbed_organ.zone == BODY_ZONE_CHEST || stabbed_organ.zone == BODY_ZONE_PRECISE_GROIN)
				stabbed_organ.applyOrganDamage(105) // Breaks all normal organs, severely damages cyber organs

		message_admins("[ADMIN_LOOKUPFLW(user)] attempted to changeling neuter a non-changeling, [ADMIN_LOOKUPFLW(target)] via surgery.")

	return ..()

/// Failing to neuter the changeling gives them full chemicals.
/datum/surgery_step/neuter_ling/failure(mob/user, mob/living/carbon/target, target_zone, obj/item/tool, datum/surgery/surgery)
	// Failure means they couldn't find a headslug, but there may be one in there...
	display_results(user, target,
		span_danger("You fail to locate a headslug within [target], causing internal damage!"),
		span_danger("[user] fails to locate a headslug within [target], causing internal damage!"),
		span_notice("[user] fails to locate a headslug!"), TRUE)

	// ...And if there is, the changeling gets pissed
	var/datum/antagonist/changeling/our_changeling = is_any_changeling(target)
	if(our_changeling)
		to_chat(target, span_changeling("[user] has attempted and failed to neuter our changeling abilities! We feel invigorated, we must break free!"))
		target.do_jitter_animation(50)
		our_changeling.chem_charges = our_changeling.total_chem_storage

	// Causes organ damage nonetheless
	for(var/obj/item/organ/stabbed_organ as anything in target.internal_organs)
		if(stabbed_organ.zone == BODY_ZONE_CHEST || stabbed_organ.zone == BODY_ZONE_PRECISE_GROIN)
			stabbed_organ.applyOrganDamage(25)
