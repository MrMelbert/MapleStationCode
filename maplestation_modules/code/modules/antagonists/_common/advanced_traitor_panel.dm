/// -- The advanced traitor panuel UI. --

/datum/advanced_antag_datum/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, advanced_panel_type)
		ui.open()

/datum/advanced_antag_datum/ui_status(mob/user)
	if (user == linked_antagonist.owner.current && !can_use_ui)
		return UI_CLOSE

	return UI_INTERACTIVE

/datum/advanced_antag_datum/ui_state(mob/user)
	if(user != linked_antagonist.owner.current)
		to_chat(user, "You are viewing [linked_antagonist.owner.current]'s advanced traitor panel as an admin.")
		if(isliving(user)) // If they're in a mob...
			message_admins("[ADMIN_LOOKUPFLW(user)] is viewing [ADMIN_LOOKUPFLW(linked_antagonist.owner.current)]'s advanced traitor panel as an admin.")
		return GLOB.admin_state
	else
		return GLOB.always_state

/datum/advanced_antag_datum/ui_data(mob/user)
	var/list/data = list()

	data["antag_type"] = linked_antagonist.name
	data["name"] = name
	data["employer"] = employer
	data["backstory"] = backstory
	data["goals_finalized"] = finalized
	data["finalize_text"] = get_finalize_text()
	data["backstory_tutorial_text"] = get_backstory_tutorial_text(background_tutorial_state)
	data["objective_tutorial_text"] = get_objective_tutorial_text(objective_tutorial_state)

	var/goal_num = 1
	for(var/datum/advanced_antag_goal/found_goal in our_goals)
		var/list/goal_data = list(
			id = goal_num,
			ref = REF(found_goal),
			goal = found_goal.goal,
			intensity = found_goal.intensity,
			notes = found_goal.notes,
			check_all_objectives = found_goal.check_all_objectives,
			always_succeed = found_goal.always_succeed,
			objective_data = list(),
			)
		if(LAZYLEN(found_goal.similar_objectives))
			var/obj_num = 1
			for(var/datum/objective/found_objective in found_goal.similar_objectives)
				var/list/found_objective_data = list(
					id = obj_num,
					ref = REF(found_objective),
					text = found_objective.explanation_text,
					trimmed_text = TextPreview(found_objective.explanation_text, 65),
				)
				goal_data["objective_data"] += list(found_objective_data)
				obj_num++
		data["goals"] += list(goal_data)
		goal_num++

	return data

/datum/advanced_antag_datum/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(usr != linked_antagonist.owner.current)
		to_chat(usr, "You can't edit [linked_antagonist.owner]'s goals!")
		return // third parties can look around the UI but no touching

	var/datum/advanced_antag_goal/edited_goal
	if(params["goal_ref"])
		edited_goal = locate(params["goal_ref"]) in our_goals
		if(!edited_goal)
			CRASH("Advanced_traitor_panel passed a reference parameter to a goal that it could not locate!")

	switch(action)
		// Tutorial stuff
		if("begin_background_tutorial")
			background_tutorial_state = (background_tutorial_state == TUTORIAL_OFF ? TUTORIAL_BACKGROUND_START : TUTORIAL_OFF)
			. = TRUE

		if("begin_objective_tutorial")
			objective_tutorial_state = (objective_tutorial_state == TUTORIAL_OFF ? TUTORIAL_OBJECTIVE_START : TUTORIAL_OFF)
			. = TRUE

		if("proceede_beginner_tutorial")
			background_tutorial_state++
			if(background_tutorial_state == TUTORIAL_BACKGROUND_END)
				background_tutorial_state = TUTORIAL_OFF
			. = TRUE

		if("proceede_objective_tutorial")
			objective_tutorial_state++
			if(objective_tutorial_state == TUTORIAL_OBJECTIVE_END)
				objective_tutorial_state = TUTORIAL_OFF
			. = TRUE

		/// Background stuff
		if("set_name")
			set_name(params["name"])
			. = TRUE

		if("set_employer")
			set_employer(params["employer"])
			. = TRUE

		if("set_backstory")
			set_backstory(params["backstory"])
			. = TRUE

		/// Goal Stuff
		if("add_advanced_goal")
			if(LAZYLEN(our_goals) >= ADV_TRAITOR_MAX_GOALS)
				to_chat(usr, "Maximum amount of goals reached.")
				return

			add_advanced_goal()
			. = TRUE

		if("remove_advanced_goal")
			if(LAZYLEN(our_goals) == 1)
				to_chat(usr, "You can't remove your last goal.")
				return
			remove_advanced_goal(edited_goal)
			. = TRUE

		if("set_goal_text")
			edited_goal.set_goal_text(params["newgoal"])
			. = TRUE

		if("set_goal_intensity")
			edited_goal.set_intensity(params["newlevel"])
			. = TRUE

		if("set_note_text")
			edited_goal.set_note_text(params["newtext"])
			. = TRUE

		if("add_similar_objective")
			if(LAZYLEN(edited_goal.similar_objectives) >= ADV_TRAITOR_MAX_SIMILAR_OBJECTIVES)
				to_chat(usr, "Maximum amount of similar objectives reached for this goal.")
				return

			var/new_objective_type = input("Add an objective:", "Objective type", null) as null|anything in possible_objectives
			if(!new_objective_type)
				return

			new_objective_type = possible_objectives[new_objective_type]
			var/datum/objective/objective_to_add = new new_objective_type()
			objective_to_add.admin_edit(usr)
			edited_goal.add_similar_objective(objective_to_add)
			. = TRUE

		if("remove_similar_objective")
			var/datum/objective/removed_objective = locate(params["objective_ref"]) in edited_goal.similar_objectives
			if(!removed_objective)
				CRASH("Advanced_traitor_panel passed a reference to an objective belonging to a goal that could not be located!")

			edited_goal.remove_similar_objective(removed_objective)
			. = TRUE

		if("clear_sim_objectives")
			QDEL_LIST(edited_goal.similar_objectives)
			. = TRUE

		if("toggle_check_all_objectives")
			edited_goal.check_all_objectives = !edited_goal.check_all_objectives
			. = TRUE

		if("toggle_always_succeed")
			edited_goal.always_succeed = !edited_goal.always_succeed
			. = TRUE

		/// Finalize
		if("finalize_goals")
			. = post_finalize_actions()


