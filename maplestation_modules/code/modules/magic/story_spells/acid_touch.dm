/datum/component/uses_mana/story_spell/touch/acid_touch
	var/acid_touch_attunement_amount = 0.5
	var/acid_touch_cost = 50

/datum/component/uses_mana/story_spell/touch/acid_touch/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/earth] += acid_touch_attunement_amount

/datum/component/uses_mana/story_spell/touch/acid_touch/get_mana_required(atom/caster, atom/cast_on, ...)
	var/final_cost = acid_touch_cost
	final_cost *= ..() // default multiplier
	if(isturf(cast_on))
		final_cost *= 2 // 2x cost for aciding turfs, so it's not a skeleton key
	if(isobj(cast_on))
		final_cost *= 1.5 // 1.5x cost for aciding objects, to make it harder to destroy items
	return final_cost

/datum/action/cooldown/spell/touch/acid_touch
	name = "Acid Touch"
	desc = "Empower your fingers with a sticky acid, melting anything you touch. \
		Right click to use on walls or floors."
	sound = 'sound/weapons/sear.ogg'

	school = SCHOOL_EVOCATION
	cooldown_time = 1 MINUTES
	invocation = "Ac rid!"
	invocation_type = INVOCATION_SHOUT
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	hand_path = /obj/item/melee/touch_attack/acid_touch
	can_cast_on_self = TRUE

	/// Acid power of the slap, 2.5x against objects and 5x against turfs
	var/slap_power = 20
	/// Acid volume of the slap, 2x against objects and 4x against turfs
	var/slap_volume = 50

/datum/action/cooldown/spell/touch/acid_touch/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/touch/acid_touch)

/datum/action/cooldown/spell/touch/acid_touch/is_valid_target(atom/cast_on)
	return TRUE

/datum/action/cooldown/spell/touch/acid_touch/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isturf(victim))
		return victim.acid_act(slap_power * 5, slap_volume * 4) ? SECONDARY_ATTACK_CONTINUE_CHAIN : SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/datum/action/cooldown/spell/touch/acid_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isturf(victim))
		return FALSE

	if(isobj(victim))
		return victim.acid_act(slap_power * 2.5, slap_volume * 2)

	return victim.acid_act(slap_power, slap_volume)

/obj/item/melee/touch_attack/acid_touch
	name = "\improper acid touch"
	desc = "The opposite of the Midas touch."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"
	color = COLOR_PALE_GREEN_GRAY
