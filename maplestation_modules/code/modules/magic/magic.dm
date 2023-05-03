/// A datum that simply holds a mana pool, nothing more. Mostly unneccessary for now-but may become needed once mana pools are refactored into
/// gas-mixture like lists of datums.
/datum/mana_holder
	var/datum/mana_pool/mana

/datum/mana_holder/New()
	. = ..()

	initialize_mana()

/datum/mana_holder/Destroy(force, ...)
	QDEL_NULL(mana)

	return ..()

/// Adjust the amount of the mana we hold + their attunements. Will become necessary once mana pools are refactored into gas-mixture like lists of datums.
/datum/mana_holder/proc/adjust_mana(amount, list/incoming_attunements = GLOB.default_attunements)
	return mana.adjust_mana(amount, incoming_attunements)

/// Return the average attunements across all mana within us.
/datum/mana_holder/proc/get_attunements()
	return mana.attunements

/// Getter for our mana.
/datum/mana_holder/proc/get_stored_mana()
	return mana

/// Should only be called during init. Instantiates our mana.
/datum/mana_holder/proc/initialize_mana()
	mana = new /datum/mana_pool(generate_initial_capacity(), get_initial_mana_amount(), get_initial_attunements())
	return mana

/// Generates our initial attunement list.
/datum/mana_holder/proc/get_initial_attunements()
	return GLOB.default_attunements.Copy()

/// Generates the mana amount our pool will start with.
/datum/mana_holder/proc/get_initial_mana_amount()
	return generate_initial_capacity()

/// Generates the maximum mana our pool can hold.
/datum/mana_holder/proc/generate_initial_capacity()
	return 0
