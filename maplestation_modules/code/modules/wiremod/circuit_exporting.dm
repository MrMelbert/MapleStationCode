/obj/machinery/module_duplicator/attackby_secondary(obj/item/weapon, mob/user, params)
	if (!istype(weapon, /obj/item/integrated_circuit))
		return ..()
	
	if (HAS_TRAIT(weapon, TRAIT_CIRCUIT_UNDUPABLE))
		balloon_alert(user, "unable to scan!")
		return ..()
	
	flick("module-fab-scan", src)
	addtimer(CALLBACK(src, PROC_REF(finish_json_export), weapon, user), 1.4 SECONDS)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/module_duplicator/proc/finish_json_export(obj/item/integrated_circuit/circuit, mob/user)
	var/datum/tgui_input_text/default_value/text_input = new(user, "", "Circuit Export", circuit.convert_to_json(), INFINITY, TRUE, FALSE, 0, GLOB.always_state)
	text_input.ui_interact(user)

/datum/tgui_input_text/default_value/ui_static_data(mob/user)
	. = ..()
	.["default_value"] = default

/obj/machinery/module_duplicator/attack_hand_secondary(mob/user, list/modifiers)
	var/circuit_data = tgui_input_text(user, "Import JSON for your circuit", "Circuit Import", "", INFINITY, TRUE, FALSE)
	if (!circuit_data)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	
	var/list/errors = list()
	var/obj/item/integrated_circuit/temp_circuit = new(src)
	temp_circuit.load_circuit_data(circuit_data, errors) // For data validation
	if (errors.len)
		qdel(temp_circuit)
		balloon_alert(user, "invalid import!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	
	var/circuit_name = tgui_input_text(user, "Name your circuit", "Circuit Import")
	if (!circuit_name)
		qdel(temp_circuit)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	
	for(var/list/component_data as anything in scanned_designs)
		if(component_data["name"] == circuit_name)
			balloon_alert(user, "name already exists!")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	
	var/list/data = list()
	data["name"] = circuit_name
	data["desc"] = "An integrated circuit that has been loaded in by [user]."
	data["dupe_data"] = circuit_data

	var/datum/design/integrated_circuit/circuit_design = SSresearch.techweb_design_by_id("integrated_circuit")
	var/materials = list(GET_MATERIAL_REF(/datum/material/glass) = temp_circuit.current_size * cost_per_component)
	for(var/material_type in circuit_design.materials)
		materials[material_type] += circuit_design.materials[material_type]
	qdel(temp_circuit)
	data["materials"] = materials
	data["integrated_circuit"] = TRUE
	scanned_designs += list(data)
	balloon_alert(user, "circuit loaded!")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	
/obj/machinery/component_printer/attackby(obj/item/weapon, mob/living/user, params)
	if(istype(weapon, /obj/item/circuit_component/module) && !user.combat_mode)
		var/obj/item/circuit_component/module/module = weapon
		module.internal_circuit.linked_component_printer = WEAKREF(src)
		module.internal_circuit.update_static_data_for_all_viewers()
		balloon_alert(user, "successfully linked to the integrated circuit")
		return
	return ..()
