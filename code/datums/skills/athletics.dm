/datum/skill/athletics
	name = "Athletics"
	title = "Athlete"
	blurb = "Twinkle twinkle little star, hit the gym and lift the bar."
	earned_by = "exercising on the machines in the station's recreation area"
	grants_you = "greater ease of grabbing, grappling, and carrying others"
	higher_levels_grant_you = "the ability to exercise for longer periods of time"
	// The skill value modifier effects the max duration that is possible for /datum/status_effect/exercised; The rands modifier determines block probability and crit probability while boxing against boxers
	modifiers = list(
		SKILL_VALUE_MODIFIER = list(
			1 MINUTES,
			1.5 MINUTES,
			2 MINUTES,
			2.5 MINUTES,
			3 MINUTES,
			3.5 MINUTES,
			5 MINUTES
		),
		SKILL_RANDS_MODIFIER = list(
			0,
			5,
			10,
			15,
			20,
			30,
			50
		)
	)
	skill_item_path = /obj/item/clothing/gloves/boxing/golden
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/athletics/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_MASTER] = span_nicegreen("After lots of exercise, I've begun to truly understand the surprising depth behind [name].")
	level_up_messages[SKILL_LEVEL_LEGENDARY] = span_nicegreen("Through incredible determination and effort, I've reached the peak of my Athletic abilities.")
