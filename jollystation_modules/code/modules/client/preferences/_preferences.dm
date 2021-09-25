// -- Base preferences exentions. --

/*
 * Post preference transfer handling, done after quirks are assigned. (TODO: FIND A BETTER WAY TO DO THIS, maybe.)
 *
 * Why in AssignQuirks?
 *
 * Because some preferences (post loadout equipping, languages) need to be done after quirks are assigned
 * for both latejoiners and roundstart players - this ensures that post pref handling is done
 * after quirks are done for both types of players easily and modularly.
 *
 * Why not extend the other two relevant procs (equip_characters and AttemptLateSpawn)?
 *
 * AssignQuirks is passed the mob and the client, which are both needed for after_prefs_transfer
 * If the procs were extended, it'd lose the relevant vars from the scope of those procs.
 */
/datum/controller/subsystem/processing/quirks/AssignQuirks(mob/living/user, client/cli)
	. = ..()
	cli?.prefs?.after_prefs_transfer(user)

/// Used to apply preferences at the very end of applying preferences, quirks, clothing, etc.
/datum/preferences/proc/after_prefs_transfer(mob/living/carbon/human/target)
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		preference.after_apply_to_human(target, src, read_preference(preference.type))

/// See above. Called at the very end of player initialization.
/datum/preference/proc/after_apply_to_human(mob/living/carbon/human/target, datum/preferences/prefs, value)
	return
