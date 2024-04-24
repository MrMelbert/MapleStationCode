/obj/item/stock_parts/cell/redtech
	name = "strange red power cell"
	desc = "A strange red power cell. Its design is unlike anything you've seen before. It seems to be EMP resistant."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/redparts.dmi'
	icon_state = "redcell"
	connector_type = "redcellconnector"
	// Just an EMP resistant bluespace cell.
	maxcharge = STANDARD_CELL_CHARGE * 40
	chargerate = STANDARD_CELL_CHARGE * 4
	// Useful for scrapping.
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/plasma=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=HALF_SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/consumable/liquidelectricity/auric = 15)

/obj/item/stock_parts/cell/redtech/empty
	empty = TRUE

/obj/item/stock_parts/cell/redtech/Initialize(mapload)
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)
	return ..()

/obj/item/stock_parts/servo/redtech
	name = "precise red servo"
	desc = "A precise red servo motor. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/redparts.dmi'
	icon_state = "redservo"
	// Just a reskinned femto servo.
	rating = 4
	energy_rating = 10
	// Useful for scrapping.
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/diamond=HALF_SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/titanium = 15, /datum/reagent/gravitum/aerialite = 15)

/obj/item/stock_parts/capacitor/redtech
	name = "powerful red capacitor"
	desc = "A powerful red capacitor. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/redparts.dmi'
	icon_state = "redcapacitor"
	// Reskinned quadratic capacitor.
	rating = 4
	energy_rating = 10
	// Useful for scrapping.
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/titanium=HALF_SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=HALF_SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/consumable/liquidelectricity/auric = 15)
