#define MINOR_INSANITY_PEN 5
#define MAJOR_INSANITY_PEN 10
#define MOOD_CATEGORY_NUTRITION "nutrition"
#define MOOD_CATEGORY_AREA_BEAUTY "area_beauty"

/**
 * Mood datum
 *
 * Contains the logic for controlling a living mob's mood and sanity.
 */
/datum/mood
	/// The parent (living) mob
	var/mob/living/mob_parent

	/// The total combined value of all moodlets for the mob
	var/mood
	/// Current sanity of the mob (ranges from 0 - 150)
	var/sanity = SANITY_NEUTRAL
	/// the total combined value of all visible moodlets for the mob
	var/shown_mood
	/// Multiplier to the sum total of mood the mob is experiencing
	var/mood_modifier = 1
	/// Multiplier to positive moodlet values. Stacks with mood_modifier
	var/positive_mood_modifier = 1
	/// Multiplier to negative moodlet values. Stacks with mood_modifier
	var/negative_mood_modifier = 1
	/// Multiplier to the length of positive moodlets.
	/// Please don't set this to 0
	var/positive_moodlet_length_modifier = 1
	/// Multiplier to the length of negative moodlets.
	/// Please don't set this to 0
	var/negative_moodlet_length_modifier = 1
	/// Used to track what stage of moodies they're on (1-9)
	var/mood_level = MOOD_LEVEL_NEUTRAL
	/// To track what stage of sanity they're on (1-6)
	var/sanity_level = SANITY_LEVEL_NEUTRAL
	/// Is the owner being punished for low mood? if so, how much?
	var/insanity_effect = 0
	/// The screen object for the current mood level
	var/atom/movable/screen/mood/mood_screen_object
	/// List of mood events currently active on this datum
	var/list/mood_events = list()
	/// Lazylist that maps mood text slots currently active so we can avoid stacking them on top of each other
	var/list/active_mood_maptexts
	/// Assoc lazylist of mood event types to the next world.time where we show that mood text again, to prevent spam
	var/list/mood_maptext_cooldowns

/datum/mood/New(mob/living/mob_to_make_moody)
	if (!istype(mob_to_make_moody))
		stack_trace("Tried to apply mood to a non-living atom!")
		qdel(src)
		return

	START_PROCESSING(SSmood, src)

	mob_parent = mob_to_make_moody

	RegisterSignal(mob_to_make_moody, COMSIG_MOB_HUD_CREATED, PROC_REF(modify_hud))
	RegisterSignal(mob_to_make_moody, COMSIG_ENTER_AREA, PROC_REF(check_area_mood))
	RegisterSignal(mob_to_make_moody, COMSIG_EXIT_AREA, PROC_REF(exit_area))
	RegisterSignal(mob_to_make_moody, COMSIG_LIVING_POST_FULLY_HEAL, PROC_REF(on_aheal))
	RegisterSignal(mob_to_make_moody, COMSIG_MOB_STATCHANGE, PROC_REF(handle_mob_death))
	RegisterSignal(mob_to_make_moody, COMSIG_QDELETING, PROC_REF(clear_parent_ref))

	var/area/our_area = get_area(mob_to_make_moody)
	if(our_area)
		check_area_mood(mob_to_make_moody, our_area)

	mob_to_make_moody.become_area_sensitive(MOOD_DATUM_TRAIT)
	if(mob_to_make_moody.hud_used)
		modify_hud()
		var/datum/hud/hud = mob_to_make_moody.hud_used
		hud.show_hud(hud.hud_version)

/datum/mood/proc/clear_parent_ref()
	SIGNAL_HANDLER

	unmodify_hud()
	mob_parent.lose_area_sensitivity(MOOD_DATUM_TRAIT)
	UnregisterSignal(mob_parent, list(COMSIG_MOB_HUD_CREATED, COMSIG_ENTER_AREA, COMSIG_EXIT_AREA, COMSIG_LIVING_POST_FULLY_HEAL, COMSIG_MOB_STATCHANGE, COMSIG_QDELETING))
	var/area/our_area = get_area(mob_parent)
	if(our_area)
		UnregisterSignal(our_area, COMSIG_AREA_BEAUTY_UPDATED)

	mob_parent = null

/datum/mood/Destroy(force)
	STOP_PROCESSING(SSmood, src)
	QDEL_LIST_ASSOC_VAL(mood_events)
	return ..()

