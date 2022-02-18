// -- Quartermaster locker stuff. --
/obj/structure/closet/secure_closet/quartermaster/PopulateContents()
	. = ..()
	new /obj/item/storage/box/skillchips/cargo(src)
	new /obj/item/storage/bag/garment/magic/quartermaster(src) // done at the veeeery end for a reason.
