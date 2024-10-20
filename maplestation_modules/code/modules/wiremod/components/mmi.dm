/obj/item/circuit_component/mmi
	// Called when the MMI middle clicks.
	var/datum/port/output/middle_click

	// Click modifiers
	var/datum/port/output/alt_click
	var/datum/port/output/ctrl_click
	var/datum/port/output/shift_click

/obj/item/circuit_component/mmi/populate_ports()
	. = ..()
	middle_click = add_output_port("Middle Click", PORT_TYPE_SIGNAL)
	alt_click = add_output_port("Alt Click", PORT_TYPE_NUMBER)
	shift_click = add_output_port("Shift Click", PORT_TYPE_NUMBER)
	ctrl_click = add_output_port("Ctrl Click", PORT_TYPE_NUMBER)

/obj/item/circuit_component/mmi/handle_mmi_attack(mob/living/source, atom/target, list/modifiers)
	alt_click.set_output(LAZYACCESS(modifiers, ALT_CLICK))
	shift_click.set_output(LAZYACCESS(modifiers, SHIFT_CLICK))
	ctrl_click.set_output(LAZYACCESS(modifiers, CTRL_CLICK))
	clicked_atom.set_output(target)

	if (LAZYACCESS(modifiers, RIGHT_CLICK))
		secondary_attack.set_output(COMPONENT_SIGNAL)
		return COMSIG_MOB_CANCEL_CLICKON

	if (LAZYACCESS(modifiers, MIDDLE_CLICK))
		middle_click.set_output(COMPONENT_SIGNAL)
		return COMSIG_MOB_CANCEL_CLICKON

	attack.set_output(COMPONENT_SIGNAL)
	if (!LAZYACCESS(modifiers, ALT_CLICK) && !LAZYACCESS(modifiers, SHIFT_CLICK) && !LAZYACCESS(modifiers, CTRL_CLICK))
		return COMSIG_MOB_CANCEL_CLICKON
