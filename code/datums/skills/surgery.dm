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
			SKILL_LEVEL_NONE = 0.85,
			SKILL_LEVEL_NOVICE = 0.9,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 1.1,
			SKILL_LEVEL_EXPERT = 1.1,
			SKILL_LEVEL_MASTER = 1.25,
			SKILL_LEVEL_LEGENDARY = 1.4,
		),
		// flat modifier to tool quality used in surgery
		// ie a 0.1 modifier makes a 1.0 quality tool, 1.1 quality
		// which in turn translates to a 10% speed decrease
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = 0.1,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 0,
			SKILL_LEVEL_EXPERT = -0.1,
			SKILL_LEVEL_MASTER = -0.1,
			SKILL_LEVEL_LEGENDARY = -0.25,
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
