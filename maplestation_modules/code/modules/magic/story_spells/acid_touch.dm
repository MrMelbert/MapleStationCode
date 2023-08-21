/datum/component/uses_mana/story_spell/touch/acid_touch
	/// Attunement modifier for Earth attunement
	var/acid_touch_attunement_amount = 0.5
	/// Base mana cost
	var/acid_touch_cost = 50
	/// Multiplier applied to cost when casting on turfs
	var/turf_cost_multiplier = 0.25
	/// Multiplier applied to cost when casting on objects
	var/obj_cost_multiplier = 0.5

/datum/component/uses_mana/story_spell/touch/acid_touch/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/earth] += acid_touch_attunement_amount

/datum/component/uses_mana/story_spell/touch/acid_touch/get_mana_required(atom/caster, atom/cast_on, ...)
	var/datum/action/cooldown/spell/touch/acid_touch/spell = parent
	var/final_cost = acid_touch_cost
	final_cost *= ..() // default multiplier
	if(isturf(cast_on))
		final_cost *= max(1, spell.turf_modifier * turf_cost_multiplier) // so it's not a skeleton key
	if(isobj(cast_on))
		final_cost *= max(1, spell.obj_modifier * obj_cost_multiplier) // to make it harder to destroy items
	return final_cost

/datum/action/cooldown/spell/touch/acid_touch
	name = "Acid Touch"
	desc = "Empower your fingers with a sticky acid, melting anything you touch. \
		Right click to use on walls or floors."
	button_icon_state = "transformslime"
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

	/// Modifier to power and volume applied to aciding objects
	var/obj_modifier = 2.5
	/// Modifier to power and volume applied to aciding turfs
	var/turf_modifier = 10

/datum/action/cooldown/spell/touch/acid_touch/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/touch/acid_touch)

/datum/action/cooldown/spell/touch/acid_touch/is_valid_target(atom/cast_on)
	return TRUE

/datum/action/cooldown/spell/touch/acid_touch/cast_on_secondary_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isturf(victim))
		// it takes 200 acid power and like 400 acid volume to melt a normal iron wall
		return victim.acid_act(max(slap_power * turf_modifier, ACID_POWER_MELT_TURF), max(slap_volume * turf_modifier, 400)) \
			? SECONDARY_ATTACK_CONTINUE_CHAIN \
			: SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return SECONDARY_ATTACK_CALL_NORMAL

/datum/action/cooldown/spell/touch/acid_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	if(isturf(victim))
		return FALSE

	if(isobj(victim))
		return victim.acid_act(slap_power * obj_modifier, slap_volume * obj_modifier)

	return victim.acid_act(slap_power, slap_volume)

/obj/item/melee/touch_attack/acid_touch
	name = "\improper acid touch"
	desc = "The opposite of the Midas touch."
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"
	color = COLOR_PALE_GREEN_GRAY
