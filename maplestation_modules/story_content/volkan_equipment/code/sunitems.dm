/*
 * # Stuff for the beach!
 * Volkan has 0 pigment, so the sun damages him a lot IC.
 * His synth avatar also has this flaw, mainly due to the type of synthflesh used. He made it too damn realistic.
 * As a result, have items that help with dealing with the sun!
 */

///sunscreen, does nothing for now but is cool for flavor.
/obj/item/sunscreen
	name = "generic sunscreen"
	desc = "A generic sunscreen product. Cream based application. It is labeled SPF 30"
	w_class = WEIGHT_CLASS_TINY
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/sun_items.dmi'
	icon_state = "sunscreen_generic"
	///How long it takes before sunscreen runs out in minutes
	var/reaplication_time = 30
	///The sunscreen's SPF rating.
	var/spf = 30
	///how long it takes to apply in seconds
	var/application_time = 10

/obj/item/sunscreen/shitty
	name = "cheap generic sunscreen"
	desc = "A budget generic sunscreen product. Cream based application. It is labeled SPF 20. It feels like it won't last long."
	reaplication_time = 1

	spf = 20

/obj/item/sunscreen/nanotrasen
	name = "Nanotrasen sunscreen"
	desc = "A Nanotrasen sunscreen product. Cream based application. It is labeled SPF 50"
	icon_state = "sunscreen_nanotrasen"

	spf = 50
	application_time = 5

///HaSE has developed a pretty good sunscreen. It doesn't smell too great though.
/obj/item/sunscreen/volkan
	name = "strange sunscreen"
	desc = "A sunscreen product in a metal container. It seems to have a high SPF rating. It seems to be a spray based application. Smells like industrial chemicals when sprayed."
	icon_state = "sunscreen_volkan"

	spf = 50
	application_time = 1
	reaplication_time = 15 //spray based doesn't last as long, plus its funny to have volkan be applying sunscreen all the time.

/obj/item/sunscreen/attack_self(mob/user)
	apply(user, user)

/obj/item/sunscreen/interact_with_atom(atom/target, mob/living/user)
	apply(target, user)
	return ..()

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
	var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))

	affecting.burn_modifier -= spf/1000

	if(do_after(user, application_time SECONDS, user))
		addtimer(CALLBACK(src, PROC_REF(loseEffectiveness), target, affecting), reaplication_time MINUTES)
		user.visible_message(
			span_notice("[user] has applied [src] onto [target]."),
			to_chat(target, span_notice("You have applied [src]!"))
		)

///Stuff that happens when the sunscreen runs out.
/obj/item/sunscreen/proc/loseEffectiveness(mob/living/carbon/target, /obj/item/bodypart/affecting)
	affecting.burn_modifier += spf/1000
	to_chat(target, span_notice("You don't feel the sunscreen anymore."))

