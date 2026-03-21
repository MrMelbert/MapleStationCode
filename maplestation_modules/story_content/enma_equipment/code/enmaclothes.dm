// -- enma clothes --

/obj/item/clothing/under/jumpsuit/enma
	name = "short black robe"
	desc = "A deep black robe with a very short trim. Colorful outlines adorn the sleeves and front. There's a black collar with the moon attached."
	icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_worn.dmi'
	icon_state = "robe"
	resistance_flags = INDESTRUCTIBLE
	alternate_worn_layer = ABOVE_SHOES_LAYER
	clothing_traits = list(TRAIT_TOXINLOVER, TRAIT_NOBREATH) // no more ahelp for nobreath

/datum/loadout_item/under/formal/enma
	name = "Short Black Robe"
	item_path = /obj/item/clothing/under/jumpsuit/enma

/datum/loadout_item/under/formal/enma/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/suit/enma
	name = "thin blue scarf"
	desc = "A loose scarf that barely clings on, with a yellow scarf to keep it all together. If you look close enough, you can see stars shimmering on it."
	icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_worn.dmi'
	icon_state = "scarf"
	resistance_flags = INDESTRUCTIBLE
	alternate_worn_layer = ABOVE_SHOES_LAYER

/datum/loadout_item/suit/enma
	name = "Thin Blue Scarf"
	item_path = /obj/item/clothing/suit/enma

/datum/loadout_item/suit/enma/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/shoes/enma
	name = "golden leg cuffs"
	desc = "A golden cuff that attaches to the ankle, chained to Venus."
	icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_worn.dmi'
	icon_state = "shackle"
	resistance_flags = INDESTRUCTIBLE

/datum/loadout_item/shoes/enma
	name = "Golden Leg Cuffs"
	item_path = /obj/item/clothing/shoes/enma

/datum/loadout_item/shoes/enma/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/gloves/enma
	name = "golden handcuffs"
	desc = "Golden cuffs chained to several planets, Earth, Jupiter, Mars, and Neptune."
	icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_item.dmi'
	worn_icon = 'maplestation_modules/story_content/enma_equipment/icons/enmaclothes_worn.dmi'
	icon_state = "handcuffs"
	resistance_flags = INDESTRUCTIBLE

/datum/loadout_item/gloves/enma
	name = "Golden Handcuffs"
	item_path = /obj/item/clothing/gloves/enma

/datum/loadout_item/gloves/enma/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
