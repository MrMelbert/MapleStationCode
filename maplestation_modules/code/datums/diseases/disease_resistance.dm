// -- Disease resistance --
/mob/living/carbon/CanContractDisease(datum/disease/D)
	if(HAS_TRAIT(src, TRAIT_VIRUS_CONTACT_IMMUNE))
		return FALSE
	return ..()
