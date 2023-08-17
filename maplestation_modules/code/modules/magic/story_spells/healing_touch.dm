/datum/component/uses_mana/story_spell/touch/healing_touch
	var/healing_touch_attunement_amount = 0.5
	var/healing_touch_cost_per_healed = 4

/datum/component/uses_mana/story_spell/touch/healing_touch/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/life] += healing_touch_attunement_amount

/datum/component/uses_mana/story_spell/touch/healing_touch/get_mana_required(...)
	var/datum/action/cooldown/spell/touch/healing_touch/touch_spell = parent
	return ..() * (touch_spell.brute_heal + touch_spell.burn_heal + touch_spell.tox_heal + touch_spell.oxy_heal) * healing_touch_cost_per_healed

/datum/action/cooldown/spell/touch/healing_touch
	name = "Healing Touch"
	desc = "Lay your hands on a target to heal them."
	sound = 'sound/magic/staff_healing.ogg'

	school = SCHOOL_RESTORATION // or SCHOOL_HOLY
	cooldown_time = 1 MINUTES
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	invocation = "Victus sano!"
	invocation_type = INVOCATION_WHISPER

	hand_path = /obj/item/melee/touch_attack/healing_touch

	/// How much brute damage to heal.
	var/brute_heal = 5
	/// How much burn damage to heal.
	var/burn_heal = 5
	/// How much toxin damage to heal.
	var/tox_heal = 0
	/// How much oxygen damage to heal.
	var/oxy_heal = 0

/datum/action/cooldown/spell/touch/healing_touch/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/touch/healing_touch)

/datum/action/cooldown/spell/touch/healing_touch/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/touch/healing_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	victim.adjustBruteLoss(brute_heal, FALSE)
	victim.adjustFireLoss(burn_heal, FALSE)
	victim.adjustToxLoss(tox_heal, FALSE, TRUE)
	victim.adjustOxyLoss(oxy_heal, FALSE)
	victim.updatehealth()
	new /obj/effect/temp_visual/heal(victim.loc, LIGHT_COLOR_HOLY_MAGIC)
	return TRUE

/obj/item/melee/touch_attack/healing_touch
	name = "\improper healing touch"
	desc = "Banish the shadows!"
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"
	color = LIGHT_COLOR_HOLY_MAGIC

	var/hands_plural = FALSE

/obj/item/melee/touch_attack/healing_touch/Initialize(mapload, datum/action/cooldown/spell/spell)
	. = ..()
	var/mob/living/carbon/caster = loc
	if(!istype(caster) || caster.usable_hands <= 1 || caster.get_num_held_items() > 0)
		return
	AddComponent(/datum/component/two_handed, require_twohands = TRUE)
	hands_plural = TRUE

/obj/item/melee/touch_attack/healing_touch/attack(mob/target, mob/living/carbon/user)
	. = ..()
	if(.)
		return TRUE
	if(target == user)
		return TRUE
	if(DOING_INTERACTION(user, REF(src)))
		return TRUE // cancel attack chain

	var/hand_or_hands = (hands_plural && user.usable_hands > 1) ? "hands" : "hand"

	user.visible_message(span_notice("[user] lays [user.p_their()] [hand_or_hands] on [target]..."), span_notice("You lay your [hand_or_hands] on [target]..."), vision_distance = COMBAT_MESSAGE_RANGE)
	if(!do_after(user, 3 SECONDS, target, interaction_key = REF(src)))
		return TRUE // cancel attack chain

	user.visible_message(span_green("[user]'s [hand_or_hands] glow a brilliant yellow light!"), span_green("Your [hand_or_hands] glow a brilliant yellow light!"))
	return FALSE // go to after attack (cast)