/datum/advanced_antag_datum/proc/get_backstory_tutorial_text(current_step)
	switch(current_step)
		if(TUTORIAL_BACKGROUND_START)
			return {"This top section is mostly flavor about your antagonist - What makes you tick.

Who are you? Why are you here? Who sent you here? Stuff to establish your backstory.

Having set information and backstory isn't necessary to make a good antagonist - though we encourage it.

All of this information will be displayed in the roundend report (unless you leave them blank)."}
		if(TUTORIAL_BACKGROUND_NAME)
			return {"On the top left is your antagonist name. This is what your antagonist is called - 'Traitor', 'Heretic', or 'Cultist'.

Or you can be more specific - You're a "Cybersun Industries Spy", a "Ratvarian Cultist", or a "DonkCo Clown".

You can set this box to anything, but it cannot be empty - This box is required."}
		if(TUTORIAL_BACKGROUND_EMPLOYER)
			return {"On the middle left is your employer name. This is who is sending you out on your mission.

"The Syndicate", "Cybersun Industries", "Nar'sie", or "The Wizard Federation". Any kind of organization.

You can set this box to anything, or you can leave it blank to be 'self-employed'. This box is optional."}
		if(TUTORIAL_BACKGROUND_BACKSTORY)
			return {"In the middle is your backstory. This is why you've embarked on your mission.

"You're in poverty and had to accept a syndicate contract". "You really hate a certain crewmember". "You're a glutton for chaos".

You can this box to anything, or leave it empty. Having a backstory is not necessary (especially if you make your goals obvious in game). This box is optional."}
		else
			return null

/datum/advanced_antag_datum/proc/get_objective_tutorial_text(current_step)
	switch(current_step)
		if(TUTORIAL_OBJECTIVE_START)
			return {"This lower section is the important part of your antagonist - What's your job? What's the plan?

It's recommended you set at least 2 goals to start out with. These goals lay out what you plan on actually doing.

All your goals and notes will be listed in the roundend report."}
		if(TUTORIAL_OBJECTIVE_ADD_GOAL)
			return{"You can start out by pressing 'add goal' to create a new goal for your antagonist.
Pressing 'add goal' will initialize a blank goal for you to fill out.

You can navigate the goals by clicking through the tabs that appear.

The red minus on the tabs of each goal will delete and remove that goal from your list."}
		if(TUTORIAL_OBJECTIVE_EDIT_GOAL)
			return{"For each goal, you have two main text boxes you can type in. The 'goals' box, and the 'notes' box.

The goals box is the most important part of the goal - it's what the actual objective is.
Steal as much technology as you can. Sacrifice the captain to your god. Delaminate the engine. Lube the halls.
It's required you set at least something in the goals box. It doesn't need to be long, but it needs to be something you want to achieve.

The second box is the notes box. This box is optional, and it allows you to provide extra info about the goal.
You can add any additional side-notes about your goal here. How you plan on accomplishing it, why you're choosing to do it, and so on.
The contents of the notes box gets forwarded to the online admins, so if you want to let the admins know something about the goal, do it here."}
		if(TUTORIAL_OBJECTIVE_INTENSITIES)
			return{"Between the goals and notes boxes, there's the intensity dial.

The intensity level of the goal is how dangerous this goal may be.
The scale is as followed:

1 = Minor theft or basic antagonizing
2 = Kidnapping / Theft
3 = Assassination / Grand Theft
4 = Mass sabotage (engine delamination)
5 = Mass killings, destroying entire departments

Your average traitor will have 2 goals of intensity 3. Intensity 4 or 5 objectives will message the admins online.
Setting your goal to an intensity level is required."}
		if(TUTORIAL_OBJECTIVE_SIM_OBJECTIVES)
			return{"To the far right is the 'similar objectives' tab. This is entirely optional for antagonists who want to fill our their objectives with more context.
You can add a similar objective with the green button. This pulls up a list of common objectives you can choose from to add to your goal.
You can add multiple similar objectives to your goal, up to 5.

A traitor interested in stealing technology might set 3 or 4 steal objectives for high-risk, high-tech items on board the station,
while an evil cultist might set an objective to assassinate the captain and the head of security to go along with a blood sacrifice."}
		if(TUTORIAL_OBJECTIVE_SIM_OBJECTIVES_EXTRA)
			return{"The checkbox to the left will toggle the objective between 'check all objectives' and 'check the first success'.
If your goal is set to 'check all objectives', it will go through all similar objectives you set to check for success at the end of the round.
While if your goal is set to 'check first success', you will only need one of your objective to succeed to be successful at the end of the round.

The checkbox to the right will toggle between whether the objective is set to always succeed.
If enabled, your objective will always show up as successful at round end, even if you set no similar objectives.

If you don't set any similar objectives, success won't even be checked at the end of the round - it's entirely up to you."}
		else
			return null
