
/datum/action/item_action/cult
	/// Text displayed when examining the item while this spell is invoked.
	var/examine_hint
	/// Whether this spell is invoked / active.
	var/active = FALSE
	/// The invocation said after a successful cast.
	var/invocation
	/// The amount of charges of this spell.
	var/charges = 1
	/// The base description, so we can edit it.
	var/base_desc
	/// The overlay that is shown when invoked.
	var/active_overlay_name
	/// The file the overlay is made from.
	var/active_overlay_file
	/// The overlay that is shown in hand invoked.
	var/active_overlay_held_name
	/// The file that the left hand overlay takes from.
	var/active_overlay_lhand_file
	/// The file that the right hand overlay takes from.
	var/active_overlay_rhand_file
	/// If FALSE, after_successful_spell() will be called automatically after a spell is used.
	/// If set to TRUE, you will need to handle saying the invocation and reducing the charges manually.
	var/manually_handle_charges = FALSE
	/// The blood magic ability that created this spell
	var/datum/action/innate/cult/blood_magic/magic_source

/datum/action/item_action/cult/New(Target, datum/action/innate/cult/blood_magic/new_magic)
	. = ..()
	if(new_magic)
		magic_source = new_magic
	base_desc = desc
	desc = base_desc + "<br><b><u>Has [charges] use\s remaining</u></b>."

/datum/action/item_action/cult/Grant(mob/M)
	if(!IS_CULTIST(M) || M != magic_source?.owner)
		Remove(owner)
		return

	. = ..()
	button.locked = TRUE
	button.ordered = FALSE
	magic_source.Positioning()

/datum/action/item_action/cult/Destroy()
	if(active)
		deactivate(TRUE)
	if(magic_source)
		magic_source.spells -= src
		magic_source = null
	return ..()

/datum/action/item_action/cult/Trigger(trigger_flags)
	var/obj/item/item_target = target
	for(var/datum/action/item_action/cult/spell in item_target.actions)
		if(spell != src && spell.active)
			spell.deactivate(TRUE)

	if(active)
		deactivate()
	else
		activate()

/// Activate the spell, registering signals to make it function.
/datum/action/item_action/cult/proc/activate(silent = FALSE)
	var/obj/item/target_item = target

	if(!owner.is_holding(target_item))
		if(owner.can_equip(target_item, ITEM_SLOT_HANDS))
			owner.temporarilyRemoveItemFromInventory(target_item)
			owner.put_in_hands(target_item)
		else
			if(!silent)
				to_chat(owner, span_warning("You fail to invoke the power of [src]!"))
			return

	active = TRUE
	RegisterSignal(target, COMSIG_ITEM_PRE_ATTACK, .proc/try_spell_effects)
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/on_equipped)
	if(active_overlay_name)
		RegisterSignal(target, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/on_item_update_overlays)
		target_item.update_icon(UPDATE_OVERLAYS)
	if(active_overlay_held_name)
		RegisterSignal(magic_source.owner, COMSIG_ATOM_UPDATE_OVERLAYS, .proc/on_mob_update_overlays)
		RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/on_dropped)
		magic_source.owner.update_icon(UPDATE_OVERLAYS)

	if(!silent)
		to_chat(magic_source.owner, span_brass("You invoke the power of [src] into [target]."))

/// Deactivate the spell, unregistering all the signals.
/datum/action/item_action/cult/proc/deactivate(silent = FALSE)
	var/obj/item/target_item = target

	active = FALSE
	if(active_overlay_name)
		target_item.update_icon(UPDATE_OVERLAYS)
	if(active_overlay_held_name)
		magic_source.owner.update_icon(UPDATE_OVERLAYS)

	UnregisterSignal(target, list(
		COMSIG_ITEM_PRE_ATTACK,
		COMSIG_PARENT_EXAMINE,
		COMSIG_ITEM_EQUIPPED,
		COMSIG_ITEM_DROPPED,
		COMSIG_ATOM_UPDATE_OVERLAYS,
		))
	UnregisterSignal(magic_source.owner, COMSIG_ATOM_UPDATE_OVERLAYS)

	if(!silent)
		to_chat(magic_source.owner, span_brass("You withdraw the power of [src] from [target]."))

/*
 * Signal proc for [COMSIG_PARENT_EXAMINE].
 */
/datum/action/item_action/cult/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(isliving(user) && !IS_CULTIST(user)) // observers / dead people can see it
		return

	examine_list += span_alloy("[name] is currently readied on [target], which will [examine_hint]")

/*
 * Signal proc for [COMSIG_ATOM_UPDATE_OVERLAYS], for the slab itself.
 */
/datum/action/item_action/cult/proc/on_item_update_overlays(obj/item/source, list/overlays)
	SIGNAL_HANDLER

	if(!active || !active_overlay_name)
		return

	overlays += mutable_appearance(active_overlay_file || icon_icon, active_overlay_name, ABOVE_OBJ_LAYER)

/*
 * Signal proc for [COMSIG_ATOM_UPDATE_OVERLAYS], for the mob holding the slab.
 */
/datum/action/item_action/cult/proc/on_mob_update_overlays(mob/living/source, list/overlays)
	SIGNAL_HANDLER

	if(!active || !active_overlay_held_name)
		return

	var/our_file
	var/held_hand = source.get_held_index_of_item(target)
	if(!held_hand)
		return

	if(held_hand % 2 == 0)
		our_file = active_overlay_rhand_file
	else
		our_file = active_overlay_lhand_file

	overlays += mutable_appearance(our_file, active_overlay_held_name, ABOVE_MOB_LAYER)