/datum/mood/process(seconds_per_tick)
	var/change = 0
	var/new_min = SANITY_INSANE
	var/new_max = SANITY_GREAT
	switch(mood_level)
		if(MOOD_LEVEL_SAD4)
			change = -0.3
		if(MOOD_LEVEL_SAD3)
			change = -0.15
			new_min = SANITY_CRAZY
		if(MOOD_LEVEL_SAD2)
			change = -0.1
			new_min = SANITY_UNSTABLE
		if(MOOD_LEVEL_SAD1)
			change = -0.05
			new_min = SANITY_UNSTABLE
		if(MOOD_LEVEL_NEUTRAL)
			new_min = SANITY_UNSTABLE
		if(MOOD_LEVEL_HAPPY1)
			change = 0.2
			new_min = SANITY_UNSTABLE
		if(MOOD_LEVEL_HAPPY2)
			change = 0.3
			new_min = SANITY_UNSTABLE
		if(MOOD_LEVEL_HAPPY3)
			change = 0.4
			new_min = SANITY_NEUTRAL
			new_max = SANITY_MAXIMUM
		if(MOOD_LEVEL_HAPPY4)
			change = 0.6
			new_min = SANITY_NEUTRAL
			new_max = SANITY_MAXIMUM

	// If our sanity is beneath our new lower threshold,
	// a significant boost is added to help recover up to it
	if(sanity < new_min)
		change += 0.7
		new_min = SANITY_INSANE

	if(change)
		adjust_sanity(change * seconds_per_tick, new_min, new_max)

	if(sanity_level >= SANITY_LEVEL_CRAZY && SPT_PROB(sanity_level == SANITY_LEVEL_CRAZY ? 2 : 5, seconds_per_tick))
		mob_parent.set_jitter_if_lower(3 SECONDS)
		for(var/mood_cat in shuffle(mood_events))
			var/datum/mood_event/event = mood_events[mood_cat]
			if(event.insanity_effect(sanity))
				break

/datum/mood/proc/handle_mob_death(datum/source, new_stat, old_stat)
	SIGNAL_HANDLER

	if (old_stat == DEAD && new_stat != DEAD)
		START_PROCESSING(SSmood, src)
	else if (old_stat != DEAD && new_stat == DEAD)
		STOP_PROCESSING(SSmood, src)

/// Handles mood given by nutrition
/datum/mood/proc/update_nutrition_moodlets()
	if(HAS_TRAIT(mob_parent, TRAIT_NOHUNGER))
		clear_mood_event(MOOD_CATEGORY_NUTRITION)
		return FALSE

	if(HAS_TRAIT(mob_parent, TRAIT_FAT) && !HAS_TRAIT(mob_parent, TRAIT_VORACIOUS))
		add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/fat)
		return TRUE

	switch(mob_parent.nutrition)
		if(NUTRITION_LEVEL_FULL to INFINITY)
			add_mood_event(MOOD_CATEGORY_NUTRITION, HAS_TRAIT(mob_parent, TRAIT_VORACIOUS) ? /datum/mood_event/wellfed : /datum/mood_event/too_wellfed)
		if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/wellfed)
		if( NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/fed)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			clear_mood_event(MOOD_CATEGORY_NUTRITION)
		if(NUTRITION_LEVEL_VERY_HUNGRY to NUTRITION_LEVEL_HUNGRY)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/hungry)
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_VERY_HUNGRY)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/hungry_very)
		if(0 to NUTRITION_LEVEL_STARVING)
			add_mood_event(MOOD_CATEGORY_NUTRITION, /datum/mood_event/starving)

	return TRUE

/**
 * Adds a mood event to the mob
 *
 * Arguments:
 * * category - (text) category of the mood event - see /datum/mood_event for category explanation
 * * type - (path) any /datum/mood_event (besides /datum/mood_event/conditional)
 */
/datum/mood/proc/add_mood_event(category, new_type, ...)
	if (!ispath(new_type, /datum/mood_event))
		CRASH("A non path ([new_type]), was used to add a mood event. This shouldn't be happening.")
	if (ispath(new_type, /datum/mood_event/conditional))
		CRASH("A conditional mood event ([new_type]) was used in add_mood_event. Use add_conditional_mood_event instead.")
	if (!istext(category))
		category = REF(category)

	var/list/params = args.Copy(3)
	var/datum/mood_event/new_event = new new_type(category)
	if(!new_event.can_effect_mob(arglist(list(src, mob_parent) + params)))
		qdel(new_event)
		return

	add_mood_event_instance(new_event, params)

/**
 * Handles adding a mood event instance, including replacing or refreshing existing events
 */
/datum/mood/proc/add_mood_event_instance(datum/mood_event/new_event, list/params)
	PRIVATE_PROC(TRUE)
	var/category = new_event.category
	var/datum/mood_event/existing_event = mood_events[category]
	if(existing_event)
		var/continue_adding = FALSE
		if(existing_event.type == new_event.type)
			continue_adding = existing_event.be_refreshed(arglist(list(src) + params))
		else
			continue_adding = existing_event.be_replaced(arglist(list(src, new_event) + params))
		if(!continue_adding)
			update_mood()
			qdel(new_event)
			return
		clear_mood_event(category)

	new_event.on_add(src, mob_parent, params)
	mood_events[category] = new_event
	update_mood()
	show_mood_maptext(new_event)

	if(new_event.mood_change == 0 || new_event.hidden)
		return
	if(new_event.mood_change > 0)
		add_personality_mood_to_viewers(mob_parent, "other_good_moodlet", list(
			/datum/personality/empathetic = /datum/mood_event/empathetic_happy,
			/datum/personality/misanthropic = /datum/mood_event/misanthropic_sad
		), range = 4)
	else
		add_personality_mood_to_viewers(mob_parent, "other_bad_moodlet", list(
			/datum/personality/empathetic = /datum/mood_event/empathetic_sad,
			/datum/personality/misanthropic = /datum/mood_event/misanthropic_happy
		), range = 4)

