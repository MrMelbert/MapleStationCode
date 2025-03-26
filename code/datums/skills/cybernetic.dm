/datum/skill/cybernetics
	name = "Cybernetics"
	title = "Cyberneticist"
	blurb = "You can build and repair cybernetic implants."
	earned_by = "installing and repairing cybernetic implants"
	grants_you = "less pain when installing cybernetic implants on yourself and others"
	modifiers = list(
		// amount of pain to reduce when installing cybernetic implants
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = -10,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 10,
			SKILL_LEVEL_EXPERT = 20,
			SKILL_LEVEL_MASTER = 30,
			SKILL_LEVEL_LEGENDARY = 50,
		),
	)
	skill_flags = SKILL_ALWAYS_PRINT
