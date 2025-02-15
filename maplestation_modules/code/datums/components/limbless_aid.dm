/// Attach to items that help mobs missing limbs move faster when held.
/datum/component/limbless_aid
	/// What slot flags must the parent item have to provide the bonus?
	var/required_slot
	/// How much should the movespeed be modified?
	var/movespeed_mod

/datum/component/limbless_aid/Initialize(required_slot = ITEM_SLOT_HANDS, movespeed_mod = 0.5)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.required_slot = required_slot
	src.movespeed_mod = movespeed_mod

/datum/component/limbless_aid/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_ATOM_EXAMINE, PROC_REF(examined))

	var/obj/item/item_parent = parent
	if(isliving(item_parent.loc))
		var/mob/living/wearer = item_parent.loc
		on_equip(parent, wearer, wearer.get_slot_by_item(parent))

/datum/component/limbless_aid/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED, COMSIG_ATOM_EXAMINE))

	var/obj/item/item_parent = parent
	if(isliving(item_parent.loc))
		on_drop(item_parent, item_parent.loc)

/datum/component/limbless_aid/proc/examined(obj/item/source, mob/living/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_info("It will support your weight, allowing you to move faster with a wounded, disabled, or missing leg.")
	examine_list += span_info("Holding <b>two</b> will allow you to <b>walk</b> despite having two missing or disabled legs.")
	examine_list += span_info("<b>Resisting</b> will brace you, allowing you to <b>stand</b> on one support, \
		despite having two missing or disabled legs. Moving will cancel this effect.")

/datum/component/limbless_aid/proc/on_equip(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER

	if(!(slot & required_slot))
		lose_support(user)
		return

	add_support(user)

/datum/component/limbless_aid/proc/add_support(mob/living/user)
	ADD_TRAIT(user, TRAIT_NO_LEG_AID, "[REF(src)]_aid")
	RegisterSignal(user, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE, PROC_REF(modify_movespeed), override = TRUE)
	RegisterSignal(user, COMSIG_CARBON_PAINED_STEP, PROC_REF(pain_step), override = TRUE)
	RegisterSignal(user, COMSIG_CARBON_LIMPING, PROC_REF(limp_check), override = TRUE)
	RegisterSignal(user, COMSIG_LIVING_RESIST, PROC_REF(self_brace), override = TRUE)
	user.update_limbless_locomotion()
	user.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/on_drop(obj/item/source, mob/living/user)
	SIGNAL_HANDLER

	lose_support(user)

/datum/component/limbless_aid/proc/lose_support(mob/living/user)
	REMOVE_TRAIT(user, TRAIT_NO_LEG_AID, "[REF(src)]_aid")
	un_self_brace(user)
	UnregisterSignal(user, COMSIG_LIVING_LIMBLESS_MOVESPEED_UPDATE)
	UnregisterSignal(user, COMSIG_CARBON_PAINED_STEP)
	UnregisterSignal(user, COMSIG_CARBON_LIMPING)
	UnregisterSignal(user, COMSIG_LIVING_RESIST)
	user.update_limbless_locomotion()
	user.update_limbless_movespeed_mod()

/datum/component/limbless_aid/proc/modify_movespeed(mob/living/source, list/modifiers)
	SIGNAL_HANDLER

	var/obj/item/bodypart/leg
	if(required_slot & ITEM_SLOT_HANDS)
		// this is not backwards intentionally:
		// if you're missing the left leg, you need the left leg braced
		var/side = IS_RIGHT(source.get_held_index_of_item(parent)) ? BODY_ZONE_R_LEG : BODY_ZONE_L_LEG
		leg = source.get_bodypart(side)

	if(isnull(leg) || leg.bodypart_disabled)
		modifiers += movespeed_mod

/datum/component/limbless_aid/proc/pain_step(mob/living/source, obj/item/affected_leg, footstep_count)
	SIGNAL_HANDLER

	var/obj/item/bodypart/leg
	if(required_slot & ITEM_SLOT_HANDS)
		// note this is backwards intentionally:
		// see below
		var/side = IS_RIGHT(source.get_held_index_of_item(parent)) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG
		leg = source.get_bodypart(side)

	if(isnull(leg) || leg == affected_leg)
		return STOP_PAIN

/datum/component/limbless_aid/proc/limp_check(mob/living/source, obj/item/bodypart/next_leg)
	SIGNAL_HANDLER

	var/obj/item/bodypart/leg
	if(required_slot & ITEM_SLOT_HANDS)
		// note this is backwards intentionally:
		// you use your right arm to brace your left leg, and vice versa
		var/side = IS_RIGHT(source.get_held_index_of_item(parent)) ? BODY_ZONE_L_LEG : BODY_ZONE_R_LEG
		leg = source.get_bodypart(side)

	if(isnull(leg) || leg == next_leg)
		return COMPONENT_CANCEL_LIMP

/datum/component/limbless_aid/proc/self_brace(mob/living/source)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(self_brace_async), source)

/datum/component/limbless_aid/proc/un_self_brace(mob/living/source)
	REMOVE_TRAIT(source, TRAIT_NO_LEG_AID, "[REF(src)]_brace")
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/datum/component/limbless_aid/proc/self_brace_async(mob/living/source)
	if((required_slot & ITEM_SLOT_HANDS) && parent != source.get_active_held_item())
		return
	if(HAS_TRAIT_FROM(source, TRAIT_NO_LEG_AID, "[REF(src)]_brace"))
		return
	if(DOING_INTERACTION_WITH_TARGET(source, source))
		return
	// lying down is a lot harder to get up from
	if(!do_after(source, (source.body_position == LYING_DOWN ? 2.4 SECONDS : 0.8 SECONDS), source))
		return

	source.balloon_alert(source, "braced")
	ADD_TRAIT(source, TRAIT_NO_LEG_AID, "[REF(src)]_brace")
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(brace_moved))
	source.update_limbless_locomotion()

/datum/component/limbless_aid/proc/brace_moved(mob/living/source, atom/old_loc)
	SIGNAL_HANDLER

	if(source.loc == old_loc)
		return

	un_self_brace(source)
	source.update_limbless_locomotion()
