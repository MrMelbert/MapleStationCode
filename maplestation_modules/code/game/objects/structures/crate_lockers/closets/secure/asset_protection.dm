// -- Asset Protection locker + spawner. --

// The actual Asset Protection's locker of equipment
/obj/structure/closet/secure_closet/asset_protection
	name = "asset protection's locker"
	article = "the"
	req_access = list(ACCESS_COMMAND)
	icon = 'maplestation_modules/icons/obj/locker.dmi'
	icon_state = "ap"

/obj/structure/closet/secure_closet/asset_protection/PopulateContents()
	new /obj/item/storage/bag/garment/asset_protection(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/radio/headset/heads/asset_protection(src)
	new /obj/item/megaphone/command(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/photo_album/ap(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/dept_armbands(src)
	new /obj/item/gun/energy/e_gun(src)
	new /obj/item/stamp/ap(src)

// Asset Protection album for their locker
/obj/item/storage/photo_album/ap
	name = "photo album (Asset Protection)"
	icon_state = "album_red"
	persistence_id = "AP"
