GLOBAL_LIST_INIT(skill_types, subtypesof(/datum/skill))

/datum/skill
	/// String, required, the name of the skill
	var/name
	/// String, required, the title of the skill, e.g. "Surgeon" or "Miner"
	var/title
	/// String, required, Some flavor blurb relating to the skill
	var/blurb
	/// String, optional, how a user can be expected to earn this skill
	var/earned_by
	/// String, optional, what this skill generally does to improve the user's abilities
	var/grants_you
	/// String, optional, what this skill does to improve the user's abilities at higher levels
	var/higher_levels_grant_you
	/// Dictionary of modifier type - list of modifiers (indexed by level).
	var/list/modifiers = list(
		SKILL_SPEED_MODIFIER = list(
			SKILL_LEVEL_NONE = 1,
			SKILL_LEVEL_NOVICE = 1,
			SKILL_LEVEL_APPRENTICE = 1,
			SKILL_LEVEL_JOURNEYMAN = 1,
			SKILL_LEVEL_EXPERT = 1,
			SKILL_LEVEL_MASTER = 1,
			SKILL_LEVEL_LEGENDARY = 1,
		),
	)
	/// Flags relating to this skill
	var/skill_flags = NONE
	/// Typepath of skill item reward that will appear when a user finishes leveling up a skill
	var/skill_item_path
	/// List associating different messages that appear on level up with different levels
	var/list/level_up_messages
	/// List associating different messages that appear on level up with different levels
	var/list/level_down_messages

/// Getter for some modifier at a certain level
/datum/skill/proc/get_skill_modifier(modifier, level)
	return modifiers[modifier][level] //Levels range from 1 (None) to 7 (Legendary)

/datum/skill/New()
	. = ..()
	level_up_messages = list(
		SKILL_LEVEL_NONE = "", // Everyone starts at NONE, you can't go up to it
		SKILL_LEVEL_NOVICE = span_nicegreen("I'm starting to figure out what [name] really is!"),
		SKILL_LEVEL_APPRENTICE = span_nicegreen("I'm getting a little better at [name]!"),
		SKILL_LEVEL_JOURNEYMAN = span_nicegreen("I'm getting much better at [name]!"),
		SKILL_LEVEL_EXPERT = span_nicegreen("I feel like I've become quite proficient at [name]!"),
		SKILL_LEVEL_MASTER = span_nicegreen("After lots of practice, I've begun to truly understand the intricacies and surprising depth behind [name]. I now consider myself a master [title]."),
		SKILL_LEVEL_LEGENDARY = span_nicegreen("Through incredible determination and effort, I've reached the peak of my [name] abiltities. I'm finally able to consider myself a legendary [title]!"),
	)
	level_down_messages = list(
		SKILL_LEVEL_NONE =  span_nicegreen("I have somehow completely lost all understanding of [name]."),
		SKILL_LEVEL_NOVICE = span_nicegreen("I'm starting to forget what [name] really even is. I need more practice..."),
		SKILL_LEVEL_APPRENTICE = span_nicegreen("I'm getting a little worse at [name]. I'll need to keep practicing to get better at it..."),
		SKILL_LEVEL_JOURNEYMAN = span_nicegreen("I'm getting a little worse at [name]..."),
		SKILL_LEVEL_EXPERT = span_nicegreen("I'm losing my [name] expertise ...."),
		SKILL_LEVEL_MASTER = span_nicegreen("I feel like I'm losing my mastery of [name]."),
		SKILL_LEVEL_LEGENDARY = span_nicegreen("I feel as though my legendary [name] skills have deteriorated. I'll need more intense training to recover my lost skills."),
	)

/**
 * level_gained: Gives skill levelup messages to the user
 *
 * Only fires if the xp gain isn't silent, so only really useful for messages.
 * Arguments:
 * * mind - The mind that you'll want to send messages
 * * new_level - The newly gained level. Can check the actual level to give different messages at different levels, see defines in skills.dm
 * * old_level - Similar to the above, but the level you had before levelling up.
 * * silent - Silences the announcement if TRUE
 */
/datum/skill/proc/level_gained(datum/mind/mind, new_level, old_level, silent)
	if(new_level == SKILL_LEVEL_NONE)
		CRASH("Someone tried to level up to NONE skill level, wtf")
	if(silent || new_level == old_level)
		return
	to_chat(mind.current, level_up_messages[new_level]) //new_level will be a value from 1 to 6, so we get appropriate message from the 6-element level_up_messages list
/**
 * level_lost: See level_gained, same idea but fires on skill level-down
 */
/datum/skill/proc/level_lost(datum/mind/mind, new_level, old_level, silent)
	if(silent || new_level == old_level)
		return
	to_chat(mind.current, level_down_messages[old_level]) //old_level will be a value from 1 to 6, so we get appropriate message from the 6-element level_up_messages list

/**
 * try_skill_reward: Checks to see if a user is eligable for a tangible reward for reaching a certain skill level
 *
 * Currently gives the user a special cloak when they reach a legendary level at any given skill
 * Arguments:
 * * mind - The mind that you'll want to send messages and rewards to
 * * new_level - The current level of the user. Used to check if it meets the requirements for a reward
 */
/datum/skill/proc/try_skill_reward(datum/mind/mind, new_level)
	if (new_level != SKILL_LEVEL_LEGENDARY)
		return
	if (!ispath(skill_item_path))
		return
	if (LAZYFIND(mind.skills_rewarded, type))
		to_chat(mind.current, span_nicegreen("It seems the Professional [title] Association won't send me another status symbol."))
		return
	podspawn(list(
		"target" = get_turf(mind.current),
		"style" = STYLE_BLUESPACE,
		"spawn" = skill_item_path,
		"delays" = list(POD_TRANSIT = 150, POD_FALLING = 4, POD_OPENING = 30, POD_LEAVING = 30)
	))
	to_chat(mind.current, span_nicegreen("My legendary skill has attracted the attention of the Professional [title] Association. \
		It seems they are sending me a status symbol to commemorate my abilities."))
	LAZYADD(mind.skills_rewarded, type)
