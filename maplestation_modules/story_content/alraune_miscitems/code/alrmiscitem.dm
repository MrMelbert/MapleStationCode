// --- talisman ---

/obj/item/clothing/head/costume/goldfulu
	name = "golden fulu"
	desc = "A golden talisman with an unknown script written in red."
	icon = 'maplestation_modules/story_content/alraune_miscitems/icons/alrmiscitem_item.dmi'
	worn_icon = 'maplestation_modules/story_content/alraune_miscitems/icons/alrmiscitem_worn.dmi'
	icon_state = "fulu"
	resistance_flags = INDESTRUCTIBLE
	clothing_traits = list(TRAIT_TOXINLOVER)

/datum/loadout_item/head/goldfulu
	name = "Golden Fulu"
	item_path = /obj/item/clothing/head/costume/goldfulu

/datum/loadout_item/head/goldfulu/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
