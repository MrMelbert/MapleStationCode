/datum/mood_event/blood_smell
	description = "The metallic scent of blood fills the air."
	mood_change = -2
	timeout = 30 SECONDS
	screentext_cooldown = 1 MINUTES

/datum/mood_event/blood_smell/add_effects(...)
	if(HAS_TRAIT(owner, TRAIT_MORBID) || isvampire(owner))
		mood_change = 0

/datum/mood_event/oil_smell
	description = "The pungent odor of oil fills the air."
	mood_change = -1
	timeout = 10 SECONDS
	screentext_cooldown = 1 MINUTES

/datum/mood_event/cigarette_smoke
	description = "The acrid smell of cigarette smoke lingers in the air."
	mood_change = -1
	timeout = 10 SECONDS
	screentext_cooldown = 1 MINUTES

/datum/mood_event/cigarette_smoke/add_effects(...)
	if(HAS_TRAIT(owner, TRAIT_SMOKER))
		mood_change = 0

/datum/mood_event/disgust/minor_bad_smell
	description = "There's an unpleasant smell in the air."
	mood_change = -1
	timeout = 1 MINUTES
	screentext_cooldown = 1 MINUTES

/datum/mood_event/disgust/bad_smell
	description = "I think something must have died in here."
	mood_change = -3
	timeout = 1 MINUTES
	screentext_cooldown = 1 MINUTES

/datum/mood_event/disgust/really_bad_smell
	description = "Something horribly decayed is in this room."
	mood_change = -6
	timeout = 1 MINUTES
	screentext_cooldown = 1 MINUTES

/datum/mood_event/disgust/nauseating_stench
	description = "The stench of rot is unbearable!"
	mood_change = -12
	timeout = 1 MINUTES
	screentext_cooldown = 1 MINUTES

/datum/mood_event/good_food_aroma
	description = "That smells delicious!"
	mood_change = 2
	timeout = 2 MINUTES
	screentext_cooldown = 1 MINUTES

/datum/mood_event/burnt_food_aroma
	description = "Did someone leave something burning?"
	mood_change = -1
	timeout = 2 MINUTES
	screentext_cooldown = 1 MINUTES
