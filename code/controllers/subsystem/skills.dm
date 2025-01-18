/*!
This subsystem mostly exists to populate and manage the skill singletons.
*/

SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SKILLS
	///Dictionary of skill.type || skill ref
	var/list/all_skills = list()
	///List of level names with index corresponding to skill level
	var/list/level_names = list(
		SKILL_LEVEL_NONE = "Untrained",
		SKILL_LEVEL_NOVICE = "Novice",
		SKILL_LEVEL_APPRENTICE = "Apprentice",
		SKILL_LEVEL_JOURNEYMAN = "Journeyman",
		SKILL_LEVEL_EXPERT = "Expert",
		SKILL_LEVEL_MASTER = "Master",
		SKILL_LEVEL_LEGENDARY = "Legendary",
	)

/datum/controller/subsystem/skills/Initialize()
	InitializeSkills()
	return SS_INIT_SUCCESS

///Ran on initialize, populates the skills dictionary
/datum/controller/subsystem/skills/proc/InitializeSkills()
	for(var/type in GLOB.skill_types)
		var/datum/skill/ref = new type
		all_skills[type] = ref
