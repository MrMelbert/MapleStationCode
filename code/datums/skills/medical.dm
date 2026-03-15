/datum/skill/first_aid
	name = "First Aid"
	title = "Medic"
	blurb = "A stitch in time saves nine."
	earned_by = "healing members of the crew with sutures or bandages"
	grants_you = "an improved proficiency medical tools such as sutures or bandages"
	higher_levels_grant_you = "the ability do CPR without harming the patient"
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.15,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 0.9,
			SKILL_LEVEL_EXPERT = 0.9,
			SKILL_LEVEL_MASTER = 0.8,
			SKILL_LEVEL_LEGENDARY = 0.75,
		),
	)
	skill_flags = SKILL_ALWAYS_PRINT

/datum/skill/first_aid/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_APPRENTICE] = span_nicegreen("I'm getting a little better at [name] - now I can perform proper CPR!")
	level_down_messages[SKILL_LEVEL_APPRENTICE] = span_nicegreen("I'm getting a little worse at [name] - I don't think I can perform proper CPR anymore...")

/datum/skill/first_aid/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_APPRENTICE)
		ADD_TRAIT(mind, TRAIT_CPR_CERTIFIED, type)

/datum/skill/first_aid/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_APPRENTICE && new_level < SKILL_LEVEL_APPRENTICE)
		REMOVE_TRAIT(mind, TRAIT_CPR_CERTIFIED, type)
