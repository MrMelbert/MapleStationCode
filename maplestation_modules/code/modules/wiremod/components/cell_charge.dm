/**
 * # Cell Charge Component
 *
 * Returns circuit's current cell charge and its capacity
 */

/obj/item/circuit_component/cell_charge
	display_name = "Cell Charge"
	desc = "A component that reads current cell charge and its maximum capacity."
	category = "Sensor"

	var/datum/port/output/current_charge
	var/datum/port/output/max_charge

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/cell_charge/populate_ports()
	current_charge = add_output_port("Current Charge", PORT_TYPE_NUMBER)
	max_charge = add_output_port("Max Charge", PORT_TYPE_NUMBER)

/obj/item/circuit_component/cell_charge/input_received(datum/port/input/port)
	var/obj/item/stock_parts/cell/battery = parent.cell

	if(!istype(battery))
		return

	max_charge.set_output(battery.maxcharge)
	current_charge.set_output(battery.charge)
