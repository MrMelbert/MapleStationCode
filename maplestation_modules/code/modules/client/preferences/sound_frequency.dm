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
