/datum/preference/choiced/ready_anominity
	category = PREFERENCE_CATEGORY_GAME_PREFERENCES
	savefile_key = "ready_anominity"
	savefile_identifier = PREFERENCE_PLAYER
	/// What values we pass to possible values, keyed to the actual bitflag
	var/list/value_list = list(
		"Show All" = NONE,
		"Show Nothing" = ALL,
		"Just Show Ckey" = ~CKEY_ANON,
		"Just Show Character" = ~NAME_ANON,
		"Just Show Top Job" = ~JOB_ANON,
		"Don't Show Ckey" = CKEY_ANON,
		"Don't Show Character" = NAME_ANON,
		"Don't Show Top Job" = JOB_ANON,
	)

/datum/preference/choiced/ready_anominity/apply_to_client_updated(client/client, value)
	if(isnewplayer(client?.mob))
		var/mob/dead/new_player/cycle = client?.mob
		cycle.update_ready_report()

/datum/preference/choiced/ready_anominity/create_default_value()
	return value_list[3]

/datum/preference/choiced/ready_anominity/init_possible_values()
	return value_list
