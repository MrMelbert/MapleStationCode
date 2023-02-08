/// An abstract representation of collections of mana, as it's impossible to represent each individual mana unit
/datum/mana_group
    var/amount = 0

    // Future content
    //var/list/attunements = list()
    //var/list/alignments = list()

/datum/mana_group/Destroy(force, ...)
    . = ..()

/// Delete target, merge it into ourself
/datum/mana_group/proc/merge(/datum/mana_group/merge_target)
    adjust_quantity(merge_target.amount)

    // Send a signal here
    qdel(merge_target)

/datum/mana_group/proc/adjust_quantity(amount)
    src.amount = max((src.amount += amount), 0)

