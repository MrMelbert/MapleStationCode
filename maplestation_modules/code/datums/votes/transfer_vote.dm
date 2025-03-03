#define CHOICE_SHUTTLE "Initiate Crew Transfer"
#define CHOICE_CONTINUE "Continue Shift"

/datum/vote/autotransfer
	name = "Crew Transfer"
	default_message = "Click to initiate an OOC Crew Transfer vote, calling the emergency shuttle on success."
	default_choices = list(
		CHOICE_SHUTTLE,
		CHOICE_CONTINUE,
	)

/datum/vote/autotransfer/toggle_votable()
	CONFIG_SET(flag/allow_vote_transfer, !CONFIG_GET(flag/allow_vote_transfer))

/datum/vote/autotransfer/is_config_enabled()
	return CONFIG_GET(flag/allow_vote_transfer)

/datum/vote/autotransfer/can_be_initiated(forced)
	. = ..()
	if(. != VOTE_AVAILABLE)
		return .

	if(!forced && !CONFIG_GET(flag/allow_vote_transfer))
		return "Transfer votes are disabled."

	if(!SScrewtransfer)
		return "Transfer subsystem missing. Can't really host a vote for it! This is a bug."

	if(SScrewtransfer.transfer_vote_successful)
		return "A transfer vote has already passed."

	return VOTE_AVAILABLE

/datum/vote/autotransfer/get_vote_result(list/non_voters)
	if(!CONFIG_GET(flag/default_no_vote))
		// multipler applied to non-voters.
		// non-voters count for 1/3rd of a vote, then past two votes they count for 1/4th, 1/5th, and so on.
		var/non_voters_multiplier = 1 / clamp(SScrewtransfer.transfer_votes_attempted + 1, 3, 50)
		choices[CHOICE_CONTINUE] += round(length(non_voters) * non_voters_multiplier)

	return ..()


/datum/vote/autotransfer/finalize_vote(winning_option)
	if(winning_option == CHOICE_CONTINUE)
		return

	if(winning_option == CHOICE_SHUTTLE)
		SScrewtransfer.initiate_crew_transfer()
		return

	CRASH("[type] wasn't passed a valid winning choice. (Got: [winning_option || "null"])")

#undef CHOICE_SHUTTLE
#undef CHOICE_CONTINUE
