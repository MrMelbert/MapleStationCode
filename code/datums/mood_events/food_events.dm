/datum/mood_event/favorite_food
	description = "I really enjoyed eating that."
	mood_change = 5
	timeout = 4 MINUTES

/datum/mood_event/gross_food
	description = "I really didn't like that food."
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/disgusting_food
	description = "That food was disgusting!"
	mood_change = -6
	timeout = 4 MINUTES

/datum/mood_event/allergic_food
	description = "My throat itches."
	mood_change = -2
	timeout = 4 MINUTES

/datum/mood_event/breakfast
	description = "Nothing like a hearty breakfast to start the shift."
	mood_change = 2
	timeout = 10 MINUTES

/datum/mood_event/food
	timeout = 5 MINUTES
	var/quality = FOOD_QUALITY_NORMAL

// NON-MODULE CHANGE
/datum/mood_event/food/add_effects(timeout_mod = 1)
	timeout *= timeout_mod
	mood_change = floor(quality * 1.34)
	if(HAS_MIND_TRAIT(owner, TRAIT_SNOB))
		if(quality <= FOOD_QUALITY_VERYGOOD)
			mood_change -= 1
			description = "That food was [GLOB.food_quality_description[quality]], but I expect better."
		else
			mood_change += 1
			description = "That food was [GLOB.food_quality_description[quality]]. Perfection!"
	else
		description = "That food was [GLOB.food_quality_description[quality]]."

/datum/mood_event/food/nice
	quality = FOOD_QUALITY_NICE

/datum/mood_event/food/good
	quality = FOOD_QUALITY_GOOD

/datum/mood_event/food/verygood
	quality = FOOD_QUALITY_VERYGOOD

/datum/mood_event/food/fantastic
	quality = FOOD_QUALITY_FANTASTIC

/datum/mood_event/food/amazing
	quality = FOOD_QUALITY_AMAZING

/datum/mood_event/food/top
	quality = FOOD_QUALITY_TOP

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
