// -- Assistant Changes --
/datum/outfit/job/assistant/give_jumpsuit(mob/living/carbon/human/target)
	// This is done for loadouts, otherwise unique uniforms would be deleted
	if(!ispath(uniform, /obj/item/clothing/under/color/grey))
		return

	return ..()
