// --- hat ---
/obj/item/clothing/head/hats/reshiacap
	name = "black delinquent cap"
	desc = "A black cap with small golden studs and a golden emblem. You have no reason to wear this correctly."
	icon = 'maplestation_modules/story_content/reshia_equipment/icons/reshclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/reshia_equipment/icons/reshclothes_worn.dmi'
	icon_state = "delinquent"

/datum/loadout_item/head/reshiacap
	name = "Cap (Delinquent, Black)"
	item_path = /obj/item/clothing/head/hats/reshiacap

/datum/loadout_item/head/reshiacap/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

// --- coat ---
/obj/item/clothing/under/jumpsuit/reshiacoat
	name = "black uniform coat"
	desc = "A long black coat reminescent of that to a school uniform, with a gold and red armband attached. The fabric feels otherworldly."
	icon = 'maplestation_modules/story_content/reshia_equipment/icons/reshclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/reshia_equipment/icons/reshclothes_worn.dmi'
	icon_state = "blackuniform"

/datum/loadout_item/under/formal/reshiacoat
	name = "Black Uniform Coat"
	item_path = /obj/item/clothing/under/jumpsuit/reshiacoat

/datum/loadout_item/under/formal/reshiacoat/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

// --- shoes ---
/obj/item/clothing/shoes/reshiaboot
	name = "short brown boots"
	desc = "Leather boots that have seem to be roughly cut short. Looks like they've seen better days."
	icon = 'maplestation_modules/story_content/reshia_equipment/icons/reshclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/reshia_equipment/icons/reshclothes_worn.dmi'
	icon_state = "shortboot"

/datum/loadout_item/shoes/reshiaboot
	name = "Short Brown Boots"
	item_path = /obj/item/clothing/shoes/reshiaboot
