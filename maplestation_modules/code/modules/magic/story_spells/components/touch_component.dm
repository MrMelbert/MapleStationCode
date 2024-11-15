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

/datum/component/uses_mana/touch_spell/Initialize(
	datum/callback/activate_check_failure_callback,
	datum/callback/get_user_callback,
	pre_use_check_with_feedback_comsig = COMSIG_SPELL_BEFORE_CAST,
	pre_use_check_comsig,
	post_use_comsig = COMSIG_SPELL_TOUCH_HAND_HIT,
	datum/callback/mana_required,
	list/datum/attunement/attunements,
)

	..()

	if (!istype(parent, /datum/action/cooldown/spell/touch))
		return COMPONENT_INCOMPATIBLE



/datum/component/uses_mana/touch_spell/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_SPELL_TOUCH_CAN_HIT, PROC_REF(can_touch))

/datum/component/uses_mana/touch_spell/UnregisterFromParent()
	..()
	UnregisterSignal(parent, COMSIG_SPELL_TOUCH_CAN_HIT)

/datum/component/uses_mana/touch_spell/proc/can_touch(
	datum/action/cooldown/spell/touch/source,
	atom/victim,
	mob/living/carbon/caster,
)
	SIGNAL_HANDLER

	if(source.attached_hand)
		return NONE // de-activating, so don't block it

	return

// Override to send a signal we can react to
/datum/action/cooldown/spell/touch/can_hit_with_hand(atom/victim, mob/caster)
	. = ..()
	if(!.)
		return

	if(SEND_SIGNAL(src, COMSIG_SPELL_TOUCH_CAN_HIT, victim, caster) & SPELL_CANCEL_CAST)
		return FALSE

	return TRUE

#undef COMSIG_SPELL_TOUCH_CAN_HIT
