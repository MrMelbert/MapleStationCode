
/datum/action/item_action/cult/clock_spell/shackle
	name = "Slab: Shackle"
	desc = "Empowers the slab to enchain and silence targets after a short time."
	examine_hint = "wrap the target in brass chains, restraining them and silencing them for a short time."
	button_icon_state = "hateful_manacles"
	invocation = "Rap'unva Gurve Fbhy!"
	active_overlay_name = "hateful_manacles"
	charges = 2
	manually_handle_charges = TRUE

/datum/action/item_action/cult/clock_spell/shackle/do_hit_spell_effects(mob/living/victim, mob/living/user)
	if(IS_CULTIST(victim) || !iscarbon(victim))
		return FALSE

	var/mob/living/carbon/carbon_target = victim
	if(carbon_target.canBeHandcuffed())
		INVOKE_ASYNC(src, .proc/cuff_victim, victim, user)
	else
		to_chat(user, span_warning("This victim doesn't have enough arms to complete the restraint!"))

	return TRUE

/datum/action/item_action/cult/clock_spell/shackle/proc/cuff_victim(mob/living/carbon/victim, mob/living/user)
	if(victim.handcuffed)
		to_chat(user, span_warning("[victim] is already bound."))
		return

	playsound(get_turf(victim), 'sound/weapons/handcuffs.ogg', 30, TRUE, -2)
	victim.visible_message(
		span_danger("[user] points [target] at [victim], and bright yellow restraints begin to form around them!"),
		span_userdanger("[user] points [target] at you, and bright yellow chains begin to form around your wrists!")
		)

	if(!do_mob(user, victim, 3 SECONDS))
		to_chat(user, span_warning("You fail to shackle [victim]."))
		return

	if(victim.handcuffed)
		to_chat(user, span_warning("[victim] is already bound."))
		return

	victim.set_handcuffed(new /obj/item/restraints/handcuffs/energy/clock(victim))
	victim.update_handcuffed()
	victim.silent += 5
	to_chat(user, span_notice("You shackle [victim]."))
	log_combat(user, victim, "shackled")
	after_successful_spell(user)

/obj/item/restraints/handcuffs/energy/clock
	name = "hateful manacles"
	desc = "Shackles that bind the wrists in heavy yellow chains."
	trashtype = /obj/item/restraints/handcuffs/energy/used
	item_flags = DROPDEL

/obj/item/restraints/handcuffs/energy/clock/dropped(mob/user)
	user.visible_message(
		span_danger("[user]'s shackles shatter in a discharge of yellow light!"),
		span_userdanger("[src] shatters in a discharge of yellow light!")
	)
	return ..()
