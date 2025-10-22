/// Heirloom component. For use with the family heirloom quirk, tracks that an item is someone's family heirloom.
/datum/component/heirloom
	can_transfer = TRUE
	/// The mind that actually owns our heirloom.
	var/datum/mind/owner
	/// Flavor. The family name of the owner of the heirloom.
	var/family_name

/datum/component/heirloom/Initialize(new_owner, new_family_name)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	owner = new_owner
	family_name = new_family_name

/datum/component/heirloom/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_SUBTYPE_PICKER_REPLACED, PROC_REF(transfer_to_new_item))

/datum/component/heirloom/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	UnregisterSignal(parent, COMSIG_ITEM_SUBTYPE_PICKER_REPLACED)

/datum/component/heirloom/PostTransfer()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	// Moves weakref to our new item
	var/datum/quirk/item_quirk/family_heirloom/quirk = owner?.current?.get_quirk(/datum/quirk/item_quirk/family_heirloom)
	quirk?.heirloom = WEAKREF(parent)

/datum/component/heirloom/Destroy(force)
	owner = null
	return ..()

/**
 * Signal proc for [COMSIG_ATOM_EXAMINE].
 *
 * Shows who owns the heirloom on examine.
 */
/datum/component/heirloom/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	var/datum/mind/examiner_mind = user.mind

	if(examiner_mind == owner)
		examine_list += span_notice("It is your precious [family_name] family heirloom. Keep it safe!")
		return

	var/datum/antagonist/obsessed/our_creeper = examiner_mind?.has_antag_datum(/datum/antagonist/obsessed)
	if(our_creeper?.trauma.obsession == owner)
		examine_list += span_nicegreen("This must be [owner]'s family heirloom! It smells just like them...")
		return

	examine_list += span_notice("It is the [family_name] family heirloom, belonging to [owner].")

/// Transfer the component to a new item when a subtype picker replaces it.
/datum/component/heirloom/proc/transfer_to_new_item(datum/source, obj/item/new_item, mob/user)
	SIGNAL_HANDLER

	new_item.TakeComponent(src)
