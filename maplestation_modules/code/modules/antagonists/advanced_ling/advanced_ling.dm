/// -- Advanced changelings. --
/// The Advanecd Traitor antagonist datum.
/datum/antagonist/changeling/advanced
	name = "Advanced Changeling"
	ui_name = null
	hijack_speed = 0.5
	give_objectives = FALSE
	hivemind_link_awoken = FALSE
	/// List of objectives changelings can get in addition to the base ones
	var/static/list/ling_objectives = list(
		"absorb" = /datum/objective/absorb,
		"absorb most" = /datum/objective/absorb_most,
		"absorb changeling" = /datum/objective/absorb_changeling,
		"escape with identity" = /datum/objective/escape/escape_with_identity,
		"exile" = /datum/objective/exile,
		)

/datum/antagonist/changeling/advanced/create_initial_profile()
	add_new_profile(owner.current, TRUE)

/datum/antagonist/changeling/advanced/create_innate_actions()
	. = ..()
	var/datum/advanced_antag_datum/changeling/adv_ling = linked_advanced_datum
	if(adv_ling?.no_hard_absorb)
		var/datum/action/changeling/absorb_dna/dna_power = locate() in innate_powers
		if(dna_power)
			innate_powers -= dna_power
			QDEL_NULL(dna_power)

/datum/antagonist/changeling/advanced/on_gain()
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose += ling_objectives
	name = "Changeling"

	linked_advanced_datum = new /datum/advanced_antag_datum/changeling(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/changeling/advanced/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/changeling/advanced/finalize_antag()
	hivemind_link_awoken = TRUE
	. = ..()

/datum/antagonist/changeling/advanced/roundend_report()
	var/list/result = list()
	var/datum/advanced_antag_datum/changeling/our_ling = linked_advanced_datum

	result += printplayer(owner)
	result += "<b>[owner]</b> was <b>[changeling_id]</b>, a/an <b>[our_ling.name]</b>[our_ling.employer? " employed by <b>[our_ling.employer]</b>":""]."
	if(our_ling.backstory)
		result += "<b>[owner]'s</b> backstory was the following: <br>[our_ling.backstory]"

	if(LAZYLEN(linked_advanced_datum.our_goals))
		result += "<b>[owner]'s</b> objectives:"
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			result += goal.get_roundend_text(count++)
		if(linked_advanced_datum.finalized)
			result += "<br>They were given <b>[linked_advanced_datum.starting_points]</b> genetic points to accomplish these tasks."

	if(our_ling.no_hard_absorb)
		result += "The changeling gave up the ability to absorb humans!"

	if(linked_advanced_datum.finalized)
		if(length(purchased_powers))
			var/list/bought_powers = list()
			for(var/datum/action/changeling/power as anything in purchased_powers)
				bought_powers += power.name

			result += span_bold("The changeling had the following powers: [english_list(bought_powers)].")
		else
			result += span_bold("The changeling never aquired any additional changeling powers!")

	else
		result += span_bold("The changeling never finalized their goals!")

	return result.Join("<br>")

/datum/antagonist/changeling/advanced/roundend_report_footer()
	return "<br>And thus ends another mystery on board [station_name()]."

/// The advanced antag datum for traitor.
/datum/advanced_antag_datum/changeling
	name = "Advanced Changeling"
	employer = ""
	// Changelings have default 4 points, and gain 0.5 points per intensity level
	starting_points = 4
	advanced_panel_type = "_AdvancedChangelingPanel"
	/// Whether our changeling can hard absorb (husk) people.
	var/no_hard_absorb = FALSE

/datum/advanced_antag_datum/changeling/modify_antag_points()
	var/datum/antagonist/changeling/our_changeling = linked_antagonist

	starting_points = get_antag_points_from_goals()
	our_changeling.genetic_points = starting_points
	our_changeling.total_genetic_points = starting_points

	our_changeling.chem_charges = starting_points * 2
	our_changeling.total_chem_storage = round((starting_points * ADV_CHANGELING_CHEM_PER_POINTS) + (10 * no_hard_absorb))

/datum/advanced_antag_datum/changeling/get_antag_points_from_goals()
	var/finalized_starting_points = ADV_CHANGELING_INITIAL_POINTS
	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_starting_points += (goal.intensity * ADV_CHANGELING_POINTS_PER_INTENSITY)

	return min(round(finalized_starting_points + 0.1), ADV_CHANGELING_MAX_POINTS)

/datum/advanced_antag_datum/changeling/get_finalize_text()
	var/starting_points = get_antag_points_from_goals()
	return "Finalizing will give you your cellular emporium with [starting_points] genetic points, \
		and [round((starting_points * ADV_CHANGELING_CHEM_PER_POINTS) + (10 * no_hard_absorb))] total chemical storage. \
		[no_hard_absorb ? "You will not be able to absorb humans. ":""]You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/changeling/post_finalize_actions()
	. = ..()
	if(!.)
		return

	if(no_hard_absorb)
		var/datum/antagonist/changeling/our_changeling = linked_antagonist
		var/datum/action/changeling/absorb_dna/dna_power = locate() in our_changeling.innate_powers
		our_changeling.innate_powers -= dna_power
		QDEL_NULL(dna_power)

/datum/advanced_antag_datum/changeling/log_goals_on_finalize()
	. = ..()
	if(!no_hard_absorb)
		message_admins("Absorbing enabled: [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)] finalized their goals with the ability to absorb and husk enabled.")
	log_game("[key_name(linked_antagonist.owner.current)] finalized their goals with absorbing [no_hard_absorb ? "disabled":"enabled"].")

/datum/advanced_antag_datum/changeling/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are a mysterious changeling sent to [station_name()]! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)

/datum/advanced_antag_datum/changeling/ui_data(mob/user)
	. = ..()
	var/datum/antagonist/changeling/our_changeling = linked_antagonist
	.["cannot_absorb"] = no_hard_absorb
	.["changeling_id"] = our_changeling.changeling_id

/datum/advanced_antag_datum/changeling/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	/// Ling Stuff
	switch(action)
		if("set_ling_id")
			var/datum/antagonist/changeling/our_changeling = linked_antagonist
			our_changeling.changeling_id = params["changeling_id"]

		if("toggle_absorb")
			if(finalized)
				return
			no_hard_absorb = !no_hard_absorb

	return TRUE