/datum/mood/proc/show_mood_maptext(datum/mood_event/event)
	if(isnull(mob_parent.client) || mob_parent.stat >= UNCONSCIOUS || LAZYACCESS(mood_maptext_cooldowns, event.type) > world.time)
		return
	LAZYINITLISTLEN(active_mood_maptexts, mob_parent.client.prefs.read_preference(/datum/preference/numeric/mood_text_cap))
	var/first_open_index = 1
	while(LAZYACCESS(active_mood_maptexts, first_open_index))
		first_open_index += 1
	if(first_open_index > LAZYLEN(active_mood_maptexts))
		return
	var/atom/movable/screen/mood_maptext/new_maptext = new(null, null, event, first_open_index)
	new_maptext.alpha = 255 * mob_parent.client.prefs.read_preference(/datum/preference/numeric/mood_text_alpha)
	mob_parent.client.screen += new_maptext
	addtimer(CALLBACK(src, PROC_REF(fade_mood_maptext), new_maptext, first_open_index), new_maptext.running_time_length + 1 SECONDS, TIMER_DELETE_ME)
	LAZYSET(active_mood_maptexts, first_open_index, REF(new_maptext))
	LAZYSET(mood_maptext_cooldowns, event.type, world.time + event.screentext_cooldown)

/datum/mood/proc/fade_mood_maptext(atom/movable/screen/mood_maptext/maptext_to_fade, index)
	animate(maptext_to_fade, time = 1 SECONDS, alpha = 0)
	addtimer(CALLBACK(src, PROC_REF(clear_mood_maptext), maptext_to_fade, index), 2 SECONDS)

/datum/mood/proc/clear_mood_maptext(atom/movable/screen/mood_maptext/maptext_to_clear, index)
	LAZYSET(active_mood_maptexts, index, null)
	mob_parent.client?.screen -= maptext_to_clear
	qdel(maptext_to_clear)

/atom/movable/screen/mood_maptext
	maptext_width = 200
	maptext_height = 40
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = BELOW_OBJ_LAYER // render underneath storage
	VAR_FINAL/maptext_color
	VAR_FINAL/running_time_length = 0

/atom/movable/screen/mood_maptext/Initialize(mapload, datum/hud/hud_owner, datum/mood_event/base, offset = 0)
	. = ..()
	if(isnull(base))
		return INITIALIZE_HINT_QDEL

	maptext_color = base.screentext_color
	if(isnull(maptext_color) && base.mood_change != 0)
		switch(base.mood_change)
			if(-INFINITY to MOOD_SAD2)
				maptext_color = COLOR_DARK_RED
			if(MOOD_SAD2 to MOOD_SAD1)
				maptext_color = COLOR_RED
			if(MOOD_SAD1 to MOOD_NEUTRAL)
				maptext_color = COLOR_GRAY
			if(MOOD_NEUTRAL to MOOD_HAPPY1)
				maptext_color = COLOR_WHITE
			if(MOOD_HAPPY1 to MOOD_HAPPY2)
				maptext_color = COLOR_LIME
			if(MOOD_HAPPY2 to INFINITY)
				maptext_color = COLOR_DARK_LIME

	var/shown_text = base.description
	var/list/shown_words = splittext(shown_text, " ")
	if(length(shown_words) == 1)
		maptext = "<center>[MAPTEXT(shown_text)]</center>"
	else
		var/list/words = list(shown_words[1])
		maptext = construct_maptext(words)
		for(var/i in 2 to length(shown_words))
			var/new_time_length = max(1, floor(length_char(shown_words[i - 1]) * 0.75))
			words += shown_words[i]
			animate(src, time = new_time_length, maptext = construct_maptext(words), flags = ANIMATION_CONTINUE)
			running_time_length += new_time_length

	screen_loc = "CENTER-3:16,SOUTH+3:[offset * 20]"

/atom/movable/screen/mood_maptext/proc/construct_maptext(list/words)
	var/output = ""
	var/linebreaks = 0
	for(var/i in 1 to  length(words))
		var/word = words[i]
		if(i == length(words))
			output += "[word]"

		else if(linebreaks < 1 && findtext(word, GLOB.is_punctuation))
			output += "[word]<br>"
			linebreaks += 1
		else
			output += "[word] "

	return "<center>[MAPTEXT("<font color='[maptext_color]'>[output]</font>")]</center>"

/**
 * Adds a conditional mood event to the mob
 *
 * Arguments:
 * * category - (text) category of the mood event - see /datum/mood_event for category explanation
 * * base_type - (path) any /datum/mood_event/conditional
 */
