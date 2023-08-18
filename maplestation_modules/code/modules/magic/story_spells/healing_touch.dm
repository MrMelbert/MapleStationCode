/datum/component/uses_mana/story_spell/touch/healing_touch
	var/healing_touch_attunement_amount = 0.5
	var/healing_touch_cost_per_healed = 1.5

/datum/component/uses_mana/story_spell/touch/healing_touch/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/life] += healing_touch_attunement_amount

/datum/component/uses_mana/story_spell/touch/healing_touch/get_mana_required(atom/caster, atom/cast_on, ...)
	var/datum/action/cooldown/spell/touch/healing_touch/touch_spell = parent
	return ..() \
		* (touch_spell.brute_heal + touch_spell.burn_heal + touch_spell.tox_heal + touch_spell.oxy_heal + touch_spell.pain_heal * 3) \
		* healing_touch_cost_per_healed

/datum/action/cooldown/spell/touch/healing_touch
	name = "Healing Touch"
	desc = "Lay your hands on a living target to heal them."
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "blessed"
	sound = 'sound/magic/staff_healing.ogg'

	school = SCHOOL_RESTORATION // or SCHOOL_HOLY
	cooldown_time = 1 MINUTES
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	invocation = "Sana manu!"
	invocation_type = INVOCATION_WHISPER

	hand_path = /obj/item/melee/touch_attack/healing_touch

	/// How much brute damage to heal.
	var/brute_heal = 10
	/// How much burn damage to heal.
	var/burn_heal = 10
	/// How much toxin damage to heal.
	var/tox_heal = 0
	/// How much oxygen damage to heal.
	var/oxy_heal = 0
	/// How much pain to heal, applies to all bodyparts
	var/pain_heal = 4

/datum/action/cooldown/spell/touch/healing_touch/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/touch/healing_touch)

/datum/action/cooldown/spell/touch/healing_touch/is_valid_target(atom/cast_on)
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/living_cast_on = cast_on
	if(living_cast_on.stat == DEAD)
		return FALSE // can't heal the dead
	if(living_cast_on.mob_biotypes & (MOB_UNDEAD|MOB_SPIRIT))
		return FALSE // can't heal the (un)dead
	if(living_cast_on.mob_biotypes & MOB_ORGANIC)
		return TRUE // CAN heal the organic

	// everyone else need not apply (robots, golems, whatever)
	return FALSE

/datum/action/cooldown/spell/touch/healing_touch/cast_on_hand_hit(obj/item/melee/touch_attack/hand, mob/living/victim, mob/living/carbon/caster)
	// Brute and burn damage have a little conversion thing going on
	// where if someone is healed for more than they need, the excess is converted to the other damage type.
	// I'm not bothering to do this for toxin and oxygen out of thematics and laziness
	// (Healing touch = touches your skin, not your lungs or stomach or liver)
	var/final_brute_heal = brute_heal
	var/final_burn_heal = burn_heal

	var/target_brute = victim.getBruteLoss()
	var/target_burn = victim.getFireLoss()

	// (This can result in us *gaining* net healing if both values are below each other, but this is fine,
	// becuase the mob's health will be low enough such that it'll be full healed regardless)
	if(target_brute < brute_heal)
		final_burn_heal += (brute_heal - target_brute)
	if(target_burn < burn_heal)
		final_brute_heal += (burn_heal - target_burn)

	var/starting_health = victim.health
	var/starting_pain = victim.pain_controller?.get_average_pain()

	victim.adjustBruteLoss(-1 * final_brute_heal, updating_health = FALSE, forced = TRUE, required_bodytype = BODYTYPE_ORGANIC)
	victim.adjustFireLoss(-1 * final_burn_heal, updating_health = FALSE, forced = TRUE, required_bodytype = BODYTYPE_ORGANIC)
	victim.adjustToxLoss(-1 * tox_heal, updating_health = FALSE, forced = TRUE, required_biotype = MOB_ORGANIC)
	victim.adjustOxyLoss(-1 * oxy_heal, updating_health = FALSE, forced = TRUE, required_biotype = MOB_ORGANIC)
	victim.cause_pain(BODY_ZONES_ALL, -1 * pain_heal)
	victim.updatehealth()

	if(victim.health == starting_health && victim.pain_controller?.get_average_pain() == starting_pain)
		return FALSE

	new /obj/effect/temp_visual/heal(victim.loc, LIGHT_COLOR_HOLY_MAGIC)
	return TRUE

/obj/item/melee/touch_attack/healing_touch
	name = "\improper healing touch"
	desc = "Take all my strength into you and be whole once more!"
	icon = 'icons/obj/weapons/hand.dmi'
	icon_state = "duffelcurse"
	inhand_icon_state = "duffelcurse"
	color = LIGHT_COLOR_HOLY_MAGIC

/obj/item/melee/touch_attack/healing_touch/Initialize(mapload, datum/action/cooldown/spell/spell)
	. = ..()
	var/mob/living/carbon/caster = loc
	if(!istype(caster) || caster.usable_hands <= 1 || caster.get_num_held_items() > 0)
		return
	AddComponent(/datum/component/two_handed, require_twohands = TRUE)

// I'm putting this override on the touch itself instead of hooking a signal so I can  via doafter, sue me
/obj/item/melee/touch_attack/healing_touch/attack(mob/target, mob/living/carbon/user)
	. = ..()
	if(.)
		return TRUE

	var/datum/action/cooldown/spell/touch/healing_touch/touch = spell_which_made_us?.resolve()
	if(!touch?.can_hit_with_hand(target, user))
		return TRUE // cancel attack chain
	if(DOING_INTERACTION(user, REF(src)))
		return TRUE // cancel attack chain

	var/hand_or_hands = HAS_TRAIT(src, TRAIT_WIELDED) ? "hands" : "hand"

	user.visible_message(
		span_notice("[user] lays [user.p_their()] [hand_or_hands] on [target]..."),
		span_notice("You lay your [hand_or_hands] on [target]..."),
		vision_distance = COMBAT_MESSAGE_RANGE,
	)
	if(!do_after(user, 3 SECONDS, target, interaction_key = REF(src)))
		return TRUE // cancel attack chain

	user.visible_message(
		span_green("[user]'s [hand_or_hands] glow a brilliant yellow light!"),
		span_green("Your [hand_or_hands] glow a brilliant yellow light!"),
	)
	return FALSE // go to after attack (cast)
