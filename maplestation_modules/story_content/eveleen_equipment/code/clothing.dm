/obj/item/clothing/head/bow/sweet
	name = "sweet bow"
	desc = "A sweet bow that you can place on the back of your head."
	icon = 'icons/map_icons/clothing/head/_head.dmi'
	icon_state = "/obj/item/clothing/head/bow/sweet"
	post_init_icon_state = "sweet_bow"
	greyscale_config = /datum/greyscale_config/sweet_bow
	greyscale_config_worn = /datum/greyscale_config/sweet_bow/worn
	greyscale_colors = "#7b9ab5"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/under/rank/medical/paramedic/green
	name = "green paramedic jumpsuit"
	desc = "Similarly made like other paramedic's clothings, though it's green, likely brought from another sector."
	icon = 'maplestation_modules/story_content/eveleen_equipment/icons/obj/medical.dmi'
	worn_icon = 'maplestation_modules/story_content/eveleen_equipment/icons/mob/medical.dmi'


/obj/item/clothing/suit/toggle/labcoat/medical/green
	name = "green medical labcoat"
	desc = "A suit that protects against minor chemical spills. This one is greener than you'd typically expect."
	icon = 'maplestation_modules/story_content/eveleen_equipment/icons/obj/labcoat.dmi'
	worn_icon = 'maplestation_modules/story_content/eveleen_equipment/icons/mob/labcoat.dmi'
	icon_state = "labcoat_med"

/obj/item/clothing/neck/mantle
	name = "hazard mantle"
	desc = "A mantle made of fire and acid proof materials to protect the wearer."
	icon = 'maplestation_modules/story_content/eveleen_equipment/icons/obj/mantle.dmi'
	worn_icon = 'maplestation_modules/story_content/eveleen_equipment/icons/mob/mantle.dmi'
	icon_state = "light"
	inhand_icon_state = null
	w_class = WEIGHT_CLASS_SMALL
	body_parts_covered = CHEST|ARMS
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/gloves/latex/nitrile/green
	name = "green nitrile gloves"
	desc = "Pricy sterile gloves that are thicker than latex. And it's also green."
	icon = 'maplestation_modules/story_content/eveleen_equipment/icons/obj/gloves.dmi'
	worn_icon = 'maplestation_modules/story_content/eveleen_equipment/icons/mob/gloves.dmi'
	greyscale_colors = "#298b32"

/obj/item/clothing/shoes/medical/green
	name = "green medical shoes"
	desc = "Comfortable-looking shoes, though also quite distinct."
	icon = 'maplestation_modules/story_content/eveleen_equipment/icons/obj/shoes.dmi'
	icon_state = "medical"
	worn_icon = 'maplestation_modules/story_content/eveleen_equipment/icons/mob/shoes.dmi'

/datum/loadout_item/head/sweet_bow
	name = "Sweet Bow"
	item_path = /obj/item/clothing/head/bow/sweet

/datum/loadout_item/head/sweet_bow/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/datum/loadout_item/under/jumpsuit/green_paramedic
	name = "Green Paramedic Jumpsuit"
	item_path = /obj/item/clothing/under/rank/medical/paramedic/green

/datum/loadout_item/under/jumpsuit/green_paramedic/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/datum/loadout_item/suit/green_labcoat
	name = "Green Medical Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/medical/green

/datum/loadout_item/suit/green_labcoat/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/datum/loadout_item/neck/mantle
	name = "Hazard Mantle"
	item_path = /obj/item/clothing/neck/mantle

/datum/loadout_item/gloves/green_nitrile
	name = "Green Nitrile Gloves"
	item_path = /obj/item/clothing/gloves/latex/nitrile/green

/datum/loadout_item/gloves/green_nitrile/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/datum/loadout_item/shoes/green_medical
	name = "green medical shoes"
	item_path = /obj/item/clothing/shoes/medical/green

/datum/loadout_item/shoes/green_medical/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/datum/sprite_accessory/hair/nia
	name = "Nia"
	icon = 'maplestation_modules/icons/mob/human_face.dmi'
	icon_state = "hair_nia"
