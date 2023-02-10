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

/datum/mana_pool/New(amount = 0, attunements = GLOB.default_attunements.Copy())
	. = ..()

	src.amount = amount
	src.attunements = attunements

/datum/mana_pool/Destroy(force, ...)
	. = ..()

	attunements = null

#define MANA_POOL_REPLACE_ALL_ATTUNEMENTS "Fuck"
// TODO BIG FUCKING WARNING THIS EQUATION DOSENT WORK AT ALL
// Should be fine as long as nothing actually has any attunements
// Returns how much of "amount" is left.
/datum/mana_pool/proc/adjust_mana(amount, list/incoming_attunements = GLOB.default_attunements, maximum = INFINITY)

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

	var/result = clamp((src.amount + amount), 0, maximum)
	. = amount - (result - src.amount)
	src.amount = result

/// Returns an adjusted amount of "effective" mana, affected by the attunements.
/datum/mana_pool/proc/get_adjusted_amount(list/datum/attunement/incoming_attunements)
	var/mult = get_attunement_mults(incoming_attunements)

	return amount*mult

/datum/mana_pool/proc/get_attunement_mult(attunement, intensity, offset = 1)
	var/raw_value = ((offset+((attunements[attunement]) * (intensity)))) // since attunements start at 0, we offset by 1
	if (raw_value == 0) return 0
	return 1/raw_value // invert the value from 5 to 0.2 and such: higher attunement matches = less spell cost

/datum/mana_pool/proc/get_attunement_mults(list/attunements)
	var/mult = 1

	for (var/iterated_attunement as anything in attunements)
		mult += get_attunement_mult(iterated_attunement, attunements[iterated_attunement], 0)

	return mult

/datum/mana_pool/proc/get_subtracted_value(amount)
	return amount -= min(src.amount, amount) // never any less than 0
