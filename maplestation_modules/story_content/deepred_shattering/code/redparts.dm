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
			return 100
		else
			CRASH("Invalid level given to energy_rating: [tier]")

/obj/item/stock_parts/power_store/cell/redtech
	name = "processed redtech power cell"
	desc = "An advanced redtech power cell. It seems to be EMP resistant."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redcell"
	connector_type = null
	charge_light_type = null

	maxcharge = STANDARD_CELL_CHARGE * 100
	chargerate = STANDARD_CELL_RATE * 5

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/plasma=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/consumable/liquidelectricity/auric = 15)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/rtechdrive

/obj/item/stock_parts/power_store/cell/redtech/empty
	empty = TRUE

/obj/item/stock_parts/power_store/cell/redtech/Initialize(mapload)
	AddElement(/datum/element/empprotection, EMP_PROTECT_SELF)
	update_appearance()
	return ..()

/obj/item/stock_parts/power_store/cell/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redcellemissive", src, alpha = src.alpha)

/obj/item/stock_parts/servo/redtech
	name = "alloyed redtech servo"
	desc = "An alloyed redtech servo module. It sports an extremely lightweight yet durable design."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redservo"

	rating = 5
	energy_rating = 100

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/titanium=SHEET_MATERIAL_AMOUNT, /datum/material/diamond=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/carbon = 15, /datum/reagent/gravitum/aerialite = 15)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/rtechdrive

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
	name = "processed redtech capacitor"
	desc = "A processed redtech capacitor module. It seems to be able to withstand very high temperatures."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redcapacitor"

	rating = 5
	energy_rating = 100

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/titanium=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/consumable/liquidelectricity/auric = 15)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/rtechdrive

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
	name = "resonant redtech scanning module"
	desc = "A resonant redtech scanning module. It seems to be able to analyze space and time on a dimensional level."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redscanner"

	rating = 5
	energy_rating = 100

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/gold=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/gold = 15, /datum/reagent/bluespace = 15, /datum/reagent/resmythril = 15)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/rtechdrive

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
	name = "crystalline redtech micro laser"
	desc = "A crystalline redtech laser module. Despite its small size, it is able to project a disportionate amount of energy."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redlaser"

	rating = 5
	energy_rating = 100

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/uranium=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/uranium = 15, /datum/reagent/bluespace = 15, /datum/reagent/exodust = 15)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/rtechdrive

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
	name = "condensed redtech matter bin"
	desc = "A condensed redtech matter bin. It seems to compress matter on a disturbingly efficient level."
	icon = 'maplestation_modules/story_content/deepred_shattering/icons/redparts.dmi'
	icon_state = "redmatterbin"

	rating = 5
	energy_rating = 100

	custom_materials = list(/datum/material/iron=SHEET_MATERIAL_AMOUNT, /datum/material/titanium=SHEET_MATERIAL_AMOUNT, /datum/material/bluespace=SHEET_MATERIAL_AMOUNT)
	grind_results = list(/datum/reagent/iron = 15, /datum/reagent/bluespace = 15, /datum/reagent/darkplasma = 15)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	armor_type = /datum/armor/rtechdrive

/obj/item/stock_parts/matter_bin/redtech/update_overlays()
	. = ..()
	. += emissive_appearance(icon, "redmatterbinemissive", src, alpha = src.alpha)

/obj/item/stock_parts/matter_bin/redtech/Initialize(mapload)
	. = ..()
	update_appearance()

/datum/stock_part/matter_bin/tier5
	tier = 5
	physical_object_type = /obj/item/stock_parts/matter_bin/redtech

/obj/machinery/chem_dispenser/RefreshParts()
	. = ..()
	for(var/datum/stock_part/servo/servo in component_parts)
		if (servo.tier > 4)
			dispensable_reagents |= emagged_reagents
		else
			dispensable_reagents -= emagged_reagents
