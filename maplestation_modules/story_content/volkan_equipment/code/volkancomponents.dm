/*
 * # Components for Volkan pets or others!
 * This file has a bunch of components as well as various things like components and things like that.
 * First set is likely to be used in more than one mob. Maybe.
 */
#define COMSIG_COMBAT_MODE "combat_mode_active"

/*
 * # Tractor field component
 * A very important and complicated piece of tech from Volkan and co. 
 * In game it will basically act like telekinesis. 
 * Add it to a mob if the mob has Volkan's tractor field tech inside.
 */
/datum/component/tractorfield
	var/static/list/blacklisted_atoms = typecacheof(list(/atom/movable/screen))

/datum/component/tractorfield/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_ATTACK_RANGED, PROC_REF(on_ranged_attack))

/datum/component/cleaner/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_ATTACK_RANGED)

///Triggers on COMSIG_MOB_ATTACK_RANGED. Usually handles stuff like picking up items at range.
/datum/component/tractorfield/proc/on_ranged_attack(mob/source, atom/target)
	SIGNAL_HANDLER
	if(is_type_in_typecache(target, blacklisted_atoms))
		return
	if(!tkMaxRangeCheck(source, target) || source.z != target.z)
		return
	return target.attack_tractor(source)

/atom/proc/attack_tractor(mob/user)
	if(user.stat || !tkMaxRangeCheck(user, src))
		return
	new /obj/effect/temp_visual/telekinesis(get_turf(src))
	add_hiddenprint(user)
	user.UnarmedAttack(src, FALSE) // attack_hand, attack_paw, etc
	return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/attack_tractor(mob/user)
	if(user.stat)
		return
	if(anchored)
		return ..()
	return attack_tractor_grab(user)


/obj/item/attack_tractor(mob/user)
	if(user.stat)
		return
	return attack_tractor_grab(user)

/obj/proc/attack_tractor_grab(mob/user)
	var/obj/item/tk_grab/O = new(src)
	O.tk_user = user
	if(!O.focus_object(src))
		return
	SEND_SIGNAL(src, COMSIG_LIVING_UNARMED_ATTACK, O)
	add_hiddenprint(user)
	return COMPONENT_CANCEL_ATTACK_CHAIN


/*
 * # Vroomba only stuff
 * Components just for the vroomba.
 */
 ///The vroomba's hud!
/datum/hud/vroomba/New(mob/owner)
	. = ..()
	var/atom/movable/screen/using

	using = new /atom/movable/screen/drop(null, src)
	using.icon = ui_style
	using.screen_loc = ui_drone_drop
	static_inventory += using

	pull_icon = new /atom/movable/screen/pull(null, src)
	pull_icon.icon = ui_style
	pull_icon.update_appearance()
	pull_icon.screen_loc = ui_drone_pull
	static_inventory += pull_icon

	build_hand_slots()

	action_intent = new /atom/movable/screen/combattoggle/flashy(null, src)
	action_intent.icon = ui_style
	action_intent.screen_loc = ui_combat_toggle
	static_inventory += action_intent

	zone_select = new /atom/movable/screen/zone_sel(null, src)
	zone_select.icon = ui_style
	zone_select.update_appearance()
	static_inventory += zone_select

	using = new /atom/movable/screen/area_creator(null, src)
	using.icon = ui_style
	static_inventory += using

	mymob.canon_client?.clear_screen()

///The vroombas cleaner for when it is not in combat.
/datum/component/cleaner/vroomba/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_COMBAT_MODE, PROC_REF(remove_self))

/datum/component/cleaner/vroomba/proc/remove_self()
	SIGNAL_HANDLER

	qdel(src)

///this one removes itself when combat mode is deactivated.
/datum/component/tractorfield/vroomba/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_COMBAT_MODE, PROC_REF(remove_self))
	
/datum/component/tractorfield/vroomba/proc/remove_self()
	SIGNAL_HANDLER

	qdel(src)
