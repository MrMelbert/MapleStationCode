/datum/preference/numeric/frequency_modifier
	savefile_key = "speech_sound_frequency_modifier"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	minimum = 0.5
	maximum = 2
	step = 0.05

/datum/preference/numeric/frequency_modifier/apply_to_human(mob/living/carbon/human/target, value)
	target.speech_sound_frequency_modifier = value

/datum/preference/numeric/frequency_modifier/create_default_value()
	return 1

/datum/preference/numeric/pitch_modifier
	savefile_key = "speech_sound_pitch_modifier"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	minimum = 0.5
	maximum = 2
	step = 0.05

/datum/preference/numeric/pitch_modifier/apply_to_human(mob/living/carbon/human/target, value)
	target.speech_sound_pitch_modifier = value

/datum/preference/numeric/pitch_modifier/create_default_value()
	return 1

/datum/preference_middleware/speech_sound
	action_delegations = list("play_test_speech_sound" = PROC_REF(play_test_speech_sound))

/datum/preference_middleware/speech_sound/proc/play_test_speech_sound(list/params, mob/user)
	var/mob/living/carbon/human/dummy = preferences.character_preview_view?.body
	if(isnull(dummy))
		return TRUE // ???

	var/list/speech_sounds_to_try = dummy.get_speech_sounds()
	if(!length(speech_sounds_to_try))
		return FALSE

	var/picked_sound = pick(speech_sounds_to_try)
	var/sound/the_sound = sound(picked_sound)
	the_sound.pitch = dummy.speech_sound_pitch_modifier
	the_sound.frequency = round((get_rand_frequency() + get_rand_frequency()) / 2) * dummy.speech_sound_frequency_modifier

	user.playsound_local(
		turf_source = get_turf(user),
		sound_to_use = the_sound,
		vol = speech_sounds_to_try[picked_sound],
		vary = FALSE,
	)
	return FALSE
