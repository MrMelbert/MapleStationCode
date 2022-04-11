// -- Disease resistance --
/mob/living/carbon/CanContractDisease(datum/disease/D)
	if(HAS_TRAIT(src, TRAIT_DISEASE_RESISTANT))
		return FALSE
	return ..()
