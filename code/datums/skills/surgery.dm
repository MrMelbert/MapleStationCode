/datum/skill/surgery
	name = "Surgery"
	title = "Surgeon"
	blurb = "Your capability to split someone's brain in two with a pen."
	earned_by = "completing surgeries on members of the crew, or autopsies on any cadavers"
	grants_you = "an improved proficiency with surgical tools"
	higher_levels_grant_you = "the ability to perform more complex surgeries with worse (or improvised) tools"
	modifiers = list(
		// modifier to surgery speed
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.1,
			SKILL_LEVEL_NOVICE = 1.1,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 0.9,
			SKILL_LEVEL_EXPERT = 0.9,
			SKILL_LEVEL_MASTER = 0.8,
			SKILL_LEVEL_LEGENDARY = 0.75,
		),
		// flat modifier on tool effectiveness used in surgery
		// note that this also affects surgery speed (so +10 roughly corresponds to a 0.9x speed modifier),
		// but only surgeries that use items (which in practice, only excludes surgeries like "stomach pump")
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = -10,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 0,
			SKILL_LEVEL_EXPERT = 10,
			SKILL_LEVEL_MASTER = 10,
			SKILL_LEVEL_LEGENDARY = 25,
		),
	)
