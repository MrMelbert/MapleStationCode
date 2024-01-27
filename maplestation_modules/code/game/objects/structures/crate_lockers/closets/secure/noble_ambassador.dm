/obj/structure/closet/secure_closet/noble_ambassador
	name = "\proper noble ambassador's locker"
	desc = "It's a card-locked storage unit. You sure wish it had less spartan decorations."
	req_access = list(ACCESS_COMMAND)
	icon = 'maplestation_modules/icons/obj/locker.dmi'
	icon_state = "na"

/obj/structure/closet/secure_closet/noble_ambassador/PopulateContents()
	new /obj/item/storage/bag/garment/noble_ambassador(src)
	new /obj/item/radio/headset/heads/noble_ambassador(src)
	new /obj/item/stamp/na(src)
