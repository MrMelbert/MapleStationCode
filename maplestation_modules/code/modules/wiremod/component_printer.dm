/obj/machinery/component_printer/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/circuit_component/module) && !user.combat_mode)
		var/obj/item/circuit_component/module/module = weapon
		module.internal_circuit.linked_component_printer = WEAKREF(src)
		module.internal_circuit.update_static_data_for_all_viewers()
		balloon_alert(user, "successfully linked to the integrated circuit")
		return
	return ..()
