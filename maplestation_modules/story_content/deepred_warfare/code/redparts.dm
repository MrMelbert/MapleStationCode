/obj/item/stock_parts/cell/redtech
	name = "strange red power cell"
	desc = "A strange red power cell. Its design is unlike anything you've seen before. It seems to be EMP resistant."
	icon = 'maplestation_modules/story_content/deepred_warfare/icons/redparts.dmi'
	icon_state = "redcell"
	// Just an EMP resistant bluespace cell.
	maxcharge = STANDARD_CELL_CHARGE * 40
	custom_materials = list(/datum/material/glass=HALF_SHEET_MATERIAL_AMOUNT)
	chargerate = STANDARD_CELL_CHARGE * 4

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
	custom_materials = list(/datum/material/iron=HALF_SHEET_MATERIAL_AMOUNT)
