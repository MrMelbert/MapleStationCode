/datum/proc/get_available_mana(var/list/datum/attunement/attunements = GLOB.default_attunements)
    return SSmagic.get_all_leyline_mana_amount(attunements)

/* DESIGN NOTES
 * This exists because mana will eventually have attunemenents and alignments that will incresae their efficiency in being used
 * on spells/by people with corresponding attunements/alignments, vice versa for conflicting.
 * 
*/

/// An abstract representation of collections of mana, as it's impossible to represent each individual mana unit
/datum/mana_group
    var/amount = 0

    var/list/attunements
    var/datum/weakref/our_mana_pool

/datum/mana_group/New(amount, attunements = create_default_attunement_list())
    . = ..()

    src.amount = amount
    src.attunements = attunements

/datum/mana_group/Destroy(force, ...)
	. = ..()

    var/datum/mana_pool = our_mana_pool.resolve()
    if (mana_pool)
        mana_pool.mana_groups -= src
    our_mana_pool = null

    attunements = null

/datum/mana_group/proc/changed_pools(/datum/mana_pool/new_pool)
    var/datum/mana_pool = our_mana_pool.resolve()
    if (mana_pool)
        mana_pool.mana_groups -= src
    if (new_pool)
        new_pool.mana_groups += src
    our_mana_pool = WEAKREF(new_pool)

/// A collection of mana groups
/datum/mana_pool
    var/list/mana_group/mana_groups

/datum/mana_pool/New(var/list/mana_group/mana_groups = list())
	. = ..()

    src.mana_group = mana_groups

/datum/mana_pool/Destroy(force, ...)
    . = ..()

/datum/mana_pool/proc/get_average_attunements()
    . = create_default_attunement_list()
    if (mana_groups.len == 0) return
    for (var/datum/mana_group/mana as anything in mana_groups)
        for (attunement as anything in mana.attunements)
            .[attunement] += mana.attunements[attunement]
    for (attunement as anything in .)
        .[attunement] = attunement/(mana_groups.len)

/// Returns an adjusted amount of "effective" mana, affected by the attunements.
/datum/mana_pool/proc/get_amount(list/datum/attunement/incoming_attunements)
    var/mult = 1
    var/list/attunements = get_average_attunements()

    for (attunement as anything in incoming_attunements, attunements)
        mult += get_attunement_mult(attunement, incoming_attunements[attunement])

    return amount*mult

/datum/mana_pool/proc/get_attunement_mult(attunement, intensity, attunements = get_average_attunements())
    var/raw_value = (1 + ((attunements[attunement]) * (intensity))) // +1 to normalize the fact that attunements start at 0
    if (raw_value == 0) return 0
    return 1/raw_value // invert the value from 5 to 0.2 and such: higher attunement matches = less spell cost

/datum/mana_pool/proc/adjust_mana(amount)
    

