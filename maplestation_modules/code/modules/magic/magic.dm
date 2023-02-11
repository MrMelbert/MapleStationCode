/datum/mana_holder
	var/datum/mana_pool/mana

/datum/mana_holder/New()
	. = ..()

	initialize_mana()

/datum/mana_holder/Destroy(force, ...)
	. = ..()

	QDEL_NULL(mana)

/datum/mana_holder/proc/adjust_mana(amount, list/incoming_attunements = GLOB.default_attunements)
	return mana.adjust_mana(amount ,incoming_attunements)

/datum/mana_holder/proc/get_attunements()
	return mana.attunements

/datum/mana_holder/proc/get_stored_mana()
	return mana

/datum/mana_holder/proc/initialize_mana()
	mana = new /datum/mana_pool(generate_initial_capacity(), get_initial_mana_amount(), get_initial_attunements())
	return mana

/datum/mana_holder/proc/get_initial_attunements()
	return GLOB.default_attunements.Copy()

/datum/mana_holder/proc/get_initial_mana_amount()
	return generate_initial_capacity()

/datum/mana_holder/proc/generate_initial_capacity()
	return 0
