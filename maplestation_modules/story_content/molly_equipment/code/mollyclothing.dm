/obj/item/clothing/suit/toggle/mollycloak
	name = "\improper Six Shooter's Cloak"
	desc = "A custom made cloak with a muffler. Good for any terrain or weather. Seems to hide a lot underneath.."
	icon = 'maplestation_modules/story_content/molly_equipment/icons/mollyclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/molly_equipment/icons/mollyclothing_worn.dmi'
	icon_state = "mollycloak"
	toggle_noun = "cloak"
	resistance_flags = INDESTRUCTIBLE

/obj/item/clothing/suit/toggle/mollycloak/Initialize(mapload)
	. = ..()

	create_storage(storage_type = /datum/storage/bag_of_holding)

/datum/loadout_item/suit/molly
	name = "Six Shooter's Cloak"
	item_path = /obj/item/clothing/suit/toggle/mollycloak
	additional_displayed_text = list("Character Item")

/obj/item/clothing/head/hats/mollyhat
	name = "\improper Six Shooter's Hat"
	desc = "An out of place witch's hat. It's a bit worn and ridden with bullet holes.."
	icon = 'maplestation_modules/story_content/molly_equipment/icons/mollyclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/molly_equipment/icons/mollyclothing_worn.dmi'
	icon_state = "mollyhat"
	resistance_flags = INDESTRUCTIBLE

/datum/loadout_item/head/molly
	name = "Six Shooter's Hat"
	item_path = /obj/item/clothing/head/hats/mollyhat
	additional_displayed_text = list("Character Item")
