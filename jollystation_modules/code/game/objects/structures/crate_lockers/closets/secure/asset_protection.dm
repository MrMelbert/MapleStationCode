// -- Asset Protection locker + spawner. --

// The actual Asset Protection's locker of equipment
/obj/structure/closet/secure_closet/asset_protection
	name = "\proper asset protection's locker"
	req_access = list(ACCESS_HEADS)
	icon = 'jollystation_modules/icons/obj/locker.dmi'
	icon_state = "ap"

/obj/structure/closet/secure_closet/asset_protection/PopulateContents()
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
	new /obj/item/clothing/glasses/hud/security/sunglasses(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/gars(src)
	new /obj/item/clothing/glasses/hud/security/sunglasses/eyepatch(src)
	new /obj/item/storage/photo_album/ap(src)
	new /obj/item/storage/belt/security/full(src)
	new /obj/item/storage/box/dept_armbands(src)
	new /obj/item/gun/energy/e_gun(src)

// Asset Protection album for their locker
/obj/item/storage/photo_album/ap
	name = "photo album (Asset Protection)"
	icon_state = "album_red"
	persistence_id = "AP"
