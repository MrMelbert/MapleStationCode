// Modular boxes + contents

// Box of office supplies; goes in the BO locker
/obj/item/storage/box/office_supplies
	name = "box of office supplies"
	desc = "Sometimes you get the itch to go buy a new pen. Don't, your box has you covered."

/obj/item/storage/box/office_supplies/PopulateContents()
	new /obj/item/pen/red(src)
	new /obj/item/pen/blue(src)
	new /obj/item/pen/fountain(src)
	new /obj/item/stamp(src)
	new /obj/item/stamp/denied(src)

// Box of department arm bands; goes in the AP locker
/obj/item/storage/box/dept_armbands
	name = "box of department armbands"
	desc = "Show off which department you'll guard today! Or which head of staff you'll annoy the piss out of. Free of charge!"

/obj/item/storage/box/dept_armbands/PopulateContents()
	new /obj/item/clothing/accessory/armband/cargo(src)
	new /obj/item/clothing/accessory/armband/engine(src)
	new /obj/item/clothing/accessory/armband/science(src)
	new /obj/item/clothing/accessory/armband/medblue(src)
	new /obj/item/clothing/accessory/armband/service(src)
