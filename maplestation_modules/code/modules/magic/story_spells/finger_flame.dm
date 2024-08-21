#define FINGERFLAME_MANA_COST 5 // very cheap, it's just a lighter
#define FINGERFLAME_ATTUNEMENT_FIRE 0.2 // flame users make this EVEN cheaper
// This doesn't use the touch spell component because we use mana on activation rather than touch.
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
	var/mana_cost = FINGERFLAME_MANA_COST

	COOLDOWN_DECLARE(free_use_cooldown)
	// I was considering giving this the same "trigger on snap emote" effect that the arm implant has,
	// but considering this has a tangible cost (mana) while the arm implant is free, I decided against it.

	/// You get some seconds of freecasting to prevent spam.\

/datum/action/cooldown/spell/touch/finger_flame/can_cast_spell(...)
	if(!source.attached_hand)
		return NONE

/datum/action/cooldown/spell/touch/finger_flame/RegisterWithParent()
	RegisterSignal(parent, COMSIG_SPELL_TOUCH_CAN_HIT, PROC_REF(can_cast_spell))

/datum/action/cooldown/spell/touch/finger_flame/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_SPELL_TOUCH_CAN_HIT)

/datum/action/cooldown/spell/touch/finger_flame/cast(...)
	// this drains mana "on cast", and not on "touch spell hit" or "on after cast", unlike the touch spell component.
	// whichs means it uses mana when the flame / hand is CREATED instead of used
	..()
	COOLDOWN_START(src, free_use_cooldown, 4 SECONDS)

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

	var/list/datum/attunement/attunements = GLOB.default_attunements.Copy()
	attunements[MAGIC_ELEMENT_FIRE] += FINGERFLAME_ATTUNEMENT_FIRE

	AddComponent(/datum/component/uses_mana/spell/, \
		mana_required = CALLBACK(src, PROC_REF(get_mana_consumed)), \
		activate_check_failure_callback = CALLBACK(src, PROC_REF(spell_cannot_activate)), \
		get_user_callback = CALLBACK(src, PROC_REF(get_owner)), \
		attunements = attunements, \
	)
	desc += " Costs mana to conjure, but is free to maintain."

/datum/action/cooldown/spell/touch/finger_flame/proc/get_mana_consumed(atom/caster, atom/cast_on, ...)
	return COOLDOWN_FINISHED(src, free_use_cooldown) ? (mana_cost) : 0

/datum/action/cooldown/spell/touch/finger_flame/lizard
	name = "Muster Flame"
	desc = "Muster all you can to breathe a small mote of fire - just strong enough to light a cigarette. \
		Requires you consume an accelerant, such as alcohol, welding fuel, or plasma to fuel the flame. \
		(Stronger accelerants require less reagents.)"

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
		/datum/reagent/toxin/spore_burning = 2,
		/datum/reagent/phlogiston = 2,
		/datum/reagent/hellwater = 2,
		/datum/reagent/clf3 = 1,
	)

/datum/action/cooldown/spell/touch/finger_flame/lizard/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return
	RegisterSignals(grant_to, list(COMSIG_CARBON_GAIN_MUTATION, COMSIG_CARBON_LOSE_MUTATION), PROC_REF(update_for_firebreath))

/datum/action/cooldown/spell/touch/finger_flame/lizard/Remove(mob/living/remove_from)
	. = ..()
	UnregisterSignal(remove_from, list(COMSIG_CARBON_GAIN_MUTATION, COMSIG_CARBON_LOSE_MUTATION))

/datum/action/cooldown/spell/touch/finger_flame/lizard/proc/update_for_firebreath(mob/living/carbon/source)
	SIGNAL_HANDLER
	build_all_button_icons(UPDATE_BUTTON_NAME|UPDATE_BUTTON_STATUS)

/datum/action/cooldown/spell/touch/finger_flame/lizard/update_button_name(atom/movable/screen/movable/action_button/button, force)
	. = ..()
	var/mob/living/carbon/lizard_owner = owner
	if(lizard_owner.dna?.check_mutation(/datum/mutation/human/firebreath))
		button.name += " (Enhanced)"
		button.desc = "Prepare a small mote of fire in your mouth - just strong enough to light a cigarette. \
			No accelerant required, as you can breathe fire!"

/datum/action/cooldown/spell/touch/finger_flame/lizard/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return FALSE
	// We have to have some lungs (to breathe), a stomach (to hold the accelerant) and a head (to breathe the flame)
	var/mob/living/carbon/caster = owner
	if(!caster.get_organ_slot(ORGAN_SLOT_LUNGS))
		if(feedback)
			to_chat(caster, span_warning("You try to muster a flame, [HAS_TRAIT(caster, TRAIT_NOBREATH) ? "but you can't breathe!" : "but you can't take in air!"]"))
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
	old_cast_on.adjustOxyLoss(2, FALSE) // gulp
	old_cast_on.adjustToxLoss(-5, TRUE, TRUE) // most accelerants are toxic, so let's be a little nice for refunds

/// Check before making the hand if the mouth is covered.
/datum/action/cooldown/spell/touch/finger_flame/lizard/proc/mouth_covered_dumb_lizard(mob/living/carbon/cast_on)
	if(!cast_on.is_mouth_covered())
		return FALSE

	cast_on.visible_message(
		span_warning("<b>[cast_on]</b> tries to muster a flame, but [cast_on.p_their()] mouth is covered!"),
		span_warning("You try to muster a flame, but your mouth is covered!"),
	)
	cast_on.apply_damage(5, BURN, BODY_ZONE_HEAD)
	cast_on.adjust_fire_stacks(1)
	cast_on.ignite_mob()
	return TRUE

/datum/action/cooldown/spell/touch/finger_flame/lizard/create_hand(mob/living/carbon/cast_on)
	// Firebreath = free casting!
	if(cast_on.dna?.check_mutation(/datum/mutation/human/firebreath))
		playsound(cast_on, 'maplestation_modules/sound/magic_fire.ogg', 50, TRUE)
		return mouth_covered_dumb_lizard(cast_on) || ..()

	var/obj/item/organ/internal/stomach/stomach = cast_on.get_organ_slot(ORGAN_SLOT_STOMACH)
	var/list/present_accelerants = required_accelerant.Copy()
	for(var/datum/reagent/inner_reagent as anything in stomach.reagents.reagent_list + cast_on.reagents.reagent_list)
		for(var/existing_accelerant in present_accelerants)
			if(!istype(inner_reagent, existing_accelerant))
				continue

			present_accelerants[existing_accelerant] -= inner_reagent.volume
			if(present_accelerants[existing_accelerant] > 0)
				continue

			var/amount_consumed = required_accelerant[existing_accelerant]
			// We can go through and make the flame now
			playsound(cast_on, 'maplestation_modules/sound/magic_fire.ogg', 50, TRUE)
			if(mouth_covered_dumb_lizard(cast_on))
				amount_consumed *= 2
			else if(!..())
				return FALSE

			// It's hard to tell how much was in their stomach and how much was in their blood so we'll just remove it from both
			cast_on.reagents.remove_reagent(existing_accelerant, amount_consumed)
			stomach.reagents.remove_reagent(existing_accelerant, amount_consumed)
			return TRUE

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

#undef FINGERFLAME_MANA_COST
#undef FINGERFLAME_ATTUNEMENT_FIRE
