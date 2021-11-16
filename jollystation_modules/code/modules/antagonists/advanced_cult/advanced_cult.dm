
#define CULT_STYLES list(CULT_STYLE_RATVAR, CULT_STYLE_NARSIE)

/datum/antagonist/advanced_cult
	ui_name = null
	show_in_antagpanel = FALSE
	job_rank = ROLE_CULTIST
	antag_hud_type = ANTAG_HUD_CULT
	antag_hud_name = "cult"
	roundend_category = "cultists"
	antagpanel_category = "Cult"
	suicide_cry = "FOR MY GOD!!"
	antag_moodlet = /datum/mood_event/cult
	preview_outfit = /datum/outfit/cultist

	/// Whether this cultist is affected by implants
	var/affected_by_implants = TRUE
	/// What style of cultist are we?
	var/datum/cult_theme/cultist_style
	/// Our cult team
	var/datum/team/advanced_cult/team
	/// Our magic action (lets us invoke spells and stuff)
	var/datum/action/innate/our_magic
	var/list/possible_runes

/datum/antagonist/advanced_cult/Destroy()
	. = ..()
	cultist_style = null

/datum/antagonist/advanced_cult/get_team()
	return team

/datum/antagonist/advanced_cult/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(. && affected_by_implants)
		. = is_convertable_to_cult(new_owner.current, get_team())

/datum/antagonist/advanced_cult/on_mindshield(mob/implanter)
	if(!silent)
		to_chat(owner.current, span_warning("You feel something interfering with your mental conditioning, but you resist it!"))

/datum/antagonist/advanced_cult/finalize_antag()
	cultist_style.on_cultist_made(src, owner.current)

/datum/antagonist/advanced_cult/on_removal()
	cultist_style.on_cultist_lost(owner.current)
	if(!silent)
		owner.current.visible_message(span_deconversion_message("<span class'warningplain'>[owner.current] looks like [owner.current.p_theyve()] just reverted to [owner.current.p_their()] old faith!</span>"), null, null, null, owner.current)
		to_chat(owner.current, span_userdanger("An unfamiliar white light flashes through your mind, cleansing the taint of your old god and all your memories as their servant."))
		owner.current.log_message("has renounced their cult", LOG_ATTACK, color="#960000")

	return ..()

/datum/antagonist/advanced_cult/master
	name = "Advanced Cultist Master"
	show_in_antagpanel = TRUE
	affected_by_implants = FALSE

	var/static/list/cult_objectives = list(
		"exile" = /datum/objective/exile,
		)

/datum/antagonist/advanced_cult/master/on_gain()
	if(!GLOB.admin_objective_list)
		generate_admin_objective_list()

	if(!LAZYLEN(GLOB.cult_themes))
		generate_cult_themes()
	cultist_style = GLOB.cult_themes[CULT_STYLE_NARSIE]

	var/list/objectives_to_choose = GLOB.admin_objective_list.Copy()
	objectives_to_choose -= blacklisted_similar_objectives
	objectives_to_choose += cult_objectives
	name = "Cultist"

	linked_advanced_datum = new /datum/advanced_antag_datum/cultist(src)
	linked_advanced_datum.setup_advanced_antag()
	linked_advanced_datum.possible_objectives = objectives_to_choose
	return ..()

/datum/antagonist/advanced_cult/master/greet()
	linked_advanced_datum.greet_message(owner.current)

/datum/antagonist/advanced_cult/master/finalize_antag()
	. = ..()
	var/datum/advanced_antag_datum/cultist/our_cultist = linked_advanced_datum
	team = new(owner)
	team.no_conversion = our_cultist.no_conversion

	possible_runes = cultist_style.get_allowed_runes(src)

/datum/antagonist/advanced_cult/master/roundend_report()
	var/datum/advanced_antag_datum/cultist/our_cultist = linked_advanced_datum
	if(!our_cultist.no_conversion) //handled by the team roundend report
		return

	var/list/parts = list()

	parts += printplayer(owner)
	parts += "<b>[owner]</b> was a/an <b>[our_cultist.name]</b>[our_cultist.employer? ", a follower of <b>[our_cultist.employer]</b>":""]."
	if(our_cultist.backstory)
		parts += "<b>[owner]'s</b> backstory was the following: <br>[our_cultist.backstory]"

	if(LAZYLEN(linked_advanced_datum.our_goals))
		parts += "<b>[owner]'s</b> objectives:"
		var/count = 1
		for(var/datum/advanced_antag_goal/goal as anything in linked_advanced_datum.our_goals)
			parts += goal.get_roundend_text(count++)

	return parts.Join("<br>")

/datum/antagonist/advanced_cult/roundend_report_footer()
	return "<br>And thus finalizes another ritual on board [station_name()]."

/datum/antagonist/advanced_cult/convertee
	name = "Converted Cultist"

/datum/antagonist/advanced_cult/convertee/finalize_antag()
	. = ..()
	var/datum/team/our_team = get_team()
	if(!our_team)
		CRASH("Advanced cultist converted to someone without a team!")
	our_team.add_member(owner)

/datum/antagonist/advanced_cult/deconverted_master
	name = "Deconverted Cult Master"


/// The advanced antag datum for traitor.
/datum/advanced_antag_datum/cultist
	name = "Advanced Cultist"
	employer = "Nar'Sie"
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
	var/datum/action/innate/cult/blood_magic/advanced/cult_magic = our_cultist.our_magic
	if(no_conversion)
		cult_magic.runeless_limit += 1
		cult_magic.rune_limit += 1

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

/datum/advanced_antag_datum/cultist/ui_data(mob/user)
	. = ..()
	var/datum/antagonist/advanced_cult/our_cultist = linked_antagonist
	.["cannot_convert"] = no_conversion
	.["cult_style"] = our_cultist.cultist_style
	.["cult_style_options"] = CULT_STYLES

/datum/advanced_antag_datum/cultist/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle_conversion")
			if(finalized)
				return
			no_conversion = !no_conversion

		if("set_cult_style")
			if(finalized)
				return
			var/datum/antagonist/advanced_cult/our_cultist = linked_antagonist
			var/datum/cult_theme/theme = GLOB.cult_themes[params["cult_style"]]
			if(theme)
				theme.on_chose_breakdown(usr)
				our_cultist.cultist_style = theme
			else
				to_chat(usr, "Something went wrong and you selected an invalid theme.")
				stack_trace("[usr] selected an invalid cult theme ([params["cult_style"]])!")
				our_cultist.cultist_style = GLOB.cult_themes[CULT_STYLE_NARSIE]

	return TRUE
