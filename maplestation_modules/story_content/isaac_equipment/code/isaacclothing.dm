/obj/item/clothing/under/jumpsuit/paintersuit
	name = "painter's suit"
	desc = "A horrendously expensive suit made out of alien materials. It's well worn, covered in paint and other stains."
	icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_worn.dmi'
	icon_state = "paintersuit"
	body_parts_covered = CHEST|GROIN|ARMS
	alternate_worn_layer = ABOVE_SHOES_LAYER
	inhand_icon_state = null

/datum/loadout_item/under/formal/isaac
	name = "Painter's Suit"
	item_path = /obj/item/clothing/under/jumpsuit/paintersuit

/datum/loadout_item/under/formal/isaac/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/shoes/elvenboots
	name = "elven boots"
	desc = "Expensive boots made out of some sort of alien leather. Smells like looking down your nose at people."
	icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_worn.dmi'
	icon_state = "elvenboots"

/datum/loadout_item/shoes/isaac
	name = "Elven Boots"
	item_path = /obj/item/clothing/shoes/elvenboots

/datum/loadout_item/shoes/isaac/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/under/jumpsuit/advsuit
	name = "adventurer's suit"
	desc = "A suit made to reflect the wearer's new life. There's a small moon attached to the choker and an empty gun holster at its side."
	icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_worn.dmi'
	icon_state = "advsuit"
	body_parts_covered = CHEST|GROIN|ARMS
	inhand_icon_state = null

/datum/loadout_item/under/formal/isaacnew
	name = "Adventurer's Suit"
	item_path = /obj/item/clothing/under/jumpsuit/advsuit

/datum/loadout_item/under/formal/isaacnew/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/shoes/advboots
	name = "adventurer boots"
	desc = "Boots made to fit the new suit. Smells like wanting to be at equal footing with others."
	icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/isaac_equipment/icons/isaacclothing_worn.dmi'
	icon_state = "advboots"

/datum/loadout_item/shoes/isaacnew
	name = "Adventurer Boots"
	item_path = /obj/item/clothing/shoes/advboots

/datum/loadout_item/shoes/isaacnew/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
