/*
 * # Mining component
 * 
 *  Allows to mine rocks walls and floors
 */

/obj/item/circuit_component/mining
	display_name = "Mining"
	desc = "A component that can mine rock turfs. Only works with drone shells."
	category = "Action"

	var/datum/port/input/target
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/mining/populate_ports()
	target = add_input_port("Target", PORT_TYPE_ATOM)
	
/obj/item/circuit_component/mining/input_received(datum/port/input/port)
	var/atom/target_atom = target.value

	var/mob/shell = parent.shell
	if(!istype(shell) || !shell.CanReach(target_atom))
		return

	if (ismineralturf(target_atom))
		var/turf/closed/mineral/wall = target_atom
		wall.gets_drilled(shell, FALSE)
		return
	
	if (isasteroidturf(target_atom))
		var/turf/open/misc/asteroid/floor = target_atom
		floor.getDug()
		return
