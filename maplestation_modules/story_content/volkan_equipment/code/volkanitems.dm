//wowie volkan is in the cool club now
//I dont know if what I am doing is correct at all.
//Sci-fi looking things only.
//---------comunication chips---------
/obj/item/circuitboard/volkan/communication_chip //the basic default one
	name = "standard communication chip"
	desc = "A small, grey chip. It has a connector for a standard NT computer. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipc"
	w_class = WEIGHT_CLASS_TINY

/obj/item/circuitboard/volkan/communication_chipa //this one has a small USB port instead of the default big chonker connector
	name = "USB communication chip"
	desc = "A small, grey chip. It has a connector for a USB. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipa"
	w_class = WEIGHT_CLASS_TINY

/obj/item/circuitboard/volkan/communication_chipb //missing a connector entirely.
	name = "communication chip"
	desc = "A small, grey chip. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipb"
	w_class = WEIGHT_CLASS_TINY

/obj/item/circuitboard/volkan/communication_chip_drone //A default one but with the symbol of the drone. Unlikely to be used but good to have here.
	name = "standard communication chip"
	desc = "A small, grey chip. It has a connector for a standard NT computer. The chip has a white symbol engraved on the top."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/communication_chip.dmi'
	icon_state = "communication_chipd"
	w_class = WEIGHT_CLASS_TINY

//---------cool boxes!---------
//Chip box
//Designed to hold communication chips
/obj/item/storage/box/volkan/chip_box
	name = "intricate metal box"
	desc = "A very small, rectangular lightweight metal box. The box looks like its built to hold a very specific thing."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/metal_box.dmi'
	icon_state = "chip_box"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/storage/box/volkan/chip_box/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_SMALL
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_total_storage = 5 //It can only hold 5 tiny items, which is 5 chips.
	atom_storage.max_slots = 5


/obj/item/storage/box/volkan/chip_box/PopulateContents() //various chips. 3 of the basic ones and one of the other two just in case.
	var/static/items_inside = list(
		/obj/item/circuitboard/volkan/communication_chip = 3,
		/obj/item/circuitboard/volkan/communication_chipa = 1,
		/obj/item/circuitboard/volkan/communication_chipb = 1,
	)
	generate_items_inside(items_inside, src)

//Intricate box.
//Designed for gifts and trades.
//NOT for use yet but I am coding this in for when I want to add more Volkan stuff later on :)
/obj/item/storage/box/volkan/intricate_box
	name = "intricate metal box"
	desc = "A lightweight metal box. The box has intricate designs throughout."
	icon = 'maplestation_modules/story_content/volkan_equipment/icons/metal_box.dmi'
	icon_state = "intricate_box"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/storage/box/volkan/intricate_box/Initialize(mapload)
	. = ..()
	atom_storage.max_specific_storage = WEIGHT_CLASS_NORMAL
	atom_storage.numerical_stacking = TRUE
	atom_storage.max_total_storage = 6
	atom_storage.max_slots = 2 // I expect trades to only have two items max right now.
