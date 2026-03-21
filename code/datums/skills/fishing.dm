/**
 * skill associated with the fishing feature. It modifies the fishing minigame difficulty
 * and is gained each time one is completed.
 */
/datum/skill/fishing
	name = "Fishing"
	title = "Angler"
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
	level_up_messages[SKILL_LEVEL_NOVICE] = span_nicegreen("I'm starting to figure out what [name] really is! I can guess a fish size and weight at a glance.")
	level_up_messages[SKILL_LEVEL_APPRENTICE] = span_nicegreen("I'm getting a little better at [name]! I can tell if a fish is hungry, dying and otherwise.")
	level_up_messages[SKILL_LEVEL_JOURNEYMAN] = span_nicegreen("I feel like I've become quite proficient at [name]! I can tell what fishes I can catch at any given fishing spot.")
	level_up_messages[SKILL_LEVEL_MASTER] = span_nicegreen("I've begun to truly understand the surprising depth behind [name]. As a master [title], I can guess what I'm going to catch now!")

/datum/skill/fishing/level_gained(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(new_level >= SKILL_LEVEL_NOVICE && old_level < SKILL_LEVEL_NOVICE)
		ADD_TRAIT(mind, TRAIT_EXAMINE_FISH, SKILL_TRAIT)
	if(new_level >= SKILL_LEVEL_APPRENTICE && old_level < SKILL_LEVEL_APPRENTICE)
		ADD_TRAIT(mind, TRAIT_EXAMINE_DEEPER_FISH, SKILL_TRAIT)
	if(new_level >= SKILL_LEVEL_JOURNEYMAN && old_level < SKILL_LEVEL_JOURNEYMAN)
		ADD_TRAIT(mind, TRAIT_EXAMINE_FISHING_SPOT, SKILL_TRAIT)
	if(new_level >= SKILL_LEVEL_MASTER && old_level < SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)

/datum/skill/fishing/level_lost(datum/mind/mind, new_level, old_level, silent)
	. = ..()
	if(old_level >= SKILL_LEVEL_MASTER && new_level < SKILL_LEVEL_MASTER)
		REMOVE_TRAIT(mind, TRAIT_REVEAL_FISH, SKILL_TRAIT)
	if(old_level >= SKILL_LEVEL_JOURNEYMAN && new_level < SKILL_LEVEL_JOURNEYMAN)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_FISHING_SPOT, SKILL_TRAIT)
	if(old_level >= SKILL_LEVEL_APPRENTICE && new_level < SKILL_LEVEL_APPRENTICE)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_DEEPER_FISH, SKILL_TRAIT)
	if(old_level >= SKILL_LEVEL_NOVICE && new_level < SKILL_LEVEL_NOVICE)
		REMOVE_TRAIT(mind, TRAIT_EXAMINE_FISH, SKILL_TRAIT)