/datum/mood/proc/add_conditional_mood_event(category, datum/base_type, ...)
	if (!ispath(base_type, /datum/mood_event/conditional))
		if (ispath(base_type, /datum/mood_event))
			CRASH("A non-conditional mood event ([base_type]) was used in add_conditional_mood_event. Use add_mood_event instead.")
		CRASH("A non path ([base_type]), was used to add a mood event. This shouldn't be happening.")
	if (!istext(category))
		category = REF(category)

	var/list/params = args.Copy(3)
	var/list/datum/mood_event/conditional/all_valid_conditional_events = list()
	for(var/event_subtype in typesof(base_type))
		var/datum/mood_event/potential_event = new event_subtype(category)
		if(!potential_event.can_effect_mob(arglist(list(src, mob_parent) + params)))
			qdel(potential_event)
			continue

		all_valid_conditional_events += potential_event

	if(!length(all_valid_conditional_events))
		return //no valid events to add

	var/datum/mood_event/conditional/highest_priority_event
	for(var/datum/mood_event/conditional/checked_event as anything in all_valid_conditional_events)
		if(!highest_priority_event || checked_event.priority > highest_priority_event.priority)
			highest_priority_event = checked_event

	add_mood_event_instance(highest_priority_event, params)
	all_valid_conditional_events -= highest_priority_event // you are the chosen one
	QDEL_LIST(all_valid_conditional_events) // clean up the losers

/**
 * Removes a mood event from the mob
 *
 * Arguments:
 * * category - (Text) Removes the mood event with the given category
 */
/datum/mood/proc/clear_mood_event(category)
	if (!istext(category))
		category = REF(category)

	var/datum/mood_event/event = mood_events[category]
	if (!event)
		return

	mood_events -= category
	qdel(event)
	update_mood()

/datum/mood/proc/get_mood_event(category)
	return mood_events[category]

/// Updates the mobs mood.
/// Called after mood events have been added/removed.
/datum/mood/proc/update_mood()
	if(QDELETED(mob_parent)) //don't bother updating their mood if they're about to be salty anyway. (in other words, we're about to be destroyed too anyway.)
		return
	mood = 0
	shown_mood = 0

	for(var/category in mood_events)
		var/datum/mood_event/the_event = mood_events[category]
		var/event_mood = the_event.mood_change
		event_mood *= max((event_mood > 0) ? positive_mood_modifier : negative_mood_modifier, 0)
		mood += event_mood
		if (!the_event.hidden)
			shown_mood += event_mood

	mood *= max(mood_modifier, 0)
	shown_mood *= max(mood_modifier, 0)

	switch(mood)
		if (-INFINITY to MOOD_SAD4)
			mood_level = MOOD_LEVEL_SAD4
		if (MOOD_SAD4 to MOOD_SAD3)
			mood_level = MOOD_LEVEL_SAD3
		if (MOOD_SAD3 to MOOD_SAD2)
			mood_level = MOOD_LEVEL_SAD2
		if (MOOD_SAD2 to MOOD_SAD1)
			mood_level = MOOD_LEVEL_SAD1
		if (MOOD_SAD1 to MOOD_HAPPY1)
			mood_level = MOOD_LEVEL_NEUTRAL
		if (MOOD_HAPPY1 to MOOD_HAPPY2)
			mood_level = MOOD_LEVEL_HAPPY1
		if (MOOD_HAPPY2 to MOOD_HAPPY3)
			mood_level = MOOD_LEVEL_HAPPY2
		if (MOOD_HAPPY3 to MOOD_HAPPY4)
			mood_level = MOOD_LEVEL_HAPPY3
		if (MOOD_HAPPY4 to INFINITY)
			mood_level = MOOD_LEVEL_HAPPY4

	update_mood_icon()
	SEND_SIGNAL(mob_parent, COMSIG_CARBON_MOOD_UPDATE)

/// Updates the mob's mood icon
/datum/mood/proc/update_mood_icon()
	if (!(mob_parent.client || mob_parent.hud_used) || isnull(mood_screen_object))
		return

	mood_screen_object.cut_overlays()
	mood_screen_object.color = initial(mood_screen_object.color)

	// lets see if we have an special icons to show instead of the normal mood levels
	var/list/conflicting_moodies = list()
	var/highest_absolute_mood = 0
	for (var/category in mood_events)
		var/datum/mood_event/the_event = mood_events[category]
		if (!the_event.special_screen_obj)
			continue
		if (!the_event.special_screen_replace)
			mood_screen_object.add_overlay(the_event.special_screen_obj)
		else
			conflicting_moodies += the_event
			var/absmood = abs(the_event.mood_change)
			highest_absolute_mood = absmood > highest_absolute_mood ? absmood : highest_absolute_mood

	switch(sanity_level)
		if (SANITY_LEVEL_GREAT)
			mood_screen_object.color = "#2eeb9a"
		if (SANITY_LEVEL_NEUTRAL)
			mood_screen_object.color = "#86d656"
		if (SANITY_LEVEL_DISTURBED)
			mood_screen_object.color = "#4b96c4"
		if (SANITY_LEVEL_UNSTABLE)
			mood_screen_object.color = "#dfa65b"
		if (SANITY_LEVEL_CRAZY)
			mood_screen_object.color = "#f38943"
		if (SANITY_LEVEL_INSANE)
			mood_screen_object.color = "#f15d36"

	if (!conflicting_moodies.len) // there's no special icons, use the normal icon states
		mood_screen_object.icon_state = "mood[mood_level]"
		return

	for (var/datum/mood_event/conflicting_event as anything in conflicting_moodies)
		if (abs(conflicting_event.mood_change) == highest_absolute_mood)
			mood_screen_object.icon_state = "[conflicting_event.special_screen_obj]"
			break

