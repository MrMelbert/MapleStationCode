/// WHAT COULD GO WRONG I WONDER

/obj/item/circuit_component/mod_adapter_core
	/// do you think god stays in heaven
	var/datum/port/input/north
	var/datum/port/input/east
	var/datum/port/input/south
	var/datum/port/input/west

	/// because he too lives in fear of what he's created
	var/datum/port/input/target
	var/datum/port/input/swap_hands

	var/datum/port/input/left_click
	var/datum/port/input/middle_click
	var/datum/port/input/right_click

	var/datum/port/input/alt_click
	var/datum/port/input/shift_click
	var/datum/port/input/ctrl_click

	var/datum/port/input/get_hands

	var/datum/port/output/active_hand
	var/datum/port/output/inactive_hand

	COOLDOWN_DECLARE(move_cooldown)
	COOLDOWN_DECLARE(click_cooldown)

	var/click_delay = 0.8 SECONDS // Same as clicking

/obj/item/circuit_component/mod_adapter_core/populate_ports()
	. = ..()
	north = add_input_port("North", PORT_TYPE_SIGNAL)
	east = add_input_port("East", PORT_TYPE_SIGNAL)
	south = add_input_port("South", PORT_TYPE_SIGNAL)
	west = add_input_port("West", PORT_TYPE_SIGNAL)

	left_click = add_input_port("Left Click", PORT_TYPE_SIGNAL)
	right_click = add_input_port("Right Click", PORT_TYPE_SIGNAL)
	middle_click = add_input_port("Middle Click", PORT_TYPE_SIGNAL)

	target = add_input_port("Target", PORT_TYPE_ATOM)
	swap_hands = add_input_port("Swap Hands", PORT_TYPE_SIGNAL)

	alt_click = add_input_port("Alt Click", PORT_TYPE_NUMBER)
	shift_click = add_input_port("Shift Click", PORT_TYPE_NUMBER)
	ctrl_click = add_input_port("Ctrl Click", PORT_TYPE_NUMBER)

	get_hands = add_input_port("Get Currently Held Items", PORT_TYPE_SIGNAL)
	active_hand = add_option_port("Active Hand", PORT_TYPE_ATOM)
	inactive_hand = add_option_port("Inactive Hand", PORT_TYPE_ATOM)

/obj/item/circuit_component/mod_adapter_core/input_received(datum/port/input/port)
	. = ..()

	var/mob/living/carbon/wearer = attached_module?.mod?.wearer
	if (!istype(wearer))
		return

	if (COOLDOWN_FINISHED(src, move_cooldown))
		if (COMPONENT_TRIGGERED_BY(north, port))
			COOLDOWN_START(src, move_cooldown, wearer.cached_multiplicative_slowdown)
			wearer.Move(get_step(get_turf(wearer), NORTH))
			return
		if (COMPONENT_TRIGGERED_BY(east, port))
			COOLDOWN_START(src, move_cooldown, wearer.cached_multiplicative_slowdown)
			wearer.Move(get_step(get_turf(wearer), EAST))
			return
		if (COMPONENT_TRIGGERED_BY(south, port))
			COOLDOWN_START(src, move_cooldown, wearer.cached_multiplicative_slowdown)
			wearer.Move(get_step(get_turf(wearer), SOUTH))
			return
		if (COMPONENT_TRIGGERED_BY(west, port))
			COOLDOWN_START(src, move_cooldown, wearer.cached_multiplicative_slowdown)
			wearer.Move(get_step(get_turf(wearer), WEST))
			return
	
	if (!COOLDOWN_FINISHED(src, click_cooldown))
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
	INVOKE_ASYNC(wearer, TYPE_PROC_REF(/mob, ClickOn), target.value, list2params(modifiers))
