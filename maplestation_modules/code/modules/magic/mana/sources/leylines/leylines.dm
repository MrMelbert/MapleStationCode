GLOBAL_LIST_INIT_TYPED(all_leylines, /datum/mana_pool/leyline, generate_initial_leylines())

/proc/generate_initial_leylines()
	RETURN_TYPE(/list/datum/mana_pool/leyline)

	var/list/mana_pool/leyline/leylines = list()

	var/leylines_to_generate = get_initial_leyline_amount()
	while (leylines_to_generate-- > 0)
		leylines += generate_leyline()

/proc/generate_leyline()
	RETURN_TYPE(/list/datum/mana_pool/leyline)



// defines in _module_defines.dm

/// The lines of latent energy that run under the universe. Available to all people in the game. Should be high capacity, but slow to recharge.
/datum/mana_pool/leyline
	var/datum/leyline_intensity/intensity

	discharge_destinations = NONE

/datum/mana_pool/leyline/New(
					intensity = generate_initial_intensity(),
					maximum_mana_capacity = (LEYLINE_BASE_CAPACITY * intensity.overall_mult),
					softcap = maximum_mana_capacity,
					max_donation_rate = (LEYLINE_BASE_DONATION_RATE * intensity.overall_mult),
					exponential_decay_divisor = BASE_MANA_EXPONENTIAL_DIVISOR,
					ethereal_recharge_rate = (LEYLINE_BASE_RECHARGE * intensity.overall_mult),
					attunements = GLOB.default_attunements.Copy(),
					attunements_to_generate = null,
					transfer_default_softcap = TRUE,
					amount = maximum_mana_capacity,
)
	GLOB.all_leylines += src

	return ..()


/datum/mana_pool/leyline/Destroy(force, ...)
	QDEL_NULL(intensity)

	GLOB.all_leylines -= src

	return ..()

/datum/mana_pool/leyline/process(seconds_per_tick)
	. = ..()

/// GETTERS / SETTERS

// TODO: CHANGE THIS LATER. I want this shit to be RANDOM. Im just bad at MATH.
/datum/mana_pool/leyline/proc/intensity_capacity()
	return LEYLINE_BASE_CAPACITY * intensity.overall_mult

/datum/mana_pool/leyline/proc/intensity_donation()
	return LEYLINE_BASE_DONATION_RATE * intensity.overall_mult

/datum/mana_pool/leyline/proc/intensity_recharge_rate()
	return LEYLINE_BASE_RECHARGE * intensity.overall_mult

/datum/mana_pool/leyline/proc/generate_initial_intensity()
	var/datum/leyline_intensity/picked_intensity = pick_weight(GLOB.leyline_intensities)
	return new picked_intensity

/datum/proc/get_accessable_leylines()
	RETURN_TYPE(/list/datum/mana_pool/leyline)

	var/list/datum/mana_pool/leyline/accessable_leylines = list()

	for (var/datum/mana_pool/leyline/entry as anything in GLOB.all_leylines)
		if (entry.can_entity_access(src))
			accessable_leylines += entry

	return accessable_leylines

/datum/proc/can_access_leyline(datum/mana_pool/leyline/leyline_in_question)
	return TRUE

/datum/mana_pool/leyline/proc/can_entity_access(datum/entity)
	return entity.can_access_leyline(src)
