/datum/proc/get_available_mana(var/list/datum/attunement/attunements = GLOB.default_attunements)
	return SSmagic.get_all_leyline_mana()

/* DESIGN NOTES
* This exists because mana will eventually have attunemenents and alignments that will incresae their efficiency in being used
* on spells/by people with corresponding attunements/alignments, vice versa for conflicting.
*
*/

/// An abstract representation of collections of mana, as it's impossible to represent each individual mana unit
/datum/mana_pool
	var/amount = 0
	var/list/datum/attunement/attunements
	var/maximum_mana_capacity

/datum/mana_pool/New(maximum_mana_capacity = INFINITY, amount = maximum_mana_capacity, attunements = GLOB.default_attunements.Copy())
	. = ..()

	src.maximum_mana_capacity = maximum_mana_capacity
	src.amount = amount
	src.attunements = attunements

/datum/mana_pool/Destroy(force, ...)
	. = ..()

	attunements = null

#define MANA_POOL_REPLACE_ALL_ATTUNEMENTS "Fuck"
// TODO BIG FUCKING WARNING THIS EQUATION DOSENT WORK AT ALL
// Should be fine as long as nothing actually has any attunements
// Returns how much of "amount" was used.
/datum/mana_pool/proc/adjust_mana(amount, list/incoming_attunements = GLOB.default_attunements)

	/*if (src.amount == 0)
		CRASH("src.amount was ZERO in [src]'s adjust_quanity") //why would this happen
		*/
	if (amount == 0) return

	var/ratio
	if (src.amount == 0)
		ratio = MANA_POOL_REPLACE_ALL_ATTUNEMENTS
	else
		ratio = amount/src.amount

	/*for (var/iterated_attunement as anything in incoming_attunements)
	// equation formed in desmos, dosent work
		attunements[iterated_attunement] += (((incoming_attunements[iterated_attunement]) - attunements[iterated_attunement]) * (ratio/2)) */

	var/result = clamp(src.amount + amount, 0, maximum_mana_capacity)
	. = result - src.amount // Return the amount that was used
	//if (abs(.) > abs(amount))
		// Currently, due to floating point imprecision, leyline recharges always cause this to fire, but honestly its nothing horrible
		// Ill fix it later(?)
		//stack_trace("[.], amount used, has its absolute value more than [amount]'s during [src]'s adjust_mana")
	src.amount = result

#undef MANA_POOL_REPLACE_ALL_ATTUNEMENTS

/// Returns an adjusted amount of "effective" mana, affected by the attunements.
/// Will always return a minimum of zero and a maximum of the total amount of mana we can give.
/datum/mana_pool/proc/get_attuned_amount(list/datum/attunement/incoming_attunements, amount_to_adjust = src.amount)
	var/mult = get_attunement_mults(incoming_attunements)

	return clamp(amount_to_adjust*mult, 0, amount)

/datum/mana_pool/proc/get_attunement_mult(attunement, intensity)
	return GET_RAW_ATTUNEMENT_MULT(attunements, intensity, attunement)

/datum/mana_pool/proc/get_attunement_mults(list/attunements)
	return get_total_attunement_mult(src.attunements, attunements)

/datum/mana_pool/proc/get_subtracted_value(amount)
	return amount -= min(src.amount, amount) // never any less than 0
