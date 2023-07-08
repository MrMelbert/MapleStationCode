#define COMSIG_ITEM_WORN_ICON_MADE "item_worn_icon_made"

/obj/item/build_worn_icon(
	default_layer = 0,
	default_icon_file = null,
	isinhands = FALSE,
	female_uniform = NO_FEMALE_UNIFORM,
	override_state = null,
	override_file = null,
)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ITEM_WORN_ICON_MADE, ., default_layer, default_icon_file, isinhands, female_uniform, override_state, override_file)

/**
 * Stackble item component
 *
 * This lets an item be attached to another item, combining the sprites and benefits of both
 *
 * When the parent is equipped, so is the attached item. And when the parent is dropped, so is the attached item.
 */
/datum/component/stackable_item
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

/datum/component/stackable_item/Initialize(list/wearables, datum/callback/can_stack, datum/callback/on_equip, datum/callback/on_drop)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.wearables = wearables
	src.can_stack = can_stack
	src.on_equip = on_equip
	src.on_drop = on_drop

/datum/component/stackable_item/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_WORN_ICON_MADE, PROC_REF(update_worn_icon))
	RegisterSignal(parent, COMSIG_ATOM_EXITED, PROC_REF(atom_exited))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(item_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(item_dropped))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(item_attackby))
	RegisterSignals(parent, list(COMSIG_ATOM_DESTRUCTION, COMSIG_OBJ_DECONSTRUCT), PROC_REF(on_deconstruct))

/datum/component/stackable_item/UnregisterFromParent()
	UnregisterSignal(parent, list(
		COMSIG_ITEM_WORN_ICON_MADE,
		COMSIG_ATOM_EXITED,
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
		COMSIG_PARENT_ATTACKBY,
		COMSIG_ATOM_DESTRUCTION,
		COMSIG_OBJ_DECONSTRUCT,
	))

/datum/component/stackable_item/Destroy()
	stacked_on = null
	QDEL_NULL(can_stack)
	QDEL_NULL(on_equip)
	QDEL_NULL(on_drop)
	return ..()

/datum/component/stackable_item/proc/update_worn_icon(
	obj/item/source,
	mutable_appearance/created_icon,
	default_layer,
	default_icon_file,
	isinhands,
	female_uniform,
	override_state,
	override_file,
)
	SIGNAL_HANDLER

	if(isinhands || isnull(stacked_on))
		return

	var/mutable_appearance/stacked_overlay = stacked_on.build_worn_icon(
		default_layer,
		default_icon_file,
		isinhands,
		female_uniform,
		override_state,
		override_file,
	)

	// Add in our new worn icon as an overlay of our item's icon.
	created_icon.overlays.Add(stacked_overlay)

/datum/component/stackable_item/proc/atom_exited(obj/item/source, atom/movable/gone, direction)
	SIGNAL_HANDLER

	if(isnull(stacked_on))
		return

	var/obj/item/removing = stacked_on
	stacked_on = null
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
	stacked_on.equipped(user, slot)

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
		stacked_on.equipped(carbon_loc, equipped_flags)
		carbon_loc.update_clothing(equipped_flags)

/datum/component/stackable_item/proc/on_deconstruct(obj/item/source)
	SIGNAL_HANDLER

	stacked_on?.forceMove(source.drop_location())

// Eyepatches can also be worn with huds

/obj/item/clothing/glasses/hud/security/sunglasses/eyepatch
	name = "security eyepatch HUD" // just a rename.

/obj/item/clothing/glasses/eyepatch

/obj/item/clothing/glasses/eyepatch/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/stackable_item, \
		wearables = list(/obj/item/clothing/glasses/hud), \
		can_stack = CALLBACK(src, PROC_REF(can_attach_hud)), \
		on_drop = CALLBACK(src, PROC_REF(on_drop_patch)), \
	)

/obj/item/clothing/glasses/eyepatch/proc/can_attach_hud(obj/item/source, obj/item/clothing/glasses/hud/incoming_hud, mob/user)
	// Basically stops you from attaching HUDglasses
	return (incoming_hud.flash_protect == 0 && incoming_hud.tint == 0)

/obj/item/clothing/glasses/eyepatch/proc/on_drop_patch(obj/item/clothing/glasses/hud/equipped_hud, mob/living/carbon/user, silent)
	if(!istype(user))
		return
	if(user.glasses != src)
		return
	// This is great hack but hud glasses rely on the user.glasses var to be set to the hud glasses
	// If this ever changes this must be removed because then it will call dropped twice, which isn't bad but can be weird
	var/obj/item/pre_slot = user.glasses
	user.glasses = equipped_hud
	equipped_hud.dropped(user, silent)
	user.glasses = pre_slot

#undef COMSIG_ITEM_WORN_ICON_MADE
