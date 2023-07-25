/obj/item/storage/bag/garment/noble
	name = "regal garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Licht family."

/obj/item/storage/bag/garment/noble/PopulateContents()
	new /obj/item/clothing/under/rank/noble(src)
	new /obj/item/clothing/under/rank/noblealt(src)
	new /obj/item/clothing/shoes/noble(src)
	new /obj/item/clothing/shoes/noblealt(src)
	new /obj/item/clothing/gloves/noble(src)
	new /obj/item/clothing/gloves/noblealt(src)
	new /obj/item/clothing/suit/toggle/noble(src)
	new /obj/item/clothing/head/costume/crown/noble(src)
	new /obj/item/clothing/under/rank/chiffon(src)
	new /obj/item/clothing/suit/costume/chiffon(src)
	new /obj/item/clothing/gloves/chiffon(src)
	new /obj/item/clothing/shoes/chiffon(src)
	new /obj/item/clothing/head/costume/chiffonbow(src)
	new /obj/item/storage/backpack/satchel/leather/chiffon(src)
	//The satchel is totally a clothing item right...? Right??

/obj/item/locker_spawner/noble
	name = "regal equipment beacon"
	desc = "A beacon gifted to noticeable nobility. This one has the Licht famly emblem engraved on it."
	spawned_locker_path = /obj/item/storage/bag/garment/noble
