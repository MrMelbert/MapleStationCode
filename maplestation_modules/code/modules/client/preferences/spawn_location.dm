/datum/preference/choiced/preferred_latejoin_spawn
	savefile_key = "preferred_latejoin_spawn"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE

/datum/preference/choiced/preferred_latejoin_spawn/create_default_value()
	return SPAWNPOINT_ARRIVALS

/datum/preference/choiced/preferred_latejoin_spawn/init_possible_values()
	return list(
		SPAWNPOINT_ARRIVALS,
		SPAWNPOINT_CRYO,
	)

/datum/preference/choiced/preferred_latejoin_spawn/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/preferred_latejoin_spawn/is_accessible(datum/preferences/preferences)
	return ..() && !has_silicon_prioritized(preferences)
