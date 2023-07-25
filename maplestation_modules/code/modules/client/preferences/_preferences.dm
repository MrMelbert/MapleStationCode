// -- Base preferences exentions. --

/**
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

/// Extension of preferences/ui_act to do more actions when new preferences are added.
/datum/preferences/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if (.)
		return

	var/mob/user = usr
	switch (action)
		// Language UI
		if ("open_language_picker")
			var/datum/language_picker/tgui = new(src)
			tgui.ui_interact(user)
			return TRUE
		// Spellbook UI
		if ("open_spellbook")
			if(parent.open_spellbook_ui)
				parent.open_spellbook_ui.ui_interact(user)
			else
				var/datum/spellbook_manager/tgui = new(user)
				tgui.ui_interact(user)
			return TRUE
		// Playing test sounds from speech frequency pref
		if ("play_test_speech_sound")
			var/mob/living/carbon/human/dummy = character_preview_view?.body
			if(isnull(dummy))
				return TRUE // ???

			var/list/speech_sounds_to_try = dummy.get_speech_sounds()
			if(!length(speech_sounds_to_try))
				return

			var/picked_sound = pick(speech_sounds_to_try)
			var/speech_vol = speech_sounds_to_try[picked_sound]
			var/speech_freq_to_try = round((get_rand_frequency() + get_rand_frequency()) / 2) * dummy.speech_sound_frequency_modifier
			user.playsound_local(
				turf_source = get_turf(user),
				soundin = picked_sound,
				vol = speech_vol,
				vary = TRUE,
				frequency = speech_freq_to_try,
			)
