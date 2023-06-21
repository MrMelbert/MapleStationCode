/obj/item/storage/bag/garment/winterprincess
	name = "winter princess's garment bag"
	desc = "A bag for storing extra clothes and shoes. This one belongs to the Licht family under House Finster and is fully-packed for the cold."

/obj/item/storage/bag/garment/winterprincess/PopulateContents()
	new /obj/item/clothing/under/rank/winterprincess(src)
	new /obj/item/clothing/gloves/winterprincess(src)
	new /obj/item/clothing/shoes/winterprincess(src)
	new /obj/item/clothing/shoes/winterprincessalt(src)
	new /obj/item/clothing/under/rank/winterprincess/ballgown(src)
	new /obj/item/clothing/head/costume/crown/winterprincess(src)
	new /obj/item/clothing/suit/hooded/winterprincess(src)

/obj/item/locker_spawner/winterprincess
	name = "winter princess's equipment beacon"
	desc = "A beacon packed for relocated nobility. This one has the Licht famly emblem engraved on it under the sigil of House Finster and carries a full set of formalwear."
	spawned_locker_path = /obj/item/storage/bag/garment/winterprincess
