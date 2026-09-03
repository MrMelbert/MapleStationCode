// File for overriding smart fridges
/obj/machinery/smartfridge/extract/accept_check(obj/item/weapon)
	return (istype(weapon, /obj/item/slime_extract) || istype(weapon, /obj/item/slime_scanner) || istype(weapon, /obj/item/handheld_xenobio))

/obj/machinery/smartfridge/extract/preloaded
	initial_contents = list(/obj/item/slime_scanner = 2, /obj/item/handheld_xenobio = 1)
