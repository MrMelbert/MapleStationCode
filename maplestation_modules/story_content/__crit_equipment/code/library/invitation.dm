/obj/item/grand_library_invitation
	name = "\improper Grand Library Invitation"
	desc = "If you see this, somebody messed up and didn't use the proper subtype."
	icon = 'maplestation_modules/story_content/__crit_equipment/icons/library_card.dmi'
	icon_state = "invitation_conf"
	w_class = WEIGHT_CLASS_SMALL
	var/area_to_send_to = /area/station/commons/toilet/restrooms

/obj/item/grand_library_invitation/attack_self(mob/user, modifiers)
	if(user.stat != CONSCIOUS)
		return

	if(!length(get_areas(areatype = area_to_send_to, subtypes = FALSE))) // check if our target area does not exist
		to_chat(user, span_warning("The card is dim. It does not seem possible to use it at this moment."))
		return

	if(tgui_alert(user, "Are you sure you want to head into the Grand Library?", "Library Invitation", list("Yes", "No")) != "Yes")
		return

	teleport_to_library(user)

/obj/item/grand_library_invitation/examine(mob/user)
	. = ..()
	. += span_notice("Use in hand to teleport to the Grand Library.")

/obj/item/grand_library_invitation/proc/teleport_to_library(mob/user)
	var/list/valid_turfs = list()
	for(var/turf/possible_destination as anything in get_area_turfs(area_to_send_to))
		if(isspaceturf(possible_destination))
			continue
		if(possible_destination.density)
			continue
		if(possible_destination.is_blocked_turf(exclude_mobs = TRUE))
			continue

		valid_turfs += possible_destination

	do_teleport(user, pick(valid_turfs), asoundout = 'sound/magic/teleport_app.ogg', channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE)

	qdel(src)

/obj/item/grand_library_invitation/confidential_works
	desc = "A black, gray and white card with a book on it."
	icon_state = "invitation_conf"
	area_to_send_to = /area/grand_library/confidential_dept/reception
