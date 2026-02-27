/**
 * Stackble item component
 *
 * This lets an item be attached to another item, combining the sprites and benefits of both
 *
 * When the parent is equipped, so is the attached item. And when the parent is dropped, so is the attached item.
 */
/datum/component/stackable_item
	/// Descriptor for what you can attach to this item.
	var/wearable_descriptor = ""
	/// List of types that can be worn.
	/// Swap to a typecache if people make really large lists.
	var/list/wearables
	/// The item actively stacked on our stackable item.
	var/obj/item/stacked_on
	/// Optional callback that checks if incoming items are valid to attach.
	var/datum/callback/can_stack
	/// Optional callback that is called when an item is equipped.
	var/datum/callback/on_equip
	/// Optional callback that is called when an item is dropped.
	var/datum/callback/on_drop

/datum/component/stackable_item/Initialize(list/wearables, wearable_descriptor, datum/callback/can_stack, datum/callback/on_equip, datum/callback/on_drop)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.wearables = wearables
	src.wearable_descriptor = wearable_descriptor
	src.can_stack = can_stack
	src.on_equip = on_equip
	src.on_drop = on_drop

/datum/component/stackable_item/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(item_attackby))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE_TAGS, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(atom_exited))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(item_dropped))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(item_equipped))
	RegisterSignal(parent, COMSIG_ITEM_GET_SEPARATE_WORN_OVERLAYS, PROC_REF(update_worn_icon))
	RegisterSignals(parent, list(COMSIG_ATOM_DESTRUCTION, COMSIG_OBJ_DECONSTRUCT), PROC_REF(on_deconstruct))
	RegisterSignal(parent, COMSIG_ATOM_GET_EXAMINE_NAME, PROC_REF(get_examine_name))

/datum/component/stackable_item/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ATOM_ATTACKBY,
		COMSIG_ATOM_DESTRUCTION,
		COMSIG_ATOM_EXAMINE_TAGS,
		COMSIG_ATOM_EXITED,
		COMSIG_ITEM_DROPPED,
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_GET_SEPARATE_WORN_OVERLAYS,
		COMSIG_OBJ_DECONSTRUCT,
		COMSIG_ATOM_GET_EXAMINE_NAME,
	))

/datum/component/stackable_item/Destroy()
	stacked_on = null
	can_stack = null
	on_equip = null
	on_drop = null
	return ..()

/datum/component/stackable_item/proc/on_examine(obj/item/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(wearable_descriptor)
		examine_list["stackable"] = "You could attach [wearable_descriptor] to it."

/datum/component/stackable_item/proc/update_worn_icon(obj/item/source, list/overlays, mutable_appearance/standing, mutable_appearance/draw_target, isinhands, ...)
	SIGNAL_HANDLER

	if(isinhands || isnull(stacked_on))
		return

	// Add in our new worn icon as an overlay of our item's icon.
	var/mutable_appearance/created = stacked_on.build_worn_icon(default_layer = standing.layer, default_icon_file = get_default_icon_by_slot(stacked_on.slot_flags))
	if(isnull(created))
		return

	created.appearance_flags |= RESET_COLOR
	overlays += created

/datum/component/stackable_item/proc/atom_exited(obj/item/source, atom/movable/gone, direction)
	SIGNAL_HANDLER

	if(isnull(stacked_on))
		return

	var/obj/item/removing = stacked_on
	stacked_on = null
	UnregisterSignal(removing, COMSIG_ATOM_UPDATED_ICON)
	source.vis_contents -= removing
	removing.layer = initial(removing.layer)
	SET_PLANE_IMPLICIT(removing, initial(removing.plane))
	if(!iscarbon(source.loc))
		return

	var/mob/living/carbon/carbon_loc = source.loc
	var/equipped_flags = removing.slot_flags
	if(carbon_loc.get_item_by_slot(equipped_flags) == source)
		on_drop?.Invoke(removing, carbon_loc, TRUE)
		removing.dropped(carbon_loc, equipped_flags)
		carbon_loc.update_clothing(equipped_flags)

/datum/component/stackable_item/proc/item_equipped(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER

	if(isnull(stacked_on))
		return

	on_equip?.Invoke(stacked_on, user, slot)
	stacked_on.on_equipped(user, slot)

/datum/component/stackable_item/proc/item_dropped(obj/item/source, mob/living/user, silent)
	SIGNAL_HANDLER

	if(isnull(stacked_on))
		return

	on_drop?.Invoke(stacked_on, user, silent)
	stacked_on.dropped(user, silent)

/datum/component/stackable_item/proc/item_attackby(obj/item/source, obj/item/attacking_item, mob/user, params)
	SIGNAL_HANDLER

	if(!isnull(stacked_on))
		return
	if(!is_type_in_list(attacking_item, wearables))
		return

	. = COMPONENT_NO_AFTERATTACK

	var/obj/item/clothing/incoming_item = attacking_item
	if(can_stack && !can_stack.Invoke(source, incoming_item, user))
		return
	if(!user.transferItemToLoc(incoming_item, source, silent = TRUE))
		source.balloon_alert(user, "can't fit!")
		return

	stacked_on = incoming_item
	RegisterSignal(stacked_on, COMSIG_ATOM_UPDATED_ICON, PROC_REF(on_stacked_icon_update))
	stacked_on.layer = FLOAT_LAYER
	stacked_on.plane = FLOAT_PLANE
	source.vis_contents |= incoming_item
	source.balloon_alert(user, "item fitted")
	if(!iscarbon(source.loc))
		return

	var/mob/living/carbon/carbon_loc = source.loc
	var/equipped_flags = stacked_on.slot_flags
	if(carbon_loc.get_item_by_slot(equipped_flags) == source) // check that they're in the same slot as our source / parent
		on_equip?.Invoke(stacked_on, carbon_loc, equipped_flags)
		stacked_on.on_equipped(carbon_loc, equipped_flags)
		carbon_loc.update_clothing(equipped_flags)

/datum/component/stackable_item/proc/on_deconstruct(obj/item/source)
	SIGNAL_HANDLER

	stacked_on?.forceMove(source.drop_location())

/// Performs a clothing update if our stacked item had their appearance change.
/// Essentially just [/datum/element/update_icon_updates_onmob], but for the linked item, becuase it's not technically "on-mob".
/datum/component/stackable_item/proc/on_stacked_icon_update(obj/item/source, updates, updated)
	SIGNAL_HANDLER

	var/obj/item/parent_item = parent
	var/mob/living/carbon/carbon_loc = parent_item.loc
	if(!istype(carbon_loc))
		return

	var/equipped_flags = parent_item.slot_flags
	if(carbon_loc.get_item_by_slot(equipped_flags) == parent_item)
		carbon_loc.update_clothing(equipped_flags)

/datum/component/stackable_item/proc/get_examine_name(obj/item/source, mob/user, list/examine_override)
	SIGNAL_HANDLER

	if(isnull(stacked_on))
		return

	examine_override[EXAMINE_POSITION_NAME] += " and [stacked_on.get_examine_name()]"
