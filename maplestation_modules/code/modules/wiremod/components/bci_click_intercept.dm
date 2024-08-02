/**
 * # Click Interceptor Component
 *
 * Outputs a signal when the user clicks on something. If its been primed via a signal, their click will be negated completely.
 * Requires a BCI shell.
 */

/obj/item/circuit_component/click_interceptor
	display_name = "Click Interceptor"
	desc = "A component that allows the user to pinpoint an object using their mind. Sending an input will negate the next input the user does. Requires a BCI shell."
	category = "BCI"

	required_shells = list(/obj/item/organ/internal/cyberimp/bci)

	var/datum/port/input/click_toggle
	var/datum/port/input/move_toggle

	var/datum/port/output/left_click
	var/datum/port/output/right_click
	var/datum/port/output/middle_click

	var/datum/port/output/north
	var/datum/port/output/east
	var/datum/port/output/south
	var/datum/port/output/west

	var/datum/port/output/clicked_atom

	// Click modifiers
	var/datum/port/output/alt_click
	var/datum/port/output/ctrl_click
	var/datum/port/output/shift_click

	var/obj/item/organ/internal/cyberimp/bci/bci
	var/intercept_click = FALSE
	var/intercept_move = FALSE

/obj/item/circuit_component/click_interceptor/populate_ports()
	north = add_output_port("North", PORT_TYPE_SIGNAL)
	east = add_output_port("East", PORT_TYPE_SIGNAL)
	south = add_output_port("South", PORT_TYPE_SIGNAL)
	west = add_output_port("West", PORT_TYPE_SIGNAL)

	left_click = add_output_port("Left Click", PORT_TYPE_SIGNAL)
	right_click = add_output_port("Right Click", PORT_TYPE_SIGNAL)
	middle_click = add_output_port("Middle Click", PORT_TYPE_SIGNAL)

	clicked_atom = add_output_port("Target", PORT_TYPE_ATOM)

	alt_click = add_output_port("Alt Click", PORT_TYPE_NUMBER)
	shift_click = add_output_port("Shift Click", PORT_TYPE_NUMBER)
	ctrl_click = add_output_port("Ctrl Click", PORT_TYPE_NUMBER)

	click_toggle = add_output_port("Intercept Next Click", PORT_TYPE_SIGNAL)
	move_toggle = add_output_port("Intercept Move Click", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/click_interceptor/register_shell(atom/movable/shell)
	if(!istype(shell, /obj/item/organ/internal/cyberimp/bci))
		return

	bci = shell
	RegisterSignal(bci, COMSIG_ORGAN_IMPLANTED, PROC_REF(on_implanted))
	RegisterSignal(bci, COMSIG_ORGAN_REMOVED, PROC_REF(on_removed))
	
	var/mob/living/owner = bci.owner
	if(istype(owner))
		RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
		RegisterSignal(owner, COMSIG_MOB_CLIENT_PRE_MOVE, PROC_REF(handle_move))

/obj/item/circuit_component/click_interceptor/unregister_shell(atom/movable/shell)
	UnregisterSignal(bci, list(COMSIG_ORGAN_IMPLANTED, COMSIG_ORGAN_REMOVED))
	if (istype(bci.owner))
		UnregisterSignal(bci.owner, list(COMSIG_MOB_CLICKON, COMSIG_MOB_CLIENT_PRE_MOVE))
	bci = null

/obj/item/circuit_component/click_interceptor/input_received(datum/port/input/port)
	if (COMPONENT_TRIGGERED_BY(click_toggle, port))
		intercept_click = TRUE
	if (COMPONENT_TRIGGERED_BY(move_toggle, port))
		intercept_move = TRUE

/obj/item/circuit_component/click_interceptor/proc/handle_move(datum/source, list/move_args)
	SIGNAL_HANDLER
	var/move_dir = get_dir(get_turf(source), move_args[MOVE_ARG_NEW_LOC])

	if (move_dir & NORTH)
		north.set_output(COMPONENT_SIGNAL)
	if (move_dir & EAST)
		east.set_output(COMPONENT_SIGNAL)
	if (move_dir & SOUTH)
		south.set_output(COMPONENT_SIGNAL)
	if (move_dir & WEST)
		west.set_output(COMPONENT_SIGNAL)
	
	if (intercept_move)
		return COMSIG_MOB_CLIENT_BLOCK_PRE_MOVE

/obj/item/circuit_component/click_interceptor/proc/on_implanted(datum/source, mob/living/carbon/owner)
	SIGNAL_HANDLER
	RegisterSignal(owner, COMSIG_MOB_CLICKON, PROC_REF(handle_click))
	RegisterSignal(owner, COMSIG_MOB_CLIENT_PRE_MOVE, PROC_REF(handle_move))

/obj/item/circuit_component/click_interceptor/proc/on_removed(datum/source, mob/living/carbon/owner)
	SIGNAL_HANDLER
	UnregisterSignal(owner, list(COMSIG_MOB_CLICKON, COMSIG_MOB_CLIENT_PRE_MOVE))
	
/obj/item/circuit_component/click_interceptor/proc/handle_click(mob/living/source, atom/target, list/modifiers)
	SIGNAL_HANDLER

	if (source.stat >= UNCONSCIOUS)
		return

	alt_click.set_output(LAZYACCESS(modifiers, ALT_CLICK))
	shift_click.set_output(LAZYACCESS(modifiers, SHIFT_CLICK))
	ctrl_click.set_output(LAZYACCESS(modifiers, CTRL_CLICK))

	clicked_atom.set_output(target)

	if (LAZYACCESS(modifiers, RIGHT_CLICK))
		right_click.set_output(COMPONENT_SIGNAL)
	else if (LAZYACCESS(modifiers, MIDDLE_CLICK))
		middle_click.set_output(COMPONENT_SIGNAL)
	else
		left_click.set_output(COMPONENT_SIGNAL)
	
	if (intercept_click)
		intercept_click = FALSE
		return COMSIG_MOB_CANCEL_CLICKON
