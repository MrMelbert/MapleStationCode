/datum/preference/toggle/show_init_stats
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "show_init_stats"
	savefile_identifier = PREFERENCE_PLAYER
	default_value = TRUE

/datum/preference/toggle/show_init_stats/apply_to_client_updated(client/client, value)
	for(var/atom/movable/screen/lobby_init_text/text in client.mob?.hud_used?.static_inventory)
		if(!value)
			text.alpha = 0 // go away instantly
		else if(!SStitle.stats_faded)
			text.alpha = 255 // show instantly if possible
