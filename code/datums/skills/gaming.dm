/datum/skill/gaming
	name = "Gaming"
	title = "Gamer"
	blurb = "I'm a gamer, I have lots of lives."
	earned_by = "winning arcade games (earning achievements also helps)"
	grants_you = "greater skill in arcade games"
	higher_levels_grant_you = "a taste for gamer fuel"
	modifiers = list(
		SKILL_PROBS_MODIFIER = list(
			SKILL_LEVEL_NONE = 0,
			SKILL_LEVEL_NOVICE = 5,
			SKILL_LEVEL_APPRENTICE = 10,
			SKILL_LEVEL_JOURNEYMAN = 15,
			SKILL_LEVEL_EXPERT = 15,
			SKILL_LEVEL_MASTER = 20,
			SKILL_LEVEL_LEGENDARY = 25,
		),
		SKILL_RANDS_MODIFIER = list(
			SKILL_LEVEL_NONE = 0,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 2,
			SKILL_LEVEL_JOURNEYMAN = 3,
			SKILL_LEVEL_EXPERT = 4,
			SKILL_LEVEL_MASTER = 5,
			SKILL_LEVEL_LEGENDARY = 7,
		),
	)
	skill_item_path = /obj/item/clothing/neck/cloak/skill_reward/gaming

/datum/skill/gaming/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_NOVICE] = span_nicegreen("I'm starting to get a hang of the controls of these games...")
	level_up_messages[SKILL_LEVEL_JOURNEYMAN] = span_nicegreen("I'm starting to pick up the meta of these arcade games. If I were to minmax the optimal strat and accentuate my playstyle around well-refined tech...")
	level_up_messages[SKILL_LEVEL_MASTER] = span_nicegreen("Through incredible determination and effort, I've reached the peak of my [name] abilities. I wonder how I can become any more powerful... Maybe gamer fuel would actually help me play better..?")
