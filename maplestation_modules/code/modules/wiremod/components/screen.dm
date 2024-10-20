/**
 * # Screen component
 *
 * Displays text when examined
 * Can flash the message to all viewers
 * Returns entity when examined
 */
/obj/item/circuit_component/screen
	display_name = "Screen"
	desc = "A component that displays information. Activating the component will make it flash the message to all nearby viewers."
	category = "Entity"

	/// The input port
	var/datum/port/input/input_port

	/// Entity that examined the circuit
	var/datum/port/output/viewer
	var/datum/port/output/observed

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/screen/populate_ports()
	input_port = add_input_port("Display text", PORT_TYPE_STRING)
	viewer = add_output_port("Viewer", PORT_TYPE_ATOM)
	observed = add_output_port("Observed", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/screen/input_received(datum/port/input/port)
	var/atom/owner = parent.shell || parent
	owner.visible_message("[icon2html(owner, viewers(owner))] [owner] flashes \"[span_notice(input_port.value)]\" on its screen.")

/obj/item/circuit_component/screen/register_shell(atom/movable/shell)
	RegisterSignal(shell, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/obj/item/circuit_component/screen/unregister_shell(atom/movable/shell)
	UnregisterSignal(shell, COMSIG_ATOM_EXAMINE)

/obj/item/circuit_component/screen/proc/on_examine(atom/source, mob/user, list/examine_list)
	SIGNAL_HANDLER

	examine_list += span_notice("It's screen is displaying \"[input_port.value]\"")
	viewer.set_output(user)
	observed.set_output(COMPONENT_SIGNAL)
