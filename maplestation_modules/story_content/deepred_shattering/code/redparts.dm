/datum/stock_part/energy_rating()
	switch (tier)
		if (1)
			return 1
		if (2)
			return 3
		if (3)
			return 5
		if (4)
			return 10
		if (5)
			return 50
		else
			CRASH("Invalid level given to energy_rating: [tier]")

/obj/item/stock_parts/power_store/cell/redtech
	name = "processed red power cell"
	desc = "A processed power cell. Its design is unlike anything you've seen before. It seems to be EMP resistant."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redcell"
	connector_type = null // GOD it's hardcoded.
	charge_light_type = null
	rating_base = STANDARD_CELL_CHARGE * 2

	maxcharge = STANDARD_CELL_CHARGE * 60
	chargerate = STANDARD_CELL_RATE * 5

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/plasma=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/consumable/liquidelectricity/auric = 15)

/obj/item/stock_parts/power_store/cell/redtech/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/redtech/Initialize(mapload)
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)
	return ..()

/obj/item/stock_parts/power_store/cell/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redcellemissive", src, alpha = src.alpha)

/obj/item/stock_parts/servo/redtech
	name = "alloyed red servo"
	desc = "An alloyed servo module. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redservo"

	rating = 5
	energy_rating = 20

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/titanium=SHEET_MATERIAL_AMOUNT, /datum/material/diamond=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/carbon = 15, /datum/reagent/gravitum/aerialite = 15)

/obj/item/stock_parts/servo/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redservoemissive", src, alpha = src.alpha)

/obj/item/stock_parts/servo/redtech/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/stock_part/servo/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/servo/redtech

/obj/item/stock_parts/capacitor/redtech
	name = "processed red capacitor"
	desc = "A processed capacitor module. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redcapacitor"

	rating = 5
	energy_rating = 20

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/titanium=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/consumable/liquidelectricity/auric = 15)

/obj/item/stock_parts/capacitor/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redcapacitoremissive", src, alpha = src.alpha)

/obj/item/stock_parts/capacitor/redtech/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/stock_part/capacitor/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/capacitor/redtech

/obj/item/stock_parts/scanning_module/redtech
	name = "resonant red scanning module"
	desc = "A resonant scanning module. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redscanner"

	rating = 5
	energy_rating = 20

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/gold=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 15, /datum/reagent/bluespace = 15, /datum/reagent/resmythril = 15)

/obj/item/stock_parts/scanning_module/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redscanneremissive", src, alpha = src.alpha)

/obj/item/stock_parts/scanning_module/redtech/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/stock_part/scanning_module/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/scanning_module/redtech

/obj/item/stock_parts/micro_laser/redtech
	name = "crystalline red micro laser"
	desc = "A crystalline laser module. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redlaser"

	rating = 5
	energy_rating = 20

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/uranium=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/uranium = 15, /datum/reagent/bluespace = 15, /datum/reagent/exodust = 15)

/obj/item/stock_parts/micro_laser/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redlaseremissive", src, alpha = src.alpha)

/obj/item/stock_parts/micro_laser/redtech/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/stock_part/micro_laser/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/micro_laser/redtech

/obj/item/stock_parts/matter_bin/redtech
	name = "condensed red matter bin"
	desc = "A condensed matter bin. Its design is unlike anything you've seen before."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redmatterbin"

	rating = 5
	energy_rating = 20

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/titanium=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/darkplasma = 15)

/obj/item/stock_parts/matter_bin/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redmatterbinemissive", src, alpha = src.alpha)

/obj/item/stock_parts/matter_bin/redtech/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/stock_part/matter_bin/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/matter_bin/redtech
