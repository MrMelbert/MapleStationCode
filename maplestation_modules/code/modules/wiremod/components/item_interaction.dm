s/*
 * # Item Interaction component
 * 
 * Allows a shell to left, right or middle click an atom next to it. Supports ctrl, shift and alt clicking. Drone shell only.
 * 
 * Currently admin-only because I'm afraid this could generate far too many runtimes
 */

/obj/item/circuit_component/item_interact
	display_name = "Item Interaction"
	desc = "A component that allows a shell to interact with objects right next to it. Drone shell only."
	category = "Action"

	var/datum/port/input/target

	var/datum/port/input/left_click
	var/datum/port/input/middle_click
	var/datum/port/input/right_click

	var/datum/port/input/alt_click
	var/datum/port/input/shift_click
	var/datum/port/input/ctrl_click
	var/datum/port/input/in_hand_click

	var/click_delay = 0.8 SECONDS // Same as click cooldown
	COOLDOWN_DECLARE(click_cooldown)

/obj/item/circuit_component/item_interact/populate_ports()
	target = add_input_port("Target", PORT_TYPE_ATOM)

	left_click = add_input_port("Left Click", PORT_TYPE_SIGNAL)
	middle_click = add_input_port("Middle Click", PORT_TYPE_SIGNAL)
	right_click = add_input_port("Right Click", PORT_TYPE_SIGNAL)

	alt_click = add_input_port("Alt Click", PORT_TYPE_NUMBER)
	shift_click = add_input_port("Shift Click", PORT_TYPE_NUMBER)
	ctrl_click = add_input_port("Ctrl Click", PORT_TYPE_NUMBER)
	in_hand_click = add_input_port("In-Hand Click", PORT_TYPE_NUMBER)

	trigger_output = add_output_port("Triggered", PORT_TYPE_SIGNAL, order = 2)

/obj/item/circuit_component/item_interact/input_received(datum/port/input/port, list/return_values)
	if (!COOLDOWN_FINISHED(src, click_delay))
		return

	if (isnull(target.value))
		return

	if (!COMPONENT_TRIGGERED_BY(left_click, port) && !COMPONENT_TRIGGERED_BY(middle_click, port) && !COMPONENT_TRIGGERED_BY(right_click, port))
		return

	var/mob/shell = parent.shell
	if(!istype(shell) || !shell.CanReach(target.value))
		return

	var/list/modifiers = list()

	if (alt_click.value)
		modifiers[ALT_CLICK] = TRUE
	if (shift_click.value)
		modifiers[SHIFT_CLICK] = TRUE
	if (ctrl_click.value)
		modifiers[CTRL_CLICK] = TRUE
	
	if (in_hand_click.value)
		if (!isitem(target.value))
			return
		
		var/obj/item/target_item = target.value
		if (COMPONENT_TRIGGERED_BY(left_click, port))
			target_item.attack_self(shell, modifiers)
			COOLDOWN_START(src, click_cooldown, click_delay)
			trigger_output.set_output(COMPONENT_SIGNAL)

		if (COMPONENT_TRIGGERED_BY(right_click, port))
			target_item.attack_self_secondary(shell, modifiers)
			COOLDOWN_START(src, click_cooldown, click_delay)
			trigger_output.set_output(COMPONENT_SIGNAL)
		return

	if (COMPONENT_TRIGGERED_BY(left_click, port))
		modifiers[LEFT_CLICK] = TRUE
	if (COMPONENT_TRIGGERED_BY(middle_click, port))
		modifiers[MIDDLE_CLICK] = TRUE
	if (COMPONENT_TRIGGERED_BY(right_click, port))
		modifiers[RIGHT_CLICK] = TRUE
	
	INVOKE_ASYNC(shell, TYPE_PROC_REF(/mob, ClickOn), target.value, list2params(modifiers))
