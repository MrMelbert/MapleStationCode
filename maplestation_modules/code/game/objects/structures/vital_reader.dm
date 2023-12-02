/obj/item/wallframe/status_display/vitals
	name = "vitals display frame"
	desc = "Used to build vitals displays. Secure on a wall nearby a stasis bed or operating table."
	result_path = /obj/machinery/computer/vitals_reader

/obj/machinery/computer/vitals_reader
	name = "vitals display"
	desc = "A small screen that displays the vitals of a patient."
	icon = 'maplestation_modules/icons/obj/status_display.dmi'
	icon_state = "frame"
	verb_say = "beeps"
	verb_ask = "beeps"
	verb_exclaim = "beeps"
	density = FALSE
	layer = ABOVE_WINDOW_LAYER
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_REQUIRES_DEXTERITY
	interaction_flags_machine = INTERACT_MACHINE_ALLOW_SILICON
	use_power = NO_POWER_USE

	var/active = FALSE
	var/scanning = FALSE
	var/advanced = FALSE
	var/mob/living/patient

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/vitals_reader, 32)

/obj/machinery/computer/vitals_reader/wrench_act(mob/living/user, obj/item/tool)
	if(tool.use_tool(src, user, 6 SECONDS, volume = 50))
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		balloon_alert(user, "[anchored ? "un" : ""]secured")
		deconstruct()
		return TRUE
	return FALSE

/obj/machinery/computer/vitals_reader/deconstruct(disassembled, mob/user)
	if(flags_1 & NODECONSTRUCT_1)
		return
	if(disassembled)
		new /obj/item/wallframe/status_display/vitals(drop_location())
	else
		var/atom/drop_loc = drop_location()
		new /obj/item/stack/sheet/iron(drop_loc, 2)
		new /obj/item/shard(drop_loc)
		new /obj/item/shard(drop_loc)
	qdel(src)

/obj/machinery/computer/vitals_reader/examine(mob/user)
	. = ..()
	if(!is_operational)
		return

	if(isnull(patient))
		. += span_notice("The display is blank.")

	else if(!issilicon(user) && !user.can_read(src, silent = TRUE))
		. += span_warning("You try to comprehend the display, but it's too complex for you to understand.")

	else if(isobserver(user) || issilicon(user) || get_dist(patient, user) <= 2)
		. += healthscan(user, patient, advanced = advanced, tochat = FALSE)

	else
		. += span_notice("<i>You are too far away to read the display.</i>")

/obj/machinery/computer/vitals_reader/Initialize(mapload, obj/item/circuitboard/C)
	. = ..()
	register_context()

/obj/machinery/computer/vitals_reader/Destroy()
	unset_patient()
	return ..()

