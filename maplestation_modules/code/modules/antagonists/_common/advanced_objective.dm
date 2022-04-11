/// -- Base Advanced antag goal datum. --
/// Like your standard /datum/objective/custom, but with more fun stuff.
/// Used by advanced antags [/datum/advaced_antagonist]
/datum/advanced_antag_goal
	/// Our antag datum
	var/datum/advanced_antag_datum/our_antag
	/// What's our actual set goal?
	var/goal = ""
	/* How dangerous this goal is
	 * 5 = Mass killings, vaporizing departments
	 * 4 = Mass sabotage (engine delamination)
	 * 3 = Assassination / Grand Theft
	 * 2 = Kidnapping / Theft
	 * 1 = Minor theft or basic antagonizing
	 */
	var/intensity = 0
	/// Extra notes about this goal.
	var/notes = ""
	/// Similar objective datums we can compare this goal too for success and such
	var/list/datum/objective/similar_objectives
	/// Whether we check all objectives or just the first successful one in our [similar_objectives]
	var/check_all_objectives = TRUE
	/// Whether this objective is successful, regardless of our [similar_objectives]
	var/always_succeed = FALSE

/datum/advanced_antag_goal/New(datum/advanced_antag_datum/antag_datum)
	our_antag = antag_datum

/datum/advanced_antag_goal/Destroy()
	QDEL_LIST(similar_objectives)
	our_antag = null
	return ..()

/// Set our goal to our passed goal.
/datum/advanced_antag_goal/proc/set_goal_text(goal)
	src.goal = STRIP_HTML_SIMPLE(goal, ADV_TRAITOR_MAX_GOAL_LENGTH)

/// Set our goal to our passed goal.
/datum/advanced_antag_goal/proc/set_note_text(notes)
	src.notes = STRIP_HTML_SIMPLE(notes, ADV_TRAITOR_MAX_NOTE_LENGTH)

/// Set our intensity level to our passed intensity.
/datum/advanced_antag_goal/proc/set_intensity(intensity)
	src.intensity = clamp(intensity, 1, 5)

/// Adds an objective to our similar objective list. Pass an instantiated objective.
/datum/advanced_antag_goal/proc/add_similar_objective(datum/objective/added_objective)
	added_objective.owner = our_antag.linked_antagonist.owner
	LAZYADD(similar_objectives, added_objective)

/// Remove an objective to our similar objective list. Pass an instantiated objective ref.
/datum/advanced_antag_goal/proc/remove_similar_objective(datum/objective/removed_objective)
	if(similar_objectives.Remove(removed_objective))
		qdel(removed_objective)

/// Generate roundend text for the roundend report for this advanced goal.
/// Number is the number in the list that this objective is. (1 to 5)
/datum/advanced_antag_goal/proc/get_roundend_text(number)
	var/datum/advanced_antag_datum/our_antag_datum = our_antag
	var/formatted_text = "<b>Objective #[number]</b>: [goal]"
	if(LAZYLEN(similar_objectives) || always_succeed)
		if(check_relative_success())
			formatted_text += span_greentext("<br>The [our_antag_datum.name] succeeded this goal!")
		else
			formatted_text += span_redtext("<br>The [our_antag_datum.name] failed this goal!")
	if(notes)
		formatted_text += span_info("<br>Extra info they had about this goal: [notes]")

	return formatted_text + "<br>"

/// Loop through all our similar objectives and see if we completed them.
/// If [check_all_objectives] is true, we need all objectives in the list to be successful to return TRUE.
/// If it is false, we only need ONE objective to be true to return TRUE.
/datum/advanced_antag_goal/proc/check_relative_success()
	for(var/datum/objective/objective in similar_objectives)
		if(check_all_objectives)
			if(!objective.check_completion())
				return FALSE || always_succeed
		else
			if(objective.check_completion())
				return TRUE

	return TRUE
