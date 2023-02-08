/* DESIGN NOTES
 * This exists because mana will eventually have attunemenents and alignments that will incresae their efficiency in being used
 * on spells/by people with corresponding attunements/alignments, vice versa for conflicting.
 * 
*/

/// An abstract representation of collections of mana, as it's impossible to represent each individual mana unit
/datum/mana_group
    var/amount = 0

    // Future content
    var/list/attunements

/datum/mana_group/New(amount, attunements)
	. = ..()

    var/list/all_attunements = GLOB.magic_attunements.Copy()
    for (var/iterated_attunement as anything in all_attunements)
        if (isnull(attunements[iterated_attunement]))
            attunements[iterated_attunement] = 0 // make it an assoc list

    src.amount = amount
    src.attunements = attunements

/datum/mana_group/Destroy(force, ...)
    . = ..()

/// Delete target, merge it into ourself
/datum/mana_group/proc/merge(/datum/mana_group/merge_target)
    adjust_mana(merge_target.amount, merge_target.attunemenents)

    // Send a signal here
    qdel(merge_target)

// TODO BIG FUCKING WARNING THIS EQUATION DOSENT WORK AT ALL
/datum/mana_group/proc/adjust_mana(amount, list/incoming_attunements)

    if (src.amount == 0) 
        CRASH("src.amount was ZERO in [src]'s adjust_quanity") //why would this happen
    if (amount == 0) return
    var/ratio = amount/src.amount

    for (var/iterated_attunement as anything in incoming_attunements)
        // equation formed in desmos, dosent work
        attunements[iterated_attunement] += ((incoming_attunements[iterated_attunement]) - attunements[iterated_attunement]) * (ratio/2)

    src.amount = max((src.amount += amount), 0)
// At a 1:1 ratio of amounts, a the difference between src's fire attunement of 2 and incoming fire attunement of 4 would be 2
// However, due to the 1:1 ratio, the effective difference should become 1, so 2 becomes 1
// So, (2 += ((4/2)*((amount/src.amount)-0.5)))

/// Returns an adjusted amount of "effective" mana, affected by the attunements.
/datum/mana_group/proc/get_amount(list/datum/attunement/incoming_attunements)
    var/mult = 1

    for (attunement in incoming_attunements)
        if (isnull(attunements[attunement])) 
            continue
        mult += get_attunement_mult(attunement, incoming_attunements[attunement])

    return amount*mult

/datum/mana_group/proc/get_attunement_mult(attunement, intensity)
    if (isnull(attunements[attunement])) return 1
    var/raw_value = (1 + ((attunements[attunement]) * (intensity))) // +1 to normalize the fact that attunements start at 0
    if (raw_value == 0) return 0
    return 1/raw_value // invert the value from 5 to 0.2 and such: higher attunement matches = less spell cost

/datum/mana_group/proc/get_raw_amount()
    return amount
