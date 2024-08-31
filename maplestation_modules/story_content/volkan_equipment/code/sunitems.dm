/*
 * # Stuff for the beach!
 * Volkan has 0 pigment, so the sun damages him a lot IC.
 * His synth avatar also has this flaw, mainly due to the type of synthflesh used. He made it too damn realistic.
 * As a result, have items that help with dealing with the sun!
 */

///Sunscreen!
/obj/item/sunscreen
	name = "generic sunscreen"
	desc = "A generic sunscreen product. Cream based application."
	w_class = WEIGHT_CLASS_TINY
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/sun_items.dmi'
	icon_state = "sunscreen_generic"

	///how long it takes to apply in seconds
	var/application_time = 10 SECONDS
	///How long it takes before sunscreen runs out in seconds
	var/reaplication_time = 1800 SECONDS
	///The sunscreen's burn modifier.
	var/burn_modifier = 0.03

/obj/item/sunscreen/shitty
	name = "cheap generic sunscreen"
	desc = "A budget generic sunscreen product. Cream based application."

	reaplication_time = 60 SECONDS
	burn_modifier = 0.02

/obj/item/sunscreen/nanotrasen
	name = "Nanotrasen sunscreen"
	desc = "A Nanotrasen sunscreen product. Cream based application."
	icon_state = "sunscreen_nanotrasen"

	application_time = 5 SECONDS
	burn_modifier = 0.05

///HaSE has developed a pretty good sunscreen. It doesn't smell too great though.
/obj/item/sunscreen/volkan
	name = "strange sunscreen"
	desc = "A sunscreen product in a metal container. It seems to be a spray based application. Smells like industrial chemicals when sprayed."
	icon_state = "sunscreen_volkan"

	application_time = 1 SECONDS
	reaplication_time = 900 SECONDS//spray based doesn't last as long, plus it's funny to have volkan be applying sunscreen all the time.
	burn_modifier = 0.1

/obj/item/sunscreen/attack_self(mob/user)
	apply(user, user)

/obj/item/sunscreen/examine()
	. = ..()
	. += span_info("It's labeled SPF [burn_modifier * 1000]. Reapply in [reaplication_time / 600] minutes.")

/obj/item/sunscreen/interact_with_atom(atom/target, mob/living/user)
	apply(target, user)
	return ITEM_INTERACT_SUCCESS

/**
 * Applies sunscreen to a mob.
 *
 * Arguments:
 * * target - The mob who we will apply the sunscreen to.
 * * user -  the mob that is applying the sunscreen.
 */
/obj/item/sunscreen/proc/apply(mob/living/carbon/target, mob/user)
	if(!ishuman(target))
		return

	if(target == user)
		user.visible_message(
			span_notice("[user] starts to apply [src] on [user.p_them()]self..."),
			span_notice("You begin applying [src] on yourself...")
		)
	else
		user.visible_message(
			span_notice("[user] starts to apply [src] on [target]."),
			span_notice("You begin applying [src] on [target]...")
		)

	if(do_after(user, application_time, user))
		target.apply_status_effect(/datum/status_effect/sunscreen, reaplication_time, burn_modifier)

//sunscreen status effect
/atom/movable/screen/alert/status_effect/sunscreen
	name = "Sunscreen"
	desc = "You are covered in sunscreen!"
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/sun_items.dmi'
	icon_state = "sunscreen_generic"

/datum/status_effect/sunscreen
	id = "sunscreen"
	duration = 1800 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/sunscreen
	var/burn_modifier = 0.03

/datum/status_effect/sunscreen/on_creation(mob/living/new_owner, duration, burn_modifier)
	src.duration = _duration
	src.burn_modifier = burn_modifier
	return ..()

/datum/status_effect/sunscreen/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.burn_mod -= burn_modifier
	owner.visible_message(span_warning("[owner] has applied sunscreen!"),
		span_notice("You are covered in sunscreen!"))
	return ..()

///Stuff that happens when the sunscreen runs out.
/datum/status_effect/sunscreen/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.physiology.burn_mod += burn_modifier
	owner.visible_message(span_warning("[owner]'s sunscreen dissolves away."),
		span_notice("Your sunscreen is gone!"))
