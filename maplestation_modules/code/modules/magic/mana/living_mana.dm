/mob/living/carbon/generate_max_mana_capacity()
	return (CARBON_BASE_MANA_CAPACITY * get_max_mana_capacity_mult())

/mob/living/carbon/proc/get_max_mana_capacity_mult()
	return 1

/mob/living/carbon/generate_initial_mana_exp_coeff()
	return BASE_CARBON_MANA_EXPONENTIAL_DIVISOR

/mob/living/carbon/get_mana_softcap_percent()
	return BASE_CARBON_MANA_SOFTCAP_PERCENT
