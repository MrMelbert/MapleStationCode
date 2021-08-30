/// -- Advanced changelings. --

/datum/antagonist/changeling/finalize_antag()
	create_actions()
	reset_powers()
	create_initial_profile()
	owner.current.grant_all_languages(FALSE, FALSE, TRUE) //Grants omnitongue. We are able to transform our body after all.

/// The Advanecd Traitor antagonist datum.
/datum/antagonist/changeling/advanced
	name = "Advanced Changeling"
	ui_name = null
	hijack_speed = 0.5
	give_objectives = FALSE
	you_are_greet = FALSE
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

/// Greet the antag with big menacing text.
/datum/antagonist/changeling/advanced/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/changeling/advanced/finalize_antag()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ling_aler.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)

/datum/antagonist/changeling/advanced/roundend_report()
	var/list/result = list()
	var/datum/advanced_antag_datum/changeling/our_ling = linked_advanced_datum

	result += printplayer(owner)
	result += "<b>[owner]</b> was a/an <b>[our_ling.name]</b>[our_ling.employer? " employed by <b>[our_ling.employer]</b>":""]."
	if(our_ling.backstory)
		result += "<b>[owner]'s</b> backstory was the following: <br>[our_ling.backstory]"

	if(LAZYLEN(linked_advanced_datum.our_goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			result += goal.get_roundend_text(count++)
		if(linked_advanced_datum.finalized)
			result += "<br>They were given <b>[linked_advanced_datum.starting_points]</b> genetic points to accomplish these tasks."

	if(our_ling.no_hard_absorb)
		result += "The changeling gave up the ability to absorb humans!"

	var/list/powers = purchasedpowers
	if(powers.len && linked_advanced_datum.finalized)
		var/list/bought_powers = list()
		for(var/datum/action/changeling/power as anything in powers)
			if(power.dna_cost > 0)
				bought_powers += power.name

		if(bought_powers.len)
			result += span_bold("The changeling aquired the following powers: [english_list(bought_powers)].")
		else
			result += span_bold("The [name] never aquired any additional changeling powers!")
	else
		result += span_bold("The [name] never recieved their changeling powers! ...Why?")

	return result.Join("<br>")

/datum/antagonist/changeling/advanced/roundend_report_footer()
	return "<br>And thus ends another mystery on board [station_name()]."

/// The advanced antag datum for traitor.
/datum/advanced_antag_datum/changeling
	name = "Advanced Changeling"
	employer = ""
	// Changelings have default 4 points, and gain 0.5 points per intensity level
	starting_points = 4
	advanced_panel_type = /datum/advanced_antag_panel/changeling
	/// Our antag datum linked to our advanced antag.
	var/datum/antagonist/changeling/our_changeling
	/// Whether our changeling can hard absorb (husk) people.
	var/no_hard_absorb = FALSE

/datum/advanced_antag_datum/changeling/New(datum/antagonist/linked_antag)
	. = ..()
	our_changeling = linked_antag

/datum/advanced_antag_datum/changeling/Destroy()
	our_changeling = null
	. = ..()

/datum/advanced_antag_datum/changeling/modify_antag_points()
	starting_points = get_antag_points_from_goals()
	our_changeling.geneticpoints = starting_points
	our_changeling.total_geneticspoints = starting_points

	our_changeling.chem_charges = starting_points * 2
	our_changeling.chem_storage = round((starting_points * ADV_CHANGELING_CHEM_PER_POINTS) + (10 * no_hard_absorb))
	our_changeling.total_chem_storage = round((starting_points * ADV_CHANGELING_CHEM_PER_POINTS) + (10 * no_hard_absorb))

/datum/advanced_antag_datum/changeling/get_antag_points_from_goals()
	var/finalized_starting_points = ADV_CHANGELING_INITIAL_POINTS
	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_starting_points += (goal.intensity * ADV_CHANGELING_POINTS_PER_INTENSITY)

	return min(round(finalized_starting_points + 0.1), ADV_CHANGELING_MAX_POINTS)

/datum/advanced_antag_datum/changeling/get_finalize_text()
	var/starting_points = get_antag_points_from_goals()
	return "Finalizing will give your your cellular emproium with [starting_points] genetic points, and [round((starting_points * ADV_CHANGELING_CHEM_PER_POINTS) + (10 * no_hard_absorb))] total chemical storage. [no_hard_absorb ? "You will not be able to absorb humans. ":""]You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/changeling/post_finalize_actions()
	. = ..()
	if(!.)
		return

	if(no_hard_absorb)
		var/datum/action/changeling/absorb_dna/dna_power = locate() in our_changeling.purchasedpowers
		dna_power?.Remove(linked_antagonist.owner.current)

/datum/advanced_antag_datum/changeling/log_goals_on_finalize()
	. = ..()
	if(!no_hard_absorb)
		message_admins("Absorbing enabled: [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)] finalized their goals with the ability to absorb and husk enabled.")
	log_game("[key_name(linked_antagonist.owner.current)] finalized their goals with absorbing [no_hard_absorb ? "disabled":"enabled"].")

/datum/advanced_antag_datum/changeling/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are a mysterious changeling sent to [station_name()]! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)
