/datum/skill/electronics
	name = "Electronics"
	title = "Electrical Engineer"
	blurb = "Hack the planet! Or, y'know, do your job."
	grants_you = "reduced chance of being shocked when hacking or messing with cables"
	higher_levels_grant_you = "innate knowledge of airlock and APC wiring"
	modifiers = list(
		SKILL_PROBS_MODIFIER = list(
			SKILL_LEVEL_NONE = 0,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 10,
			SKILL_LEVEL_JOURNEYMAN = 20,
			SKILL_LEVEL_EXPERT = 30,
			SKILL_LEVEL_MASTER = 40,
			SKILL_LEVEL_LEGENDARY = 50,
		),
	)
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/electronics/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_EXPERT)
		ADD_TRAIT(mind, TRAIT_KNOW_ENGI_WIRES, type)

/datum/skill/electronics/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_EXPERT && new_level < SKILL_LEVEL_EXPERT)
		REMOVE_TRAIT(mind, TRAIT_KNOW_ENGI_WIRES, type)
