// mana sense, a roundstart spell that lets you sense mana on a target, on a cooldown
/datum/action/cooldown/spell/pointed/mana_sense
	name = "Mana Sense"
	desc = "Attempt to read the mana contained with in a creature or object \
	requires no mana to use, but will take you a few seconds to readjust after use. \ "
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "quantum_sparks"
	sound = 'sound/effects/magic.ogg'

	cooldown_time = 25 SECONDS
	spell_requirements = NONE

	school = SCHOOL_UNSET
	antimagic_flags = MAGIC_RESISTANCE

	cast_range = 4

/datum/action/cooldown/spell/pointed/mana_sense/is_valid_target(atom/movable/cast_on)
	if (isturf(cast_on))
		return FALSE
	if (!cast_on.mana_pool)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/pointed/mana_sense/before_cast(atom/movable/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return .
	var/mob/caster = usr || owner
	if(DOING_INTERACTION(caster, REF(src)))
		return . | SPELL_CANCEL_CAST

	if(!is_valid_target(cast_on))
		caster.balloon_alert(caster, "invalid target!")
		return . | SPELL_CANCEL_CAST

	if(!do_after( // this was copied from soothe, feeling like keeping this here so lenses and mana sense both have reasons to use both
		user = caster,
		delay = 1 SECONDS,
		target = cast_on,
		timed_action_flags = IGNORE_TARGET_LOC_CHANGE|IGNORE_HELD_ITEM|IGNORE_SLOWDOWNS,
		extra_checks = CALLBACK(src, PROC_REF(block_cast), caster, cast_on), \
		interaction_key = REF(src), \
	))
		. |= SPELL_CANCEL_CAST

	return .

/datum/action/cooldown/spell/pointed/mana_sense/proc/block_cast(mob/living/caster, mob/living/cast_on)
	if(QDELETED(src) || QDELETED(caster) || QDELETED(cast_on))
		return FALSE
	if(!is_valid_target(cast_on))
		caster.balloon_alert(caster, "invalid target!")
		return FALSE
	if(get_dist(cast_on, caster) > cast_range)
		caster.balloon_alert(caster, "out of range!")
		return FALSE

	return TRUE

/datum/action/cooldown/spell/pointed/mana_sense/cast(atom/movable/cast_on)
	. = ..()
	var/mob/caster = usr || owner
	caster.balloon_alert(caster, "mana amount: [cast_on.mana_pool.amount]")
