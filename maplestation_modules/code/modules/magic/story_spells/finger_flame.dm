// This doesn't use the touch spell component because we use mana on activation rather than touch.
/datum/component/uses_mana/story_spell/finger_flame
	var/flame_cost = 5 // very cheap, it's just a lighter
	var/flame_attunement = 0.2 // flame users make this EVEN cheaper

	/// You get some seconds of freecasting to prevent spam.
	COOLDOWN_DECLARE(free_use_cooldown)

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
	return COOLDOWN_FINISHED(src, free_use_cooldown) ? 0 : (..() * flame_cost)

/datum/component/uses_mana/story_spell/finger_flame/handle_precast(datum/action/cooldown/spell/touch/finger_flame/source, atom/cast_on)
	if(source.attached_hand)
		return NONE
	return ..()

/datum/component/uses_mana/story_spell/finger_flame/handle_cast(datum/action/cooldown/spell/source, atom/cast_on)
	// this drains mana "on cast", and not on "touch spell hit" or "on after cast", unlike the touch spell component.
	// whichs means it uses mana when the flame / hand is CREATED instead of used
	react_to_successful_use(source, cast_on)

/datum/component/uses_mana/story_spell/finger_flame/react_to_successful_use(datum/action/cooldown/spell/source, atom/cast_on)
	. = ..()
	COOLDOWN_START(src, free_use_cooldown, 4 SECONDS)

// All this spell does is give you a lighter on demand.
/datum/action/cooldown/spell/touch/finger_flame
	name = "Free Finger Flame"
	desc = "With a snap, conjures a low flame at the tip of your fingers - just enough to light a cigarette."
	button_icon = 'maplestation_modules/icons/mob/actions/actions_cantrips.dmi'
	button_icon_state = "spark"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_HANDS_BLOCKED
	school = SCHOOL_CONJURATION // can also be SCHOOL_EVOCATION
	cooldown_time = 2 SECONDS
	invocation_type = INVOCATION_NONE
	spell_requirements = NONE

	hand_path = /obj/item/lighter/finger/magic
	draw_message = null
	drop_message = null
	can_cast_on_self = TRUE // self burn

	// I was considering giving this the same "trigger on snap emote" effect that the arm implant has,
	// but considering this has a tangible cost (mana) while the arm implant is free, I decided against it.

/datum/action/cooldown/spell/touch/finger_flame/can_cast_spell(feedback)
	return ..() && !HAS_TRAIT(owner, TRAIT_EMOTEMUTE) // checked as if it were an emote invocation spell

/datum/action/cooldown/spell/touch/finger_flame/is_valid_target(atom/cast_on)
	return ismovable(cast_on)

/datum/action/cooldown/spell/touch/finger_flame/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster)
	return TRUE // essentially, if we touch something with the flame it goes away.

/datum/action/cooldown/spell/touch/finger_flame/proc/do_snap(mob/living/carbon/cast_on)
	set waitfor = FALSE
	cast_on.emote("snap")
	cast_on.visible_message(
		span_rose("With a snap, <b>[cast_on]</b> conjures a flickering flame at the tip of [cast_on.p_their()] finger."),
		span_rose("With a snap, you conjure a flickering flame at the tip of your finger."),
	)

/datum/action/cooldown/spell/touch/finger_flame/proc/do_unsnap(mob/living/carbon/old_cast_on)
	set waitfor = FALSE
	old_cast_on.emote("snap")
	old_cast_on.visible_message(
		span_rose("<b>[old_cast_on]</b> dispels the flame with another snap."),
		span_rose("You dispel the flame with another snap."),
	)

/datum/action/cooldown/spell/touch/finger_flame/create_hand(mob/living/carbon/cast_on)
	do_snap(cast_on)
	. = ..()
	if(!.)
		return
	var/obj/item/lighter/finger/lighter = attached_hand
	lighter.set_lit(TRUE)

/datum/action/cooldown/spell/touch/finger_flame/remove_hand(mob/living/hand_owner, reset_cooldown_after)
	if(QDELETED(src) || QDELETED(hand_owner) || QDELETED(attached_hand))
		return ..()

	var/obj/item/lighter/finger/lighter = attached_hand
	lighter.set_lit(FALSE) // not strictly necessary as we qdel, but for the sound fx
	if(reset_cooldown_after)
		do_unsnap(hand_owner)
	return ..()

/datum/action/cooldown/spell/touch/finger_flame/mana
	name = "Finger Flame"

/datum/action/cooldown/spell/touch/finger_flame/mana/New(Target, original)
	. = ..()
	AddComponent(/datum/component/uses_mana/story_spell/finger_flame)
	desc += " Costs mana to conjure, but is free to maintain."

/datum/action/cooldown/spell/touch/finger_flame/lizard
	name = "Breathe Small Flame"
	desc = "Muster all you can to breathe a small mote of fire - just strong enough to light a cigarette. \
		Requires you consume an accelerant, such as alcohol, welding fuel, or plasma to fuel the flame. \
		Stronger accelerants require you consume less reagents."

	button_icon = 'maplestation_modules/icons/obj/magic_particles.dmi'
	button_icon_state = "fire-on"
	school = SCHOOL_UNSET

	cooldown_time = 5 SECONDS

	hand_path = /obj/item/lighter/flame

	/// Assoc list of [possible accelerant] to [how much of it is required to cast the spell]
	var/static/list/required_accelerant = list(
		/datum/reagent/consumable/ethanol = 8,
		/datum/reagent/napalm = 4,
		/datum/reagent/fuel = 4,
		/datum/reagent/toxin/plasma = 4,
		/datum/reagent/phlogiston = 2,
		/datum/reagent/hellwater = 2,
		/datum/reagent/toxin/spore_burning = 2,
		/datum/reagent/clf3 = 1,
	)

