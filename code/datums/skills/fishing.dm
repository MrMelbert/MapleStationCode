/**
 * skill associated with the fishing feature. It modifies the fishing minigame difficulty
 * and is gained each time one is completed.
 */
/datum/skill/fishing
	name = "Fishing"
	title = "Fisher"
	blurb = "How empty and alone you are on this barren Earth."
	earned_by = "attempting a fishing challenge"
	grants_you = "reduced difficulty in fishing challenges"
	modifiers = list(
		SKILL_VALUE_MODIFIER = list(
			SKILL_LEVEL_NONE = 1,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 0,
			SKILL_LEVEL_JOURNEYMAN = -1,
			SKILL_LEVEL_EXPERT = -2,
			SKILL_LEVEL_MASTER = -4,
			SKILL_LEVEL_LEGENDARY = -6,
		),
	)
	skill_item_path = /obj/item/clothing/head/soft/fishing_hat

/datum/skill/fishing/New()
	. = ..()
	level_up_messages[SKILL_LEVEL_MASTER] = span_nicegreen("After lots of practice, I've begun to truly understand the surprising depth behind [name]. As a master [title], I can take an easier guess of what I'm trying to catch now.")

/datum/skill/fishing/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_MASTER && old_level < SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)

/datum/skill/fishing/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_MASTER && new_level < SKILL_LEVEL_MASTER)
		REMOVE_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)
