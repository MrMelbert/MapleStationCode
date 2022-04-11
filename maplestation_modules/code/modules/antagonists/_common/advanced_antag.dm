/// -- Base advanced antag datum --
/// The advanced antag datum - the datum that runs our advanced antags.
/datum/advanced_antag_datum
	/// The antagonist this datum is linked to.
	var/datum/antagonist/linked_antagonist
	/// Changed to "Traitor" on spawn, but can be changed by the player.
	var/name = "Advanced Antagonist"
	/// Can be changed by the player.
	var/employer = "The Badmins"
	/// This player's backstory for their antag - optional, can be empty/null
	var/backstory = ""
	/// The starting "traitor fun points" for our antag. TC, processing power, etc.
	var/starting_points = 0
	/// Lazylist of our goals datums linked to this antag.
	var/list/datum/advanced_antag_goal/our_goals
	/// List of objectives we can add to similar objectives.
	var/list/possible_objectives = list()
	/// Whether our goals are finalized.
	var/finalized = FALSE

	/// -- UI STUFF --

	/// Whether the antag can actually open and edit the ui.
	var/can_use_ui = TRUE
	/// The type of advanced panel datum we make / open
	var/advanced_panel_type = "_AdvancedTraitorPanel"
	/// The current state of the background tutorial.
	var/background_tutorial_state = TUTORIAL_OFF
	/// The current state of the objective tutorial.
	var/objective_tutorial_state = TUTORIAL_OFF

/datum/advanced_antag_datum/New(datum/antagonist/linked_antag)
	src.linked_antagonist = linked_antag
	src.name = linked_antagonist.name

/datum/advanced_antag_datum/Destroy()
	remove_verb(linked_antagonist.owner.current, /mob/proc/open_advanced_antag_panel)
	linked_antagonist = null
	QDEL_LIST(our_goals)
	return ..()

/// Give the antagonist the verb to open their goal panel.
/datum/advanced_antag_datum/proc/setup_advanced_antag()
	linked_antagonist.antag_memory += "Use the \"Antagonist - Set Goals\" verb to set your goals.<br>"

	/// Only giving them one objective as a reminder - "Set your goals". Only shows up in their memory.
	var/datum/objective/custom/custom_objective = new()
	custom_objective.explanation_text = "Set your custom goals via the IC tab."
	custom_objective.owner = linked_antagonist.owner
	custom_objective.completed = TRUE
	linked_antagonist.objectives += custom_objective

	add_advanced_goal()
	show_advanced_antag_panel(linked_antagonist.owner.current)
	add_verb(linked_antagonist.owner.current, /mob/proc/open_advanced_antag_panel)

/// Greet the antagonist with some text after spawning.
/// antagonist - the mob being greeted, the antagonist.
/datum/advanced_antag_datum/proc/greet_message(mob/antagonist)
	to_chat(antagonist, span_alertsyndie("You are a [name]!"))
	antagonist.playsound_local(get_turf(antagonist), 'maplestation_modules/sound/radiodrum.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	addtimer(CALLBACK(src, .proc/greet_message_two, antagonist), 3 SECONDS)

/// Give them details on what their role actually means to them, then move to greet_three after 3 seconds.
/// antagonist - the mob being greeted, the antagonist.
/datum/advanced_antag_datum/proc/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are a story driven antagonist! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)

/// Give them a short guide on how to use the goal panel, and what all the buttons do.
/// antagonist - the mob being greeted, the antagonist.
/datum/advanced_antag_datum/proc/greet_message_three(mob/antagonist)
	to_chat(antagonist, span_danger("In your goal panel, you should set a few goals to get started and finalize them to receive your uplink. If you're not sure how to use the panel or its functions, use the tutorial built into the UI."))

/* Updates the user's currently open TGUI panel, or open a new panel if they don't have one.
 * If user is the antagonist itself, and can_use_ui is FALSE, does nothing.
 *
 * user - the mob opening the panel (usually the antagonist themselves, but sometimes admins)
 */
/datum/advanced_antag_datum/proc/show_advanced_antag_panel(mob/user)
	if(user == linked_antagonist.owner.current && !can_use_ui)
		to_chat(user, span_warning("You can no longer use this."))
		return

	ui_interact(user)

/// Modify the traitor's starting_points (TC, processing points, etc) based on their goals's intensity levels.
/datum/advanced_antag_datum/proc/modify_antag_points()
	CRASH("modify_antag_points not implemented for [type]!")

