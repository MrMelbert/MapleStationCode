#define LINK_RANGE 2

/datum/design/board/vital_floor_scanner
	name = "Vitals Scanning Pad"
	desc = "The circuit board for a vitals scanning pad."
	id = "scanning_pad"
	build_path = /obj/item/circuitboard/machine/vital_floor_scanner
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL

/obj/item/circuitboard/machine/vital_floor_scanner
	name = "\improper Vitals Scanning Pad"
	greyscale_colors = CIRCUIT_COLOR_MEDICAL
	build_path = /obj/machinery/vital_floor_scanner
	req_components = list(
		/obj/item/stack/cable_coil = 5,
		/datum/stock_part/scanning_module = 1,
	)

/obj/machinery/vital_floor_scanner
	name = "vitals scanning pad"
	desc = "A pad that scans the vitals of anyone who steps on it and displays the results on nearby vitals monitors."
	icon = 'maplestation_modules/icons/obj/floor_scan.dmi'
	icon_state = "scanner"
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	density = FALSE
	obj_flags = CAN_BE_HIT|BLOCKS_CONSTRUCTION
	use_power = IDLE_POWER_USE
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.1
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 0.1
	light_range = 1
	light_power = 0.5
	light_color = LIGHT_COLOR_ELECTRIC_CYAN
	light_on = TRUE
	circuit = /obj/item/circuitboard/machine/vital_floor_scanner
	/// Cooldown between successful "scans"
	COOLDOWN_DECLARE(scan_cooldown)

/obj/machinery/vital_floor_scanner/Destroy()
	set_occupant(null)
	return ..()

/obj/machinery/vital_floor_scanner/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_AFTER_SUCCESSFUL_INITIALIZED_ON = PROC_REF(on_entered),
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)
	update_appearance(UPDATE_OVERLAYS)
	register_context()

/obj/machinery/vital_floor_scanner/examine(mob/user)
	. = ..()
	if(isliving(user) && !issilicon(user))
		. += span_notice("To use: Step on the pad and wait for the scan to complete. \
			Your results will be displayed on nearby vitals monitors. \
			<b>Examine</b> the monitor for a detailed breakdown of your vitals.")

/obj/machinery/vital_floor_scanner/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(held_item?.tool_behaviour == TOOL_SCREWDRIVER)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/vital_floor_scanner/update_overlays()
	. = ..()
	if(!is_operational)
		return

	. += emissive_appearance(icon, "scanner_emissive", src, alpha = src.alpha)

/obj/machinery/vital_floor_scanner/proc/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if(!is_operational)
		return
	if(!isnull(occupant))
		return
	if(!COOLDOWN_FINISHED(src, scan_cooldown))
		return
	if(!isliving(arrived) || !can_scan(arrived))
		return

	COOLDOWN_START(src, scan_cooldown, 5 SECONDS)
	playsound(src, 'maplestation_modules/sound/healthscanner_used.ogg', 15, FALSE, MEDIUM_RANGE_SOUND_EXTRARANGE)
	set_occupant(arrived)
	use_energy(active_power_usage)

/obj/machinery/vital_floor_scanner/proc/on_exited(datum/source, atom/movable/departed)
	SIGNAL_HANDLER
	if(occupant != departed)
		return
	set_occupant(null)

/obj/machinery/vital_floor_scanner/proc/enable_vitals_nearby()
	if(!is_operational || QDELETED(occupant))
		return

	for(var/obj/machinery/computer/vitals_reader/reader in range(LINK_RANGE, src))
		if(!reader.is_operational)
			continue

		if(!reader.active)
			reader.toggle_active()

		else if(isnull(reader.patient))
			reader.set_patient(occupant)

		if(isnull(reader.patient)) // It failed I guess
			continue

		reader.beeps = FALSE
		var/scansound = 'maplestation_modules/sound/healthscanner_stable.ogg'
		switch(reader.patient.stat)
			if(DEAD)
				scansound = 'maplestation_modules/sound/healthscanner_dead.ogg'
				reader.beep_message("lets out a droning beep.")
			if(HARD_CRIT)
				scansound = 'maplestation_modules/sound/healthscanner_danger.ogg'
				reader.beep_message("lets out an alternating beep.")
			if(SOFT_CRIT)
				scansound = 'maplestation_modules/sound/healthscanner_critical.ogg'
				reader.beep_message("lets out a high pitch beep.")
			else
				reader.beep_message("lets out a beep.")

		playsound(reader, scansound, 15, FALSE, MEDIUM_RANGE_SOUND_EXTRARANGE)
		return

