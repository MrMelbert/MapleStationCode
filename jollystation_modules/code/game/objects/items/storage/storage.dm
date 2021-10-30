//Nerf for smuggler satchels
/obj/item/storage/ComponentInitialize()
	. = .. ()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(null, list(/obj/item/storage/backpack/satchel/flat))
