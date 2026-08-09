/obj/item/clothing/under
	/// The "pockets" attached to this uniform
	var/obj/effect/abstract/abstract_storage/uniform_pockets/pockets

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(take_pockets_comsig))

/obj/item/clothing/under/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/under/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()
	if(!isnull(held_item) && can_slip_in_pockets(user, held_item))
		context[SCREENTIP_CONTEXT_RMB] = "Add to pockets"
		. = CONTEXTUAL_SCREENTIP_SET

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(!pockets)
		return
	if(pockets.id)
		. += ("&bull; " + span_notice("It's got [pockets.id] attached to [p_they()]."))
	if(pockets.l_pocket && pockets.r_pocket && pockets.l_pocket.w_class == WEIGHT_CLASS_TINY && pockets.r_pocket.w_class == WEIGHT_CLASS_TINY)
		. += ("&bull; " + span_notice("You can see something in both of [p_their()] pockets."))
	else if(pockets.l_pocket)
		. += ("&bull; " + span_notice("You can see [pockets.l_pocket.w_class == WEIGHT_CLASS_TINY ? "something" : "\a [pockets.l_pocket]"] in [p_their()] left pocket."))
	else if(pockets.r_pocket)
		. += ("&bull; " + span_notice("You can see [pockets.r_pocket.w_class == WEIGHT_CLASS_TINY ? "something" : "\a [pockets.r_pocket]"] in [p_their()] right pocket."))

/obj/item/clothing/under/proc/can_slip_in_pockets(mob/living/user, obj/item/tool)
	if(tool.w_class > POCKET_WEIGHT_CLASS)
		return FALSE
	if(src == user.get_item_by_slot(slot_flags))
		return FALSE

	return TRUE

/obj/item/clothing/under/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(!can_slip_in_pockets(user, tool))
		return NONE

	if(isnull(pockets))
		init_pockets()

	else if(tool.slot_flags & ITEM_SLOT_ID)
		if(pockets.id)
			to_chat(user, span_warning("[src] already has an ID attached to [p_them()]."))
			return ITEM_INTERACT_BLOCKING

	else if(pockets.l_pocket && pockets.r_pocket)
		to_chat(user, span_warning("[src] already has something in both of [p_their()] pockets."))
		return ITEM_INTERACT_BLOCKING

	if(!pockets.atom_storage.can_insert(tool))
		balloon_alert(user, "can't fit!")
		QDEL_NULL(pockets)
		return ITEM_INTERACT_BLOCKING

	user.visible_message(
		span_notice("[user] slips something in [src]'s pockets."),
		span_notice("You slip [tool] in [src]'s pockets."),
		vision_distance = COMBAT_MESSAGE_RANGE,
	)
	if(!do_after(user, 2 SECONDS, src) \
		|| !pockets.atom_storage.can_insert(tool) \
		|| !user.temporarilyRemoveItemFromInventory(tool))
		QDEL_NULL(pockets)
		return ITEM_INTERACT_BLOCKING

	if(tool.slot_flags & ITEM_SLOT_ID)
		if(!pockets.id)
			pockets.id = tool
			tool.forceMove(pockets)
			return ITEM_INTERACT_SUCCESS
	if(!pockets.l_pocket)
		pockets.l_pocket = tool
		tool.forceMove(pockets)
		return ITEM_INTERACT_SUCCESS
	if(!pockets.r_pocket)
		pockets.r_pocket = tool
		tool.forceMove(pockets)
		return ITEM_INTERACT_SUCCESS

	// need to do this incase someone else added pocket items while we were waiting
	balloon_alert(user, "can't fit!")
	user.put_in_active_hand(tool)
	return ITEM_INTERACT_BLOCKING

/obj/item/clothing/under/equipped(mob/living/user, slot)
	. = ..()
	if(isnull(pockets))
		return
	if(!(slot & slot_flags))
		return

	// do not allow storage interaction while worn
	pockets.unregister_storage_signals()
	pockets.atom_storage?.close_all()
	// put pocket items back to relevant slots
	for(var/equip_thing, equip_slot in pockets.get_items())
		user.equip_to_slot_if_possible(equip_thing, equip_slot, disable_warning = TRUE)
	// anything that maybe left behind for whatever reason
	dump_pockets(user.drop_location())

/obj/item/clothing/under/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	// always dump on toss
	dump_pockets()

/obj/item/clothing/under/dropped(mob/living/user)
	. = ..()
	if(isnull(pockets))
		return

	// ensure you can interact with pockets after unequipping
	pockets.register_storage_signals()
	// drop pocket items if putting the uniform on the ground, otherwise keep
	if(!ismob(loc) && should_dump_on_drop())
		dump_pockets()

/obj/item/clothing/under/atom_deconstruct(disassembled)
	pockets?.deconstruct(disassembled)
	return ..()

/// Checks if we should dump pocket contents on drop
/obj/item/clothing/under/proc/should_dump_on_drop()
	for(var/atom/movable/thing in loc)
		if(GLOB.typecache_elevated_structures[thing.type])
			return FALSE
	return TRUE

/// Dumps pocket contents to the given location
/obj/item/clothing/under/proc/dump_pockets(atom/drop_loc = drop_location())
	pockets?.atom_storage?.remove_all(drop_loc)

