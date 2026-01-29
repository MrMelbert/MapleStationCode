/// Neutered changeling surgery.

/**
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
	surgery = /datum/surgery_operation/limb/neuter_ling
	research_icon_state = "surgery_chest"

/datum/surgery_operation/limb/neuter_ling
	name = "neuter changeling"
	desc = "Attempt to neuter a changeling's headslug."
	rnd_name = "Mutatiotripsy (Neuter Changeling)"
	rnd_desc = "An experimental surgery that attempts to neuter the headslug of a changeling by operating within their chest cavity. \
		Successful surgery will remove the changeling's abilities, but failed surgery will only enrage it further. \
		If the target is not a changeling, this surgery will cause massive internal organ damage."
	time = 15 SECONDS
	operation_flags = OPERATION_ALWAYS_FAILABLE | OPERATION_IGNORE_CLOTHES | OPERATION_NOTABLE | OPERATION_MORBID | OPERATION_LOCKED
	implements = list(
		TOOL_SCALPEL = 1.33,
		TOOL_RETRACTOR = 1.33,
		TOOL_HEMOSTAT = 1.5,
		TOOL_SCREWDRIVER = 5.0,
		TOOL_WIRECUTTER = 6.66,
	)
	all_surgery_states_required = SURGERY_SKIN_OPEN | SURGERY_VESSELS_CLAMPED | SURGERY_ORGANS_CUT | SURGERY_BONE_DRILLED

/datum/surgery_operation/limb/neuter_ling/snowflake_check_availability(obj/item/bodypart/limb, mob/living/surgeon, tool, operated_zone)
	var/obj/item/offhand = surgeon.get_inactive_held_item()
	return !!offhand?.get_sharpness()

/datum/surgery_operation/limb/state_check(obj/item/bodypart/limb)
	if(limb.body_zone != BODY_ZONE_CHEST)
		return FALSE
	if(limb.owner.stat < UNCONSCIOUS)
		return FALSE
	return TRUE

/datum/surgery_operation/limb/neuter_ling/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("You begin operate within [limb.owner]'s [limb.plaintext_zone], looking for a changeling headslug..."),
		span_notice("[surgeon] begins to operate within [limb.owner]'s [limb.plaintext_zone], looking for a changeling headslug."),
		span_notice("[surgeon] begins to work within [limb.owner]'s [limb.plaintext_zone]."),
	)

/datum/surgery_operation/limb/neuter_ling/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/target = limb.owner
	if(is_neutered_changeling(target))
		to_chat(surgeon, span_notice("The changeling headslug inside has already been neutered!"))
		return
	if(is_fallen_changeling(target))
		to_chat(surgeon, span_notice("The changeling headslug inside is dead!"))
		return

	var/datum/antagonist/changeling/old_ling_datum = is_any_changeling(target)
	if(old_ling_datum)
		// It was a ling, good job bucko! The changeling is neutered.
		display_results(
			surgeon,
			target,
			span_notice("You locate and succeed in neutering the headslug within [target]'s [limb.plaintext_zone]."),
			span_notice("[surgeon] successfully locates and neuters the headslug within [target]'s [limb.plaintext_zone]!"),
			span_notice("[surgeon] finishes working within [target]'s [limb.plaintext_zone]."),
		)
		var/ling_id = old_ling_datum.changeling_id

		target.mind.remove_antag_datum(/datum/antagonist/changeling)
		var/datum/antagonist/changeling/new_ling_datum = target.mind.add_antag_datum(/datum/antagonist/changeling/neutered)
		new_ling_datum.changeling_id = ling_id

		target.do_jitter_animation(30)

		var/revival_message_end = "and limply"
		if(target.get_organ_slot(ORGAN_SLOT_HEART))
			revival_message_end = "as their heart beats once more"
		if(target.heal_and_revive((target.stat == DEAD ? 50 : 75), span_danger("[target] begins to writhe unnaturally [revival_message_end], their body struggling to regenerate!")))
			new_ling_datum.chem_charges += 15
			var/datum/action/changeling/regenerate/regenerate_action = locate() in target.actions
			regenerate_action?.sting_action(target) // Regenerate ourselves after revival, for heads / organs / whatever
			target.AdjustUnconscious(15 SECONDS, TRUE)
			target.cause_pain(BODY_ZONE_CHEST, 60)
			target.cause_pain(BODY_ZONE_HEAD, 40)
			target.cause_pain(BODY_ZONES_LIMBS, 25)
		to_chat(target, span_big(span_green("Our headslug has been neutered! Our powers are lost... The hive screams in agony before going silent.")))
		message_admins("[ADMIN_LOOKUPFLW(surgeon)] neutered [ADMIN_LOOKUPFLW(target)]'s changeling abilities via surgery.")
		target.log_message("has has their changeling abilities neutered by [key_name(surgeon)] via surgery", LOG_ATTACK)
		log_game("[key_name(surgeon)] neutered [key_name(target)]'s changeling abilities via surgery.")
	else
		// It wasn't a ling, idiot! Now you have a headless, all-chest-organs-destroyed body of an innocent person to fix up!
		display_results(
			surgeon,
			target,
			span_danger("You succeed in operating within [target]'s [limb.plaintext_zone]...but find no headslug, causing heavy internal damage!"),
			span_danger("[surgeon] finishes operating within [target]'s [limb.plaintext_zone]...but finds no headslug, causing heavy internal damage!"),
			span_notice("[surgeon] finishes working within [target]'s [limb.plaintext_zone]."),
			TRUE,
		)
		target.cause_pain(BODY_ZONE_CHEST, 60)
		target.cause_pain(BODY_ZONES_LIMBS, 25)
		for(var/obj/item/organ/stabbed_organ as anything in limb)
			if(stabbed_organ.organ_flags & ORGAN_EXTERNAL)
				continue
			stabbed_organ.apply_organ_damage(105) // Breaks all normal organs, severely damages cyber organs
		message_admins("[ADMIN_LOOKUPFLW(surgeon)] attempted to changeling neuter a non-changeling, [ADMIN_LOOKUPFLW(target)] via surgery.")

/datum/surgery_operation/limb/neuter_ling/on_failure(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	var/mob/living/carbon/target = limb.owner
	// Failure means they couldn't find a headslug, but there may be one in there...
	display_results(
		surgeon,
		target,
		span_danger("You fail to locate a headslug within [target], causing internal damage!"),
		span_danger("[surgeon] fails to locate a headslug within [target], causing internal damage!"),
		span_notice("[surgeon] fails to locate a headslug!"),
		TRUE,
	)
	// ...And if there is, the changeling gets pissed
	var/datum/antagonist/changeling/our_changeling = is_any_changeling(target)
	if(our_changeling)
		to_chat(target, span_changeling("[surgeon] has attempted and failed to neuter our changeling abilities! We feel invigorated, we must break free!"))
		target.do_jitter_animation(50)
		our_changeling.adjust_chemicals(INFINITY)
	// Causes organ damage nonetheless
	for(var/obj/item/organ/stabbed_organ as anything in limb)
		if(stabbed_organ.organ_flags & ORGAN_EXTERNAL)
			continue
		stabbed_organ.apply_organ_damage(25)
