/mob/proc/get_base_casting_cost()
	return BASE_STORY_MAGIC_CAST_COST_MULT

/mob/living/carbon/get_base_casting_cost()
	. = ..()
	var/obj/held_item = src.get_active_held_item()
	if (!held_item)
		. *= NO_CATALYST_COST_MULT

/datum/component/story_spell
	var/datum/action/cooldown/spell/spell_parent

	can_transfer = FALSE

/datum/component/story_spell/Initialize(var/datum/action/cooldown/spell/our_spell)
	. = ..()

	if (!istype(our_spell))
		return . | COMPONENT_INCOMPATIBLE

/datum/component/story_spell/RegisterWithParent()
	. = ..()

	if (!istype(parent, /datum/action/cooldown/spell))
		qdel(src) // i dont know what to do here tbh
		return . | COMPONENT_INCOMPATIBLE
	spell_parent = parent

	RegisterSignal(spell_parent, COMSIG_SPELL_BEFORE_CAST, .proc/handle_precast)
	RegisterSignal(spell_parent, COMSIG_SPELL_CAST, .proc/handle_cast)
	RegisterSignal(spell_parent, COMSIG_SPELL_AFTER_CAST, .proc/handle_aftercast)

/datum/component/story_spell/UnregisterFromParent()
	. = ..()

	UnregisterSignal(spell_parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(spell_parent, COMSIG_SPELL_CAST)
	UnregisterSignal(spell_parent, COMSIG_SPELL_AFTER_CAST)

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
/datum/component/story_spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER
	return

/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/datum/component/story_spell/proc/handle_cast(atom/cast_on)
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
/datum/component/story_spell/proc/handle_aftercast(atom/cast_on)
	SIGNAL_HANDLER
	return
