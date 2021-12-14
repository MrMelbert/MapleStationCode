// The Replica fabricator.
// It's a buffed RCD.
// TODO; maybe make it so it calls a "ratvar_act" on whatever it makes. Or something.
/obj/item/construction/rcd/clock
	name = "replica fabricator"
	desc = "A cryptic looking device that can be used by ratvarian cultists to construct and deconstruct at rapid pace."
	icon = 'icons/obj/clockwork_objects.dmi'
	icon_state = "replica_fabricator"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	inhand_icon_state = "replica_fabricator"
	max_matter = 200
	matter = 200
	delay_mod = 0.5
	actions_types = list()
	has_ammobar = FALSE

/obj/item/construction/rcd/clock/attack_self(mob/user)
	if(!IS_CULTIST(user))
		backfire(user)
		return TRUE

	return ..()

/obj/item/construction/rcd/clock/pre_attack(atom/A, mob/user, params)
	if(!IS_CULTIST(user))
		backfire(user)
		return TRUE

	return ..()

/obj/item/construction/rcd/clock/pre_attack_secondary(atom/target, mob/living/user, params)
	if(!IS_CULTIST(user))
		backfire(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	return ..()

/obj/item/construction/rcd/clock/handle_openspace_click(turf/target, mob/user, proximity_flag, click_parameters)
	if(!IS_CULTIST(user))
		backfire(user)
		return

	return ..()

/obj/item/construction/rcd/clock/rcd_create(atom/A, mob/user)
	if(!IS_CULTIST(user))
		backfire(user)
		return FALSE

	return ..()

/// Harm whoever tried to use it.
/obj/item/construction/rcd/clock/proc/backfire(mob/living/user)
	to_chat(user, span_danger("The [src] begins to whirr and shake as it rejects your hand!"))
	var/obj/item/bodypart/affecting = user.get_active_hand()

	if(affecting)
		user.apply_damage(12, def_zone = affecting.body_zone, forced = TRUE, wound_bonus = CANT_WOUND)

	user.Paralyze(1.5 SECONDS)
	new /obj/effect/temp_visual/clock/disable(get_turf(user))
