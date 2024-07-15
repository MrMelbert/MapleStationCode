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
		var/mob/living/wearer = item_parent.loc
		UnregisterSignal(wearer, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE)
		wearer.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/on_equip(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER

	if(!(slot & required_slot))
		return

	RegisterSignal(user, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE, PROC_REF(modify_movespeed), override = TRUE)
	RegisterSignal(user, COMSIG_CARBON_PAINED_STEP, PROC_REF(pain_step))
	user.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/on_drop(obj/item/source, mob/living/user)
	SIGNAL_HANDLER

	UnregisterSignal(user, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE)
	UnregisterSignal(user, COMSIG_CARBON_PAINED_STEP)
	user.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/modify_movespeed(mob/living/source, list/modifiers)
	SIGNAL_HANDLER

	modifiers += movespeed_mod

/datum/component/limbless_aid/proc/pain_step(mob/living/source, footstep_count)
	SIGNAL_HANDLER

	if(parent in source.get_held_items_for_side(SELECT_LEFT_OR_RIGHT(footstep_count, LEFT_HANDS, RIGHT_HANDS), all = TRUE))
		return STOP_PAIN
	return NONE
