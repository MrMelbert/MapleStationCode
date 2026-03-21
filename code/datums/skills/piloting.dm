/datum/skill/piloting
	name = "Piloting"
	title = "Pilot"
	blurb = "Call the navigator, set course, and go!"
	grants_you = "improved control over mechas and vehicles"
	modifiers = list(
		// reduces change of internal damage when taking damage in a mecha
		SKILL_PROBS_MODIFIER = list(
			SKILL_LEVEL_NONE = -5,
			SKILL_LEVEL_NOVICE = -2.5,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 2,
			SKILL_LEVEL_EXPERT = 4,
			SKILL_LEVEL_MASTER = 5,
			SKILL_LEVEL_LEGENDARY = 10,
		),
		// affects turn speed. (not normal speed because that's kinda scary)
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 0.3,
			SKILL_LEVEL_NOVICE = 0.2,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = -0.1,
			SKILL_LEVEL_EXPERT = -0.2,
			SKILL_LEVEL_MASTER = -0.3,
			SKILL_LEVEL_LEGENDARY = -0.5,
		)
	)