/// Sets up the mood HUD object
/datum/mood/proc/modify_hud(datum/source)
	SIGNAL_HANDLER

	var/datum/hud/hud = mob_parent.hud_used
	mood_screen_object = new
	mood_screen_object.color = "#4b96c4"
	hud.infodisplay += mood_screen_object
	RegisterSignal(hud, COMSIG_QDELETING, PROC_REF(unmodify_hud))
	RegisterSignal(mood_screen_object, COMSIG_SCREEN_ELEMENT_CLICK, PROC_REF(hud_click))

/// Removes the mood HUD object
/datum/mood/proc/unmodify_hud(datum/source)
	SIGNAL_HANDLER

	if(!mood_screen_object)
		return
	var/datum/hud/hud = mob_parent.hud_used
	if(hud?.infodisplay)
		hud.infodisplay -= mood_screen_object
	QDEL_NULL(mood_screen_object)
	UnregisterSignal(hud, COMSIG_QDELETING)

/// Handles clicking on the mood HUD object
/datum/mood/proc/hud_click(datum/source, location, control, params, mob/user)
	SIGNAL_HANDLER

	if(user != mob_parent)
		return
	if(user.stat >= UNCONSCIOUS)
		return
	print_mood(user)

/// Prints the users mood, sanity, and moodies to chat
/datum/mood/proc/print_mood(mob/user)
	var/msg = "[span_info("<EM>My current mental status:</EM>")]<br>"

	if(!HAS_TRAIT(src, TRAIT_NOHUNGER))
		msg += span_notice("My hunger: ")
		var/nutrition = mob_parent.nutrition
		switch(nutrition)
			if(NUTRITION_LEVEL_FULL to INFINITY)
				msg += "[span_info("I'm completely stuffed!")]<br>"
			if(NUTRITION_LEVEL_WELL_FED to NUTRITION_LEVEL_FULL)
				msg += "[span_info("I'm well fed!")]<br>"
			if(NUTRITION_LEVEL_FED to NUTRITION_LEVEL_WELL_FED)
				msg += "[span_info("I'm not hungry.")]<br>"
			if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
				msg += "[span_info("I could use a bite to eat.")]<br>"
			if(NUTRITION_LEVEL_VERY_HUNGRY to NUTRITION_LEVEL_HUNGRY)
				msg += "[span_warning("I'm feeling hungry.")]<br>"
			if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_VERY_HUNGRY)
				msg += "[span_warning("I feel quite hungry.")]<br>"
			if(0 to NUTRITION_LEVEL_STARVING)
				msg += "[span_boldwarning("I'm starving!")]<br>"

	var/drunkness = mob_parent.get_drunk_amount()
	if(drunkness >= 1)
		msg += span_notice("My current drunkenness: ")
		switch(drunkness)
			if(1 to 10)
				msg += "[span_info("I'm feeling a little tipsy.")]<br>"
			if(11 to 21)
				msg += "[span_info("I'm feeling a bit drunk.")]<br>"
			if(21 to 41)
				msg += "[span_info("I'm feeling quite drunk.")]<br>"
			if(41 to 61)
				msg += "[span_info("I'm feeling very drunk.")]<br>"
			if(61 to 81)
				msg += "[span_warning("I'm feeling like a mess.")]<br>"
			if(81 to INFINITY)
				msg += "[span_boldwarning("I'm completely wasted.")]<br>"

	msg += span_notice("My current sanity: ") //Long term
	switch(sanity)
		if(SANITY_GREAT to INFINITY)
			msg += "[span_boldnicegreen("My mind feels like a temple!")]<br>"
		if(SANITY_NEUTRAL to SANITY_GREAT)
			msg += "[span_nicegreen("I have been feeling great lately!")]<br>"
		if(SANITY_DISTURBED to SANITY_NEUTRAL)
			msg += "[span_nicegreen("I have felt quite decent lately.")]<br>"
		if(SANITY_UNSTABLE to SANITY_DISTURBED)
			msg += "[span_warning("I'm feeling a little bit unhinged...")]<br>"
		if(SANITY_CRAZY to SANITY_UNSTABLE)
			msg += "[span_warning("I'm freaking out!!")]<br>"
		if(SANITY_INSANE to SANITY_CRAZY)
			msg += "[span_boldwarning("AHAHAHAHAHAHAHAHAHAH!!")]<br>"

	msg += span_notice("My current mood: ") //Short term
	switch(mood_level)
		if(MOOD_LEVEL_SAD4)
			msg += "[span_boldwarning("I wish I was dead!")]<br>"
		if(MOOD_LEVEL_SAD3)
			msg += "[span_boldwarning("I feel terrible...")]<br>"
		if(MOOD_LEVEL_SAD2)
			msg += "[span_boldwarning("I feel very upset.")]<br>"
		if(MOOD_LEVEL_SAD1)
			msg += "[span_warning("I'm a bit sad.")]<br>"
		if(MOOD_LEVEL_NEUTRAL)
			msg += "[span_grey("I'm alright.")]<br>"
		if(MOOD_LEVEL_HAPPY1)
			msg += "[span_nicegreen("I feel pretty okay.")]<br>"
		if(MOOD_LEVEL_HAPPY2)
			msg += "[span_boldnicegreen("I feel pretty good.")]<br>"
		if(MOOD_LEVEL_HAPPY3)
			msg += "[span_boldnicegreen("I feel amazing!")]<br>"
		if(MOOD_LEVEL_HAPPY4)
			msg += "[span_boldnicegreen("I love life!")]<br>"

	var/list/additional_lines = list()
	SEND_SIGNAL(user, COMSIG_CARBON_MOOD_CHECK, additional_lines)
	if (length(additional_lines))
		msg += "[additional_lines.Join("<br>")]<br>"

	msg += "[span_notice("Moodlets:")]<br>"//All moodlets
	if(mood_events.len)
		for(var/category in mood_events)
			var/datum/mood_event/event = mood_events[category]
			msg += "&bull; "
			switch(event.mood_change)
				if(-INFINITY to MOOD_SAD2)
					msg += "[span_boldwarning(event.description)]<br>"
				if(MOOD_SAD2 to MOOD_SAD1)
					msg += "[span_warning(event.description)]<br>"
				if(MOOD_SAD1 to MOOD_NEUTRAL)
					msg += "[span_grey(event.description)]<br>"
				if(MOOD_NEUTRAL to MOOD_HAPPY1)
					msg += "[span_info(event.description)]<br>"
				if(MOOD_HAPPY1 to MOOD_HAPPY2)
					msg += "[span_nicegreen(event.description)]<br>"
				if(MOOD_HAPPY2 to INFINITY)
					msg += "[span_boldnicegreen(event.description)]<br>"
	else
		msg += "&bull; [span_grey("I don't have much of a reaction to anything right now.")]<br>"

	if(LAZYLEN(mob_parent.quirks))
		msg += span_notice("You have these quirks: [mob_parent.get_quirk_string(FALSE, CAT_QUIRK_ALL)].")

	to_chat(user, examine_block(msg))

