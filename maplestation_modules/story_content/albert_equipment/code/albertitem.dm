// --- plushie ---
/obj/item/toy/plush/albertcat
	name = "Albus"
	desc = "A handstitched white and red cat plush. Holding it, your heart feels heavy.."
	icon = 'maplestation_modules/story_content/albert_equipment/icons/albertitem_item.dmi'
	icon_state = "albus"
	inhand_icon_state = null

/datum/loadout_item/pocket_items/plush/albertcat
	name = "Plush (Albus)"
	item_path = /obj/item/toy/plush/albertcat

/datum/loadout_item/pocket_items/plush/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
