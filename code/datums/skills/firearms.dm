/datum/skill/firearms
	name = "Firearms"
	title = "Gunner"
	blurb = "Don't shoot yourself in the foot."
	earned_by = "training at the firing range (or shooting people)"
	grants_you = "reduced accuracy penalties when using firearms while wounded"
	modifiers = list(
		SKILL_RANDS_MODIFIER = list(
			SKILL_LEVEL_NONE = 5,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = -5,
			SKILL_LEVEL_JOURNEYMAN = -5,
			SKILL_LEVEL_EXPERT = -10,
			SKILL_LEVEL_MASTER = -10,
			SKILL_LEVEL_LEGENDARY = -20,
		),
	)
	innate_skill = TRUE
