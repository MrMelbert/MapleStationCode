/// WHAT COULD GO WRONG I WONDER

/obj/item/circuit_component/mod_adapter_core
	/// do you think god stays in heaven
	var/datum/port/input/north
	var/datum/port/input/east
	var/datum/port/input/south
	var/datum/port/input/west

	var/datum/port/output/moved
	var/datum/port/output/move_fail

	/// because he too lives in fear of what he's created
	var/datum/port/input/target
	var/datum/port/input/swap_hands

	var/datum/port/output/swapped_hands

	var/datum/port/input/left_click
	var/datum/port/input/middle_click
	var/datum/port/input/right_click

	var/datum/port/input/alt_click
	var/datum/port/input/shift_click
	var/datum/port/input/ctrl_click

	var/datum/port/output/clicked

	var/datum/port/input/get_hands

	var/datum/port/output/active_hand
	var/datum/port/output/inactive_hand
	var/datum/port/output/fetched_hands

	COOLDOWN_DECLARE(move_cooldown)
	COOLDOWN_DECLARE(click_cooldown)

	var/click_delay = 0.8 SECONDS // Same as clicking

/obj/item/circuit_component/mod_adapter_core/populate_ports()
	. = ..()
	north = add_input_port("North", PORT_TYPE_SIGNAL)
	east = add_input_port("East", PORT_TYPE_SIGNAL)
	south = add_input_port("South", PORT_TYPE_SIGNAL)
	west = add_input_port("West", PORT_TYPE_SIGNAL)
	moved = add_output_port("Successful Move", PORT_TYPE_SIGNAL)
	move_fail = add_output_port("Failed Move", PORT_TYPE_SIGNAL)

	left_click = add_input_port("Left Click", PORT_TYPE_SIGNAL)
	right_click = add_input_port("Right Click", PORT_TYPE_SIGNAL)
	middle_click = add_input_port("Middle Click", PORT_TYPE_SIGNAL)
	clicked = add_output_port("After Click", PORT_TYPE_SIGNAL)

	target = add_input_port("Target", PORT_TYPE_ATOM)
	swap_hands = add_input_port("Swap Hands", PORT_TYPE_SIGNAL)
	swapped_hands = add_output_port("Swapped Hands", PORT_TYPE_SIGNAL)

	alt_click = add_input_port("Alt Click", PORT_TYPE_NUMBER)
	shift_click = add_input_port("Shift Click", PORT_TYPE_NUMBER)
	ctrl_click = add_input_port("Ctrl Click", PORT_TYPE_NUMBER)

	get_hands = add_input_port("Get Currently Held Items", PORT_TYPE_SIGNAL)
	active_hand = add_output_port("Active Hand", PORT_TYPE_ATOM)
	inactive_hand = add_output_port("Inactive Hand", PORT_TYPE_ATOM)
	fetched_hands = add_output_port("Fetched Held Items", PORT_TYPE_SIGNAL)

/obj/item/circuit_component/mod_adapter_core/input_received(datum/port/input/port)
	. = ..()

	var/mob/living/carbon/wearer = attached_module?.mod?.wearer
	if (!istype(wearer))
		return

	if (COMPONENT_TRIGGERED_BY(get_hands, port) && attached_module.mod.gauntlets?.loc == wearer)
		active_hand.set_output(wearer.get_active_held_item())
		active_hand.set_output(wearer.get_inactive_held_item())
		fetched_hands.set_output(COMPONENT_SIGNAL)
		return

	if (COMPONENT_TRIGGERED_BY(swap_hands, port) && attached_module.mod.gauntlets?.loc == wearer)
		wearer.swap_hand()
		swapped_hands.set_output(COMPONENT_SIGNAL)
		return

	if (COOLDOWN_FINISHED(src, move_cooldown) && attached_module.mod.boots?.loc == wearer)
		var/move_dir = null

		if (COMPONENT_TRIGGERED_BY(north, port))
			move_dir = NORTH
		if (COMPONENT_TRIGGERED_BY(east, port))
			move_dir = EAST
		if (COMPONENT_TRIGGERED_BY(south, port))
			move_dir = SOUTH
		if (COMPONENT_TRIGGERED_BY(west, port))
			move_dir = WEST

		if (!isnull(move_dir))
			COOLDOWN_START(src, move_cooldown, wearer.cached_multiplicative_slowdown)
			if (!isnull(wearer.client))
				COOLDOWN_START(wearer.client, move_delay, wearer.cached_multiplicative_slowdown)
			if (wearer.Move(get_step(get_turf(wearer), NORTH)))
				moved.set_output(COMPONENT_SIGNAL)
			else
				move_fail.set_output(COMPONENT_SIGNAL)
			return
	
	if (!COOLDOWN_FINISHED(src, click_cooldown) || attached_module.mod.gauntlets?.loc != wearer)
		return

	if (!COMPONENT_TRIGGERED_BY(left_click, port) && !COMPONENT_TRIGGERED_BY(middle_click, port) && !COMPONENT_TRIGGERED_BY(right_click, port))
		return
	
	var/list/modifiers = list()

	if (alt_click.value)
		modifiers[ALT_CLICK] = TRUE
	if (shift_click.value)
		modifiers[SHIFT_CLICK] = TRUE
	if (ctrl_click.value)
		modifiers[CTRL_CLICK] = TRUE
	if (COMPONENT_TRIGGERED_BY(left_click, port))
		modifiers[LEFT_CLICK] = TRUE
	if (COMPONENT_TRIGGERED_BY(middle_click, port))
		modifiers[MIDDLE_CLICK] = TRUE
	if (COMPONENT_TRIGGERED_BY(right_click, port))
		modifiers[RIGHT_CLICK] = TRUE
	
	COOLDOWN_START(src, click_cooldown, click_delay)
	INVOKE_ASYNC(src, PROC_REF(do_click), target.value, list2params(modifiers))

/obj/item/circuit_component/mod_adapter_core/proc/do_click(atom/target, params)
	var/mob/living/carbon/wearer = attached_module?.mod?.wearer
	if (!istype(wearer))
		return
	wearer.ClickOn(target, params)
	clicked.set_output(COMPONENT_SIGNAL)
