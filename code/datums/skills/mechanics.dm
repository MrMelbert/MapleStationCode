/datum/skill/mechanics
	name = "Mechanics"
	title = "Mechanical Engineer"
	blurb = "I solve problems. Not problems like 'What is beauty?'... I solve practical problems."
	// earned_by = "repairing and building machines"
	grants_you = "faster mechanical tool usage"
	skill_flags = SKILL_ALWAYS_PRINT
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.2,
			SKILL_LEVEL_NOVICE = 1.1,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 1,
			SKILL_LEVEL_EXPERT = 0.9,
			SKILL_LEVEL_MASTER = 0.8,
			SKILL_LEVEL_LEGENDARY = 0.75,
		),
	)
