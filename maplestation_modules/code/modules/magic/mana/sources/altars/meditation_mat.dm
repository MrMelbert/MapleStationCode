/obj/machinery/meditation_mat
	name = "Meditation Mat"
	desc = "A purple mat meant to empower those who meditate" // todo: this sucks rewrite it

	icon = 'maplestation_modules/icons/obj/magic/altars.dmi'
	icon_state = "meditation_mat"

	can_buckle = TRUE
	buckle_lying = 0
	resistance_flags = NONE
	use_power = NO_POWER_USE

	var/foldable_type = /obj/item/meditation_mat

/obj/machinery/meditation_mat/examine(mob/user)
	. = ..()
	if(!isnull(foldable_type))
		. += span_notice("You can fold it up with a Right-click.")

/obj/machinery/meditation_mat/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!ishuman(user) || !user.can_perform_action(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(has_buckled_mobs())
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	user.visible_message(span_notice("[user] collapses [src]."), span_notice("You collapse [src]."))
	var/obj/machinery/meditation_mat/folded_mat = new foldable_type(get_turf(src))
	user.put_in_hands(folded_mat)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/meditation_mat/proc/apply_effects(mob/living/target)
	if(target != occupant)
		return
	target.apply_status_effect(/datum/status_effect/meditation_mat, MEDITATION_MAT_EFFECT)

/obj/machinery/meditation_mat/proc/remove_effects(mob/living/target)
	target.remove_status_effect(/datum/status_effect/meditation_mat, MEDITATION_MAT_EFFECT)

/obj/machinery/meditation_mat/post_buckle_mob(mob/living/L)
	if(!can_be_occupant(L))
		return
	set_occupant(L)
	apply_effects(L)

/obj/machinery/meditation_mat/post_unbuckle_mob(mob/living/L)
	remove_effects(L)
	if(L == occupant)
		set_occupant(null)

// status effect
/datum/status_effect/meditation_mat
	id = "meditation_mat_status"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/meditation_mat

/datum/status_effect/meditation_mat/on_apply()
	. = ..()
	if(!.)
		return
	owner.add_traits(list(
		TRAIT_EMPOWERED_MEDITATION,
	), TRAIT_STATUS_EFFECT(id))

/datum/status_effect/meditation_mat/on_remove()
	owner.remove_traits(list(
		TRAIT_EMPOWERED_MEDITATION,
	), TRAIT_STATUS_EFFECT(id))
	return . = ..()

/atom/movable/screen/alert/status_effect/meditation_mat
	name = "Focused Meditation"
	desc = "You are kneeling? resting? napping? On the mat. Your ability to focus on specific mental capabilities is improved."
	icon_state = "woozy"

// folded item
/obj/item/meditation_mat
	name = "Folded Meditation Mat"
	desc = "A mat for meditation, rolled and folded up for easy transport."
	icon = 'icons/obj/medical/medical_bed.dmi'
	icon_state = "emerg_folded"
	inhand_icon_state = "emergencybed"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/meditation_mat/attack_self(mob/user)
	deploy_bed(user, user.loc)

/obj/item/meditation_mat/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isopenturf(interacting_with))
		deploy_bed(user, interacting_with)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/meditation_mat/proc/deploy_bed(mob/user, atom/location)
	var/obj/machinery/meditation_mat/deployed = new /obj/machinery/meditation_mat(location)
	deployed.add_fingerprint(user)
	qdel(src)

/obj/item/stack/sheet/cloth/get_main_recipes()
	. = ..()
	. += list(new /datum/stack_recipe("meditation mat", /obj/item/meditation_mat, 8))
