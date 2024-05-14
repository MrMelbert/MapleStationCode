/obj/item/stack/sheet/mineral/aerialite
	name = "alloyed aerialite"
	desc = "Rare material found in distant lands."
	singular_name = "alloyed aerialite bar"
	icon = "" // ADD SPRITES.
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	icon_state = "sheet-runite"
	inhand_icon_state = "sheet-runite" // ADD SPRITES.
	mats_per_unit = list(/datum/material/aerialite=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gravitum/aerialite = 20)
	merge_type = /obj/item/stack/sheet/mineral/aerialite
	material_type = /datum/material/aerialite
	// FUN FACT: This this actually an aerialite --> cosmilite alloy.

/datum/material/aerialite
	name = "alloyed aerialite"
	desc = "Alloyed Aerialite"
	color = "#00d0ff"
	greyscale_colors = "#00d0ff"
	strength_modifier = 3 // You must be a maniac to forge something out of this in the first place.
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/aerialite
	value_per_unit = 6000 / SHEET_MATERIAL_AMOUNT // Giga valuable.
	beauty_modifier = 1.5 // I think aerialite / cosmilite looks nice.
	armor_modifiers = list(MELEE = 2.5, BULLET = 2.5, LASER = 1.5, ENERGY = 1.5, BOMB = 2.5, BIO = 1, FIRE = 1.5, ACID = 1.5)

/obj/item/stack/sheet/mineral/resmythril
	name = "resonant mythril"
	desc = "Rare material found in distant lands."
	singular_name = "resonant mythril bar"
	icon = ""// ADD SPRITES.
	lefthand_file = 'icons/mob/inhands/items/sheets_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/sheets_righthand.dmi'
	icon_state = "sheet-runite"
	inhand_icon_state = "sheet-runite"// ADD SPRITES.
	mats_per_unit = list(/datum/material/resmythril=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/resmythril = 20)
	merge_type = /obj/item/stack/sheet/mineral/resmythril
	material_type = /datum/material/resmythril
	// FUN FACT: I chose mythril for the scanner module because it's used in the codebreaker's scanner.

/datum/material/resmythril
	name = "resonant mythril"
	desc = "Resonant Mythril"
	color = "#14747c"
	greyscale_colors = "#14747c"
	strength_modifier = 2
	categories = list(MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	sheet_type = /obj/item/stack/sheet/mineral/resmythril
	value_per_unit = 6000 / SHEET_MATERIAL_AMOUNT
	beauty_modifier = 2
	armor_modifiers = list(MELEE = 1.5, BULLET = 1.5, LASER = 2.5, ENERGY = 2.5, BOMB = 1.5, BIO = 1, FIRE = 2.5, ACID = 1.5)
	// We already have mythril in the code, so this is resonant.
