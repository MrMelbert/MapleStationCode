// -- Assistant Changes --
/datum/job/assistant
	departments_bitflags = DEPARTMENT_BITFLAG_ASSISTANT

/datum/job/assistant/get_radio_information()
	return null

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
