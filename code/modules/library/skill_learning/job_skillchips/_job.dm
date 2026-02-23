/// Job related skillchip category
#define SKILLCHIP_CATEGORY_JOB "job"

/obj/item/skillchip/job
	skillchip_flags = SKILLCHIP_RESTRICTED_CATEGORIES
	chip_category = SKILLCHIP_CATEGORY_JOB
	incompatibility_list = list(SKILLCHIP_CATEGORY_JOB)
	abstract_parent_type = /obj/item/skillchip/job
	slot_use = 2

#undef SKILLCHIP_CATEGORY_JOB

/obj/item/skillchip/job/skills
	skill_icon = FA_ICON_BRIEFCASE
	/// Asooc list skillchip typepath => amount of exp to give
	var/list/exp_to_give = list()

/obj/item/skillchip/job/skills/Initialize(mapload, is_removable, job_type)
	. = ..()
	if(isnull(job_type))
		return INITIALIZE_HINT_QDEL
	var/datum/job/job_datum = SSjob.GetJobType(job_type)
	if(!length(job_datum.base_skills))
		stack_trace("Skill job skillchip on a job with no skills, USELESS. (job type: [job_type])")
		return INITIALIZE_HINT_QDEL

	name = "[job_datum.title] Skillchip"
	desc = "A basic skillchip designed to give you the foundational skills needed to perform the duties of a [job_datum.title]."

	var/list/skill_names = list()
	for(var/datum/skill/skill as anything in job_datum.base_skills)
		if(initial(skill.skill_flags) & SKILL_PHYSICAL)
			continue
		exp_to_give[skill] = SKILL_EXP_LIST[job_datum.base_skills[skill]]
		skill_names += initial(skill.name)

	skill_name = "[job_datum.title] Basics"
	skill_description = "Grants you greater abilities in [english_list(skill_names)]."

	activate_message = span_notice("You feel like a real [job_datum.title]!")
	deactivate_message = span_notice("You no longer feel like a [job_datum.title].")

/obj/item/skillchip/job/skills/on_activate(mob/living/carbon/user, silent)
	. = ..()
	give_skills(user.mind)
	RegisterSignal(user, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF, PROC_REF(mind_lost))
	RegisterSignal(user, COMSIG_MOB_MIND_TRANSFERRED_INTO, PROC_REF(mind_gained))

/obj/item/skillchip/job/skills/on_deactivate(mob/living/carbon/user, silent)
	. = ..()
	remove_skills(user.mind)
	UnregisterSignal(user, COMSIG_MOB_MIND_TRANSFERRED_OUT_OF)
	UnregisterSignal(user, COMSIG_MOB_MIND_TRANSFERRED_INTO)

/obj/item/skillchip/job/skills/proc/give_skills(datum/mind/to_who)
	if(isnull(to_who))
		return
	for(var/skill in exp_to_give)
		to_who.set_experience(skill, max(to_who.get_skill_exp(skill), exp_to_give[skill]), TRUE)

/obj/item/skillchip/job/skills/proc/remove_skills(datum/mind/from_who)
	if(isnull(from_who))
		return
	for(var/skill in exp_to_give)
		from_who.adjust_experience(skill, -exp_to_give[skill], TRUE)

/obj/item/skillchip/job/skills/proc/mind_lost(mob/living/old_mind, mob/living/new_mind)
	SIGNAL_HANDLER
	remove_skills(old_mind)
	give_skills(new_mind)

/obj/item/skillchip/job/skills/proc/mind_gained(mob/living/new_mind, mob/living/old_mind)
	SIGNAL_HANDLER
	remove_skills(old_mind)
	give_skills(new_mind)

// For admins
/obj/item/skillchip/job/skills/engineering

/obj/item/skillchip/job/skills/engineering/Initialize(mapload, is_removable, job_type)
	return ..(mapload, is_removable, /datum/job/station_engineer)
