// this is basically only used to cut down on boilerplate.
// all that remains is stuff that has to be on the spell itself to work (checking for mana cost, attunements, some of the callbacks)
// i'll provide a sample block so this file can be a "tutorial IG"
/datum/component/uses_mana/spell
	can_transfer = FALSE

/datum/component/uses_mana/spell/Initialize(
	datum/callback/activate_check_failure_callback,
	datum/callback/get_user_callback,
	pre_use_check_with_feedback_comsig = COMSIG_SPELL_BEFORE_CAST,
	pre_use_check_comsig,
	post_use_comsig = COMSIG_SPELL_AFTER_CAST,
	datum/callback/mana_required,
	list/datum/attunement/attunements
	)
	. = ..()

	if (!istype(parent, /datum/action/cooldown/spell))
		return . | COMPONENT_INCOMPATIBLE

/* sample tutorial block. plus explanations.

/datum/action/cooldown/spell/ourspell/New(Target, original)
	. = ..()

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_X] += SPELL_X_ATTUNEMENT // define the numeric value you want for the attunement ideally at the top, it is the value you want the spell's cost to be multiplied (done using decimals since its supposed to be a discount) by when the user is correctly attunned..
		replace the "X" with what element you want, such as "light". Replace "SPELL" with the name of your spell.

	AddComponent(/datum/component/uses_mana/spell, \ // the two main signals are pre-defined in uses_mana/spell so you don't have to copy paste it. everything here needs to be in the init since its on the spell itself.
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \ // this is defined on datum/action/cooldown/spell and just sends the signal used to cancel casting. must be in this define.
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \ // "get_owner" is a proc on datum/action/ and must be defined in "the block"
		mana_required = mana_cost, \ // mana_cost is defined on the spell datum action, set it to a variable at the top ideally. if you want fancier stuff, see the next line:
		mana_required = CALLBACK(src, PROC_REF(get_mana_consumed)), \ // obviously only ever set mana required ONCE, but this is an example of what you want to do if you want to do a variable cost system, define the proc for this on the spell itself.
		attunements = attunements, \ // see above. you can just copy paste this to every instance, if you don't want attunements just don't add this block or the two lines outside the add component
	)

	heres a sample callback for get mana required, taken from healing touch.

	/datum/action/cooldown/spell/touch/healing_touch/proc/get_mana_consumed(atom/caster, atom/cast_on, ...)
	return (brute_heal + burn_heal + tox_heal + oxy_heal + pain_heal * 3) \ // instead this will calculate your cost based on how much it heals. whenever it wants to check the mana cost value, it'll defer to this proc.
		* mana_cost
*/
// this should be the only thing left lmfao, the rest is going to be held till the end
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
/* /datum/component/uses_mana/spell/RegisterWithParent()
	. = ..()

	RegisterSignal(parent, COMSIG_SPELL_BEFORE_CAST, PROC_REF(handle_precast))
	RegisterSignal(parent, COMSIG_SPELL_CAST, PROC_REF(handle_cast))
	RegisterSignal(parent, COMSIG_SPELL_AFTER_CAST, PROC_REF(react_to_successful_use)) */

/* /datum/component/uses_mana/spell/UnregisterFromParent()
	. = ..()

	UnregisterSignal(parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_AFTER_CAST) */

/* /datum/component/uses_mana/spell/give_unable_to_activate_feedback(atom/cast_on)
	. = ..()
	var/datum/action/cooldown/spell/spell_parent = parent

	spell_parent.owner.balloon_alert(spell_parent.owner, "insufficient mana!") */ // should be redundant, holding onto till pr completion

// SIGNAL HANDLERS


/* /datum/component/uses_mana/spell/proc/handle_precast(atom/cast_on)
	SIGNAL_HANDLER
	return can_activate_with_feedback() */ // todo get this up to date
	//can_activate_with_feedback(TRUE, parent_spell.owner, cast_on)
	//var/datum/action/cooldown/spell/parent_spell = parent



/**
 * Actions done as the main effect of the spell.
 *
 * For spells without a click intercept, [cast_on] will be the owner.
 * For click spells, [cast_on] is whatever the owner clicked on in casting the spell.
 */
/* /datum/component/uses_mana/spell/proc/handle_cast(atom/cast_on)
	SIGNAL_HANDLER
	return

/datum/component/uses_mana/spell/proc/get_mana_required_spell(atom/caster, atom/cast_on, ...)
	if(ismob(caster))
		var/mob/caster_mob = caster
		return caster_mob.get_casting_cost_mult()
	return 1 */
