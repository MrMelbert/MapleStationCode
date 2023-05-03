// defines in _module_defines.dm

/// The lines of latent energy that run under the universe. Available to all people in the game. Should be high capacity, but slow to recharge.
/datum/mana_holder/leyline
	var/datum/leyline_intensity/intensity

	var/recharge_rate

/datum/mana_holder/leyline/New()
	intensity = generate_initial_intensity()

	. = ..()

	recharge_rate = generate_recharge_rate()

	SSmagic.start_processing_leyline(src)

/datum/mana_holder/leyline/Destroy(force, ...)
	SSmagic.stop_processing_leyline(src)

	QDEL_NULL(intensity)

	return ..()

/datum/mana_holder/leyline/process(delta_time)
	adjust_mana(recharge_rate * delta_time) //recharge

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