/// Calculate the traitor's starting points (TC, processing power, etc) based on their goals's intensity levels.
/// Returns a number (the number of points calculated)
/datum/advanced_antag_datum/proc/get_antag_points_from_goals()
	CRASH("get_antag_points_from_goals not implemented for [type]!")

/// Get the text that shows up in the tooltip of the finalize button.
/// Returns a string (The formatted text)
/datum/advanced_antag_datum/proc/get_finalize_text()
	CRASH("get_finalize_text not implemented for [type]!")

/// Actions to do after the antag finalizes their goals.
/datum/advanced_antag_datum/proc/post_finalize_actions()
	if(finalized)
		return FALSE

	finalized = TRUE
	linked_antagonist.finalize_antag()
	modify_antag_points()
	log_goals_on_finalize()

	return TRUE

/// Miscellaneous logging for the antagonist's goals after they finalize them.
/// Extend this proc for adding in extra logging to an antagonist.
/datum/advanced_antag_datum/proc/log_goals_on_finalize()
	SHOULD_CALL_PARENT(TRUE)

	var/mob/antag = linked_antagonist.owner.current
	message_admins("[ADMIN_LOOKUPFLW(antag)] finalized their objectives. They began with [starting_points] antagonist points as a [linked_antagonist.name]. ")
	log_game("[key_name(antag)] finalized their objectives. Their began with [starting_points] antagonist points as a [linked_antagonist.name]. ")
	if(!LAZYLEN(our_goals))
		message_admins("No set goal: [ADMIN_LOOKUPFLW(antag)] finalized their goals with 0 goals set.")
		return

	for(var/datum/advanced_antag_goal/goal as anything in our_goals)
		if(goal.goal)
			if(goal.intensity >= 4)
				message_admins("High intensity goal: [ADMIN_LOOKUPFLW(antag)] finalized an intensity [goal.intensity] goal: [goal.goal]")
			else if(goal.intensity == 0)
				message_admins("Potential error: [ADMIN_LOOKUPFLW(antag)] finalized an intensity 0 goal: [goal.goal]")
		else if(goal.intensity > 0)
			message_admins("Potential exploit: [ADMIN_LOOKUPFLW(antag)] finalized an intensity [goal.intensity] goal with no goal text. Potential exploit of goals for extra points.")
		else
			message_admins("Potential error: [ADMIN_LOOKUPFLW(antag)] finalized a goal with no goal text.")

		if(goal.notes)
			message_admins("Finalized goal note: [ADMIN_LOOKUPFLW(antag)] finalized a goal with additional notes: [goal.notes]")

		log_game("[key_name(antag)] finalized an intensity [goal.intensity] goal: [goal.goal] (notes: [goal.notes]).")

/// Saniztize and set our name.
/// name - the name we're changing this to
/datum/advanced_antag_datum/proc/set_name(name)
	src.name = STRIP_HTML_SIMPLE(name, MAX_NAME_LEN)

/// Sanitize and set our employer
/// employer - the employer we're changing this to
/datum/advanced_antag_datum/proc/set_employer(employer)
	src.employer = STRIP_HTML_SIMPLE(employer, MAX_NAME_LEN)

/// Sanitize and set our backstory
/// backstory - the backstory we're changing this to
/datum/advanced_antag_datum/proc/set_backstory(backstory)
	src.backstory = STRIP_HTML_SIMPLE(backstory, MAX_MESSAGE_LEN)

/// Initialize a new goal and append it to our lazylist
/datum/advanced_antag_datum/proc/add_advanced_goal()
	var/datum/advanced_antag_goal/new_goal = new(src)
	LAZYADD(our_goals, new_goal)

/// Remove a goal from our lazylist and qdel it
/// old_goal - reference to the goal we're removing
/datum/advanced_antag_datum/proc/remove_advanced_goal(datum/advanced_antag_goal/old_goal)
	LAZYREMOVE(our_goals, old_goal)
	qdel(old_goal)

/// A mob proc / verb that lets the antagonist open up their goal panel in game.
/mob/proc/open_advanced_antag_panel()
	set name = "Antagonist - Set Goals"
	set category = "IC"

	for(var/datum/antagonist/antag_datum in mind?.antag_datums)
		if(!antag_datum.linked_advanced_datum)
			continue
		antag_datum.linked_advanced_datum.show_advanced_antag_panel(src)
		return

	to_chat(src, "You shouldn't have this!")
	remove_verb(src, /mob/proc/open_advanced_antag_panel)
