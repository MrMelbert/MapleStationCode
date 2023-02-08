/// The base component to be applied to all spells that interact with the mana system.
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

	spell_parent = null

/datum/component/story_spell/proc/can_cast(mana_needed = get_mana_needed_for_cast(), available_mana = get_available_mana())
	if (available_mana < mana_needed)
		return FALSE
	return TRUE

/// This MUST be overridden if the spell uses any mana, ever.
/datum/component/story_spell/proc/get_mana_needed_for_cast()
	return 0

/// Should return all mana readily available to the caster.
/// TODO: Deprecate later, we will stop using raw numeric values and start using mana datums, similar to gas mixtures.
/// Said mana datums will have things like attunement that will increase/decrease efficiency of using that mana
/// If a spell has an attunement for/against it's attunements.
/datum/component/story_spell/proc/get_available_mana()
	return SSmagic.get_available_mana()
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
/datum/component/story_spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER

	if (!can_cast()) // TODO: Maybe make this return a bitflag so we know why it failed/succeeded?
		return handle_can_cast_failure(cast_on)

/datum/component/story_spell/proc/handle_can_cast_failure(atom/cast_on)
	to_chat(spell_parent.owner, span_warning("Insufficient mana!")) //placeholder
	return SPELL_CANCEL_CAST

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
	adjust_mana(cast_on)
	return

/datum/component/story_spell/proc/adjust_mana(atom/cast_on)
	return
