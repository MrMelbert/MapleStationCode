// defines in _module_defines.dm

/// The lines of latent energy that run under the universe. Available to all people in the game. Should be high capacity, but slow to recharge.
/datum/mana_pool/leyline
	var/datum/leyline_intensity/intensity


/datum/mana_pool/leyline/New()
	intensity = generate_initial_intensity()

	. = ..()

	recharge_rate = generate_recharge_rate()
	attunements_to_generate = generate_attunements()

	SSmagic.start_processing_leyline(src)

/datum/mana_pool/leyline/Destroy(force, ...)
	SSmagic.stop_processing_leyline(src)

	QDEL_NULL(intensity)

	return ..()

/datum/mana_pool/leyline/process(seconds_per_tick)
	. = ..()

/// GETTERS / SETTERS

// TODO: CHANGE THIS LATER. I want this shit to be RANDOM. Im just bad at MATH.
/datum/mana_pool/leyline/generate_initial_capacity()
	return LEYLINE_BASE_CAPACITY * intensity.overall_mult

/datum/mana_pool/leyline/proc/generate_recharge_rate()
	return LEYLINE_BASE_RECHARGE * intensity.overall_mult

/datum/mana_pool/leyline/proc/get_recharge_rate()
	return recharge_rate

/datum/mana_pool/leyline/proc/generate_initial_intensity()
	var/datum/leyline_intensity/picked_intensity = pick_weight(GLOB.leyline_intensities)
	return new picked_intensity

/datum/mana_pool/leyline/proc/generate_attunements()
	RETURN_TYPE(/list/attunement)

	return GLOB.default_attunements.Copy()
