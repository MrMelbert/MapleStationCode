// -- Bridge Officer locker + spawner. --

// Landmark for mapping in Bridge Officer equipment.
// Use this in place of manually mapping it in - this allows us to track all Bridge Officer lockers in the world.
// We do this so we can detect if a map doesn't have a Bridge Officer locker, so we can allow the player to spawn one in manually.
/obj/effect/landmark/bridge_officer_equipment
	name = "bridge officer locker"
	icon_state = "secequipment"
	var/spawn_anchored = FALSE

/obj/effect/landmark/bridge_officer_equipment/Initialize(mapload)
	GLOB.bridge_officer_lockers += loc
	var/obj/structure/closet/secure_closet/bridge_officer/spawned_locker = new(drop_location())
	if(spawn_anchored)
		spawned_locker.set_anchored(TRUE)
	return ..()

/obj/effect/landmark/bridge_officer_equipment/Destroy()
	GLOB.bridge_officer_lockers -= loc
	return ..()

// Subtype that spawns anchored.
/obj/effect/landmark/bridge_officer_equipment/spawn_anchored
	spawn_anchored = TRUE

// The actual Bridge Officer's locker of equipment
/obj/structure/closet/secure_closet/bridge_officer
	name = "\proper bridge officer's locker"
	req_access = list(ACCESS_HEADS)
	icon = 'jollystation_modules/icons/obj/locker.dmi'
	icon_state = "bo"
	icon_door = "bo"

/obj/structure/closet/secure_closet/bridge_officer/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/security/bridge_officer/black/skirt (src)
	new /obj/item/clothing/under/rank/security/bridge_officer/black(src)
	new /obj/item/clothing/under/rank/security/bridge_officer(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/radio/headset/heads/bridge_officer(src)
	new /obj/item/clothing/head/beret/black/bridge_officer(src)
	new /obj/item/clothing/glasses/sunglasses/garb(src)
	new /obj/item/clothing/suit/armor/vest/bridge_officer(src)
	new /obj/item/clothing/suit/armor/vest/bridge_officer/large(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/cartridge/hos(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/photo_album/bo(src)

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
	var/mob/living/carbon/human/human_user = user
	if(requires_job && istype(human_user) && human_user.mind?.assigned_role != "Bridge Officer")
		to_chat(human_user, "<span class='warning'>\The [src] requires you are assigned to the station as an official Bridge Officer to use.</span>")
		return
	spawn_locker(human_user)

// Actually spawn the locker at the [bridge_officer]'s feet.
/obj/item/bridge_officer_locker_spawner/proc/spawn_locker(mob/living/carbon/human/bridge_officer)
	if(istype(bridge_officer.ears, /obj/item/radio/headset))
		to_chat(bridge_officer, "You hear something crackle in your ears for a moment before a voice speaks. \
			\"Please stand by for a message from Central Command. Message as follows: \
			<span class='bold'>Equipment request received. Your new locker is inbound. \
			Thank you for your valued service as a \[Bridge Officer\]!</span> Message ends.\"")
	else
		to_chat(bridge_officer, "<span class='notice'>You notice a target painted on the ground below you.</span>")

	var/list/spawned_paths = list(/obj/structure/closet/secure_closet/bridge_officer)
	podspawn(list(
		"target" = get_turf(bridge_officer),
		"style" = STYLE_CENTCOM,
		"spawn" = spawned_paths,
		"delays" = list(POD_TRANSIT = 20, POD_FALLING = 50, POD_OPENING = 20, POD_LEAVING = 10)
	))

	qdel(src)
