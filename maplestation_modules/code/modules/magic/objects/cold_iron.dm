//Cold-iron

/datum/material/iron/cold_iron
	name = "Cold Wrought Iron"
	desc = "A handforged magical iron metal. It is very difficult to make and commands a very high price point."
	color = "#c6c9c9"
	greyscale_colors = "#c6c9c9"
	sheet_type = /obj/item/stack/sheet/iron/cold_iron
	categories = list(MAT_CATEGORY_ORE = FALSE, MAT_CATEGORY_RIGID = TRUE, MAT_CATEGORY_BASE_RECIPES = TRUE, MAT_CATEGORY_ITEM_MATERIAL=TRUE)
	value_per_unit = 1000 / SHEET_MATERIAL_AMOUNT
	tradable = FALSE

/datum/reagent/iron/cold_iron
	name = "Cold Iron"
	description = "Cold iron is a magical metal."
	taste_description = "spicy iron"
	material = /datum/material/iron/cold_iron
	color = "#c6c9c9"

/obj/item/stack/sheet/iron/cold_iron
	name = "Cold Wrought Iron"
	singular_name = "Cold Wrought Iron sheet"
	desc = "A sheet of handforged magical iron metal. It is very difficult to make and commands a very high price point."
	icon_state = "sheet-coldiron"
	icon = 'maplestation_modules/icons/obj/magic/magic_metals.dmi'
	merge_type = /obj/item/stack/sheet/iron/cold_iron
	grind_results = list(/datum/reagent/iron/cold_iron = 20)
	material_type = /datum/material/iron/cold_iron

//pure cold iron
/datum/material/iron/cold_iron/pure
	name = "Pure Cold Wrought Iron"
	desc = "A perfectly pure handforged magical iron metal. It appears to almost glow."
	color = "#cecdc3"
	greyscale_colors = "#cecdc3"
	sheet_type = /obj/item/stack/sheet/iron/cold_iron/pure
	value_per_unit = 10000 / SHEET_MATERIAL_AMOUNT
	tradable = FALSE


/obj/item/stack/sheet/iron/cold_iron/pure
	name = "Pure Cold Wrought Iron"
	singular_name = "Pure Cold Wrought Iron sheet"
	desc = "A perfectly pure sheet of handforged magical iron metal. It is very difficult to make and commands an extremely high price point."
	icon_state = "sheet-purecoldiron"
	merge_type = /obj/item/stack/sheet/iron/cold_iron/pure
	grind_results = list(/datum/reagent/iron/cold_iron = 20) //loses its grandeur when grinded. its all in the crystal structure, maybe!
	material_type = /datum/material/iron/cold_iron/pure
