/datum/mood_event/favorite_food
	description = "I really enjoyed eating that."
	mood_change = 5
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FOOD

/datum/mood_event/gross_food
	description = "I really didn't like that food."
	mood_change = -2
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FOOD

/datum/mood_event/disgusting_food
	description = "That food was disgusting!"
	mood_change = -6
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FOOD

/datum/mood_event/allergic_food
	description = "My throat itches."
	mood_change = -2
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FOOD

/datum/mood_event/breakfast
	description = "Nothing like a hearty breakfast to start the shift."
	mood_change = 2
	timeout = 10 MINUTES
	event_flags = MOOD_EVENT_FOOD

/datum/mood_event/food
	timeout = 5 MINUTES
	event_flags = MOOD_EVENT_FOOD

/datum/mood_event/food/add_effects(quality = FOOD_QUALITY_NORMAL, timeout_mod = 1)
	mood_change = calculate_mood_change(quality)
	timeout *= timeout_mod
	update_description(quality)

/datum/mood_event/food/be_refreshed(datum/mood/home, quality, timeout_mod)
	timeout = max(timeout, initial(timeout) * timeout_mod)
	mood_change = max(mood_change, calculate_mood_change(quality))
	update_description(quality)
	return ..()

/datum/mood_event/food/proc/calculate_mood_change(base_quality)
	var/effective_quality = base_quality
	if(HAS_PERSONALITY(owner, /datum/personality/gourmand))
		if(effective_quality <= FOOD_QUALITY_GOOD)
			effective_quality = FOOD_QUALITY_NORMAL
	if(HAS_PERSONALITY(owner, /datum/personality/snob))
		if(effective_quality <= FOOD_QUALITY_VERYGOOD)
			effective_quality = FOOD_QUALITY_NORMAL

	var/mood = 1 + 1.5 * effective_quality
	if(HAS_PERSONALITY(owner, /datum/personality/ascetic))
		mood *= 0.5
	return ceil(mood)

/datum/mood_event/food/proc/update_description(quality)
	if(HAS_PERSONALITY(owner, /datum/personality/snob))
		if(quality <= FOOD_QUALITY_VERYGOOD)
			description = "That food was [GLOB.food_quality_description[quality]], but I expect better."
		else
			description = "That food was [GLOB.food_quality_description[quality]]. Perfection!"
	else
		description = "That food was [GLOB.food_quality_description[quality]]."

// NON-MODULE CHANGE
/datum/mood_event/mid_food
	timeout = 5 MINUTES
	description = "That's some shockingly mediocre food."
	mood_change = 0

/datum/mood_event/mid_food/add_effects()
	if(HAS_MIND_TRAIT(owner, TRAIT_SNOB))
		mood_change = -2
		description = "That's some shockingly mediocre food - I expect better!"

// NON-MODULE CHANGE
/datum/mood_event/bad_food
	timeout = 5 MINUTES
	description = "That food wasn't very good, but at least it didn't make me sick."
	mood_change = -2

/datum/mood_event/bad_food/add_effects()
	if(HAS_MIND_TRAIT(owner, TRAIT_SNOB))
		mood_change = -4
		description = "That food wasn't very good. I expect better!"

/datum/mood_event/pacifist_eating_fish_item
	description = "I shouldn't be eating living creatures..."
	mood_change = -1 //The disgusting food moodlet already has a pretty big negative value, this is just for context.
	timeout = 4 MINUTES
	event_flags = MOOD_EVENT_FOOD