/datum/action/cooldown/spell/touch/finger_flame/lizard/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	// We have to have some lungs (to breathe), a stomach (to hold the accelerant) and a head (to breathe the flame)
	var/mob/living/carbon/caster = owner
	if(HAS_TRAIT_NOT_FROM(caster, TRAIT_NOBREATH, SPECIES_TRAIT) && !caster.get_organ_slot(ORGAN_SLOT_LUNGS))
		if(feedback)
			to_chat(caster, span_warning("You try to muster a flame, but you can't breathe!"))
		return FALSE

	if(!caster.get_organ_slot(ORGAN_SLOT_STOMACH))
		if(feedback)
			to_chat(caster, span_warning("You try to muster a flame, but you can't feel your stomach!"))
		return FALSE

	if(!caster.get_bodypart(BODY_ZONE_HEAD))
		if(feedback)
			to_chat(caster, span_warning("You try to muster a flame, but you don't exactly have a mouth, do you?"))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/touch/finger_flame/lizard/do_snap(mob/living/carbon/cast_on)
	cast_on.visible_message(
		span_rose("<b>[cast_on]</b> inhales, and musters a flame in [cast_on.p_their()] mouth."),
		span_rose("With an inhale, you muster a flame in your mouth."),
	)

/datum/action/cooldown/spell/touch/finger_flame/lizard/do_unsnap(mob/living/carbon/old_cast_on)
	old_cast_on.visible_message(
		span_rose("<b>[old_cast_on]</b> swallows the flame."),
		span_rose("You swallow the flame."),
	)

/datum/action/cooldown/spell/touch/finger_flame/lizard/create_hand(mob/living/carbon/cast_on)
	var/obj/item/organ/internal/stomach/stomach = cast_on.get_organ_slot(ORGAN_SLOT_STOMACH)

	var/list/present_accelerants = required_accelerant.Copy()
	for(var/datum/reagent/inner_reagent as anything in stomach.reagents.reagent_list + cast_on.reagents.reagent_list)
		for(var/existing_accelerant in present_accelerants)
			if(!istype(inner_reagent, existing_accelerant))
				continue

			present_accelerants[existing_accelerant] -= inner_reagent.volume
			if(present_accelerants[existing_accelerant] > 0)
				continue

			// We can go through and make the flame now
			playsound(cast_on, 'maplestation_modules/sound/unathiignite.ogg', 50, TRUE)
			if(cast_on.is_mouth_covered())
				cast_on.visible_message(
					span_warning("<b>[cast_on]</b> tries to muster a flame, but [cast_on.p_their()] mouth is covered!"),
					span_warning("You try to muster a flame, but your mouth is covered!"),
				)
				cast_on.apply_damage(5, BURN, BODY_ZONE_HEAD)
				cast_on.adjust_fire_stacks(1)
				cast_on.ignite_mob()
				// It's hard to tell how much was in their stomach and how much was in their blood so we'll just remove it from both
				cast_on.reagents.remove_all_type(existing_accelerant, required_accelerant[existing_accelerant] * 2)
				stomach.reagents.remove_all_type(existing_accelerant, required_accelerant[existing_accelerant] * 2)
				return FALSE

			var/obj/item/existing_hand = cast_on.get_inactive_held_item()
			if(istype(existing_hand, hand_path))
				cast_on.visible_message(
					span_warning("The flame in <b>[cast_on]</b>'s mouth builds in strength!"),
					span_warning("You try to muster a flame, but you already have one in your mouth, causing it to strengthen!"),
				)
				cast_on.apply_damage(5, BURN, BODY_ZONE_HEAD)
				cast_on.adjust_fire_stacks(2)
				cast_on.ignite_mob()
				// Same as above
				cast_on.reagents.remove_all_type(existing_accelerant, required_accelerant[existing_accelerant] * 2)
				stomach.reagents.remove_all_type(existing_accelerant, required_accelerant[existing_accelerant] * 2)
				existing_hand.transform.Scale(2, 2)
				return FALSE

			if(..())
				// Same as above
				cast_on.reagents.remove_all_type(existing_accelerant, required_accelerant[existing_accelerant])
				stomach.reagents.remove_all_type(existing_accelerant, required_accelerant[existing_accelerant])
				return TRUE

			return FALSE

	to_chat(cast_on, span_warning("You try to muster a flame, but you don't have enough accelerant..."))
	StartCooldown(3 SECONDS)
	return FALSE

/datum/species/lizard/on_species_gain(mob/living/carbon/C, datum/species/old_species, pref_load)
	. = ..()
	var/datum/action/cooldown/spell/touch/finger_flame/lizard/fire_breath = new(C)
	fire_breath.Grant(C)

/datum/species/lizard/on_species_loss(mob/living/carbon/human/C, datum/species/new_species, pref_load)
	. = ..()
	var/datum/action/cooldown/spell/touch/finger_flame/lizard/fire_breath = locate() in C.actions
	qdel(fire_breath)