/obj/machinery/computer/vitals_reader/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	if(!isnull(held_item))
		return NONE

	context[SCREENTIP_CONTEXT_LMB] = "Toggle readout"
	if(issilicon(user))
		context[SCREENTIP_CONTEXT_RMB] = "Examine"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/computer/vitals_reader/attack_robot_secondary(mob/user, list/modifiers)
	if(!is_operational)
		return ..()
	user.run_examinate(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/computer/vitals_reader/attack_ai_secondary(mob/user, list/modifiers)
	if(!is_operational)
		return ..()
	user.run_examinate(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/machinery/computer/vitals_reader/update_overlays()
	. = ..()
	if(!active)
		return

	if(ishuman(patient))
		. += get_humanoid_overlays()

	else if(isliving(patient))
		. += get_simple_mob_overlays()

	else
		. += mutable_appearance(icon, "scanning", alpha = src.alpha)
		. += emissive_appearance(icon, "scanning_emissive", src, alpha = src.alpha)

		. += mutable_appearance(icon, "unknown", src, alpha = src.alpha)
		. += emissive_appearance(icon, "unknown_emissive", alpha = src.alpha)

/*
/obj/machinery/computer/vitals_reader/process()
	. = ..()
	if(active)
		update_appearance(UPDATE_OVERLAYS)
*/

/obj/machinery/computer/vitals_reader/proc/get_humanoid_overlays()
	. = list()
	for(var/body_zone in BODY_ZONES_ALL)
		var/obj/item/bodypart/real_part = patient.get_bodypart(body_zone)
		var/mutable_appearance/limb_overlay = mutable_appearance(icon, "human_[body_zone]", alpha = src.alpha)
		limb_overlay.appearance_flags |= RESET_COLOR
		. += limb_overlay
		if(isnull(real_part))
			limb_overlay.color = COLOR_GRAY
			continue

		switch((real_part.brute_dam + real_part.burn_dam) / real_part.max_damage)
			if(-INFINITY to 0.25)
				limb_overlay.color = COLOR_GREEN
			if(0.25 to 0.5)
				limb_overlay.color = COLOR_YELLOW
			if(0.5 to INFINITY)
				limb_overlay.color = COLOR_RED

	. += emissive_appearance(icon, "human_emissive", src, layer, alpha)

/obj/machinery/computer/vitals_reader/proc/get_simple_mob_overlays()
	. = list()

	var/mutable_appearance/mob_overlay = mutable_appearance(icon, "mob", alpha = src.alpha)
	mob_overlay.appearance_flags |= RESET_COLOR
	switch(patient.health / patient.maxHealth)
		if(-INFINITY to 0.33)
			mob_overlay.color = COLOR_GREEN
		if(0.33 to 0.66)
			mob_overlay.color = COLOR_YELLOW
		if(0.66 to INFINITY)
			mob_overlay.color = COLOR_RED

	. += mob_overlay
	. += emissive_appearance(icon, "mob_emissive", src, alpha = src.alpha)

/obj/machinery/computer/vitals_reader/interact(mob/user, special_state)
	. = ..()
	if(.)
		return .
	if(!is_operational)
		return .

	toggle_active()
	balloon_alert(user, "readout [active ? "" : "de"]activated")
	playsound(src, 'sound/machines/click.ogg', 50)
	return TRUE

/obj/machinery/computer/vitals_reader/on_set_is_operational(old_value)
	if(!is_operational && active)
		toggle_active()

/obj/machinery/computer/vitals_reader/proc/toggle_active()
	if(active)
		active = FALSE
		update_use_power(NO_POWER_USE)
		unset_patient()
	else
		active = TRUE
		update_use_power(IDLE_POWER_USE)
		find_active_patient()
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/computer/vitals_reader/proc/find_active_patient(scan_attempts = 0)
	if(!active)
		return

	for(var/obj/machinery/nearby_thing in view(3, src))
		var/mob/living/patient = nearby_thing.get_patient_for_vitals()
		if(istype(patient) && (patient.mob_biotypes & MOB_ORGANIC))
			set_patient(patient)
			return

	if(scan_attempts > 12)
		toggle_active()
		return

	addtimer(CALLBACK(src, PROC_REF(find_active_patient), scan_attempts + 1), 5 SECONDS)

/obj/machinery/computer/vitals_reader/proc/set_patient(mob/living/new_patient)
	if(!isnull(patient))
		unset_patient()

	patient = new_patient
	RegisterSignals(patient, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_MOVED
	), PROC_REF(unset_patient))
	RegisterSignals(patient, list(
		COMSIG_CARBON_POST_REMOVE_LIMB,
		COMSIG_CARBON_POST_ATTACH_LIMB,
		COMSIG_LIVING_HEALTH_UPDATE
	), PROC_REF(update_overlay_on_signal))
	update_appearance(UPDATE_OVERLAYS)

/obj/machinery/computer/vitals_reader/proc/unset_patient(...)
	SIGNAL_HANDLER
	if(isnull(patient))
		return

	UnregisterSignal(patient, list(
		COMSIG_PARENT_QDELETING,
		COMSIG_MOVABLE_MOVED,
		COMSIG_CARBON_POST_REMOVE_LIMB,
		COMSIG_CARBON_POST_ATTACH_LIMB,
		COMSIG_LIVING_HEALTH_UPDATE,
	))

	patient = null
	if(QDELING(src))
		return

	update_appearance(UPDATE_OVERLAYS)
	if(active)
		find_active_patient()

/obj/machinery/computer/vitals_reader/proc/update_overlay_on_signal(...)
	SIGNAL_HANDLER
	update_appearance(UPDATE_OVERLAYS)


/obj/machinery/proc/get_patient_for_vitals()
	return null

/obj/machinery/get_patient_for_vitals()
	return occupant

/obj/machinery/computer/operating/get_patient_for_vitals()
	return table?.patient

/obj/machinery/gibber/get_patient_for_vitals()
	return null

/obj/machinery/recharge_station/get_patient_for_vitals()
	return null

/obj/machinery/skill_station/get_patient_for_vitals()
	return null

/obj/machinery/bci_implanter/get_patient_for_vitals()
	return null

/obj/machinery/suit_storage_unit/get_patient_for_vitals()
	return null
