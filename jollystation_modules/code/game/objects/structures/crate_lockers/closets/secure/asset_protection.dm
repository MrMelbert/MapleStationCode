// -- Asset Protection locker + spawner. --

// The actual Asset Protection's locker of equipment
/obj/structure/closet/secure_closet/asset_protection
	name = "\proper asset protection's locker"
	req_access = list(ACCESS_HEADS)
	icon = 'jollystation_modules/icons/obj/locker.dmi'
	icon_state = "ap"

/obj/structure/closet/secure_closet/asset_protection/PopulateContents()
	. = ..()
	new /obj/item/clothing/under/rank/security/officer/blueshirt/asset_protection(src)
	new /obj/item/clothing/under/rank/security/officer/grey/asset_protection(src)
	new /obj/item/clothing/gloves/color/black(src)
	new /obj/item/clothing/shoes/jackboots(src)
	new /obj/item/radio/headset/heads/asset_protection(src)
	new /obj/item/clothing/head/beret/black/asset_protection(src)
	new /obj/item/clothing/suit/armor/vest/asset_protection(src)
	new /obj/item/clothing/suit/armor/vest/asset_protection/large(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/cartridge/hos(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/photo_album/ap(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/dept_armbands(src)
	new /obj/item/gun/energy(src)

// Asset Protection album for their locker
/obj/item/storage/photo_album/ap
	name = "photo album (Asset Protection)"
	icon_state = "album_red"
	persistence_id = "AP"

// Beacon spawner from BO
/obj/item/asset_protection_locker_spawner
	name = "Asset Protection Equipment Beacon"
	desc = "A beacon handed out for enterprising Asset Protections being assigned to station without proper \
			accommodations made for their occupation. When used, drop-pods in a fully stocked locker \
			of equipment for use when assisting command of Nanotrasen research stations."
	icon = 'icons/obj/device.dmi'
	icon_state = "gangtool-red"
	w_class = WEIGHT_CLASS_SMALL
	/// Whether this beacon actually requires the user have the correct assigned role
	var/requires_job = TRUE

/obj/item/asset_protection_locker_spawner/attack_self(mob/user, modifiers)
	. = ..()
	if(requires_job && !istype(user.mind?.assigned_role, /datum/job/asset_protection))
		to_chat(user, "<span class='warning'>\The [src] requires you are assigned to the station as an official Bridge Officer to use.</span>")
		return
	spawn_locker(user)

// Actually spawn the locker at the [asset_protection]'s feet.
/obj/item/asset_protection_locker_spawner/proc/spawn_locker(mob/living/carbon/human/asset_protection)
	if(istype(asset_protection.ears, /obj/item/radio/headset))
		var/nanotrasen_message = span_bold("Equipment request received. Your new locker is inbound. \
			Thank you for your valued service as a Nanotrasen official \[[asset_protection.mind?.assigned_role.title]\]!")
		to_chat(asset_protection,
			"You hear something crackle in your ears for a moment before a voice speaks. \
			\"Please stand by for a message from Central Command. Message as follows: [nanotrasen_message] Message ends.\"")
	else
		to_chat(asset_protection, span_notice("You notice a target painted on the ground below you."))

	var/list/spawned_paths = list(/obj/structure/closet/secure_closet/asset_protection)
	podspawn(list(
		"target" = get_turf(asset_protection),
		"style" = STYLE_CENTCOM,
		"spawn" = spawned_paths,
		"delays" = list(POD_TRANSIT = 20, POD_FALLING = 50, POD_OPENING = 20, POD_LEAVING = 10)
	))

	qdel(src)
