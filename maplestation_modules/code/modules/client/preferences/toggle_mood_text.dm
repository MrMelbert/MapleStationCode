/datum/preference/numeric/mood_text_alpha
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "mood_text_alpha"
	savefile_identifier = PREFERENCE_PLAYER
	minimum = 0
	maximum = 1
	step = 0.01

/datum/preference/numeric/mood_text_alpha/create_default_value()
	return 0.75

/datum/preference/numeric/mood_text_alpha/apply_to_client_updated(client/client, value)
	for(var/atom/movable/screen/mood_maptext/maptext in client.screen)
		maptext.alpha = 255 * value
