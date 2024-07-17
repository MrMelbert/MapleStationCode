#define COMSIG_SPELL_TOUCH_CAN_HIT "spell_touch_can_hit"

/**
 * A preset component for touch spells that use mana
 *
 * These spells require mana to activate (channel into your hand)
 * but does not expend mana until you actually touch someone with it.
 * Addendum: under normal situations cooldown spells like this would get the /spell subtype
 * touch spells are inherently snowflakey, so it gets a snowflakey component.
 */
/datum/component/uses_mana/touch_spell
	can_transfer = FALSE

/datum/component/uses_mana/touch_spell/Initialize(...)
	if (!istype(parent, /datum/action/cooldown/spell/touch))
		return COMPONENT_INCOMPATIBLE

	return ..()

/datum/component/uses_mana/touch_spell/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SPELL_BEFORE_CAST, PROC_REF(handle_precast))
	RegisterSignal(parent, COMSIG_SPELL_TOUCH_CAN_HIT, PROC_REF(can_touch))
	RegisterSignal(parent, COMSIG_SPELL_TOUCH_HAND_HIT, PROC_REF(handle_touch))

/datum/component/uses_mana/touch_spell/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_TOUCH_CAN_HIT)
	UnregisterSignal(parent, COMSIG_SPELL_TOUCH_HAND_HIT)

/datum/component/uses_mana/touch_spell/proc/can_touch(
	datum/action/cooldown/spell/touch/source,
	atom/victim,
	mob/living/carbon/caster,
)
	SIGNAL_HANDLER

	if(source.attached_hand)
		return NONE // de-activating, so don't block it

	return can_activate_with_feedback(TRUE, caster, victim)

/datum/component/uses_mana/touch_spell/proc/handle_touch(
	datum/action/cooldown/spell/touch/source,
	atom/victim,
	mob/living/carbon/caster,
	obj/item/melee/touch_attack/hand,
)
	SIGNAL_HANDLER

	react_to_successful_use(source, victim)

/datum/component/uses_mana/touch_spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER

	var/datum/action/cooldown/spell/parent_spell = parent
	return can_activate_with_feedback(TRUE, parent_spell.owner, cast_on) // TODO: get this up to date

// Override to send a signal we can react to
/datum/action/cooldown/spell/touch/can_hit_with_hand(atom/victim, mob/caster)
	. = ..()
	if(!.)
		return

	if(SEND_SIGNAL(src, COMSIG_SPELL_TOUCH_CAN_HIT, victim, caster) & SPELL_CANCEL_CAST)
		return FALSE

	return TRUE

#undef COMSIG_SPELL_TOUCH_CAN_HIT