/*
 * Signal proc for [COMSIG_ITEM_EQUIPPED]
 * Un-invokes the spell when the item is equipped (picked up) by a non-cultist.
 */
/datum/action/item_action/cult/proc/on_equipped(datum/source, mob/grabber)
	SIGNAL_HANDLER

	if(IS_CULTIST(grabber))
		magic_source.owner.update_icon(UPDATE_OVERLAYS)
		return

	deactivate(TRUE)

/*
 * Signal proc for [COMSIG_ITEM_DROPPED]
 */
/datum/action/item_action/cult/proc/on_dropped(datum/source, mob/user)
	SIGNAL_HANDLER

	magic_source.owner.update_icon(UPDATE_OVERLAYS)

/*
 * Signal proc for [COMSIG_ITEM_PRE_ATTACK].
 *
 * Calls do_self_spell_effects() if (user) hits themselves with (target).
 * Calls do_hit_spell_effects() if (user) hits (a mob, hit) with (target).
 * Calls do_atom_spell_effects() if (user) hits (a non-mob atom, hit) with (target).

 * If either return TRUE, and manually_handle_charges is FALSE,
 * then we call after_successful_spell().
 */
/datum/action/item_action/cult/proc/try_spell_effects(datum/source, atom/hit, mob/user, params)
	SIGNAL_HANDLER

	if(!IS_CULTIST(user))
		return


	if(isliving(hit))
		if(hit == user)
			if(do_self_spell_effects(user))
				. = COMPONENT_NO_AFTERATTACK

		else
			if(do_hit_spell_effects(hit, user))
				. = COMPONENT_NO_AFTERATTACK

	else if(!ismob(hit))
		if(do_atom_spell_effects(hit, user))
			. = COMPONENT_NO_AFTERATTACK

	if(!manually_handle_charges && . == COMPONENT_NO_AFTERATTACK)
		INVOKE_ASYNC(src, .proc/after_successful_spell, user)


/*
 * Called when (user) hits themselves with (target).
 *
 * Return TRUE to return COMPONENT_NO_AFTERATTACK.
 */
/datum/action/item_action/cult/proc/do_self_spell_effects(mob/living/user)

/*
 * Called when (user) hits (victim) with (target).
 *
 * Return TRUE to return COMPONENT_NO_AFTERATTACK.
 */
/datum/action/item_action/cult/proc/do_hit_spell_effects(mob/living/victim, mob/living/user)

/*
 * Called when (user) hits (hit) with (target).
 *
 * Return TRUE to return COMPONENT_NO_AFTERATTACK.
 */
/datum/action/item_action/cult/proc/do_atom_spell_effects(atom/hit, mob/living/user)

/*
 * Called after a spell is successfuly cast.
 * Forces the user to say the invocation,
 * Reduces the amount of charges,
 * and updates the description if there are charges remaining.
 */
/datum/action/item_action/cult/proc/after_successful_spell(mob/living/user)
	charges--
	if(invocation)
		user.whisper(invocation, language = /datum/language/common, forced = "cult invocation")
	desc = base_desc + "<br><b><u>Has [charges] use\s remaining</u></b>." // TODO: Doesn't work
	if(charges <= 0)
		qdel(src)

/datum/action/item_action/cult/clock_spell
	icon_icon = 'maplestation_modules/icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough
	active_overlay_file = 'icons/obj/clockwork_objects.dmi'
	active_overlay_lhand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	active_overlay_rhand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'

/datum/action/item_action/cult/clock_spell/IsAvailable()
	if(owner)
		if(!IS_CULTIST(owner) || owner.incapacitated() || charges <= 0)
			return FALSE
	return ..()

/datum/action/innate/cult/clock_spell
	icon_icon = 'maplestation_modules/icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough
	/// The amount of charges on the spell.
	var/charges = 1
	/// The base description, for editing.
	var/base_desc
	/// The invocation on cast.
	var/invocation
	/// The magic action that created the spell.
	var/datum/action/innate/cult/blood_magic/all_magic

/datum/action/innate/cult/clock_spell/Grant(mob/living/owner, datum/action/innate/cult/blood_magic/magic_source)
	base_desc = desc
	desc += "<br><b><u>Has [charges] use\s remaining</u></b>."
	all_magic = magic_source
	. = ..()
	button.locked = TRUE
	button.ordered = FALSE

/datum/action/innate/cult/clock_spell/Remove()
	if(all_magic)
		all_magic.spells -= src
		all_magic = null
	return ..()

/datum/action/innate/cult/clock_spell/IsAvailable()
	if(!IS_CULTIST(owner) || owner.incapacitated() || charges <= 0)
		return FALSE
	return ..()

/datum/action/innate/cult/blood_magic/advanced/clock
	name = "Prepare Clockwork Magic"
	desc = "Invoke clockwork magic into your slab. This is easier by a <b>sigil of power</b>."
	icon_icon = 'maplestation_modules/icons/mob/actions/actions_clockcult.dmi'
	button_icon_state = "hierophant_slab"
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough
	rune_that_empowers_us = /obj/effect/rune/empower/clock

// Clocky temp effects. Slightly transparent, fade out over a second.
/obj/effect/temp_visual/clock
	icon = 'maplestation_modules/icons/effects/clockwork_effects.dmi'
	randomdir = FALSE
	layer = BELOW_MOB_LAYER
	alpha = 155
	duration = 11

/obj/effect/temp_visual/clock/Initialize(mapload)
	. = ..()
	animate(src, alpha = 0, time = 10, easing = EASE_OUT)
