/// Attach to items that help mobs missing limbs move faster when held.
/datum/component/limbless_aid
	/// What slot flags must the parent item have to provide the bonus?
	var/required_slot = ITEM_SLOT_HANDS
	/// How much should the movespeed be modified?
	var/movespeed_mod = 0.5

/datum/component/limbless_aid/Initialize(required_slot = ITEM_SLOT_HANDS, movespeed_mod = 0.5)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.required_slot = required_slot
	src.movespeed_mod = movespeed_mod

/datum/component/limbless_aid/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))

	var/obj/item/item_parent = parent
	if(isliving(item_parent.loc))
		var/mob/living/wearer = item_parent.loc
		on_equip(parent, wearer, wearer.get_slot_by_item(parent))

/datum/component/limbless_aid/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

	var/obj/item/item_parent = parent
	if(isliving(item_parent.loc))
		on_drop(item_parent, item_parent.loc)

/datum/component/limbless_aid/proc/on_equip(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER

	if(!(slot & required_slot))
		return

	ADD_TRAIT(user, TRAIT_NO_LEG_AID, REF(src))
	RegisterSignal(user, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE, PROC_REF(modify_movespeed), override = TRUE)
	RegisterSignal(user, COMSIG_CARBON_LIMPING, PROC_REF(limp_check), override = TRUE)
	user.update_limbless_locomotion()
	user.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/on_drop(obj/item/source, mob/living/user)
	SIGNAL_HANDLER

	REMOVE_TRAIT(user, TRAIT_NO_LEG_AID, REF(src))
	UnregisterSignal(user, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE)
	UnregisterSignal(user, COMSIG_CARBON_LIMPING)
	user.update_limbless_locomotion()
	user.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/modify_movespeed(mob/living/source, list/modifiers)
	SIGNAL_HANDLER

	var/obj/item/bodypart/leg = get_braced_leg(source)
	if(isnull(leg) || leg.bodypart_disabled)
		modifiers += movespeed_mod

/datum/component/limbless_aid/proc/limp_check(mob/living/source, obj/item/bodypart/next_leg)
	SIGNAL_HANDLER

	var/obj/item/bodypart/leg = get_braced_leg(source)
	if(isnull(leg) || leg == next_leg)
		return COMPONENT_CANCEL_LIMP

#define IS_RIGHT_ARM(index) (index % 2 == 0)

/// Checks what side the item is equipped on
/datum/component/limbless_aid/proc/get_braced_leg(mob/living/who)
	if(required_slot & ITEM_SLOT_HANDS)
		// note this is backwards intentionally:
		// right arm braces the left leg, and left arm braces right leg
		var/side = IS_RIGHT_ARM(who.get_held_index_of_item(parent)) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG
		return who.get_bodypart(side)

	return null // unimplemented

#undef IS_RIGHT_ARM
