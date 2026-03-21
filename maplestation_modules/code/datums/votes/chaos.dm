/datum/vote/round_chaos
	name = "Round Chaos Level"
	default_message = "Initiate a vote to gauge how much chaos the players want in the round. Has no mechanical effect."
	default_choices = list(
		"None",
		"Low",
		"Medium",
		"High",
	)
	count_method = VOTE_COUNT_METHOD_MULTI
	display_statistics = FALSE

/datum/vote/round_chaos/initiate_vote(initiator, duration)
	. = ..()
	. += "<br>"
	. += span_slightly_smaller("This vote is used to gauge player sentiment and has no mechanical effect.")

/datum/vote/round_chaos/can_mob_vote(mob/voter)
	// Roundstart observers / people who DNR'd have no say
	if(isobserver(voter) && isnull(voter.mind))
		return "Observers cannot vote."
	return ..()

/datum/vote/round_chaos/is_accessible_vote()
	return TRUE

/datum/vote/round_chaos/can_be_initiated(forced)
	if(!forced)
		return "Only admins can initiate this vote."
	return ..()

/datum/vote/round_chaos/tiebreaker(list/winners)
	switch(length(winners))
		if(2)
			return jointext(winners, "-")
		if(3)
			return winners[2] // averaged out
		if(4)
			return "Any"

	return "Unknown"

/datum/vote/round_chaos/finalize_vote(winning_option)
	SSticker.voted_round_chaos = winning_option
