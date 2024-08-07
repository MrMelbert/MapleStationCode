/*
 * # Tile Scanner component
 * 
 * Outputs a list of all atoms on a given tile, offset from circuit's position
 */

/obj/item/circuit_component/tile_scanner
	display_name = "Tile Scanner"
	desc = "A component that scans a tile based on an offset from the shell."
	category = "Sensor"

	var/datum/port/input/x_pos
	var/datum/port/input/y_pos

	var/scan_delay = 0.5 SECONDS
	COOLDOWN_DECLARE(scan_cooldown)

	var/datum/port/output/scanned_atoms

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL


/obj/item/circuit_component/tile_scanner/populate_ports()
	x_pos = add_input_port("X offset", PORT_TYPE_NUMBER)
	y_pos = add_input_port("Y offset", PORT_TYPE_NUMBER)
	scanned_atoms = add_output_port("Scanned Objects", PORT_TYPE_LIST(PORT_TYPE_ATOM))
	trigger_output = add_output_port("Triggered", PORT_TYPE_SIGNAL, order = 2)

/obj/item/circuit_component/tile_scanner/input_received(datum/port/input/port, list/return_values)
	if (!COOLDOWN_FINISHED(src, scan_cooldown))
		return

	if (isnull(x_pos.value) || isnull(y_pos.value))
		return

	var/turf/target_turf = locate(parent.shell.x + x_pos.value, parent.shell.y + y_pos.value, parent.shell.z)
	if (!target_turf)
		return

	var/list/result = list(target_turf) + target_turf.contents
	COOLDOWN_START(src, scan_cooldown, scan_delay)
	scanned_atoms.set_output(result)
	trigger_output.set_output(COMPONENT_SIGNAL)