/obj/item/clothing/under/proc/take_pockets_comsig(datum/source, force, newloc, no_move, invdrop, silent)
	SIGNAL_HANDLER

	if(!invdrop || QDELING(src))
		return

	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return
	if(!wearer.wear_id && !wearer.l_store && !wearer.r_store)
		return

	take_pockets(wearer)

/obj/item/clothing/under/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == pockets)
		pockets = null
		if(!QDELING(gone))
			qdel(gone)

/// Init pockets if necessary
/obj/item/clothing/under/proc/init_pockets()
	pockets ||= new(src)

/// Take our pockets and IDs and places them in relevant slots
/obj/item/clothing/under/proc/take_pockets(mob/living/carbon/human/from_who)
	init_pockets()

	var/obj/item/who_id = from_who.wear_id
	if(who_id && !pockets.id && pockets.atom_storage.can_insert(who_id) && from_who.temporarilyRemoveItemFromInventory(who_id))
		pockets.id = who_id
		who_id.forceMove(pockets)

	var/obj/item/who_l_pocket = from_who.l_store
	if(who_l_pocket && !pockets.l_pocket && pockets.atom_storage.can_insert(who_l_pocket) && from_who.temporarilyRemoveItemFromInventory(who_l_pocket))
		pockets.l_pocket = who_l_pocket
		who_l_pocket.forceMove(pockets)

	var/obj/item/who_r_pocket = from_who.r_store
	if(who_r_pocket && !pockets.r_pocket && pockets.atom_storage.can_insert(who_r_pocket) && from_who.temporarilyRemoveItemFromInventory(who_r_pocket))
		pockets.r_pocket = who_r_pocket
		who_r_pocket.forceMove(pockets)

// Storage just for uniform fake pockets
/datum/storage/uniform_pocket

/datum/storage/uniform_pocket/attempt_insert(obj/item/to_insert, mob/user, override, force, messages)
	return FALSE // Don't let anyone inser things normally AT ALL thank you. We'll forceMove if we must

/datum/storage/uniform_pocket/animate_storage(atom/animate)
	animate = parent.loc
	return ..() // Redirects animations to the uniform itself (parent.loc)

/**
 * Abstract object intended for either:
 * - Holding a storage datum for an atom that might get another storage datum from another source
 * - Holding an item's contents that might have other non-storage contents
 */
/obj/effect/abstract/abstract_storage
	density = FALSE
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	// hack to get around the fact that we fail canreach if our loc doesn't have a storage of itself
	// probably fine if we just rename this flag to be more accurate (CAN_ALWAYS_REACH_1 or something)
	flags_1 = IS_ONTOP_1
	/// What type of storage do we use
	var/storage_type = /datum/storage

/obj/effect/abstract/abstract_storage/Initialize(mapload)
	. = ..()
	if(!isnull(storage_type))
		create_storage(storage_type = storage_type)

// Used for uniforms (to circumvent accessories)
/obj/effect/abstract/abstract_storage/uniform_pockets
	name = "pockets"
	storage_type = /datum/storage/uniform_pocket
	/// What was in our left pocket?
	var/obj/item/l_pocket
	/// What was in our right pocket?
	var/obj/item/r_pocket
	/// What was in our ID slot?
	var/obj/item/id

/obj/effect/abstract/abstract_storage/uniform_pockets/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = POCKET_WEIGHT_CLASS
	atom_storage.max_slots = 3
	atom_storage.max_total_storage = atom_storage.max_specific_storage * atom_storage.max_slots
	if(isnull(loc))
		return

	name = "[loc.name]'s pockets"
	register_storage_signals()

/obj/effect/abstract/abstract_storage/uniform_pockets/proc/register_storage_signals()
	atom_storage.RegisterSignal(loc, COMSIG_MOUSEDROP_ONTO, TYPE_PROC_REF(/datum/storage, on_mousedrop_onto), TRUE)
	atom_storage.RegisterSignals(loc, list(COMSIG_CLICK_ALT, COMSIG_ATOM_ATTACK_GHOST, COMSIG_ATOM_ATTACK_HAND_SECONDARY), TYPE_PROC_REF(/datum/storage, open_storage_on_signal), TRUE)

/obj/effect/abstract/abstract_storage/uniform_pockets/proc/unregister_storage_signals()
	atom_storage.UnregisterSignal(loc, COMSIG_MOUSEDROP_ONTO)
	atom_storage.UnregisterSignal(loc, list(COMSIG_CLICK_ALT, COMSIG_ATOM_ATTACK_GHOST, COMSIG_ATOM_ATTACK_HAND_SECONDARY))

/obj/effect/abstract/abstract_storage/uniform_pockets/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == id)
		id = null
	if(gone == l_pocket)
		l_pocket = null
	if(gone == r_pocket)
		r_pocket = null

/obj/effect/abstract/abstract_storage/uniform_pockets/proc/get_items()
	. = list()
	if(id)
		.[id] = ITEM_SLOT_ID
	if(l_pocket)
		.[l_pocket] = ITEM_SLOT_LPOCKET
	if(r_pocket)
		.[r_pocket] = ITEM_SLOT_RPOCKET

// Used for winter coats because they store the hood in the coat's contents
/obj/effect/abstract/abstract_storage/coat_pockets
	name = "coat pockets"
	storage_type = null
