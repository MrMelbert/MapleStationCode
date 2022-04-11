/// -- Advanced Antag for Malf AIs. --
/// Proc to give the malf their hacked module.
/datum/antagonist/malf_ai/finalize_antag()
	if(give_objectives)
		employer = pick(GLOB.ai_employers)
		malfunction_flavor = strings(MALFUNCTION_FLAVOR_FILE, employer)

	add_law_zero()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/malf.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	owner.current.grant_language(/datum/language/codespeak, TRUE, TRUE, LANGUAGE_MALF)

/// The Advanced Malf datum.
/datum/antagonist/malf_ai/advanced
	name = "Advanced Malfunctioning AI"
	ui_name = null
	employer = "The Syndicate"
	give_objectives = FALSE
	should_give_codewords = FALSE
	finalize_antag = FALSE
	/// List of objectives AIs can get in addition to the base ones
	var/static/list/ai_objectives = list(
		"no organics on shuttle" = /datum/objective/block,
		"no mutants on shuttle" = /datum/objective/purge,
		"robot army" = /datum/objective/robot_army,
		"survive AI" = /datum/objective/survive/malf,
		)
	/// Goals that advanced malf AIs shouldn't be able to pick
	var/static/list/blacklisted_ai_objectives = list(
		"survive",
		"destroy AI",
		"download",
		"steal",
		"escape",
		"debrain"
		)

/datum/antagonist/malf_ai/advanced/on_gain()
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose -= blacklisted_ai_objectives
	objectives_to_choose += ai_objectives
	name = "Malfunctioning AI"

	linked_advanced_datum = new /datum/advanced_antag_datum/malf_ai(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/malf_ai/advanced/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/malf_ai/advanced/roundend_report()
	var/list/result = list()

	result += printplayer(owner)
	result += "<b>[owner]</b> was a/an <b>[linked_advanced_datum.name]</b>[employer? " hacked by <b>[employer]</b>":""]."
	if(linked_advanced_datum.backstory)
		result += "<b>[owner]'s</b> backstory was the following: <br>[linked_advanced_datum.backstory]"

	if(LAZYLEN(linked_advanced_datum.our_goals))
		result += "<b>[owner]'s</b> objectives:"
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			result += goal.get_roundend_text(count++)

	return result.Join("<br>")

/datum/antagonist/malf_ai/advanced/roundend_report_footer()
	return "<br>And thus ends another security breach on board [station_name()]."

/// The advanced antag datum itself for malf AIs.
/datum/advanced_antag_datum/malf_ai
	name = "Advanced Malfunctioning AI"
	employer = "The Syndicate"
	starting_points = 20

/datum/advanced_antag_datum/malf_ai/modify_antag_points()
	var/mob/living/silicon/ai/traitor_ai = linked_antagonist.owner.current
	if(!istype(traitor_ai))
		CRASH("Advanced Malf AI datum on a mob that isn't an AI!")

	var/datum/module_picker/traitor_ai_uplink = traitor_ai.malf_picker
	starting_points = get_antag_points_from_goals()
	traitor_ai_uplink.processing_time = starting_points

/datum/advanced_antag_datum/malf_ai/get_antag_points_from_goals()
	var/finalized_starting_points = ADV_TRAITOR_INITIAL_MALF_POINTS
	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_starting_points += (goal.intensity * ADV_TRAITOR_MALF_POINTS_PER_INTENSITY)

	return min(finalized_starting_points, ADV_TRAITOR_MAX_MALF_POINTS)

/datum/advanced_antag_datum/malf_ai/get_finalize_text()
	return "Finalizing will begin installlation of your malfunction module with [get_antag_points_from_goals()] processing power. You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/malf_ai/set_employer(employer)
	. = ..()
	var/datum/antagonist/malf_ai/our_ai = linked_antagonist
	our_ai.employer = src.employer
