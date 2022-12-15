// Unticked for the moment while I wait to see how to use this
/datum/action/changeling/linglink
	name = "Hivemind Link"
	desc = "We link our victim's mind into the changeling hivemind, allowing us to communicate discretely and at range."
	helptext = "If our target is a changeling, our hiveminds will be linked permanently. If they are a human, it will only last temporarily."
	button_icon_state = "hivemind_link"
	chemical_cost = 0
	dna_cost = 0
	req_human = 1
	/// If we've linked to a non changeling - weakref to their mob
	var/datum/weakref/linked_non_ling

/datum/action/changeling/linglink/can_sting(mob/living/carbon/user)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/target = user.pulling
	if(!istype(target))
		to_chat(user, span_warning("We must be grabbing a creature to link!"))
		return FALSE
	if(user.grab_state <= GRAB_PASSIVE)
		to_chat(user, span_warning("We must have a tighter grip to link with this creature!"))
		return FALSE
	if(target.stat == DEAD)
		to_chat(user, span_warning("This creature is dead!"))
		return FALSE
	if(!target.mind)
		to_chat(user, span_warning("This creature has no mind or soul to probe!"))
		return FALSE

	return TRUE

/datum/action/changeling/linglink/sting_action(mob/user)
	var/mob/living/carbon/human/target = user.pulling

	user.visible_message(span_danger("[user] begins to extend something inhuman from their head!"), span_notice("This creature is compatible. We begin to probe their mind..."))
	if(!do_mob(user, target, 6 SECONDS))
		to_chat(user, span_danger("You fail to probe [target]'s mind!"))
		return

	to_chat(target, span_userdanger("You experience a stabbing sensation and your ears begin to ring..."))
	target.sharp_pain(BODY_ZONE_HEAD, 30, BRUTE, 10 SECONDS) // A ton of pain immediately that wanes
	target.reagents?.add_reagent(/datum/reagent/medicine/mannitol, 10)
	target.reagents?.add_reagent(/datum/reagent/medicine/epinephrine, 5)

	if(!do_mob(user, target, 6 SECONDS))
		to_chat(user, span_danger("You fail to probe [target]'s mind!"))
		user.stop_pulling()
		return

	for(var/mob/global_mob as anything in GLOB.mob_list)
		if(global_mob.ling_hive_check() == LING_HIVE_LING)
			to_chat(global_mob, span_changeling("We can sense a foreign presence in the hivemind..."))

	var/datum/antagonist/changeling/their_ling_datum = is_any_changeling(target)

	to_chat(target, span_userdanger("A migraine throbs behind your eyes, you hear yourself screaming - but your mouth has not opened!"))
	if(their_ling_datum)
		their_ling_datum.hivemind_link_awoken = TRUE
		to_chat(target, span_bold(span_changeling("You can now communicate in the changeling hivemind using \"[MODE_TOKEN_CHANGELING]\".")))
	else
		if(linked_non_ling)
			unlink_target(linked_non_ling.resolve())
			linked_non_ling = null
		ADD_TRAIT(target, TRAIT_LING_LINKED, "[owner]-[CHANGELING_ABILITY]")
		to_chat(target, span_bold(span_changeling("You can now temporarily communicate in the changeling hivemind using \"[MODE_TOKEN_CHANGELING]\".")))
		addtimer(CALLBACK(src, PROC_REF(unlink_target), target), HIVELINK_DURATION)
		linked_non_ling = WEAKREF(target)


	target.say("[MODE_TOKEN_CHANGELING] AAAAARRRRGGGGGHHHHH!!")
	// And normal / non-sharp pain done at the end
	target.cause_pain(BODY_ZONE_HEAD, 30)
	target.cause_pain(BODY_ZONE_CHEST, 20)
	user.stop_pulling()

	SSblackbox.record_feedback("nested tally", "changeling_powers", 1, list("[name]"))
	return TRUE

/datum/action/changeling/linglink/Remove(mob/user)
	if(linked_non_ling)
		unlink_target(linked_non_ling.resolve())
		linked_non_ling = null
	. = ..()

/// Remove [target] from being temporarily linked to the hivemind.
/datum/action/changeling/linglink/proc/unlink_target(mob/target)
	if(!HAS_TRAIT(target, TRAIT_LING_LINKED))
		return

	REMOVE_TRAIT(target, TRAIT_LING_LINKED, "[owner]-[CHANGELING_ABILITY]")
	to_chat(target, span_changeling("Your mind goes silent - you are left alone once more. You can no longer communicate in the changeling hivemind."))
	to_chat(owner, span_notice("Our linked creature, [target], has been removed from our hivemind."))
