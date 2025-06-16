/datum/mind/proc/init_known_skills()
	for (var/type in GLOB.skill_types)
		known_skills[type] = list(SKILL_LVL = SKILL_LEVEL_NONE, SKILL_EXP = 0)

///Return the amount of EXP needed to go to the next level. Returns 0 if max level
/datum/mind/proc/exp_needed_to_level_up(skill)
	var/lvl = update_skill_level(skill)
	if (lvl >= length(SKILL_EXP_LIST)) //If we're already past the last exp threshold
		return 0
	return SKILL_EXP_LIST[lvl+1] - known_skills[skill][SKILL_EXP]

///
/**
 * Adjust experience of a specific skill
 *
 * * skill: The skill to adjust, typepath
 * * amt: The amount to adjust the skill by
 * * silent: If TRUE, don't send messages to the player
 * * force_old_level: If set to any skill level, we will act as if the skill was at that level before the adjustment, rather than their current level
 */
/datum/mind/proc/adjust_experience(skill, amt, silent = FALSE, force_old_level)
	var/datum/skill/S = GetSkillRef(skill)
	var/old_level = force_old_level || known_skills[skill][SKILL_LVL] //Get current level of the S skill
	experience_multiplier = initial(experience_multiplier)
	for(var/key in experience_multiplier_reasons)
		experience_multiplier += experience_multiplier_reasons[key]
	known_skills[skill][SKILL_EXP] = max(0, known_skills[skill][SKILL_EXP] + amt*experience_multiplier) //Update exp. Prevent going below 0
	known_skills[skill][SKILL_LVL] = update_skill_level(skill)//Check what the current skill level is based on that skill's exp
	if(known_skills[skill][SKILL_LVL] > old_level)
		S.level_gained(src, known_skills[skill][SKILL_LVL], old_level, silent)
	else if(known_skills[skill][SKILL_LVL] < old_level)
		S.level_lost(src, known_skills[skill][SKILL_LVL], old_level, silent)

///Set experience of a specific skill to a number
/datum/mind/proc/set_experience(skill, amt, silent = FALSE)
	var/old_level = known_skills[skill][SKILL_EXP]
	known_skills[skill][SKILL_EXP] = amt
	adjust_experience(skill, 0, silent, old_level) //Make a call to adjust_experience to handle updating level

///Set level of a specific skill
/datum/mind/proc/set_level(skill, newlevel, silent = FALSE)
	var/oldlevel = get_skill_level(skill)
	var/difference = SKILL_EXP_LIST[newlevel] - SKILL_EXP_LIST[oldlevel]
	adjust_experience(skill, difference, silent)

///Check what the current skill level is based on that skill's exp
/datum/mind/proc/update_skill_level(skill)
	var/i = 0
	for (var/exp in SKILL_EXP_LIST)
		i ++
		if (known_skills[skill][SKILL_EXP] >= SKILL_EXP_LIST[i])
			continue
		return i - 1 //Return level based on the last exp requirement that we were greater than
	return i //If we had greater EXP than even the last exp threshold, we return the last level

///Gets the skill's singleton and returns the result of its get_skill_modifier
/datum/mind/proc/get_skill_modifier(skill, modifier)
	var/datum/skill/S = GetSkillRef(skill)
	return S.get_skill_modifier(modifier, known_skills[skill][SKILL_LVL])

/// Gets the skill's singleton and returns the result of its get_skill_modifier
/// If the mind is null, assume as little experience as possible ([SKILL_LEVEL_NONE])
/mob/proc/get_skill_modifier(skill, modifier)
	if(isnull(mind))
		return SSskills.all_skills[skill].get_skill_modifier(modifier, SKILL_LEVEL_NONE)
	return mind.get_skill_modifier(skill, modifier)

/mob/living/carbon/human/dummy/get_skill_modifier(skill, modifier)
	return 1

///Gets the player's current level number from the relevant skill
/datum/mind/proc/get_skill_level(skill)
	return known_skills[skill][SKILL_LVL]

///Gets the player's current exp from the relevant skill
/datum/mind/proc/get_skill_exp(skill)
	return known_skills[skill][SKILL_EXP]

/// Gets the what name the player's current level of the skill corresponds to
/datum/mind/proc/get_skill_level_name(skill)
	return SSskills.level_names[get_skill_level(skill)]

/datum/mind/proc/print_levels(user)
	var/list/shown_skills = list()
	for(var/datum/skill/known_skill as anything in known_skills)
		if((initial(known_skill.skill_flags) & SKILL_ALWAYS_PRINT) || known_skills[known_skill][SKILL_LVL] > SKILL_LEVEL_NONE) //Do we actually have a level in this?
			shown_skills += known_skill
	if(!length(shown_skills))
		to_chat(user, span_notice("You don't seem to have any particularly outstanding skills."))
		return
	var/list/skill_strings = list()
	for(var/datum/skill/shown_skill as anything in shown_skills)
		skill_strings += "&bull; [initial(shown_skill.name)] - [get_skill_level_name(shown_skill)]"

	sortTim(skill_strings, GLOBAL_PROC_REF(cmp_text_asc))
	to_chat(user, examine_block("[span_info("<em>Your skills:</em>")]<br>[span_notice(jointext(skill_strings, "<br>"))]"))
