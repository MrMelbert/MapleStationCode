/// The base component to be applied to all spells that interact with the mana system.
/datum/component/uses_mana/story_spell
	var/datum/action/cooldown/spell/spell_parent

	can_transfer = FALSE

/datum/component/uses_mana/story_spell/Initialize(var/datum/action/cooldown/spell/our_spell)
	. = ..()

	if (!istype(our_spell))
		return . | COMPONENT_INCOMPATIBLE

/datum/component/uses_mana/story_spell/RegisterWithParent()
	. = ..()

	if (!istype(parent, /datum/action/cooldown/spell))
		qdel(src) // i dont know what to do here tbh
		return . | COMPONENT_INCOMPATIBLE
	spell_parent = parent

	RegisterSignal(spell_parent, COMSIG_SPELL_BEFORE_CAST, PROC_REF(handle_precast))
	RegisterSignal(spell_parent, COMSIG_SPELL_CAST, PROC_REF(handle_cast))
	RegisterSignal(spell_parent, COMSIG_SPELL_AFTER_CAST, PROC_REF(react_to_successful_use))

/datum/component/uses_mana/story_spell/UnregisterFromParent()
	. = ..()

	UnregisterSignal(spell_parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(spell_parent, COMSIG_SPELL_CAST)
	UnregisterSignal(spell_parent, COMSIG_SPELL_AFTER_CAST)

	spell_parent = null

// SIGNAL HANDLERS

/**
 * Actions done before the actual cast is called.
 * This is the last chance to cancel the spell from being cast.
 *
 * Can be used for target selection or to validate checks on the caster (cast_on).
 *
 * Returns a bitflag.
 * - SPELL_CANCEL_CAST will stop the spell from being cast.
 * - SPELL_NO_FEEDBACK will prevent the spell from calling [proc/spell_feedback] on cast. (invocation), sounds)
 * - SPELL_NO_IMMEDIATE_COOLDOWN will prevent the spell from starting its cooldown between cast and before after_cast.
 */
/datum/component/uses_mana/story_spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER

	return can_activate_check(TRUE, cast_on)

/datum/component/uses_mana/story_spell/unable_to_activate()
	return SPELL_CANCEL_CAST

/datum/component/uses_mana/story_spell/give_unable_to_activate_feedback(atom/cast_on)
	. = ..()

	to_chat(spell_parent.owner, span_warning("Insufficient mana!"))
/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/datum/component/uses_mana/story_spell/proc/handle_cast(atom/cast_on)
	SIGNAL_HANDLER
	return

/**
 * Actions done after the main cast is finished.
 * This is called after the cooldown's already begun.
 *
 * It can be used to apply late spell effects where order matters
 * (for example, causing smoke *after* a teleport occurs in cast())
 * or to clean up variables or references post-cast.
 */
/datum/component/uses_mana/story_spell/react_to_successful_use(atom/cast_on)
	. = ..()

	var/cost = -get_mana_required()
	var/list/datum/attunement/our_attunements = get_attunement_dispositions()
	for (var/datum/mana_pool/iterated_pool as anything in get_usable_mana(spell_parent.owner))
		var/mult = iterated_pool.get_attunement_mults(our_attunements)
		var/multiplied_cost = (cost*mult)
		cost -= (multiplied_cost)
		cost += iterated_pool.adjust_mana((multiplied_cost))
		if (cost == 0) break
	if (cost != 0)
		stack_trace("cost was not 0 after react_to_successful_use on [src]")
