/obj/structure/destructible/brass
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/clockwork_objects.dmi'
	light_power = 2
	break_sound = 'sound/hallucinations/veryfar_noise.ogg'
	debris = list(/obj/item/stack/sheet/brass = 1)
	var/cult_examine_tip
	COOLDOWN_DECLARE(use_cooldown)

/obj/structure/destructible/brass/examine(mob/user)
	. = ..()
	. += span_notice("\The [src] is [anchored ? "":"not "]secured to the floor.")
	if(IS_CULTIST(user) || isobserver(user))
		if(cult_examine_tip)
			. += span_brass(cult_examine_tip)
		if(!COOLDOWN_FINISHED(src, use_cooldown))
			. += span_brasstalics("The magic in [src] is too weak, it will be ready to use again in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(src, use_cooldown))]</b>.")

/obj/structure/destructible/brass/examine_status(mob/user)
	if(IS_CULTIST(user) || isobserver(user))
		return span_brass("It's at <b>[round(atom_integrity * 100 / max_integrity)]%</b> stability.")
	return ..()

/obj/structure/destructible/brass/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!isliving(user) || !IS_CULTIST(user))
		to_chat(user, span_warning("You're pretty sure you know exactly what this is used for and you can't seem to touch it."))
		return
	if(!anchored)
		to_chat(user, span_brasstalics("You need to anchor [src] to the floor first."))
		return
	if(!COOLDOWN_FINISHED(src, use_cooldown))
		to_chat(user, span_brasstalics("The magic in [src] is too weak, it will be ready to use again in <b>[DisplayTimeText(COOLDOWN_TIMELEFT(src, use_cooldown))]</b>."))
		return

	var/list/spawned_items = open_radial_and_get_item(user)
	if(!length(spawned_items))
		return
	if(QDELETED(src) || !anchored || !Adjacent(user) || !check_menu(user) || !COOLDOWN_FINISHED(src, use_cooldown))
		return

	COOLDOWN_START(src, use_cooldown, 5 MINUTES)
	for(var/item_to_make in spawned_items)
		var/obj/item/made_item = new item_to_make(get_turf(src))
		succcess_message(user, made_item)

/obj/structure/destructible/brass/proc/open_radial_and_get_item(mob/living/user)
	CRASH("[type] - open_radial_and_get_item() not implemented.")

/obj/structure/destructible/brass/proc/succcess_message(mob/living/user, obj/item/spawned_item)
	to_chat(user, span_brass("[src] whirrs as a [spawned_item.name] is produced."))

/obj/structure/destructible/brass/set_anchored(anchorvalue)
	. = ..()
	if(isnull(.))
		return
	update_appearance(UPDATE_ICON)

/obj/structure/destructible/brass/update_icon_state()
	icon_state = "[initial(icon_state)][anchored ? "" : "_unwrenched"]"
	return ..()

/obj/structure/destructible/brass/proc/conceal()
	set_density(FALSE)
	visible_message(span_danger("[src] fades away."))
	invisibility = INVISIBILITY_OBSERVER
	alpha = 100
	set_light_power(0)
	set_light_range(0)
	update_light()
	STOP_PROCESSING(SSfastprocess, src)

/obj/structure/destructible/brass/proc/reveal()
	set_density(initial(density))
	invisibility = 0
	visible_message(span_danger("[src] suddenly appears!"))
	alpha = initial(alpha)
	set_light_range(initial(light_range))
	set_light_power(initial(light_power))
	update_light()
	START_PROCESSING(SSfastprocess, src)

/obj/structure/destructible/brass/proc/check_menu(mob/user)
	return isliving(user) && IS_CULTIST(user) && !user.incapacitated()
