// defines in _module_defines.dm

/// The global store of mana accessable to all. Simulates leylines. Version 1 -- OTher versions may have more advanced simulation, such as multiple leylines existing
/datum/leyline
	var/datum/leyline_intensity/intensity

	var/max_mana_capacity

	var/recharge_rate
	var/stored_mana

/datum/leyline/New()
	. = ..()

	intensity = generate_initial_intensity()

	max_mana_capacity = generate_initial_capacity()

	recharge_rate = generate_recharge_rate()
	stored_mana = max_mana_capacity

	SSmagic.start_processing_leyline(src)

/datum/leyline/Destroy(force, ...)
	. = ..()

	SSmagic.stop_processing_leyline(src)

	QDEL_NULL(intensity)

/datum/leyline/process(delta_time)
	adjust_stored_mana(recharge_rate * delta_time) //recharge

/// GETTERS / SETTERS

// TODO: CHANGE THIS LATER. I want this shit to be RANDOM. Im just bad at MATH.
/datum/leyline/proc/generate_initial_capacity()
	return LEYLINE_BASE_CAPACITY * intensity.overall_mult

/datum/leyline/proc/generate_recharge_rate()
	return LEYLINE_BASE_RECHARGE * intensity.overall_mult

/datum/leyline/proc/get_stored_mana()
	return stored_mana

/datum/leyline/proc/adjust_stored_mana(amount)
	stored_mana = clamp((stored_mana + amount), 0, max_mana_capacity)

/datum/leyline/proc/get_recharge_rate()
	return recharge_rate

/datum/leyline/proc/generate_initial_intensity()
	var/datum/leyline_intensity/picked_intensity = pick_weight(GLOB.leyline_intensities)
	return new picked_intensity
