/datum/antagonist/advanced_cult
	name = "Advanced Cultist"
	roundend_category = "cultists"
	antagpanel_category = "Cult"
	antag_moodlet = /datum/mood_event/cult
	suicide_cry = "FOR MY GOD!!"
	preview_outfit = /datum/outfit/cultist

	job_rank = ROLE_CULTIST
	antag_hud_type = ANTAG_HUD_CULT
	antag_hud_name = "cult"
	ui_name = null

	var/datum/team/advanced_cult/team
	var/datum/action/innate/cult/blood_magic/advanced/our_magic

	var/static/list/cult_objectives = list(
		"exile" = /datum/objective/exile,
		)

/datum/antagonist/advanced_cult/on_gain()
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose += cult_objectives
	name = "Cultist"

	linked_advanced_datum = new /datum/advanced_antag_datum/cultist(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/advanced_cult/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/advanced_cult/get_team()
	return team

/datum/antagonist/advanced_cult/finalize_antag()
	. = ..()
	our_magic = new()
	for(var/datum/action/innate/cult/blood_spell/magic as anything in subtypesof(/datum/action/innate/cult/blood_magic))
		if(initial(magic.blacklisted_by_default))
			continue
		LAZYADD(our_magic.all_allowed_spell_types, magic)
	team = new(owner)

/// The advanced antag datum for traitor.
/datum/advanced_antag_datum/cultist
	name = "Advanced Cultist"
	employer = ""
	advanced_panel_type = "_AdvancedCultPanel"
	/// Whether our cultist can convert people.
	var/no_conversion = FALSE

/datum/advanced_antag_datum/cultist/modify_antag_points()
	return 0 // Cult has no "points" to modify

/datum/advanced_antag_datum/cultist/get_antag_points_from_goals()
	return 0 // Cult has no "points" to modify

/datum/advanced_antag_datum/cultist/post_finalize_actions()
	. = ..()
	if(!.)
		return

	var/datum/antagonist/advanced_cult/our_cultist = linked_antagonist
	if(no_conversion)
		our_cultist.our_magic.runeless_limit += 1
		our_cultist.our_magic.rune_limit += 1

/datum/advanced_antag_datum/cultist/get_finalize_text()
	return "Finalizing will allow you to use blood magic and grant you your equipment. You will [no_conversion ? "not":""] be able to convert humans to your cult[no_conversion ? ", but you will gain +1 max spell slots ([ADV_CULTIST_MAX_SPELLS_NORUNE + 1] unempowered, [ADV_CULTIST_MAX_SPELLS_RUNE + 1] empowered).":""]. You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/cultist/log_goals_on_finalize()
	. = ..()
	if(!no_conversion)
		message_admins("Conversion enabled: [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)] finalized their goals with the ability convert others enabled.")
	log_game("[key_name(linked_antagonist.owner.current)] finalized their goals with conversion [no_conversion ? "disabled":"enabled"].")

/datum/advanced_antag_datum/cultist/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are a magical cultist on board [station_name()]! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)
