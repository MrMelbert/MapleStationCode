/// Multitool has no right to be that expensive compared to normal multitools
/datum/design/circuit_multitool
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT, /datum/material/glass = SMALL_MATERIAL_AMOUNT)

// Wiremod components are 1/5th the glass cost.
/datum/design/component
	materials = list(/datum/material/glass = SMALL_MATERIAL_AMOUNT)

// Drone shells don't cost gold.
/datum/design/drone_shell
	materials = list(
		/datum/material/glass = SHEET_MATERIAL_AMOUNT,
		/datum/material/iron = SHEET_MATERIAL_AMOUNT * 6, // (+1 iron sheet in compensation)
	)

// The module duplicate is also 1/4th the cost.
/obj/machinery/module_duplicator
	cost_per_component = SHEET_MATERIAL_AMOUNT * 0.025

/datum/design/headset_shell
	name = "Headset Shell"
	desc = "A portable shell integrated with a radio headset."
	id = "headset_shell"
	build_path = /obj/item/radio/headset/shell
	materials = list(/datum/material/glass =SHEET_MATERIAL_AMOUNT, /datum/material/iron = SHEET_MATERIAL_AMOUNT * 2.5)
	build_type = COMPONENT_PRINTER
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
