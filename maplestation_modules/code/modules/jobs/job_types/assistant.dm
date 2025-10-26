// -- Assistant Changes --
/datum/job/assistant
	departments_bitflags = DEPARTMENT_BITFLAG_ASSISTANT

/datum/job/assistant/after_spawn(mob/living/spawned, client/player_client)
	. = ..()
	var/list/skill_pool = list(
		/datum/skill/athletics,
		/datum/skill/bartending,
		/datum/skill/chemistry,
		/datum/skill/cleaning,
		/datum/skill/cooking,
		/datum/skill/electronics,
		/datum/skill/firearms,
		/datum/skill/first_aid,
		/datum/skill/mechanics,
		/datum/skill/surgery,
	)
	for(var/i in 1 to rand(3, floor(length(skill_pool) * 0.5))) // give a few random skills to work with
		spawned.mind.adjust_experience(pick_n_take(skill_pool), round(rand(100, 750), 50), TRUE)

// This is done for loadouts, otherwise unique uniforms would be deleted.
/datum/outfit/job/assistant
	uniform = null

/datum/outfit/job/assistant/give_jumpsuit(mob/living/carbon/human/target)
	if(!isnull(uniform))
		return

	return ..()

// This is done because gimmick assistants override the jumpsuit anyways
/datum/outfit/job/assistant/gimmick
	uniform = /obj/item/clothing/under/color/grey
