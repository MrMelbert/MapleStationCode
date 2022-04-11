/// -- Advanced heretic datum --
/// Advanced traitor, but for heretics!
/datum/antagonist/heretic/advanced
	name = "Advanced Heretic"
	finalize_antag = FALSE
	/// Static list of extra objectives heretics have.
	var/static/list/heretic_objectives = list(
		"minor sacrifice" = /datum/objective/minor_sacrifice,
		"major sacrifice" = /datum/objective/major_sacrifice,
		"research" = /datum/objective/heretic_research,
		"exile" = /datum/objective/exile,
		)

/datum/antagonist/heretic/advanced/on_gain()

	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose += heretic_objectives
	name = "Heretic"

	linked_advanced_datum = new /datum/advanced_antag_datum/heretic(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/heretic/advanced/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/heretic/advanced/finalize_antag()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ecult_op.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)//subject to change

	for(var/starting_knowledge in GLOB.heretic_start_knowledge)
		gain_knowledge(starting_knowledge)

	GLOB.reality_smash_track.add_tracked_mind(owner)
	addtimer(CALLBACK(src, .proc/passive_influence_gain), passive_gain_timer) // Gain +1 knowledge every 20 minutes.

/datum/antagonist/heretic/advanced/forge_primary_objectives()
	return FALSE

/datum/antagonist/heretic/advanced/roundend_report()
	var/list/parts = list()

	var/datum/advanced_antag_datum/heretic/our_heretic = linked_advanced_datum
	parts += printplayer(owner)
	parts += "<b>[owner]</b> was a/an <b>[our_heretic.name]</b>[our_heretic.employer? ", a follower of <b>[our_heretic.employer]</b>":""]."
	if(our_heretic.backstory)
		parts += "<b>[owner]'s</b> backstory was the following: <br>[our_heretic.backstory]"

	parts += span_bold("Sacrifices Made: [total_sacrifices]")

	if(LAZYLEN(linked_advanced_datum.our_goals))
		parts += "<b>[owner]'s</b> objectives:"
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			parts += goal.get_roundend_text(count++)
		if(our_heretic.ascension_enabled)
			if(ascended)
				parts += span_big(span_greentext("THE HERETIC ASCENDED!"))
		else
			parts += span_bold("The heretic gave up the rite of ascension!")

	if(linked_advanced_datum.finalized)
		parts += "<br>The heretic was bestowed [our_heretic.starting_points] knowledge points initially."
		parts += span_bold("Knowledge Researched: ")

		var/list/string_of_knowledge = list()
		for(var/knowledge_index in researched_knowledge)
			var/datum/heretic_knowledge/knowledge = researched_knowledge[knowledge_index]
			string_of_knowledge += knowledge.name

		parts += english_list(string_of_knowledge)

		return parts.Join("<br>")

	else
		parts += span_bold("The heretic never finalized their goals!")

	return parts.Join("<br>")

/datum/antagonist/heretic/advanced/roundend_report_footer()
	return "<br>And thus closes another book on board [station_name()]."

/datum/antagonist/heretic/advanced/ui_status(mob/user, datum/ui_state/state)
	if(!linked_advanced_datum?.finalized)
		return UI_DISABLED
	return ..()

/// The advanced antag datum for heretics.
/datum/advanced_antag_datum/heretic
	name = "Advanced Heretic"
	employer = "The Mansus"
	starting_points = 0
	advanced_panel_type = "_AdvancedHereticPanel"
	/// Whether our heretic is allowed to ascend.
	var/ascension_enabled = TRUE

/// Modify out codex with oour [starting_points].
/datum/advanced_antag_datum/heretic/modify_antag_points()
	starting_points = get_antag_points_from_goals()
	var/datum/antagonist/heretic/linked_heretic = linked_antagonist
	linked_heretic.knowledge_points += starting_points

/// Adjust the amount of influence charges the heretic gets on spawn.
/// Max of 5, +3 if they can't ascend, +3 if they can't sacrifice.
/// Roughly 1 influence per 3 intensity levels.
/// Flat +3 from disabling ascension, and another +3 from disabling sacrifices.
/datum/advanced_antag_datum/heretic/get_antag_points_from_goals()
	var/finalized_influences = ADV_HERETIC_INITIAL_INFLUENCE
	var/max_influnces = ADV_HERETIC_MAX_INFLUENCE
	if(!ascension_enabled)
		finalized_influences += ADV_HERETIC_NO_ASCENSION_INFLUENCE
		max_influnces += ADV_HERETIC_NO_ASCENSION_MAX

	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_influences += (goal.intensity * ADV_HERETIC_INFLUENCE_PER_INTENSITY)

	return min(round(finalized_influences), max_influnces)

/datum/advanced_antag_datum/heretic/get_finalize_text()
	return {"Finalizing will deliver you a Codex Cicatrix with [get_antag_points_from_goals()] influence charges and a Living heart. \
If you finalize now, you will be [ascension_enabled ? "allowed to ascend": "disallowed from ascending"]. \
You can still edit your goals after finalizing, but you will not be able to re-enable ascension!"}

/datum/advanced_antag_datum/heretic/post_finalize_actions()
	. = ..()
	if(!.)
		return

	var/datum/antagonist/heretic/our_heretic = linked_antagonist
	if(!ascension_enabled)
		if(our_heretic.gain_knowledge(/datum/heretic_knowledge/no_ascension))
			log_heretic_knowledge("[key_name(our_heretic.owner.current)] gave up the ability to ascend.")
		else
			CRASH("[key_name(our_heretic.owner.current)] gave up the ability to ascend, but did not gain the proper knowledge!")

/datum/advanced_antag_datum/heretic/log_goals_on_finalize()
	. = ..()
	if(ascension_enabled)
		message_admins("Ascension enabled: [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)] finalized their goals with acension enabled.")
	log_game("[key_name(linked_antagonist.owner.current)] finalized their goals with [ascension_enabled? "ascension enabled":"ascension disabled"].")

/datum/advanced_antag_datum/heretic/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are a cultic follower sent to [station_name()]! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)

/datum/advanced_antag_datum/heretic/ui_data(mob/user)
	. = ..()
	.["can_ascend"] = ascension_enabled

/datum/advanced_antag_datum/heretic/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_ascension")
			if(finalized)
				return
			ascension_enabled = !ascension_enabled

	return TRUE

/datum/objective/heretic_research/admin_edit(mob/admin)
	var/required = input(admin, "How much knowledge to research?", name, target_amount) as num|null
	if(required)
		target_amount = required
	update_explanation_text()

/datum/objective/minor_sacrifice/admin_edit(mob/admin)
	var/required = input(admin, "How many crewmebers to sacrifice?", name, target_amount) as num|null
	if(required)
		target_amount = required
	update_explanation_text()