/// Updates the mob's moodies, if the area provides a mood bonus
/datum/mood/proc/check_area_mood(datum/source, area/new_area)
	SIGNAL_HANDLER

	RegisterSignal(new_area, COMSIG_AREA_BEAUTY_UPDATED, PROC_REF(update_beauty))

	update_beauty(new_area)
	if (new_area.mood_bonus && (!new_area.mood_trait || HAS_TRAIT(source, new_area.mood_trait)))
		add_mood_event("area", /datum/mood_event/area, new_area.mood_bonus, new_area.mood_message)
	else
		clear_mood_event("area")

/// Updates the mob's given beauty moodie, based on the area
/datum/mood/proc/update_beauty(area/area_to_beautify)
	SIGNAL_HANDLER
	if (area_to_beautify.outdoors) // if we're outside, we don't care
		clear_mood_event(MOOD_CATEGORY_AREA_BEAUTY)
		return

	if(HAS_MIND_TRAIT(mob_parent, TRAIT_MORBID))
		if(HAS_TRAIT(mob_parent, TRAIT_SNOB))
			switch(area_to_beautify.beauty)
				if(BEAUTY_LEVEL_DECENT to BEAUTY_LEVEL_GOOD)
					add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/ehroom)
					return
				if(BEAUTY_LEVEL_GOOD to BEAUTY_LEVEL_GREAT)
					add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/badroom)
					return
				if(BEAUTY_LEVEL_GREAT to INFINITY)
					add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/horridroom)
					return
		switch(area_to_beautify.beauty)
			if(-INFINITY to BEAUTY_LEVEL_HORRID)
				add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/greatroom)
			if(BEAUTY_LEVEL_HORRID to BEAUTY_LEVEL_BAD)
				add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/goodroom)
			if(BEAUTY_LEVEL_BAD to BEAUTY_LEVEL_DECENT)
				clear_mood_event(MOOD_CATEGORY_AREA_BEAUTY)
		return

	if(HAS_TRAIT(mob_parent, TRAIT_SNOB))
		switch(area_to_beautify.beauty)
			if(-INFINITY to BEAUTY_LEVEL_HORRID)
				add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/horridroom)
				return
			if(BEAUTY_LEVEL_HORRID to BEAUTY_LEVEL_BAD)
				add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/badroom)
				return
	switch(area_to_beautify.beauty)
		if(BEAUTY_LEVEL_BAD to BEAUTY_LEVEL_DECENT)
			clear_mood_event(MOOD_CATEGORY_AREA_BEAUTY)
		if(BEAUTY_LEVEL_DECENT to BEAUTY_LEVEL_GOOD)
			add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/decentroom)
		if(BEAUTY_LEVEL_GOOD to BEAUTY_LEVEL_GREAT)
			add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/goodroom)
		if(BEAUTY_LEVEL_GREAT to INFINITY)
			add_mood_event(MOOD_CATEGORY_AREA_BEAUTY, /datum/mood_event/greatroom)

