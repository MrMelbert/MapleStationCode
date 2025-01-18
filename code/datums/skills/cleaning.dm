/datum/skill/cleaning
	name = "Cleaning"
	title = "Cleaner"
	blurb = "It's not who I am underneath, but what I mop up that defines me."
	earned_by = "cleaning grime and blood"
	grants_you = "an improved proficiency with cleaning tools"
	modifiers = list(
		// speed also touches probability in using up a soap's charge
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1.1,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 0.9,
			SKILL_LEVEL_JOURNEYMAN = 0.8,
			SKILL_LEVEL_EXPERT = 0.7,
			SKILL_LEVEL_MASTER = 0.6,
			SKILL_LEVEL_LEGENDARY = 0.5,
		),
	)
	skill_item_path = /obj/item/clothing/neck/cloak/skill_reward/cleaning
	innate_skill = TRUE
