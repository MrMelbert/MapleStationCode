/// Add to an item to cause it to slow the wearer if worn simultaneously with a backpack.
/datum/component/slows_with_backpack
	/// Backpack or backpack like items that we can't stack without penalty
	var/static/list/backpack_types = typecacheof(list(
		/obj/item/storage/backpack,
		/obj/item/tank/jetpack,
	))


/datum/component/slows_with_backpack/Initialize(...)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_unequipped))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/component/slows_with_backpack/Destroy()
	var/obj/item/item_parent = parent
	if(ismob(item_parent.loc))
		UnregisterSignal(item_parent.loc, COMSIG_MOB_EQUIPPED_ITEM)
		UnregisterSignal(item_parent.loc, COMSIG_MOB_UNEQUIPPED_ITEM)

	qdel(parent.GetComponent(/datum/component/make_item_slow))
	UnregisterSignal(parent, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(parent, COMSIG_ITEM_DROPPED)
	UnregisterSignal(parent, COMSIG_ATOM_EXAMINE)
	return ..()

/datum/component/slows_with_backpack/proc/on_examine(obj/item/source, mob/examiner, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_info("Wearing both a backpack and [source] simultaneously will encumber you.")

/datum/component/slows_with_backpack/proc/on_equipped(obj/item/source, mob/user, slot)
	SIGNAL_HANDLER

	if(!(slot & (source.slot_flags|ITEM_SLOT_SUITSTORE)))
		return

	RegisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(check_for_backpack))
	RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(uncheck_for_backpack))
	var/obj/item/storage/backpack/backpack = user.get_item_by_slot(ITEM_SLOT_BACK)
	if(!is_type_in_typecache(backpack, backpack_types))
		return

	source.AddComponent(/datum/component/make_item_slow, 0.75)
	to_chat(user, span_warning("Wearing [source] and [backpack] at the same time encumbers you a bit."))

/datum/component/slows_with_backpack/proc/on_unequipped(obj/item/source, mob/user, ...)
	SIGNAL_HANDLER
	UnregisterSignal(user, COMSIG_MOB_EQUIPPED_ITEM)
	UnregisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM)
	qdel(source.GetComponent(/datum/component/make_item_slow))

/datum/component/slows_with_backpack/proc/check_for_backpack(mob/living/user, obj/item/equipped, slot)
	SIGNAL_HANDLER

	if((slot & ITEM_SLOT_BACK) && (equipped.slot_flags & ITEM_SLOT_BACK) && is_type_in_typecache(equipped, backpack_types))
		parent.AddComponent(/datum/component/make_item_slow, 0.75)
		to_chat(user, span_warning("Wearing [parent] and [equipped] at the same time encumbers you a bit."))

/datum/component/slows_with_backpack/proc/uncheck_for_backpack(mob/living/user, obj/item/unequipped, ...)
	SIGNAL_HANDLER

	if(!is_type_in_typecache(unequipped, backpack_types))
		return
	if(!(unequipped.slot_flags & ITEM_SLOT_BACK))
		return
	qdel(parent.GetComponent(/datum/component/make_item_slow))
