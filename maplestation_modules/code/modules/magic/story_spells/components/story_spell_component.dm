// its been decided to genericize this for further use. free MaplePoints :tm: if you can perfectly genercize uses_mana without needing boiler plate
// this is used for action/cooldown spells that don't need any special functionality
// if you want to say, make a sword that uses mana, just use the basetype
/datum/component/uses_mana/spell
	can_transfer = FALSE

/datum/component/uses_mana/spell/Initialize(...)
	. = ..()

	if (!istype(parent, /datum/action/cooldown/spell))
		return . | COMPONENT_INCOMPATIBLE

/datum/component/uses_mana/spell/RegisterWithParent()
	. = ..()

	RegisterSignal(parent, COMSIG_SPELL_BEFORE_CAST, PROC_REF(handle_precast))
	RegisterSignal(parent, COMSIG_SPELL_CAST, PROC_REF(handle_cast))
	RegisterSignal(parent, COMSIG_SPELL_AFTER_CAST, PROC_REF(react_to_successful_use))

/datum/component/uses_mana/spell/UnregisterFromParent()
	. = ..()

	UnregisterSignal(parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_AFTER_CAST)

/* /datum/component/uses_mana/spell/give_unable_to_activate_feedback(atom/cast_on)
	. = ..()
	var/datum/action/cooldown/spell/spell_parent = parent

	spell_parent.owner.balloon_alert(spell_parent.owner, "insufficient mana!") */ // should be redundant, holding onto till pr completion

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
/datum/component/uses_mana/spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER

	var/datum/action/cooldown/spell/parent_spell = parent
	return can_activate_with_feedback(TRUE, parent_spell.owner, cast_on) // todo get this up to date

/datum/component/uses_mana/spell/can_activate_check_failure(give_feedback, ...)
	. = ..()
	return . | SPELL_CANCEL_CAST

/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/datum/component/uses_mana/spell/proc/handle_cast(atom/cast_on)
	SIGNAL_HANDLER
	return
