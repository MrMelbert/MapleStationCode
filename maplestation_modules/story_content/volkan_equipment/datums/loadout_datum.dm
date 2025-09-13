
/datum/loadout_item/suit/ce/volkan
	name = "Modified CE Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/ce/volkan

/datum/loadout_item/suit/ce/volkan/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/datum/loadout_item/pocket_items/rad_umbrella
	name = "Umbrella (Radiation Shielded)"
	item_path = /obj/item/umbrella/volkan

/datum/loadout_item/pocket_items/rad_umbrella/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