/datum/mood/proc/exit_area(datum/source, area/old_area)
	SIGNAL_HANDLER
	UnregisterSignal(old_area, COMSIG_AREA_BEAUTY_UPDATED)

/// Called when parent is ahealed.
/datum/mood/proc/on_aheal(datum/source, heal_flags)
	SIGNAL_HANDLER

	if (!(heal_flags & HEAL_ADMIN))
		return
	remove_temp_moods()
	set_sanity(initial(sanity), override = TRUE)

/// Sets sanity to the specified amount and applies effects.
/datum/mood/proc/set_sanity(amount, minimum = SANITY_INSANE, maximum = SANITY_MAXIMUM, override = FALSE)
	if(!override)
		if(HAS_TRAIT(mob_parent, TRAIT_UNSTABLE))
			maximum = sanity
			minimum = min(minimum, maximum)

	amount = clamp(round(amount, 0.01), minimum, maximum)

	if(amount == sanity) //Prevents stuff from flicking around.
		return

	sanity = amount
	SEND_SIGNAL(mob_parent, COMSIG_CARBON_SANITY_UPDATE, amount)
	switch(sanity)
		if(SANITY_INSANE to SANITY_CRAZY)
			set_insanity_effect(MAJOR_INSANITY_PEN)
			mob_parent.add_movespeed_modifier(/datum/movespeed_modifier/sanity/insane)
			mob_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/low_sanity)
			sanity_level = SANITY_LEVEL_INSANE
		if(SANITY_CRAZY to SANITY_UNSTABLE)
			set_insanity_effect(MINOR_INSANITY_PEN)
			mob_parent.add_movespeed_modifier(/datum/movespeed_modifier/sanity/crazy)
			mob_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/low_sanity)
			sanity_level = SANITY_LEVEL_CRAZY
		if(SANITY_UNSTABLE to SANITY_DISTURBED)
			set_insanity_effect(0)
			mob_parent.add_movespeed_modifier(/datum/movespeed_modifier/sanity/disturbed)
			mob_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/low_sanity)
			sanity_level = SANITY_LEVEL_UNSTABLE
		if(SANITY_DISTURBED to SANITY_NEUTRAL)
			set_insanity_effect(0)
			mob_parent.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
			mob_parent.remove_actionspeed_modifier(ACTIONSPEED_ID_SANITY)
			sanity_level = SANITY_LEVEL_DISTURBED
		if(SANITY_NEUTRAL+1 to SANITY_GREAT+1) //shitty hack but +1 to prevent it from responding to super small differences
			set_insanity_effect(0)
			mob_parent.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
			mob_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/high_sanity)
			sanity_level = SANITY_LEVEL_NEUTRAL
		if(SANITY_GREAT+1 to INFINITY)
			set_insanity_effect(0)
			mob_parent.remove_movespeed_modifier(MOVESPEED_ID_SANITY)
			mob_parent.add_actionspeed_modifier(/datum/actionspeed_modifier/high_sanity)
			sanity_level = SANITY_LEVEL_GREAT

	// Crazy or insane = add some uncommon hallucinations
	if(sanity_level >= SANITY_LEVEL_CRAZY)
		mob_parent.apply_status_effect(/datum/status_effect/hallucination/sanity)
	else
		mob_parent.remove_status_effect(/datum/status_effect/hallucination/sanity)

	update_mood_icon()
	update_sanity_screen()

/// Sets sanity to a specific amount, useful for callbacks
/datum/mood/proc/reset_sanity(amount)
	set_sanity(amount, override = TRUE)

/// Adjusts sanity by a value
/datum/mood/proc/adjust_sanity(amount, minimum = SANITY_INSANE, maximum = SANITY_GREAT, override = FALSE)
	set_sanity(sanity + amount, minimum, maximum, override)

/datum/client_colour/sanity
	fade_in = 2 SECONDS
	fade_out = 2 SECONDS
	var/desaturation = 1.0

/datum/client_colour/sanity/New(mob/owner)
	. = ..()
	src.colour = color_matrix_saturation(desaturation)

/datum/client_colour/sanity/tier4
	desaturation = 0.6

