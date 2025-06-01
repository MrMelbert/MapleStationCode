/datum/skill/fitness
	name = "Athletics"
	title = "Fitness"
	blurb = "Twinkle twinkle little star, hit the gym and lift the bar."
	earned_by = "exercising on the machines in the station's recreation area"
	grants_you = "greater ease of grabbing, grappling, and carrying others"
	higher_levels_grant_you = "the ability to exercise for longer periods of time"
	// The skill value modifier effects the max duration that is possible for /datum/status_effect/exercised
	modifiers = list(
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = 1 MINUTES,
			SKILL_LEVEL_NOVICE = 1.5 MINUTES,
			SKILL_LEVEL_APPRENTICE = 2 MINUTES,
			SKILL_LEVEL_JOURNEYMAN = 2.5 MINUTES,
			SKILL_LEVEL_EXPERT = 3 MINUTES,
			SKILL_LEVEL_MASTER = 3.5 MINUTES,
			SKILL_LEVEL_LEGENDARY = 5 MINUTES,
		),
	)
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/fitness/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_MASTER] = span_nicegreen("After lots of exercise, I've begun to truly understand the surprising depth behind [name].")
	level_up_messages[SKILL_LEVEL_LEGENDARY] = span_nicegreen("Through incredible determination and effort, I've reached the peak of my Athletic abilities.")
