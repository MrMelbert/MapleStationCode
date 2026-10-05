/datum/quirk/skill
	abstract_parent_type = /datum/quirk/skill
	quirk_flags = QUIRK_HIDE_FROM_SCAN
	var/list/skills

/datum/quirk/skill/add()
	if(isnull(quirk_holder.mind))
		RegisterSignal(quirk_holder, COMSIG_MOB_MIND_INITIALIZED, PROC_REF(add_skill))
	else
		add_skill()

/datum/quirk/skill/remove()
	UnregisterSignal(quirk_holder, COMSIG_MOB_MIND_INITIALIZED)
	for(var/skill, level in skills)
		quirk_holder.adjust_skill_experience(skill, -SKILL_EXP_LIST[level], silent = TRUE)

/datum/quirk/skill/proc/add_skill(...)
	SIGNAL_HANDLER

	for(var/skill, level in skills)
		quirk_holder.adjust_skill_experience(skill, SKILL_EXP_LIST[level], silent = TRUE)
	UnregisterSignal(quirk_holder, COMSIG_MOB_MIND_INITIALIZED)

/datum/quirk/skill/first_aid_certified
	name = "First Aid Certified"
	desc = "You are certified to perform basic first aid, allowing for safer CPR and slightly faster wound treatments."
	medical_record_text = "Patient has completed First Aid certification."
	skills = list(
		/datum/skill/first_aid = SKILL_LEVEL_APPRENTICE,
	)
	icon = FA_ICON_FIRST_AID
	value = 2

/datum/quirk/skill/electronics
	name = "Hobbyist Electrician"
	desc = "You have some innate experience with electronics, either from natural aptitude or from a hobby."
	skills = list(
		/datum/skill/electronics = SKILL_LEVEL_JOURNEYMAN,
	)
	icon = FA_ICON_SCREWDRIVER
	value = 1

/datum/quirk/skill/mechanics
	name = "Hobbyist Mechanic"
	desc = "You have some innate experience with mechanics, either from natural aptitude or from a hobby."
	skills = list(
		/datum/skill/mechanics = SKILL_LEVEL_JOURNEYMAN,
	)
	icon = FA_ICON_WRENCH
	value = 1

/datum/quirk/skill/cooking
	name = "Home Cook"
	desc = "You have some innate experience with cooking, either from natural aptitude or from a hobby."
	skills = list(
		/datum/skill/cooking = SKILL_LEVEL_JOURNEYMAN,
	)
	icon = FA_ICON_KITCHEN_SET
	value = 1

/datum/quirk/skill/hydroponics
	name = "Green Thumb"
	desc = "You have some innate experience with plants, either from natural aptitude or from a hobby."
	skills = list(
		/datum/skill/botany = SKILL_LEVEL_JOURNEYMAN,
	)
	icon = FA_ICON_LEAF
	value = 1

/datum/quirk/skill/firearms
	name = "Gun Enthusiast"
	desc = "You have past experience using ballistic or energy weapons, either from natural aptitude or from a hobby."
	skills = list(
		/datum/skill/firearms = SKILL_LEVEL_JOURNEYMAN,
	)
	icon = FA_ICON_PERSON_RIFLE
	value = 2

/datum/quirk/skill/athletics
	name = "Fit"
	desc = "Whether you have trained yourself diligently or are just naturally well built, you have some innate athletic ability."
	skills = list(
		/datum/skill/athletics = SKILL_LEVEL_APPRENTICE,
	)
	icon = FA_ICON_DUMBBELL
	value = 4
