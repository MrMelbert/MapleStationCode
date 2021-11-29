
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

/datum/action/item_action/cult/Trigger()
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
	if(!owner.is_holding(target) && !owner.put_in_hands(target)) // TODO: Bugs the pocket, some reason
		if(!silent)
			to_chat(owner, span_warning("You fail to invoke the power of [src]!"))
		return

	active = TRUE
	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)
	RegisterSignal(target, COMSIG_ITEM_ATTACK, .proc/try_spell_effects)
	RegisterSignal(target, COMSIG_ITEM_DROPPED, .proc/drop_deactivate)
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, .proc/equip_deactivate)

	if(!silent)
		to_chat(owner, span_brass("You invoke the power of [src] into [target]."))

/// Deactivate the spell, unregistering all the signals.
/datum/action/item_action/cult/proc/deactivate(silent = FALSE)
	active = FALSE
	UnregisterSignal(target, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_ATTACK, COMSIG_ITEM_DROPPED, COMSIG_ITEM_EQUIPPED))

	if(!silent)
		to_chat(owner, span_brass("You withdraw the power of [src] from [target]."))

/*
 * Signal proc for [COMSIG_PARENT_EXAMINE].
 */
/datum/action/item_action/cult/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	if(!IS_CULTIST(user))
		return

	examine_list += span_alloy("[name] is currently readied on [target], which will [examine_hint]")

/*
 * Signal proc for [COMSIG_ITEM_ATTACK].
 *
 * Calls do_self_spell_effects() if (user) hits themselves with (target).
 * Calls do_hit_spell_effects() if (user) hits (victim) with (target).
 *
 * If either return TRUE, and manually_handle_charges is FALSE,
 * then we call after_successful_spell().
 */
/datum/action/item_action/cult/proc/try_spell_effects(datum/source, mob/living/victim, mob/living/user)
	SIGNAL_HANDLER

	if(!IS_CULTIST(user))
		return

	if(victim == user)
		if(do_self_spell_effects(user))
			. = COMPONENT_NO_AFTERATTACK

	else
		if(do_hit_spell_effects(victim, user))
			. = COMPONENT_NO_AFTERATTACK

	if(!manually_handle_charges && . == COMPONENT_NO_AFTERATTACK)
		INVOKE_ASYNC(src, .proc/after_successful_spell, user)

/*
 * Signal proc for [COMSIG_ITEM_DROPPED]
 * Un-invokes the spell when the item is dropped.
 */
/datum/action/item_action/cult/proc/drop_deactivate(datum/source, mob/living/user)
	SIGNAL_HANDLER

	deactivate(TRUE)

/*
 * Signal proc for [COMSIG_ITEM_EQUIPPED]
 * Un-invokes the spell when the item is equipped (picked up) by a non-cultist.
 */
/datum/action/item_action/cult/proc/equip_deactivate(datum/source, mob/living/taker)
	SIGNAL_HANDLER

	if(IS_CULTIST(taker))
		return

	deactivate(TRUE)

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
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_clockcult.dmi'
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough

/datum/action/item_action/cult/clock_spell/IsAvailable()
	if(owner)
		if(!IS_CULTIST(owner) || owner.incapacitated() || charges <= 0)
			return FALSE
	return ..()

/datum/action/innate/cult/clock_spell
	icon_icon = 'jollystation_modules/icons/mob/actions/actions_clockcult.dmi'
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
	background_icon_state = "bg_clock"
	buttontooltipstyle = "plasmafire" // close enough
