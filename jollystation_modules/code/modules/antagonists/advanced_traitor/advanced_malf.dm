/// -- Advanced Antag for Malf AIs. --
/// Proc to give the malf their hacked module.
/datum/antagonist/malf_ai/finalize_antag()
	add_law_zero()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/malf.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	owner.current.grant_language(/datum/language/codespeak, TRUE, TRUE, LANGUAGE_MALF)

/// The Advanced Malf datum.
/datum/antagonist/malf_ai/advanced
	name = "Advanced Malfunctioning AI"
	employer = "The Syndicate"
	give_objectives = FALSE
	should_give_codewords = FALSE
	should_equip = FALSE
	finalize_antag = FALSE
	/// List of objectives AIs can get, because apparently they're not initialized anywhere like normal objectives.
	var/static/list/ai_objectives = list("no organics on shuttle" = /datum/objective/block, "no mutants on shuttle" = /datum/objective/purge, "robot army" = /datum/objective/robot_army, "survive AI" = /datum/objective/survive/malf)

/datum/antagonist/malf_ai/advanced/on_gain()
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	name = "Malfunctioning AI"
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose -= blacklisted_ai_objectives
	objectives_to_choose += ai_objectives

	linked_advanced_datum = new /datum/advanced_antag_datum/malf_ai(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/malf_ai/advanced/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/malf_ai/advanced/roundend_report()
	var/list/result = list()

	result += printplayer(owner)
	result += "<b>[owner]</b> was \a <b>[linked_advanced_datum.name]</b>[employer? " hacked by <b>[employer]</b>":""]."
	if(linked_advanced_datum.backstory)
		result += "<b>[owner]'s</b> backstory was the following: <br>[linked_advanced_datum.backstory]"

	if(LAZYLEN(linked_advanced_datum.our_goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			result += goal.get_roundend_text(count)
			count++

	return result.Join("<br>")

/datum/antagonist/malf_ai/advanced/roundend_report_footer()
	return "<br>And thus ends another security breach on board [station_name()]."

/datum/antagonist/malf_ai/advanced/get_admin_commands()
	. = ..()
	.["View Goals"] = CALLBACK(src, .proc/show_advanced_traitor_panel, usr)

/datum/antagonist/malf_ai/advanced/antag_listing_commands()
	. = ..()
	. += "<a href='?_src_=holder;[HrefToken()];admin_check_goals=[REF(src)]'>Show Goals</a>"

/// The advanced antag datum itself for malf AIs.
/datum/advanced_antag_datum/malf_ai
	name = "Advanced Malfunctioning AI"
	employer = "The Syndicate"
	style = "jolly-syndicate"
	starting_points = 20
	/// Our antag datum linked to our advanced antag.
	var/datum/antagonist/malf_ai/our_ai

/datum/advanced_antag_datum/malf_ai/New(datum/antagonist/linked_antag)
	. = ..()
	our_ai = linked_antag

/datum/advanced_antag_datum/malf_ai/Destroy()
	our_ai = null
	. = ..()

/datum/advanced_antag_datum/malf_ai/modify_antag_points()
	var/mob/living/silicon/ai/traitor_ai = linked_antagonist.owner.current
	if(!istype(traitor_ai))
		CRASH("Advanced Malf AI datum on a mob that isn't an AI!")

	var/datum/module_picker/traitor_ai_uplink = traitor_ai.malf_picker
	starting_points = get_antag_points_from_goals()
	traitor_ai_uplink.processing_time = starting_points

/datum/advanced_antag_datum/malf_ai/get_antag_points_from_goals()
	var/finalized_starting_points = TRAITOR_PLUS_INITIAL_MALF_POINTS
	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_starting_points += (goal.intensity * 5)

	return min(finalized_starting_points, TRAITOR_PLUS_MAX_MALF_POINTS)

/datum/advanced_antag_datum/malf_ai/get_finalize_text()
	return "Finalizing will begin installlation of your malfunction module with [get_antag_points_from_goals()] processing power. You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/malf_ai/post_finalize_actions()
	. = ..()
	if(!.)
		return

	our_ai.should_equip = TRUE
	our_ai.finalize_antag()
	modify_antag_points()

/datum/advanced_antag_datum/malf_ai/set_employer(employer)
	. = ..()
	our_ai.employer = src.employer
