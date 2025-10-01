/datum/skill/surgery
	name = "Surgery"
	title = "Surgeon"
	blurb = "Your capability to split someone's brain in two with a pen."
	earned_by = "completing surgeries, though apprentices and above will only gain experience from operating on crewmembers. \
		Autopsies will also give training regardless of skill level (with a bonus for non-human, non-monkey species)"
	grants_you = "an improved proficiency with surgical tools"
	higher_levels_grant_you = "the ability to perform more complex surgeries with worse (or improvised) tools and greater knowledge of entrails"
	modifiers = list(
		// modifier to surgery speed
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.15,
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
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/surgery/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_EXPERT)
		ADD_TRAIT(mind, TRAIT_ENTRAILS_READER, type)

/datum/skill/surgery/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_EXPERT && new_level < SKILL_LEVEL_EXPERT)
		REMOVE_TRAIT(mind, TRAIT_ENTRAILS_READER, type)
