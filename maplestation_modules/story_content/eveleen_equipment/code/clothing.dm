///obj/item/clothing/head/bow/sweet
//	name = "sweet bow"
//	desc = "A sweet bow that you can place on the back of your head."
//	icon_state = "sweet_bow"
//	icon_preview = 'modular_doppler/modular_cosmetics/GAGS/icons/obj/head.dmi'
//	icon_state_preview = "sweet_bow"
//	greyscale_config = /datum/greyscale_config/sweet_bow
//	greyscale_config_worn = /datum/greyscale_config/sweet_bow/worn
//	greyscale_colors = "#7b9ab5"
//	flags_1 = IS_PLAYER_COLORABLE_1

///datum/greyscale_config/sweet_bow
//	name = "Sweet Bow"
//	icon_file = 'modular_doppler/modular_cosmetics/GAGS/icons/obj/head.dmi'
//	json_config = 'modular_doppler/modular_cosmetics/GAGS/json_configs/head/sweet_bow.json'

///datum/greyscale_config/sweet_bow/worn
//	name = "Sweet Bow (Worn)"
//	icon_file = 'modular_doppler/modular_cosmetics/GAGS/icons/mob/head.dmi'

// TODO: all of the above

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
