// -- Bridge Officer locker + spawner. --

// The actual Bridge Officer's locker of equipment
/obj/structure/closet/secure_closet/bridge_officer
	name = "\proper bridge officer's locker"
	req_access = list(ACCESS_HEADS)
	icon = 'jollystation_modules/icons/obj/locker.dmi'
	icon_state = "bo"

/obj/structure/closet/secure_closet/bridge_officer/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/security/bridge_officer/black/skirt (src)
	new /obj/item/clothing/under/rank/security/bridge_officer/black(src)
	new /obj/item/clothing/under/rank/security/bridge_officer(src)
	new /obj/item/clothing/gloves/color/white(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/radio/headset/heads/bridge_officer(src)
	new /obj/item/clothing/head/beret/black/bridge_officer(src)
	new /obj/item/clothing/glasses/sunglasses/garb(src)
	new /obj/item/clothing/suit/armor/vest/bridge_officer(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/cartridge/hop(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/photo_album/bo(src)
	new /obj/item/storage/box/office_supplies(src)

// Bridge Officer album for their locker
/obj/item/storage/photo_album/bo
	name = "photo album (Bridge Officer)"
	icon_state = "album_blue"
	persistence_id = "BO"

// A beacon item that pod-spawns in a Bridge Officer locker.
// Given to Bridge Officers when they spawn if the map doesn't have a locker landmark mapped in.
/obj/item/bridge_officer_locker_spawner
	name = "Bridge Officer Equipment Beacon"
	desc = "A beacon handed out for enterprising bridge officers being assigned to station without proper \
			accommodations made for their occupation. When used, drop-pods in a fully stocked locker \
			of equipment for use when manning the bridge of Nanotrasen research stations."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	w_class = WEIGHT_CLASS_SMALL
	/// Whether this beacon actually requires the user have the correct assigned role
	var/requires_job = TRUE

/obj/item/bridge_officer_locker_spawner/attack_self(mob/user, modifiers)
	. = ..()
	if(requires_job && !istype(user.mind?.assigned_role, /datum/job/bridge_officer))
		to_chat(user, "<span class='warning'>\The [src] requires you are assigned to the station as an official Bridge Officer to use.</span>")
		return
	spawn_locker(user)

// Actually spawn the locker at the [bridge_officer]'s feet.
/obj/item/bridge_officer_locker_spawner/proc/spawn_locker(mob/living/carbon/human/bridge_officer)
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
