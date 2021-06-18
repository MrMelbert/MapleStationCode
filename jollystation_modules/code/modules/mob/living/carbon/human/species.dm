/datum/species/handle_environment(mob/living/carbon/human/humi, datum/gas_mixture/environment, delta_time, times_fired) //Extends datum to handle curing
	. = ..()
	var/loc_temp = get_temperature(environment)
	var/temp_delta = loc_temp - bodytemperature

	var/datum/disease/temperature_disease/hypothermia/hypothermia_case = locate(/datum/disease/temperature_disease/hypothermia) in humi.diseases

	var/datum/disease/temperature_disease/hyperthermia/hyperthermia_case = locate(/datum/disease/temperature_disease/hyperthermia) in humi.diseases

	if(temp_delta < 0 && hypothermia_case)
		hypothermia_case.cure()
	if(temp_delta > 0 && hyperthermia_case)
		hyperthermia_case.cure()
