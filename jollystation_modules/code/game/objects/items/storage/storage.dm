//Nerf for smuggler satchels
/obj/item/storaage/flat/ComponentInitialize()
	. = .. ()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.set_holdable(null, list(/obj/item/storage/backpack/satchel/flat))
