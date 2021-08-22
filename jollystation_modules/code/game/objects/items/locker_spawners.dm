//Locker spawner tool
//For jobs primarily on Runtime/main stations

/obj/item/locker_beacon
	name = "Locker Summoning Device"
	desc = "Because your job is unique, you get this."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	w_class = WEIGHT_CLASS_SMALL
	/// Whether this beacon actually requires the user have the correct assigned role
	var/requires_job = TRUE

/obj/item/locker_beacon/attack_self(mob/user, modifiers)
	. = ..()
	if(requires_job && !istype(user.mind?.assigned_role, /datum/job/bridge_officer))
		to_chat(user, "<span class='warning'>\The [src] requires you are assigned to the station as an official Bridge Officer to use.</span>")
		return
	spawn_locker(user)

// Actually spawn the locker at the [bridge_officer]'s feet.
/obj/item/locker_beacon/proc/spawn_locker(mob/living/carbon/human/bridge_officer)
	if(istype(bridge_officer.ears, /obj/item/radio/headset))
		var/nanotrasen_message = span_bold("Equipment request received. Your new locker is inbound. \
			Thank you for your valued service as a Nanotrasen official \[[bridge_officer.mind?.assigned_role.title]\]!")
		to_chat(bridge_officer,
			"You hear something crackle in your ears for a moment before a voice speaks. \
			\"Please stand by for a message from Central Command. Message as follows: [nanotrasen_message] Message ends.\"")
	else
		to_chat(bridge_officer, span_notice("You notice a target painted on the ground below you."))

	var/list/spawned_paths = list(/obj/structure/closet/secure_closet/bridge_officer)
	podspawn(list(
		"target" = get_turf(bridge_officer),
		"style" = STYLE_CENTCOM,
		"spawn" = spawned_paths,
		"delays" = list(POD_TRANSIT = 20, POD_FALLING = 50, POD_OPENING = 20, POD_LEAVING = 10)
	))

	qdel(src)
