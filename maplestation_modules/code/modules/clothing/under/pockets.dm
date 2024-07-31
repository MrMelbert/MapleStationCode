/obj/item/clothing/under
	/// The "pockets" attached to this uniform
	var/obj/effect/abstract/abstract_storage/uniform_pockets/pockets

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_ITEM_POST_UNEQUIP, PROC_REF(take_pockets_comsig))

/obj/item/clothing/under/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/under/examine(mob/user)
	. = ..()
	if(!pockets)
		return
	if(pockets.id)
		. += ("&bull; " + span_notice("It's got [pockets.id] attached to [p_they()]."))
	if(pockets.l_pocket && pockets.r_pocket)
		. += ("&bull; " + span_notice("You can see something in both of [p_their()] pockets."))
	else if(pockets.l_pocket)
		. += ("&bull; " + span_notice("You can see something in [p_their()] left pocket."))
	else if(pockets.r_pocket)
		. += ("&bull; " + span_notice("You can see something in [p_their()] right pocket."))

/obj/item/clothing/under/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return
	if(!is_right_clicking)
		return
	if(istype(tool, /obj/item/clothing/accessory) || istype(tool, /obj/item/stack/cable_coil))
		return
	if(tool.w_class > POCKET_WEIGHT_CLASS)
		return
	if(src == user.get_item_by_slot(slot_flags))
		return

	. = ITEM_INTERACT_BLOCKING

	if(pockets)
		if(tool.slot_flags & ITEM_SLOT_ID)
			if(pockets.id)
				to_chat(user, span_warning("[src] already has an ID attached to [p_them()]."))
				return

		else
			if(pockets.l_pocket && pockets.r_pocket)
				to_chat(user, span_warning("[src] already has something in both of [p_their()] pockets."))
				return

	else
		init_pockets()

	if(!pockets.atom_storage.can_insert(tool))
		to_chat(user, span_warning("[src] can't hold [tool]."))
		QDEL_NULL(pockets)
		return

	user.visible_message(
		span_notice("[user] slips something in [src]'s pockets."),
		span_notice("You slip [tool] in [src]'s pockets."),
		vision_distance = COMBAT_MESSAGE_RANGE,
	)
	if(!do_after(user, 2 SECONDS, src) \
		|| !pockets.atom_storage.can_insert(tool) \
		|| !user.temporarilyRemoveItemFromInventory(tool))
		QDEL_NULL(pockets)
		return

	. = ITEM_INTERACT_SUCCESS

	if(tool.slot_flags & ITEM_SLOT_ID)
		if(!pockets.id)
			pockets.id = tool
			tool.forceMove(pockets)
			return
	if(!pockets.l_pocket)
		pockets.l_pocket = tool
		tool.forceMove(pockets)
		return
	if(!pockets.r_pocket)
		pockets.r_pocket = tool
		tool.forceMove(pockets)
		return

	// need to do this incase someone else added pocket items while we were waiting
	to_chat(user, span_warning("[src] can't hold [tool]."))
	user.put_in_active_hand(tool)
	if(!length(pockets.contents))
		QDEL_NULL(pockets)

/obj/item/clothing/under/equipped(mob/living/user, slot)
	. = ..()
	if(!pockets)
		return
	if(!(slot & slot_flags))
		return

	var/list/to_reequip = list(pockets.id = ITEM_SLOT_ID, pockets.l_pocket = ITEM_SLOT_LPOCKET, pockets.r_pocket = ITEM_SLOT_RPOCKET)
	for(var/obj/item/thing in to_reequip)
		user.equip_to_slot_if_possible(thing, to_reequip[thing], disable_warning = TRUE)
	// anything that maybe left behind for whatever reason
	dump_pockets(user.drop_location())

/obj/item/clothing/under/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(.)
		return
	dump_pockets()

/obj/item/clothing/under/dropped(mob/living/user)
	. = ..()
	if(!ismob(loc))
		dump_pockets()

/obj/item/clothing/under/atom_destruction(damage_flag)
	dump_pockets()
	return ..()

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

/obj/item/clothing/under/proc/init_pockets()
	if(isnull(pockets))
		pockets = new(src)
		RegisterSignal(pockets, COMSIG_QDELETING, PROC_REF(pockets_del))

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

	if(!length(pockets.contents)) // failed to collect any items
		qdel(pockets)

/obj/item/clothing/under/proc/pockets_del(...)
	SIGNAL_HANDLER
	pockets = null

// Storage just for uniform fake pockets
/datum/storage/uniform_pocket
	animated = FALSE

/datum/storage/uniform_pocket/attempt_insert(obj/item/to_insert, mob/user, override, force, messages)
	return FALSE // Don't let anyone inser things normally AT ALL thank you. We'll forceMove if we must

/// Abstract object intended for holding storage datums for an atom which might get
/// another storage datum from another source, or might have have contents of its own
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
	if(!loc)
		return

	name = "[loc.name]'s pockets"
	atom_storage.RegisterSignal(loc, COMSIG_MOUSEDROP_ONTO, TYPE_PROC_REF(/datum/storage, on_mousedrop_onto))
	atom_storage.RegisterSignals(loc, list(COMSIG_CLICK_ALT, COMSIG_ATOM_ATTACK_GHOST, COMSIG_ATOM_ATTACK_HAND_SECONDARY), TYPE_PROC_REF(/datum/storage, open_storage_on_signal))

/obj/effect/abstract/abstract_storage/uniform_pockets/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == id)
		id = null
	if(gone == l_pocket)
		l_pocket = null
	if(gone == r_pocket)
		r_pocket = null
	if(!length(contents))
		qdel(src) // we lazy af. we don't need to exist if we empty
