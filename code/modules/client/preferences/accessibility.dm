/// When toggled, being flashed will show a dark screen rather than a light one.
/datum/preference/toggle/darkened_flash
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = FALSE
	savefile_key = "darkened_flash"
	savefile_identifier = PREFERENCE_PLAYER

/// When toggled, will darken the screen on screen shake
/datum/preference/toggle/screen_shake_darken
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = FALSE
	savefile_key = "screen_shake_darken"
	savefile_identifier = PREFERENCE_PLAYER

/// When toggled on, distance speakers will have their text shrink with distance
/datum/preference/toggle/distance_text_shrinking
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "distance_text_shrinking"
	savefile_identifier = PREFERENCE_PLAYER

/// When toggled on, the names of speakers in chat will be colored according to runechat color
/datum/preference/toggle/runechat_text_names
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	default_value = TRUE
	savefile_key = "runechat_text_names"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/numeric/min_recoil_multiplier
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	maximum = 200
	minimum = 0
	savefile_key = "min_recoil_multiplier"
	savefile_identifier = PREFERENCE_PLAYER

/datum/preference/numeric/min_recoil_multiplier/create_default_value()
	return 100
