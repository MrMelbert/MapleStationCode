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

/datum/component/uses_mana/Initialize(...)
	. = ..()

/// Should return a list of attunements. Defaults to GLOB.default_attunements.
/datum/component/uses_mana/proc/get_attunement_dispositions()
	return GLOB.default_attunements.Copy()

/// If we have consistant attunements, this should be used to modify them.
/datum/component/uses_mana/proc/modify_attunements(list/datum/attunement/incoming_attunements)
	return

// TODO: Do I need the vararg?
/// Should return the numerical value of mana needed to use whatever it is we're using. Unaffected by attunements.
/datum/component/uses_mana/proc/get_mana_required(...)
	return 0

/datum/component/uses_mana/get_available_mana(list/datum/attunement/attunements)
	return parent.get_available_mana(attunements)

/// Should return TRUE if the total adjusted mana of all mana pools surpasses get_mana_required(). FALSE otherwise.
/datum/component/uses_mana/proc/is_mana_sufficient(list/datum/mana_pool/provided_mana)
	var/total_effective_mana = 0
	var/list/datum/attunement/our_attunements = get_attunement_dispositions()
	for (var/datum/mana_pool/iterated_pool as anything in provided_mana)
		total_effective_mana += iterated_pool.get_attuned_amount(our_attunements)
	if (total_effective_mana > get_mana_required())
		return TRUE

/// Should be the raw conditional we use for determining if the thing that "uses mana" can actually
/// activate the behavior that "uses mana".
/datum/component/uses_mana/proc/can_activate(...)
	return is_mana_sufficient(get_available_mana())

/// Wrapper for can_activate(). Should return a bitflag that will be passed down to the signal sender on failure.
/datum/component/uses_mana/proc/can_activate_check(give_feedback = TRUE, ...)
	var/list/argss = args.Copy(2)
	var/can_activate = can_activate(arglist(argss)) //doesnt return this + can_activate_check_... because returning TRUE/FALSE can gave bitflag implications
	if (!can_activate)
		return can_activate_check_failure(arglist(args.Copy()))

/// What can_activate_check returns apon failing to activate.
/datum/component/uses_mana/proc/can_activate_check_failure(give_feedback, ...)
	PROTECTED_PROC(TRUE)
	if (give_feedback)
		give_unable_to_activate_feedback(arglist(args.Copy(2)))
	return FALSE

/// If called, should give feedback to the user of the magic, telling them why it failed.
/datum/component/uses_mana/proc/give_unable_to_activate_feedback(...)
	PROTECTED_PROC(TRUE)
	return

/// Should react to a post-use signal given by the parent, and ideally subtract mana, or something.
/datum/component/uses_mana/proc/react_to_successful_use(...)
	SIGNAL_HANDLER
	return
/// The primary proc we will use for draining mana to simulate it being consumed to power our actions.
/datum/component/uses_mana/proc/drain_mana(list/datum/mana_pool/pools = get_available_mana(), cost = -get_mana_required(), ...)

	var/list/datum/attunement/our_attunements = get_attunement_dispositions()
	for (var/datum/mana_pool/iterated_pool as anything in pools)
		var/mult = iterated_pool.get_attunement_mults(our_attunements)
		var/attuned_cost = cost * mult
		cost -= SAFE_DIVIDE(iterated_pool.adjust_mana((attuned_cost)), mult)
		if (cost == 0) break
	if (cost != 0)
		stack_trace("cost: [cost] was not 0 after react_to_successful_use on [src]")


