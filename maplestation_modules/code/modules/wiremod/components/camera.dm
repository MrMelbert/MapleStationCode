/**
 * # Camera component
 * 
 * Adds a camera to the shell
 */

/obj/item/circuit_component/circuit_camera
	display_name = "Camera"
	desc = "A component that links to the station's camera network."
	category = "Entity"

	var/datum/port/input/enable_trigger
	var/datum/port/input/disable_trigger
	var/datum/port/input/tag_input

	var/datum/port/output/enabled
	var/datum/port/output/disabled

	var/obj/machinery/camera/circuit/camera

/obj/item/circuit_component/circuit_camera/populate_ports()
	tag_input = add_input_port("Camera name", PORT_TYPE_STRING)
	enable_trigger = add_input_port("Enable", PORT_TYPE_SIGNAL)
	disable_trigger = add_input_port("Disable", PORT_TYPE_SIGNAL)

	enabled = add_output_port("Enabled", PORT_TYPE_SIGNAL)
	disabled = add_output_port("Disabled", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/circuit_camera/register_shell(atom/movable/shell)
	camera = new(shell)

/obj/item/circuit_component/circuit_camera/unregister_shell(atom/movable/shell)
	QDEL_NULL(camera)

/obj/item/circuit_component/circuit_camera/input_received(datum/port/input/port)
	if (isnull(camera))
		return

	camera.c_tag = tag_input.value

	if(COMPONENT_TRIGGERED_BY(enable_trigger, port) && !camera.status)
		camera.toggle_cam()
		enabled.set_output(COMPONENT_SIGNAL)

	if(COMPONENT_TRIGGERED_BY(disable_trigger, port) && camera.status)
		camera.toggle_cam()
		disabled.set_output(COMPONENT_SIGNAL)

/obj/machinery/camera/circuit
	c_tag = "Circuit Shell: Unspecified"
	desc = "This camera belongs in a circuit shell. If you see this, tell a coder!"
	network = list("ss13", "rd")