/datum/client_colour/sanity/tier3
	desaturation = 0.7

/datum/client_colour/sanity/tier2
	desaturation = 0.8

/datum/client_colour/sanity/tier1
	desaturation = 0.9

/atom/movable/screen/fullscreen/sanity
	show_when_dead = FALSE
	icon_state = "passage"
	layer = UI_DAMAGE_LAYER - 0.1
	plane = FULLSCREEN_PLANE
	color = "#270227"

/atom/movable/screen/fullscreen/static_vision/sanity
	show_when_dead = FALSE
	color = "#e0e0e0"
	alpha = 25

/datum/mood/proc/update_sanity_screen()
	var/obj/old_screen = mob_parent.screens["sanity"]
	var/old_state = old_screen?.icon_state
	var/obj/new_screen

	var/esanity = sanity
	// since you're stuck with your sanity while unstable, the effect is lessened
	if(HAS_TRAIT(mob_parent, TRAIT_UNSTABLE))
		if(esanity <= 20)
			esanity = 30
		else if(esanity <= 40)
			esanity = 40

	switch(esanity)
		if (0 to 10)
			new_screen = mob_parent.overlay_fullscreen("sanity", /atom/movable/screen/fullscreen/sanity, 4)
			mob_parent.add_client_colour(/datum/client_colour/sanity/tier4, "sanity")
		if (10 to 20)
			new_screen = mob_parent.overlay_fullscreen("sanity", /atom/movable/screen/fullscreen/sanity, 3)
			mob_parent.add_client_colour(/datum/client_colour/sanity/tier3, "sanity")
		if (20 to 30)
			new_screen = mob_parent.overlay_fullscreen("sanity", /atom/movable/screen/fullscreen/sanity, 2)
			mob_parent.add_client_colour(/datum/client_colour/sanity/tier2, "sanity")
		if (30 to 40)
			new_screen = mob_parent.overlay_fullscreen("sanity", /atom/movable/screen/fullscreen/sanity, 1)
			mob_parent.add_client_colour(/datum/client_colour/sanity/tier1, "sanity")
		else
			mob_parent.clear_fullscreen("sanity")
			mob_parent.clear_fullscreen("sanity_static")
			mob_parent.remove_client_colour("sanity")

	if(new_screen && old_state != new_screen.icon_state)
		// updating static effect for new sanity level
		var/had_effect = !!mob_parent.screens["sanity_static"]
		mob_parent.clear_fullscreen("sanity_static", animated = FALSE)
		var/obj/staticystuff = mob_parent.overlay_fullscreen("sanity_static", /atom/movable/screen/fullscreen/static_vision/sanity)
		var/new_alpha = staticystuff.alpha - (esanity * 0.5)
		if(had_effect)
			animate(staticystuff, time = 2.5 MINUTES, alpha = 0, loop = -1)
			animate(time = 2.5 MINUTES, alpha = new_alpha, loop = -1)
		else
			staticystuff.alpha = 0
			animate(staticystuff, time = 0.5 MINUTES, alpha = new_alpha)
			animate(time = 2.5 MINUTES, alpha = 0, loop = -1)
			animate(time = 2.5 MINUTES, alpha = new_alpha, loop = -1)

		// resetting filter stuff
		new_screen.add_filter("sanity_filter", 1, outline_filter(1, "#270227"))
		new_screen.add_filter("sanity_blur", 2, drop_shadow_filter(1, 1, 10, 0, "#270227"))
		var/blur = new_screen.get_filter("sanity_blur")
		// makes a pulsing effect - screen gets darker but the radius gets smaller
		animate(blur, time = 10 SECONDS, size = 100, loop = -1)
		animate(time = 10 SECONDS, size = 10, loop = -1)

/// Sets the insanity effect on the mob
/datum/mood/proc/set_insanity_effect(newval)
	if (newval == insanity_effect)
		return
	mob_parent.add_max_consciousness_value("sanity", UPPER_CONSCIOUSNESS_MAX - newval)
	insanity_effect = newval

/// Removes all temporary moods
/datum/mood/proc/remove_temp_moods()
	for (var/category in mood_events)
		var/datum/mood_event/moodlet = mood_events[category]
		if (!moodlet || !moodlet.timeout)
			continue
		mood_events -= moodlet.category
		qdel(moodlet)
	update_mood()

/// Helper to forcefully drain sanity
/datum/mood/proc/direct_sanity_drain(amount)
	adjust_sanity(amount, override = TRUE)

/**
 * Returns true if you already have a mood from a provided category.
 *
 * Arguments
 * * category - Mood category to validate against.
 */
/datum/mood/proc/has_mood_of_category(category)
	for(var/i in mood_events)
		var/datum/mood_event/moodlet = mood_events[i]
		if (moodlet.category == category)
			return TRUE
	return FALSE

#undef MINOR_INSANITY_PEN
#undef MAJOR_INSANITY_PEN
#undef MOOD_CATEGORY_NUTRITION
#undef MOOD_CATEGORY_AREA_BEAUTY
