// -- Auto-transfer config values. --
/// Allow people to call votes for shuttle OOCly
/datum/config_entry/flag/allow_vote_transfer

/// Automatic crew transfer votes that start at [transfer_time_min_allowed] and happen every [transfer_time_between_auto_votes]
/datum/config_entry/flag/transfer_auto_vote_enabled

/// Minimum shift length before transfer votes can begin
/datum/config_entry/number/transfer_time_min_allowed
	config_entry_value = 1.5 HOURS
	integer = FALSE
	min_val = 5 MINUTES

/// Time between auto transfer votes
/datum/config_entry/number/transfer_time_between_auto_votes
	config_entry_value = 30 MINUTES
	integer = FALSE
	min_val = 2 MINUTES
