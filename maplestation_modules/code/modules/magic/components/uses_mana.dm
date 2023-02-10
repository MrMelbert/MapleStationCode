/* Design notes:
* This component designates the parent object as something that "uses mana".
* As such, it should modify the object's behavior at some point to require, consume, or check mana.
* Example: A magic crowbar that requires 5 mana to use it with anything.
* A component created for this crowbar should register the various signals for checking things, such as COMSIG_TOOL_START_USE, or
* COMSIG_ITEM_ATTACK. These should be linked to a proc that checks if the user has enough available mana (not sure how to make this info available with the current setuo)
* and if not, return something that cancels the proc.
* However, if the mana IS sufficient, we should listen for the successful item act signal, and react by, say, subtracting 5 mana from the mana pool provided.
* Not all need to do this, though, some could simply check and no nothing else, or others.
*/
/// Designates the item it's added to as something that "uses mana".
/datum/component/uses_mana
    var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()

/datum/component/uses_mana/proc/get_attunement_dispositions()
    return attunements

// TODO: Do I need the vararg?
/// Should return the numerical value of mana needed to use whatever it is we're using.
/datum/component/uses_mana/proc/get_mana_required(...)

/datum/component/uses_mana/proc/get_usable_mana()
    return parent.get_available_mana()

/datum/component/uses_mana/proc/is_mana_sufficient(list/datum/mana_pool/provided_mana)
    var/total_effective_mana = 0
    var/list/datum/attunement/our_attunements = get_attunement_dispositions()
    for (var/datum/mana_pool/iterated_pool as anything in provided_mana)
        total_effective_mana += iterated_pool.get_amount(our_attunements)
    if (total_effective_mana > get_mana_required())
        return TRUE

/// Should be the primary conditional we use for determining if the thing that "uses mana" can actually
/// activate the behavior that "uses mana".
/datum/component/uses_mana/proc/can_activate()
    PROC_PROTECTED()
    return is_mana_sufficient(get_usable_mana())

/datum/component/uses_mana/proc/can_activate_with_feedback()

/datum/component/uses_mana/proc/react_to_successful_use(...)
    SIGNAL_HANDLER
    return
