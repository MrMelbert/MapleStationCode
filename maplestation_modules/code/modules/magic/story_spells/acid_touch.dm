/datum/component/uses_mana/story_spell/touch/acid_touch
	var/acid_touch_attunement_amount = 0.5
	var/acid_touch_cost = 50

/*
/datum/component/uses_mana/story_spell/touch/acid_touch/get_attunement_dispositions()
	. = ..()
	.[MAGIC_ELEMENT_POISON] += attunement_amount
*/

/datum/component/uses_mana/story_spell/touch/acid_touch/get_mana_required(...)
	return ..() * acid_touch_cost

/datum/action/cooldown/spell/touch/acid_touch
	name = "Acid Touch"
	desc = "Empower your fingers with a sticky acid, melting anything you touch. \
		Right click to use on walls or floors."
	sound = 'sound/weapons/sear.ogg'

	school = SCHOOL_TRANSMUTATION
	cooldown_time = 1 MINUTES

	hand_path = /obj/item/melee/touch_attack/acid_touch

	/// Acid power of the slap, doubled against turfs
	var/slap_power = 10
	/// Acid volume of the slap, doubled against turfs
	var/slap_volume = 50

/datum/action/cooldown/spell/touch/acid_touch/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/touch/acid_touch)

/datum/action/cooldown/spell/touch/acid_touch/is_valid_target(atom/cast_on)
	return TRUE

/datum/action/cooldown/spell/touch/acid_touch/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isturf(victim))
		return victim.acid_act(slap_power * 2, slap_volume * 2) ? SECONDARY_ATTACK_CONTINUE_CHAIN : SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/datum/action/cooldown/spell/touch/acid_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isturf(victim))
		return FALSE

	return victim.acid_act(slap_power, slap_volume)

/obj/item/melee/touch_attack/acid_touch
	name = "\improper acid touch"
	desc = "The opposite of the Midas touch."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"
	color = COLOR_PALE_GREEN_GRAY
