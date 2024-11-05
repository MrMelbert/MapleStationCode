// --- Loadout item datums for masks ---

/// Mask Slot Items (Deletes overrided items)
/datum/loadout_category/mask
	category_name = "Mask"
	type_to_generate = /datum/loadout_item/mask
	tab_order = 4

/datum/loadout_item/mask
	abstract_type = /datum/loadout_item/mask

/datum/loadout_item/mask/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, job_equipping_step = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout mask was not equipped directly due to your envirosuit mask.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.mask = item_path

/datum/loadout_item/mask/balaclava
	name = "Balaclava"
	item_path = /obj/item/clothing/mask/balaclava

/datum/loadout_item/mask/gas_mask
	name = "Gas Mask"
	item_path = /obj/item/clothing/mask/gas

/datum/loadout_item/mask/bandana_greyscale
	name = "Bandana"
	item_path = /obj/item/clothing/mask/bandana

/datum/loadout_item/mask/bandana_striped_greyscale
	name = "Bandana (Striped)"
	item_path = /obj/item/clothing/mask/bandana/striped

/datum/loadout_item/mask/skull_bandana
	name = "Bandana (Skull)"
	item_path = /obj/item/clothing/mask/bandana/skull

/datum/loadout_item/mask/surgical_mask
	name = "Face Mask"
	item_path = /obj/item/clothing/mask/surgical

/datum/loadout_item/mask/fake_mustache
	name = "Fake Moustache"
	item_path = /obj/item/clothing/mask/fakemoustache

/datum/loadout_item/mask/pipe
	name = "Pipe"
	item_path = /obj/item/clothing/mask/cigarette/pipe

/datum/loadout_item/mask/corn_pipe
	name = "Corn Cob Pipe"
	item_path = /obj/item/clothing/mask/cigarette/pipe/cobpipe

/datum/loadout_item/mask/plague_doctor
	name = "Plague Doctor Mask"
	item_path = /obj/item/clothing/mask/gas/plaguedoctor

/datum/loadout_item/mask/joy
	name = "Joy Mask"
	item_path = /obj/item/clothing/mask/joy

/datum/loadout_item/mask/lollipop
	name = "Lollipop"
	item_path = /obj/item/food/lollipop

///datum/loadout_item/mask/gum
	//name = "Gum"
	//item_path = /obj/item/food/bubblegum

/datum/loadout_item/mask/avianmask_cardinal
	name = "Cardinal Mask"
	item_path = /obj/item/clothing/mask/breath/ornithid/cardinal

/datum/loadout_item/mask/avianmask_secretary
	name = "Secretary Bird Mask"
	item_path = /obj/item/clothing/mask/breath/ornithid/secretary

/datum/loadout_item/mask/avianmask_toucan
	name = "Toucan Mask"
	item_path = /obj/item/clothing/mask/breath/ornithid/toucan

/datum/loadout_item/mask/avianmask_bluejay
	name = "Blue Jay Mask"
	item_path = /obj/item/clothing/mask/breath/ornithid/bluejay
