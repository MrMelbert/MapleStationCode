/mob/living/carbon/alien/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	findQueen()
	return..()

/mob/living/carbon/alien/check_breath(datum/gas_mixture/breath, skip_breath = FALSE)
	if(status_flags & GODMODE)
		return

	if(!breath || skip_breath || (breath.total_moles() == 0))
		//Aliens breathe in vaccuum
		return 0

	if(health <= 0)
		adjustOxyLoss(2)

	var/plasma_used = 0
	var/plas_detect_threshold = 0.02
	var/breath_pressure = (breath.total_moles()*R_IDEAL_GAS_EQUATION*breath.temperature)/BREATH_VOLUME
	var/list/breath_gases = breath.gases

	breath.assert_gases(/datum/gas/plasma, /datum/gas/oxygen)

	//Partial pressure of the plasma in our breath
	var/Plasma_pp = (breath_gases[/datum/gas/plasma][MOLES]/breath.total_moles())*breath_pressure

	if(Plasma_pp > plas_detect_threshold) // Detect plasma in air
		adjustPlasma(breath_gases[/datum/gas/plasma][MOLES]*250)
		throw_alert(ALERT_XENO_PLASMA, /atom/movable/screen/alert/alien_plas)

		plasma_used = breath_gases[/datum/gas/plasma][MOLES]

	else
		clear_alert(ALERT_XENO_PLASMA)

	//Breathe in plasma and out oxygen
	breath_gases[/datum/gas/plasma][MOLES] -= plasma_used
	breath_gases[/datum/gas/oxygen][MOLES] += plasma_used

	breath.garbage_collect()

	//BREATH TEMPERATURE
	handle_breath_temperature(breath)
	return TRUE

/mob/living/carbon/alien/adult/Life(seconds_per_tick, times_fired)
	. = ..()
	handle_organs(seconds_per_tick, times_fired)
