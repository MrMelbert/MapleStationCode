// defines in _module_defines.dm

/// The global store of mana accessable to all. Simulates leylines. Version 1 -- OTher versions may have more advanced simulation, such as multiple leylines existing
/datum/mana_holder/leyline
	var/datum/leyline_intensity/intensity

	var/recharge_rate

/datum/mana_holder/leyline/New()
	intensity = generate_initial_intensity()
	
	. = ..()

	recharge_rate = generate_recharge_rate()

	SSmagic.start_processing_leyline(src)

/datum/mana_holder/leyline/Destroy(force, ...)
	. = ..()

	SSmagic.stop_processing_leyline(src)

	QDEL_NULL(intensity)

/datum/mana_holder/leyline/process(delta_time)
	adjust_stored_mana(recharge_rate * delta_time) //recharge

/// GETTERS / SETTERS

// TODO: CHANGE THIS LATER. I want this shit to be RANDOM. Im just bad at MATH.
/datum/mana_holder/leyline/generate_initial_capacity()
	return LEYLINE_BASE_CAPACITY * intensity.overall_mult

/datum/mana_holder/leyline/proc/generate_recharge_rate()
	return LEYLINE_BASE_RECHARGE * intensity.overall_mult

/datum/mana_holder/leyline/proc/get_recharge_rate()
	return recharge_rate

/datum/mana_holder/leyline/proc/generate_initial_intensity()
	var/datum/leyline_intensity/picked_intensity = pick_weight(GLOB.leyline_intensities)
	return new picked_intensity
