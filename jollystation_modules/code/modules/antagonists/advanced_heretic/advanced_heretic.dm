/// -- Advanced heretic datum --
/// Advanced traitor, but for heretics!
/datum/antagonist/heretic/advanced
	name = "Advanced Heretic"
	ui_name = null
	give_equipment = FALSE
	finalize_antag = FALSE
	/// Static list of extra objectives heretics have.
	var/static/list/heretic_objectives = list(
		"sacrifice" = /datum/objective/sacrifice_ecult/adv,
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

/datum/antagonist/heretic/advanced/equip_cultist()
	. = ..()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ecult_op.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	to_chat(owner, span_boldannounce("You are the Heretic!"))

/datum/antagonist/heretic/advanced/finalize_antag()
	equip_cultist()

/datum/antagonist/heretic/advanced/forge_primary_objectives()
	return FALSE

/datum/antagonist/heretic/advanced/roundend_report()
	var/list/parts = list()

	var/datum/advanced_antag_datum/heretic/our_heretic = linked_advanced_datum
	parts += printplayer(owner)
	parts += "<b>[owner]</b> was a/an <b>[our_heretic.name]</b>[our_heretic.employer? ", a follower of <b>[our_heretic.employer]</b>":""]."
	if(our_heretic.sacrifices_enabled)
		parts += span_bold("Sacrifices Made: [total_sacrifices]")
	else
		parts += span_bold("The heretic gave up the rite of sacrifice!")

	if(LAZYLEN(linked_advanced_datum.our_goals))
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			parts += goal.get_roundend_text(count++)
		if(our_heretic.ascension_enabled)
			if(ascended)
				parts += span_big(span_greentext("THE HERETIC ASCENDED!"))
		else
			parts += span_bold("<br>The heretic gave up the rite of ascension!")

	if(linked_advanced_datum.finalized)
		parts += "<br>The heretic was bestowed [our_heretic.starting_points] influences in their initial Codex."
		parts += span_bold("Knowledge Researched: ")

		var/list/knowledge_message = list()
		var/list/knowledge = get_all_knowledge()
		for(var/found_knowledge_id in knowledge)
			var/datum/eldritch_knowledge/found_knowledge = knowledge[found_knowledge_id]
			knowledge_message += "[found_knowledge.name]"
		parts += knowledge_message.Join(", ")
	else
		parts += span_bold("<br>The heretic never received their Codex! ")

	return parts.Join("<br>")

/datum/antagonist/heretic/advanced/roundend_report_footer()
	return "<br>And thus closes another book on board [station_name()]."

/// The advanced antag datum for heretics.
/datum/advanced_antag_datum/heretic
	name = "Advanced Heretic"
	employer = "The Mansus"
	starting_points = 0
	advanced_panel_type = /datum/advanced_antag_panel/heretic
	/// Our linked antagonist typecasted to heretic_plus.
	var/datum/antagonist/heretic/advanced/our_heretic
	/// Whether our heretic is allowed to ascend.
	var/ascension_enabled = TRUE
	/// Whether our heretic is allowed to sacrifice.
	var/sacrifices_enabled = TRUE

/datum/advanced_antag_datum/heretic/New(datum/antagonist/linked_antag)
	. = ..()
	our_heretic = linked_antag

/datum/advanced_antag_datum/heretic/Destroy()
	our_heretic = null
	. = ..()

/// Modify out codex with oour [starting_points].
/datum/advanced_antag_datum/heretic/modify_antag_points()
	starting_points = get_antag_points_from_goals()
	var/mob/living/carbon/carbon_heretic = linked_antagonist.owner.current
	for(var/obj/item/forbidden_book/codex as anything in carbon_heretic.get_all_gear())
		if(!istype(codex))
			continue
		codex.charge = starting_points
		break

/// Adjust the amount of influence charges the heretic gets on spawn.
/// Max of 5, +3 if they can't ascend, +3 if they can't sacrifice.
/// Roughly 1 influence per 3 intensity levels.
/// Flat +3 from disabling ascension, and another +3 from disabling sacrifices.
/datum/advanced_antag_datum/heretic/get_antag_points_from_goals()
	var/finalized_influences = ADV_HERETIC_INITIAL_INFLUENCE
	var/max_influnces = ADV_HERETIC_MAX_INFLUENCE
	if(!ascension_enabled)
		finalized_influences += 3
		max_influnces += ADV_HERETIC_NO_ASCENSION_MAX
	if(!sacrifices_enabled)
		finalized_influences += 3
		max_influnces += ADV_HERETIC_NO_SAC_MAX

	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		finalized_influences += (goal.intensity * ADV_HERETIC_INFLUENCE_PER_INTENSITY)

	return min(round(finalized_influences), max_influnces)

/datum/advanced_antag_datum/heretic/get_finalize_text()
	return {"Finalizing will deliver you a Codex Cicatrix with [get_antag_points_from_goals()] influence charges and a Living heart. \
If you finalize now, you will be [ascension_enabled ? "allowed to ascend": "disallowed from ascending"], \
and, you will be [sacrifices_enabled ? "allowed to sacrifice": "disallowed from sacrificing"] crew members. \
You can still edit your goals after finalizing, but you will not be able to re-enable ascension or sacrificing!"}

/datum/advanced_antag_datum/heretic/post_finalize_actions()
	. = ..()
	if(!.)
		return

	if(!ascension_enabled)
		if(our_heretic.gain_knowledge(/datum/eldritch_knowledge/no_ascension))
			log_codex_ciatrix("[key_name(our_heretic.owner.current)] gave up the ability to ascend.")
		else
			CRASH("[key_name(our_heretic.owner.current)] gave up the ability to ascend, but did not gain the proper knowledge!")

	if(!sacrifices_enabled)
		if(our_heretic.gain_knowledge(/datum/eldritch_knowledge/no_sacrifices))
			log_codex_ciatrix("[key_name(our_heretic.owner.current)] gave up the ability to sacrifice.")
		else
			CRASH("[key_name(our_heretic.owner.current)] gave up the ability to sacrifice, but did not gain the proper knowledge!")

/datum/advanced_antag_datum/heretic/log_goals_on_finalize()
	. = ..()
	if(ascension_enabled)
		message_admins("Ascension enabled: [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)] finalized their goals with acension enabled.")
	log_game("[key_name(linked_antagonist.owner.current)] finalized their goals with [ascension_enabled? "ascension enabled":"ascension disabled"].")

	if(sacrifices_enabled)
		message_admins("Sacrifices enabled: [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)] finalized their goals with sacrifices enabled.")
	log_game("[key_name(linked_antagonist.owner.current)] finalized their goals with [sacrifices_enabled? "sacrifices enabled":"sacrifices disabled"].")

/datum/advanced_antag_datum/heretic/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are a cultic follower sent to [station_name()]! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)

/datum/objective/sacrifice_ecult/adv
	name = "sacrifice"

/datum/objective/sacrifice_ecult/adv/New(text)
	. = ..()
	target_amount = rand(2, 6)

/datum/objective/sacrifice_ecult/adv/update_explanation_text() // This doesn't call parent.
	explanation_text = "Sacrifice at least [target_amount] people."

/datum/objective/sacrifice_ecult/adv/admin_edit(mob/admin)
	var/new_amount = input(admin,"How many sacrifices?", "Sacs", target_amount) as num|null
	if(new_amount)
		target_amount = clamp(new_amount, 1, 9)
	update_explanation_text()
