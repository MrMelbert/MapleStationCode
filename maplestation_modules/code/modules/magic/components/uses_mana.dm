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

// TODO: Do I need the vararg?
/datum/component/uses_mana/proc/get_mana_required(...)

/datum/component/uses_mana/proc/get_usable_mana()

/datum/component/uses_mana/proc/is_mana_sufficient(datum/mana_group/group)

/// Should be the primary conditional we use for determining if the thing that "uses mana" can actually
/// activate the behavior that "uses mana".
/datum/component/uses_mana/proc/can_activate()
    return is_mana_sufficient(get_usable_mana())
