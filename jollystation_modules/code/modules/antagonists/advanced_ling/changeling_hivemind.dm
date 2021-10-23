// -- Changeling hivemind, sort of. --

///Check if the mob has a ling hivemind
/mob/proc/ling_hive_check()
	return LING_HIVE_NONE

/mob/living/ling_hive_check()
	var/datum/antagonist/changeling/our_ling = is_any_changeling(src)
	if(our_ling)
		if(our_ling.hivemind_link_awoken)
			return LING_HIVE_LING
		else
			return LING_HIVE_NOT_AWOKEN

	if(HAS_TRAIT(src, TRAIT_LING_LINKED))
		return LING_HIVE_OUTSIDER
	if(mind?.has_antag_datum(/datum/antagonist/fallen_changeling))
		return LING_HIVE_NOT_AWOKEN

	return LING_HIVE_NONE

/mob/living/silicon/ling_hive_check()
	return LING_HIVE_NONE //Borged or AI'd lings can't speak on the ling channel.

/datum/saymode/changeling
	key = MODE_KEY_CHANGELING
	mode = MODE_CHANGELING

/datum/saymode/changeling/handle_message(mob/living/user, message, datum/language/language)
	if(HAS_TRAIT(user, TRAIT_LING_MUTE))
		to_chat(user, span_warning("The poison in the air hinders our ability to interact with the hivemind."))
		return FALSE

	switch(user.ling_hive_check())
		if(LING_HIVE_LING, LING_HIVE_OUTSIDER)
			var/datum/antagonist/changeling/valid_antag = is_any_changeling(user)
			var/datum/antagonist/other_valid_antag = is_fallen_changeling(user)
			send_mind_message(user, span_changeling("[span_bold("[valid_antag || other_valid_antag || "Outsider"] [user.mind]")] [valid_antag?.changeling_id ? "([span_italics(valid_antag.changeling_id)])" : ""]: [message]"))
			user.log_talk(message, LOG_SAY, tag = "changeling hivemind")

		if(LING_HIVE_NOT_AWOKEN)
			to_chat(user, span_changeling("Our senses have not evolved enough to be able to communicate via the hivemind."))

	return FALSE

/// Send [message] (formatted, with spans) from [user] to all mobs on the hivemind.
/datum/saymode/changeling/proc/send_mind_message(mob/user, message)
	for(var/mob/global_mob as anything in GLOB.player_list)
		if(global_mob in GLOB.dead_mob_list)
			to_chat(global_mob, "[FOLLOW_LINK(global_mob, user)] [message]")
		else
			if(HAS_TRAIT(global_mob, TRAIT_LING_MUTE))
				continue

			switch(global_mob.ling_hive_check())
				if(LING_HIVE_LING, LING_HIVE_OUTSIDER)
					to_chat(global_mob, message)

				if(LING_HIVE_NOT_AWOKEN)
					if(prob(12))
						to_chat(global_mob, span_changeling("We can faintly sense someone communicating through the hivemind..."))

// BZ metabolites mute the ling hivemind.
/datum/reagent/bz_metabolites/on_mob_metabolize(mob/living/carbon/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_LING_MUTE, "BZ")

/datum/reagent/bz_metabolites/on_mob_end_metabolize(mob/living/carbon/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_LING_MUTE, "BZ")
