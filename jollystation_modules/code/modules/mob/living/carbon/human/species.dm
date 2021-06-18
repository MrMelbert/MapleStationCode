/datum/species/handle_environment(mob/living/carbon/human/humi, datum/gas_mixture/environment, delta_time, times_fired) //Extends datum to handle curing
	. = ..()
	var/loc_temp = humi.get_temperature(environment)
	var/temp_delta = loc_temp - humi.bodytemperature

	var/datum/disease/hypothermia/hypothermia_case = locate(/datum/disease/hypothermia) in humi.diseases

	var/datum/disease/hyperthermia/hyperthermia_case = locate(/datum/disease/hyperthermia) in humi.diseases

	if(temp_delta < -30 && hypothermia_case)
		hypothermia_case.cure()
	if(temp_delta > 30 && hyperthermia_case)
		hyperthermia_case.cure()
