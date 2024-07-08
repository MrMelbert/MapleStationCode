// Adds shock blankets to general med lockers
/obj/structure/closet/secure_closet/medical1/PopulateContents()
	. = ..()
	new /obj/item/shock_blanket(src)

// Adds robotics access to anesthesiology lockers
/obj/structure/closet/secure_closet/medical2
	req_access = list()
	req_one_access = list(ACCESS_SURGERY, ACCESS_ROBOTICS)
