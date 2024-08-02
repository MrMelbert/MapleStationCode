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

/datum/design/component/bci_click
	name = "Click Interceptor Component"
	id = "comp_bci_click"
	build_path = /obj/item/circuit_component/click_interceptor

/datum/design/component/circuit_camera
	name = "Camera Component"
	id = "comp_circuit_camera"
	build_path = /obj/item/circuit_component/circuit_camera

/datum/design/component/cell_charge
	name = "Cell Charge Component"
	id = "comp_cell_charge"
	build_path = /obj/item/circuit_component/cell_charge

/datum/design/component/mining
	name = "Mining Component"
	id = "comp_mining"
	build_path = /obj/item/circuit_component/mining

/datum/design/component/screen
	name = "Screen Component"
	id = "comp_screen"
	build_path = /obj/item/circuit_component/screen

/datum/design/component/tile_scanner
	name = "Tile Scanner Component"
	id = "comp_tile_scanner"
	build_path = /obj/item/circuit_component/tile_scanner
	