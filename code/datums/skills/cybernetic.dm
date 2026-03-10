/datum/skill/cybernetics
	name = "Cybernetics"
	title = "Cyberneticist"
	blurb = "From the moment I realized the weakness of flesh, it disgusted me. I craved a better way to be."
	earned_by = "installing and repairing cybernetics"
	grants_you = "faster and safer cybernetic repair and installation"
	higher_levels_grant_you = "innate knowledge of cyborg, modsuit, and mecha wiring"
	modifiers = list(
		// amount of pain to reduce when installing cybernetic implants (negative = more instead)
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = -10,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 10,
			SKILL_LEVEL_EXPERT = 20,
			SKILL_LEVEL_MASTER = 30,
			SKILL_LEVEL_LEGENDARY = 50,
		),
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
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/cybernetics/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_EXPERT] = span_nicegreen("I feel like I've become quite proficient at [name] - I've now memorized cyborg wiring diagrams!")
	level_down_messages[SKILL_LEVEL_EXPERT] = span_nicegreen("I'm losing my [name] expertise... - I can't even remember cyborg wiring diagrams anymore!")

/datum/skill/cybernetics/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_EXPERT)
		ADD_TRAIT(mind, TRAIT_KNOW_ROBO_WIRES, type)

/datum/skill/cybernetics/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_EXPERT && new_level < SKILL_LEVEL_EXPERT)
		REMOVE_TRAIT(mind, TRAIT_KNOW_ROBO_WIRES, type)
