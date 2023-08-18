/datum/component/uses_mana/story_spell/finger_flame
	var/flame_cost = 5 // very cheap, it's just a lighter
	var/flame_attunement = 0.2 // flame users make this EVEN cheaper

/datum/component/uses_mana/story_spell/finger_flame/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SPELL_BEFORE_CAST, PROC_REF(handle_precast))
	RegisterSignal(parent, COMSIG_SPELL_CAST, PROC_REF(handle_cast))

/datum/component/uses_mana/story_spell/finger_flame/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_SPELL_BEFORE_CAST)
	UnregisterSignal(parent, COMSIG_SPELL_CAST)

/datum/component/uses_mana/story_spell/finger_flame/get_attunement_dispositions()
	. = ..()
	.[/datum/attunement/fire] = flame_attunement

/datum/component/uses_mana/story_spell/finger_flame/get_mana_required(atom/caster, atom/cast_on, ...)
	return ..() * flame_cost

/datum/component/uses_mana/story_spell/finger_flame/handle_precast(datum/action/cooldown/spell/touch/finger_flame/source, atom/cast_on)
	if(source.attached_hand)
		return NONE
	return ..()

/datum/component/uses_mana/story_spell/finger_flame/handle_cast(datum/action/cooldown/spell/source, atom/cast_on)
	// this drains mana "on cast", and not on "touch spell hit" or "on after cast", unlike the touch spell component.
	// whichs means it uses mana when the flame / hand is CREATED instead of used
	react_to_successful_use(source, cast_on)

/datum/action/cooldown/spell/touch/finger_flame
	name = "Finger Flame"
	desc = "With a snap, conjures a low flame at the tip of your fingers - just enough to light a cigarette."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "spark"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED
	school = SCHOOL_CONJURATION // can also be SCHOOL_EVOCATION
	cooldown_time = 2 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	hand_path = /obj/item/lighter/finger
	draw_message = null
	drop_message = null
	can_cast_on_self = TRUE // self burn

	// I was considering giving this the same "trigger on snap emote" effect that the arm implant has,
	// but considering this has a tangible cost (mana) while the arm implant is free, I decided against it.

/datum/action/cooldown/spell/touch/finger_flame/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/finger_flame)

/datum/action/cooldown/spell/touch/finger_flame/can_cast_spell(feedback)
	return ..() && !HAS_TRAIT(owner, TRAIT_EMOTEMUTE) // checked as if it were an emote invocation spell

/datum/action/cooldown/spell/touch/finger_flame/is_valid_target(atom/cast_on)
	return ismovable(cast_on)

/datum/action/cooldown/spell/touch/finger_flame/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	return TRUE // essentially, if we touch something with the flame it goes away.

/datum/action/cooldown/spell/touch/finger_flame/create_hand(mob/living/carbon/cast_on)
	cast_on.emote("snap")
	cast_on.visible_message(
		span_rose("With a snap, <b>[cast_on]</b> conjures a flickering flame at the tip of [cast_on.p_their()] finger."),
		span_rose("With a snap, you conjure a flickering flame at the tip of your finger."),
	)
	. = ..()
	if(!.)
		return
	var/obj/item/lighter/finger/lighter = attached_hand
	lighter.name = "finger flame"
	lighter.set_lit(TRUE)

/datum/action/cooldown/spell/touch/finger_flame/remove_hand(mob/living/hand_owner, reset_cooldown_after)
	if(QDELETED(src) || QDELETED(hand_owner))
		return ..()

	var/obj/item/lighter/finger/lighter = attached_hand
	lighter.set_lit(FALSE) // not strictly necessary as we qdel, but for the sound fx
	if(reset_cooldown_after)
		hand_owner.emote("snap")
		hand_owner.visible_message(
			span_rose("<b>[hand_owner]</b> dispels the flame with another snap."),
			span_rose("You dispel the flame with another snap."),
		)
	return ..()
