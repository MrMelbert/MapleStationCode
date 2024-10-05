GLOBAL_LIST_EMPTY_TYPED(all_leylines, /datum/mana_pool/leyline)
// uses pickweight
/proc/generate_initial_leylines()
	RETURN_TYPE(/list/datum/mana_pool/leyline)

	var/list/datum/mana_pool/leyline/leylines = list()

	var/leylines_to_generate = get_initial_leyline_amount()
	while (leylines_to_generate-- > 0)
		leylines += generate_leyline()

	return leylines

/proc/get_initial_leyline_amount()
	var/list/leyline_amount_list = list(
	"1" = 5000,
	"2" = 500,
	"3" = 200,
	"4" = 10
	)
	var/leyline_amount = text2num(pick_weight(leyline_amount_list))
	return leyline_amount

/proc/generate_leyline()
	RETURN_TYPE(/datum/mana_pool/leyline)

	return new /datum/mana_pool/leyline()

/// The lines of latent energy that run under the universe. Available to all people in the game. Should be high capacity, but slow to recharge.
/datum/mana_pool/leyline
	var/datum/leyline_variable/leyline_intensity/intensity
	var/list/datum/leyline_variable/attunement_theme/themes

	maximum_mana_capacity = LEYLINE_BASE_CAPACITY

	ethereal_recharge_rate = LEYLINE_BASE_RECHARGE
	max_donation_rate_per_second = BASE_LEYLINE_DONATION_RATE

	transfer_method = MANA_DISPERSE_EVENLY

	discharge_destinations = NONE

/datum/mana_pool/leyline/New()
	GLOB.all_leylines += src

	intensity = generate_initial_intensity()
	themes = generate_initial_themes()

	for (var/datum/leyline_variable/attunement_theme/theme as anything in themes)
		theme.adjust_attunements(attunements_to_generate)

	maximum_mana_capacity *= (intensity.overall_mult)
	softcap = maximum_mana_capacity

	ethereal_recharge_rate *= (intensity.overall_mult)
	max_donation_rate_per_second *= (intensity.overall_mult)

	amount = maximum_mana_capacity

	return ..()

/datum/mana_pool/leyline/generate_initial_attunements()
	return attunements_to_generate.Copy()

/datum/mana_pool/leyline/proc/generate_initial_intensity()
	var/picked_intensity = pick_weight(GLOB.leyline_intensities)
	return new picked_intensity

/datum/mana_pool/leyline/proc/generate_initial_themes()
	var/list/datum/leyline_variable/attunement_theme/themes = get_random_attunement_themes()

	return themes

/datum/mana_pool/leyline/Destroy(force, ...)
	QDEL_NULL(intensity)
	QDEL_LIST(themes)

	GLOB.all_leylines -= src

	return ..()

/// GETTERS / SETTERS

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