/obj/machinery/vital_floor_scanner/proc/disable_vitals_nearby(mob/leaving = occupant)
	for(var/obj/machinery/computer/vitals_reader/reader in range(LINK_RANGE, src))
		if(reader.active && reader.patient == leaving)
			reader.toggle_active()
			return

/obj/machinery/vital_floor_scanner/proc/can_scan(mob/living/who)
	if(who.mob_biotypes & MOB_ROBOTIC)
		return FALSE
	if(who.body_position != STANDING_UP)
		return FALSE
	return TRUE

/obj/machinery/vital_floor_scanner/on_set_is_operational(old_value)
	update_appearance(UPDATE_OVERLAYS)

	if(!is_operational)
		set_light_on(FALSE)
		set_occupant(null)
		return

	set_light_on(TRUE)
	for(var/mob/living/new_mob in loc)
		if(!can_scan(new_mob))
			continue
		set_occupant(new_mob)
		return

/obj/machinery/vital_floor_scanner/set_occupant(atom/movable/new_occupant)
	var/mob/living/old_occupant = occupant
	. = ..()
	if(QDELING(src))
		return
	if(!isnull(occupant))
		addtimer(CALLBACK(src, PROC_REF(enable_vitals_nearby)), /obj/effect/temp_visual/vitals_scan_effect::duration, TIMER_UNIQUE)
		scan_effect()

	else if(!isnull(old_occupant))
		disable_vitals_nearby(old_occupant)
		for(var/obj/effect/temp_visual/vitals_scan_effect/effect in old_occupant)
			animate(effect, alpha = 0, time = 0.2 SECONDS, flags = ANIMATION_PARALLEL)

/obj/machinery/vital_floor_scanner/proc/scan_effect()
	var/obj/effect/temp_visual/vitals_scan_effect/effect = new(occupant)
	SET_PLANE_IMPLICIT(effect, plane)
	occupant.vis_contents += effect

/obj/machinery/vital_floor_scanner/screwdriver_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "deconstructing...")
	if(!tool.use_tool(src, user, 4 SECONDS, volume = 50))
		return ITEM_INTERACT_BLOCKING

	deconstruct(TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/effect/temp_visual/vitals_scan_effect
	duration = 1.1 SECONDS
	alpha = 200
	icon = 'maplestation_modules/icons/obj/floor_scan.dmi'
	icon_state = "scan_effect.1"
	base_icon_state = "scan_effect"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/vitals_scan_effect/Initialize(mapload)
	. = ..()
	// we manually animate this, rather than just using an animated icon state or flick, to work around byond animated state memes
	// (normally, all animated icon states are synced to the same time, which would bad here)
	for(var/i in 2 to duration)
		if(PERFORM_ALL_TESTS(focus_only/runtime_icon_states) && !icon_exists(icon, "[base_icon_state].[i]"))
			stack_trace("Missing scan effect icon state: [base_icon_state].[i]")
		animate(src, time = 0.1 SECONDS, icon_state = "[base_icon_state].[i]", flags = ANIMATION_CONTINUE)
	if(PERFORM_ALL_TESTS(focus_only/runtime_icon_states) && icon_exists(icon, "[base_icon_state].[duration + 1]"))
		stack_trace("Extra scan effect icon state: [base_icon_state].[duration + 1]")

#undef LINK_RANGE
