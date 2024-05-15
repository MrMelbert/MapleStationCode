//wowie volkan is in the cool club now
//I dont know if what I am doing is correct at all.
//Sci-fi looking things only.
//---------comunication chips---------
/obj/item/computer_disk/volkan/communication_chip //the basic default one
	name = "standard communication chip"
	desc = "A small, grey chip. It has a connector for a standard NT computer. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipc"
	w_class = WEIGHT_CLASS_TINY
	max_capacity = 1
	starting_programs = list( //this is a messenger after all
		/datum/computer_file/program/messenger/volkan,
	)
	drop_sound = "sound/items/handling/disk_drop.ogg"
	pickup_sound = "sound/items/handling/disk_pickup.ogg"

/obj/item/computer_disk/volkan/communication_chip/usb //this one has a small USB port instead of the default big chonker connector
	name = "USB communication chip"
	desc = "A small, grey chip. It has a connector for a USB. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipa"

/obj/item/computer_disk/volkan/communication_chip/usb/Initialize(mapload) //add the actual USB port because this one has one
	. = ..()
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/ntnet_send/volkan,/obj/item/circuit_component/ntnet_receive/volkan,
	))

/obj/item/computer_disk/volkan/communication_chip/bare //missing a connector entirely.
	name = "communication chip"
	desc = "A small, grey chip. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipb"

/obj/item/computer_disk/volkan/communication_chip/drone //A default one but with the symbol of the drone. Unlikely to be used but good to have here.
	name = "standard communication chip"
	desc = "A small, grey chip. It has a connector for a standard NT computer. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipd"

//---------communication chip data------------
//I would add proper functionality but it sounds like a DAUNTING task.
//Instead have a messenger app that cannot be installed in testing but has a custom name :D

/datum/computer_file/program/messenger/volkan
	filename = "Private Messenger"
	filedesc = "Secure & Private Messenger"
	size = 1
	can_run_on_flags = PROGRAM_ALL

//For the USB port: Basically the ntnet sender and receiver, but with a custom name and description.  IC it would be *all* custom but I am lazy and this is pretty damn close :)
/obj/item/circuit_component/ntnet_send/volkan
	display_name = "Private Sender"
	desc = "A private messenger, sends the data via quantum link to a bluespace relay."
	category = "vnet"

/obj/item/circuit_component/ntnet_receive/volkan
	name = "Private Receiver"
	desc = "A private Receiver, receives the data via quantum link from a bluespace relay."
	category = "vnet"

//---------cool boxes!---------
//Chip box
//Designed to hold communication chips
/obj/item/storage/box/volkan/chip_box
	name = "small metal box"
	desc = "A very small rectangular metal box. The box looks like its built to hold specific things."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/metal_box.dmi'
	icon_state = "chip_box"
	foldable_result = null
	illustration = null
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/box/volkan/chip_box/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_TINY
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_total_storage = 5 //It can only hold 5 tiny items, which is 5 chips.
	atom_storage.max_slots = 5

/obj/item/storage/box/volkan/chip_box/PopulateContents() //various chips. 3 of the basic ones and one of the other two just in case.
	var/static/items_inside = list(
		/obj/item/computer_disk/volkan/communication_chip = 3,
		/obj/item/computer_disk/volkan/communication_chip/usb = 1,
		/obj/item/computer_disk/volkan/communication_chip/bare = 1,
	)
	generate_items_inside(items_inside, src)

//Intricate box.
//Designed for gifts and trades.
//NOT for use yet but I am coding this in for when I want to add more Volkan stuff later on :)
/obj/item/storage/box/volkan/intricate_box
	name = "intricate metal box"
	desc = "A lightweight metal box. The box has intricate engraved designs throughout."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/metal_box.dmi'
	icon_state = "intricate_box"
	foldable_result = null
	w_class = WEIGHT_CLASS_NORMAL
	illustration = null

/obj/item/storage/box/volkan/intricate_box/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_total_storage = 6
	atom_storage.max_slots = 2 // I expect trades to only have two items max right now.
