// -- Bridge Officer locker + spawner. --

// The actual Bridge Officer's locker of equipment
/obj/structure/closet/secure_closet/bridge_officer
	name = "\proper bridge officer's locker"
	req_access = list(ACCESS_HEADS)
	icon = 'jollystation_modules/icons/obj/locker.dmi'
	icon_state = "bo"

/obj/structure/closet/secure_closet/bridge_officer/PopulateContents()
	new /obj/item/clothing/under/rank/security/bridge_officer/black/skirt (src)
	new /obj/item/clothing/under/rank/security/bridge_officer/black(src)
	new /obj/item/clothing/gloves/color/white(src)
	new /obj/item/clothing/shoes/laceup(src)
	new /obj/item/radio/headset/heads/bridge_officer(src)
	new /obj/item/clothing/head/beret/black/bridge_officer(src)
	new /obj/item/clothing/glasses/sunglasses/garb(src)
	new /obj/item/clothing/suit/armor/vest/bridge_officer(src)
	new /obj/item/cartridge/hop(src)
	new /obj/item/assembly/flash/handheld(src)
	new /obj/item/storage/photo_album/bo(src)
	new /obj/item/storage/box/office_supplies(src)
	new /obj/item/taperecorder(src)
	new /obj/item/tape(src)
	new /obj/item/tape(src)

// Bridge Officer album for their locker
/obj/item/storage/photo_album/bo
	name = "photo album (Bridge Officer)"
	icon_state = "album_blue"
	persistence_id = "BO"
