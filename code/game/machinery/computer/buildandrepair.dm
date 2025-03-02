/obj/structure/frame/computer
	name = "computer frame"
	desc = "A frame for constructing your own computer. Or console. Whichever name you prefer."
	icon_state = "0"
	base_icon_state = ""
	state = FRAME_COMPUTER_STATE_EMPTY
	board_type = /obj/item/circuitboard/computer

/obj/structure/frame/computer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/simple_rotation)

/obj/structure/frame/computer/circuit_added(obj/item/circuitboard/added)
	state = FRAME_COMPUTER_STATE_BOARD_INSTALLED
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/frame/computer/circuit_removed(obj/item/circuitboard/removed)
	state = FRAME_COMPUTER_STATE_EMPTY
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/frame/computer/install_board(mob/living/user, obj/item/circuitboard/computer/board, by_hand)
	if(state != FRAME_COMPUTER_STATE_EMPTY)
		balloon_alert(user, "circuit already installed!")
		return FALSE
	return ..()

/obj/structure/frame/computer/item_interaction(mob/living/user, obj/item/tool, list/modifiers, is_right_clicking)
	. = ..()
	if(. & ITEM_INTERACT_ANY_BLOCKER)
		return .

	switch(state)
		if(FRAME_COMPUTER_STATE_EMPTY)
			if(istype(tool, /obj/item/storage/part_replacer))
				return install_circuit_from_part_replacer(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			if(istype(tool, /obj/item/stack/cable_coil))
				return add_cabling(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

			if(istype(tool, /obj/item/storage/part_replacer))
				return install_parts_from_part_replacer(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_WIRED)
			if(istype(tool, /obj/item/stack/sheet/glass))
				return add_glass(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

			if(istype(tool, /obj/item/storage/part_replacer))
				return install_parts_from_part_replacer(user, tool) ? ITEM_INTERACT_SUCCESS : ITEM_INTERACT_BLOCKING

	return .

/obj/structure/frame/computer/screwdriver_act(mob/living/user, obj/item/tool)
	. = ..()
	if(. != NONE)
		return .

	switch(state)
		if(FRAME_COMPUTER_STATE_BOARD_INSTALLED)
			tool.play_tool_sound(src)
			balloon_alert(user, "circuit secured")
			state = FRAME_COMPUTER_STATE_BOARD_SECURED
			update_appearance(UPDATE_ICON_STATE)
			return ITEM_INTERACT_SUCCESS

		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			tool.play_tool_sound(src)
			balloon_alert(user, "circuit unsecured")
			state = FRAME_COMPUTER_STATE_BOARD_INSTALLED
			update_appearance(UPDATE_ICON_STATE)
			return ITEM_INTERACT_SUCCESS

		if(FRAME_COMPUTER_STATE_WIRED)
			if(!user.combat_mode)
				balloon_alert(user, "no glass!")
				return ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_GLASSED)
			if(finalize_construction(user, tool))
				return ITEM_INTERACT_SUCCESS

			balloon_alert(user, "missing components!")
			return ITEM_INTERACT_BLOCKING

/obj/structure/frame/computer/crowbar_act(mob/living/user, obj/item/tool)
	switch(state)
		if(FRAME_COMPUTER_STATE_BOARD_INSTALLED)
			tool.play_tool_sound(src)
			balloon_alert(user, "circuit removed")
			circuit.add_fingerprint(user)
			circuit.forceMove(drop_location())
			return ITEM_INTERACT_SUCCESS

		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			if(!user.combat_mode)
				balloon_alert(user, "unsecure the circuit!")
				return ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_WIRED)
			if(!user.combat_mode)
				balloon_alert(user, "remove the wiring!")
				return ITEM_INTERACT_BLOCKING

		if(FRAME_COMPUTER_STATE_GLASSED)
			tool.play_tool_sound(src)
			balloon_alert(user, "glass removed")
			state = FRAME_COMPUTER_STATE_WIRED
			update_appearance(UPDATE_ICON_STATE)
			var/obj/item/stack/sheet/glass/dropped_glass = new (drop_location(), 2)
			if (!QDELETED(dropped_glass))
				dropped_glass.add_fingerprint(user)
			return ITEM_INTERACT_SUCCESS

/obj/structure/frame/computer/install_parts_from_part_replacer(mob/living/user, obj/item/storage/part_replacer/replacer, no_sound = FALSE)
	switch(state)
		if(FRAME_COMPUTER_STATE_BOARD_SECURED)
			var/obj/item/stack/cable_coil/cable = locate() in replacer
			if(isnull(cable))
				return FALSE

			if(add_cabling(user, cable, time = 0))
				if(!no_sound)
					replacer.play_rped_sound()
					if(replacer.works_from_distance)
						user.Beam(src, icon_state = "rped_upgrade", time = 0.5 SECONDS)
					no_sound = TRUE
				return install_parts_from_part_replacer(user, replacer, no_sound = no_sound)  // Recursive call to handle the next part

			return FALSE

		if(FRAME_COMPUTER_STATE_WIRED)
			var/obj/item/stack/sheet/glass/glass_sheets = locate() in replacer
			if(isnull(glass_sheets))
				return FALSE

			if(add_glass(user, glass_sheets, time = 0))
				if(!no_sound)
					replacer.play_rped_sound()
					if(replacer.works_from_distance)
						user.Beam(src, icon_state = "rped_upgrade", time = 0.5 SECONDS)
				return TRUE

			return FALSE

/obj/structure/frame/computer/proc/add_cabling(mob/living/user, obj/item/stack/cable_coil/cable, time = 2 SECONDS)
	if(state != FRAME_COMPUTER_STATE_BOARD_SECURED)
		return FALSE
	if(!cable.tool_start_check(user, amount = 5))
		return FALSE
	if(time > 0)
		balloon_alert(user, "adding cables...")
	if(!cable.use_tool(src, user, time, volume = 50, amount = 5) || state != FRAME_COMPUTER_STATE_BOARD_SECURED)
		return FALSE

	state = FRAME_COMPUTER_STATE_WIRED
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/structure/frame/computer/proc/add_glass(mob/living/user, obj/item/stack/sheet/glass/glass, time = 2 SECONDS)
	if(state != FRAME_COMPUTER_STATE_WIRED)
		return FALSE
	if(!glass.tool_start_check(user, amount = 2))
		return FALSE
	if(time > 0)
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		balloon_alert(user, "adding glass...")
	if(!glass.use_tool(src, user, time, amount = 2) || state != FRAME_COMPUTER_STATE_WIRED)
		return FALSE

	state = FRAME_COMPUTER_STATE_GLASSED
	update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/structure/frame/computer/wirecutter_act(mob/living/user, obj/item/tool)
	if(state != FRAME_COMPUTER_STATE_WIRED)
		return NONE

	tool.play_tool_sound(src)
	balloon_alert(user, "cables removed")
	state = FRAME_COMPUTER_STATE_BOARD_SECURED
	update_appearance(UPDATE_ICON_STATE)
	var/obj/item/stack/cable_coil/dropped_cables = new (drop_location(), 5)
	if (!QDELETED(dropped_cables))
		dropped_cables.add_fingerprint(user)
	return ITEM_INTERACT_SUCCESS

/obj/structure/frame/computer/AltClick(mob/user)
	return ..() // This hotkey is BLACKLISTED since it's used by /datum/component/simple_rotation

/obj/structure/frame/computer/finalize_construction(mob/living/user, obj/item/tool)
	tool.play_tool_sound(src)
	var/obj/machinery/new_machine = new circuit.build_path(loc)
	new_machine.balloon_alert(user, "monitor connected")
	new_machine.setDir(dir)
	transfer_fingerprints_to(new_machine)

	if(istype(new_machine, /obj/machinery/computer))
		var/obj/machinery/computer/new_computer = new_machine

		new_machine.clear_components()

		// Set anchor state and move the frame's parts over to the new machine.
		// Then refresh parts and call on_construction().
		new_computer.set_anchored(anchored)
		new_computer.component_parts = list(circuit)
		new_computer.circuit = circuit

		circuit.forceMove(new_computer)

		for(var/atom/movable/movable_part in src)
			movable_part.forceMove(new_computer)
			new_computer.component_parts += movable_part

		new_computer.RefreshParts()
		new_computer.on_construction(user)

	qdel(src)
	return TRUE

/obj/structure/frame/computer/deconstruct(disassembled = TRUE)
	if(!(obj_flags & NO_DECONSTRUCTION))
		var/atom/drop_loc = drop_location()
		if(state == FRAME_COMPUTER_STATE_GLASSED)
			if(disassembled)
				new /obj/item/stack/sheet/glass(drop_loc, 2)
			else
				new /obj/item/shard(drop_loc)
				new /obj/item/shard(drop_loc)
		if(state >= FRAME_COMPUTER_STATE_WIRED)
			new /obj/item/stack/cable_coil(drop_loc, 5)

	return ..()

/// Helpers for rcd
/obj/structure/frame/computer/rcd
	icon = 'icons/hud/radial.dmi'
	icon_state = "cnorth"
	anchored = TRUE

/obj/structure/frame/computer/rcd/Initialize(mapload)
	// yeah...
	name = "computer frame"
	icon = 'icons/obj/devices/stock_parts.dmi'
	return ..()

/obj/structure/frame/computer/rcd/north
	dir = NORTH
	name = "Computer North"
	icon_state = "cnorth"

/obj/structure/frame/computer/rcd/south
	dir = SOUTH
	name = "Computer South"
	icon_state = "csouth"

/obj/structure/frame/computer/rcd/east
	dir = EAST
	name = "Computer East"
	icon_state = "ceast"

/obj/structure/frame/computer/rcd/west
	dir = WEST
	name = "Computer West"
	icon_state = "cwest"
