/datum/skill/mining
	name = "Mining"
	title = "Miner"
	blurb = "A dwarf's biggest skill, after drinking."
	earned_by = "mining rare minerals"
	grants_you = "an improved proficiency with mining tools"
	higher_levels_grant_you = "the ability to see the contents of nearby rocks when mining"
	modifiers = list(
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.1,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 0.9,
			SKILL_LEVEL_JOURNEYMAN = 0.85,
			SKILL_LEVEL_EXPERT = 0.75,
			SKILL_LEVEL_MASTER = 0.6,
			SKILL_LEVEL_LEGENDARY = 0.5,
		),
		SKILL_PROBS_MODIFIER = list(
			SKILL_LEVEL_NONE = 0,
			SKILL_LEVEL_NOVICE = 0,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = 20,
			SKILL_LEVEL_EXPERT = 30,
			SKILL_LEVEL_MASTER = 40,
			SKILL_LEVEL_LEGENDARY = 50,
		),
	)
	skill_item_path = /obj/item/clothing/neck/cloak/skill_reward/mining
	innate_skill = TRUE
