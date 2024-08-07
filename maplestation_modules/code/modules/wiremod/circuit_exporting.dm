#define CIRCUITS_DATA_FILEPATH "data/circuit_designs/"

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

/obj/machinery/module_duplicator
	/// The current unlocked circuit component designs. Used by integrated circuits to print off circuit components remotely.
	var/list/current_unlocked_designs = list()
	/// The techweb the duplicastor will get researched designs from
	var/datum/techweb/techweb
	/// List of all circuit designs
	var/static/list/all_circuit_designs = null

/obj/machinery/module_duplicator/Initialize(mapload)
	. = ..()
	
	if (all_circuit_designs)
		return
	
	all_circuit_designs = list()
	for (var/datum/design/component/design as anything in subtypesof(/datum/design/component))
		all_circuit_designs[design::build_path] = design::id

/obj/machinery/module_duplicator/LateInitialize()
	. = ..()
	if(!CONFIG_GET(flag/no_default_techweb_link) && !techweb)
		CONNECT_TO_RND_SERVER_ROUNDSTART(techweb, src)
	if(techweb)
		on_connected_techweb()

/obj/machinery/module_duplicator/proc/connect_techweb(datum/techweb/new_techweb)
	if(techweb)
		UnregisterSignal(techweb, list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN))
	techweb = new_techweb
	if(!isnull(techweb))
		on_connected_techweb()

/obj/machinery/module_duplicator/proc/on_connected_techweb()
	for (var/researched_design_id in techweb.researched_designs)
		var/datum/design/design = SSresearch.techweb_design_by_id(researched_design_id)
		if (!(design.build_type & COMPONENT_PRINTER) || !ispath(design.build_path, /obj/item/circuit_component))
			continue

		current_unlocked_designs[design.build_path] = design.id

	RegisterSignal(techweb, COMSIG_TECHWEB_ADD_DESIGN, PROC_REF(on_research))
	RegisterSignal(techweb, COMSIG_TECHWEB_REMOVE_DESIGN, PROC_REF(on_removed))

/obj/machinery/module_duplicator/multitool_act(mob/living/user, obj/item/multitool/tool)
	if(!QDELETED(tool.buffer) && istype(tool.buffer, /datum/techweb))
		connect_techweb(tool.buffer)
	return TRUE

/obj/machinery/module_duplicator/proc/on_research(datum/source, datum/design/added_design, custom)
	SIGNAL_HANDLER
	if (!(added_design.build_type & COMPONENT_PRINTER) || !ispath(added_design.build_path, /obj/item/circuit_component))
		return
	current_unlocked_designs[added_design.build_path] = added_design.id

/obj/machinery/module_duplicator/proc/on_removed(datum/source, datum/design/added_design, custom)
	SIGNAL_HANDLER
	if (!(added_design.build_type & COMPONENT_PRINTER) || !ispath(added_design.build_path, /obj/item/circuit_component))
		return
	current_unlocked_designs -= added_design.build_path

/datum/controller/subsystem/persistence
	///Associated list of all saved circuits, ckey -> list of designs
	var/list/circuit_designs = list()

/datum/controller/subsystem/persistence/collect_data()
	. = ..()
	save_circuits()

/datum/controller/subsystem/persistence/proc/load_circuits_by_ckey(user)
	var/json_file = file("[CIRCUITS_DATA_FILEPATH][user].json")
	if(!fexists(json_file))
		circuit_designs[user] = list()
		return
	var/list/json = json_decode(file2text(json_file))
	if(!json)
		circuit_designs[user] = list()
		return
	var/list/new_circuit_designs = json["data"]
	for (var/list/design in new_circuit_designs)
		var/list/new_materials = list()
		for (var/material in design["materials"])
			new_materials[GET_MATERIAL_REF(text2path(material))] = design["materials"][material]
		design["materials"] = new_materials
	circuit_designs[user] = new_circuit_designs

/datum/controller/subsystem/persistence/proc/save_circuits()
	for (var/user in circuit_designs)
		var/json_file = file("[CIRCUITS_DATA_FILEPATH][user].json")
		var/file_data = list()
		var/list/user_designs = circuit_designs[user]
		var/list/designs_to_store = user_designs.Copy()

		for (var/list/design in designs_to_store)
			var/list/new_materials = list()
			for (var/datum/material/material in design["materials"])
				new_materials["[material.type]"] = design["materials"][material]
			design["materials"] = new_materials

		file_data["data"] = designs_to_store
		fdel(json_file)
		WRITE_FILE(json_file, json_encode(file_data))

#undef CIRCUITS_DATA_FILEPATH
