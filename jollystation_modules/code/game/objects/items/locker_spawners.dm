//Locker spawner tool
// Given to jobs that join stations not compatible with their job (IE, modular jobs on non-modular stations).

/obj/item/locker_spawner
	name = "Locker Summoning Device"
	desc = "Because your job is unique, you get this."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	w_class = WEIGHT_CLASS_SMALL
	/// Job required to use the beacon; If null, anyone can
	var/requires_job_path
	/// Path of the locker and its contents
	var/spawned_locker_path

/obj/item/locker_spawner/attack_self(mob/user, modifiers)
	. = ..()
	if(requires_job_path && !istype(user.mind?.assigned_role, requires_job_path))
		to_chat(user, span_warning("You are not assigned to use [src]!"))
		return
	spawn_locker(user)

// Actually spawn the locker at the [user]'s feet.
/obj/item/locker_spawner/proc/spawn_locker(mob/living/carbon/human/user)
	if(istype(user.ears, /obj/item/radio/headset))
		var/nanotrasen_message = span_bold("Equipment request received. Your new locker is inbound. \
			Thank you for your valued service as a Nanotrasen official \[[user.mind?.assigned_role.title]\]!")
		to_chat(user,
			"You hear something crackle in your ears for a moment before a voice speaks. \
			\"Please stand by for a message from Central Command. Message as follows: [nanotrasen_message] Message ends.\"")
	else
		to_chat(user, span_notice("You notice a target painted on the ground below you."))

	var/list/spawned_paths = list(spawned_locker_path)
	podspawn(list(
		"target" = get_turf(user),
		"style" = STYLE_CENTCOM,
		"spawn" = spawned_paths,
		"delays" = list(POD_TRANSIT = 20, POD_FALLING = 50, POD_OPENING = 20, POD_LEAVING = 10)
	))

	qdel(src)

// BO Locker summoner
/obj/item/locker_spawner/bridge_officer
	name = "bridge officer equipment beacon"
	desc = "A beacon handed out for enterprising bridge officers being assigned to stations without proper \
		accommodations made for their occupation. When used, drop-pods in a fully stocked locker of equipment \
		for use when manning the bridge of Nanotrasen research stations."
	requires_job_path = /datum/job/bridge_officer
	spawned_locker_path = /obj/structure/closet/secure_closet/bridge_officer

// AP Locker summoner
/obj/item/locker_spawner/asset_protection
	name = "asset protection equipment beacon"
	desc = "A beaconm handed out for stalwart asset protection officers being assigned to stations without proper \
		accommodations made for their occupation. When used, drop-pods in a fully stocked locker of equipment \
		for use when protecting the command staff of Nanotrasen research stations."
	requires_job_path = /datum/job/asset_protection
	spawned_locker_path = /obj/structure/closet/secure_closet/asset_protection
