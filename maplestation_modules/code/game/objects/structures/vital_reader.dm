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

	/// Whether we perform an advanced scan on examine or not, currently admin only
	var/advanced = FALSE
	/// Whether we are on or off
	VAR_FINAL/active = FALSE
	/// Reference to the mob that is being tracked / scanned
	VAR_FINAL/mob/living/patient

MAPPING_DIRECTIONAL_HELPERS(/obj/machinery/computer/vitals_reader, 32)

/obj/machinery/computer/vitals_reader/wrench_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return FALSE
	if(tool.use_tool(src, user, 6 SECONDS, volume = 50))
		playsound(src, 'sound/items/deconstruct.ogg', 50, TRUE)
		balloon_alert(user, "detached")
		deconstruct(TRUE)
	return TRUE

/obj/machinery/computer/vitals_reader/deconstruct(disassembled)
	if(flags_1 & NODECONSTRUCT_1)
		return
	var/atom/drop_loc = drop_location()
	if(disassembled)
		new /obj/item/wallframe/status_display/vitals(drop_loc)
	else
		new /obj/item/stack/sheet/iron(drop_loc, 2)
		new /obj/item/shard(drop_loc)
		new /obj/item/shard(drop_loc)
	qdel(src)

/obj/machinery/computer/vitals_reader/examine(mob/user)
	. = ..()
	if(!is_operational)
		return

	if(isnull(patient))
		. += span_notice("The display is currently scanning for a patient.")
	else if(!issilicon(user) && !user.can_read(src, silent = TRUE))
		. += span_warning("You try to comprehend the display, but it's too complex for you to understand.")
	else if(get_dist(patient, user) <= 2 || isobserver(user) || issilicon(user))
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
	if(isAI(user))
		context[SCREENTIP_CONTEXT_SHIFT_LMB] = "Examine vitals"
	return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/computer/vitals_reader/AIShiftClick(mob/user)
	// Lets AIs perform healthscans on people indirectly (they can't examine)
	if(is_operational && !isnull(patient))
		healthscan(user, patient, advanced = advanced)

/// Returns overlays to be used when active but without a patient detected
/obj/machinery/computer/vitals_reader/proc/get_scanning_overlays()
	return list(
		mutable_appearance(icon, "unknown", alpha = src.alpha),
		mutable_appearance(icon, "scanning", alpha = src.alpha),
	)

/**
 * Returns all overlays to be shown when a simple / basic animal patient is detected
 *
 * * hp_color - color being used for general, overrall health
 */
/obj/machinery/computer/vitals_reader/proc/get_simple_mob_overlays(hp_color)
	return list(
		construct_overlay("mob", hp_color),
		construct_overlay("bar1", COLOR_GRAY),
		construct_overlay("bar2", COLOR_GRAY),
		construct_overlay("bar3", COLOR_GRAY),
	)

/**
 * Returns all overlays to be shown when a humanoid patient is detected
 *
 * * hp_color - color being used for general, overrall health
 */
/obj/machinery/computer/vitals_reader/proc/get_humanoid_overlays(hp_color)
	var/list/returned_overlays = list()

	for(var/body_zone in BODY_ZONES_ALL)
		var/obj/item/bodypart/real_part = patient.get_bodypart(body_zone)
		var/bodypart_color = isnull(real_part) ? COLOR_GRAY : percent_to_color((real_part.brute_dam + real_part.burn_dam) / real_part.max_damage)
		returned_overlays += construct_overlay("human_[body_zone]", bodypart_color)

	var/blood_volume_color = "#2A72AA"
	switch(patient.blood_volume)
		if(-INFINITY to BLOOD_VOLUME_BAD)
			blood_volume_color = "#BD0600"
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			blood_volume_color = "#D3980D"
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			blood_volume_color = "#B9B40D"
	returned_overlays += construct_overlay("bar1", blood_volume_color)

	var/oxygen_color = "#5D9C11"
	switch(patient.getOxyLoss())
		if(50 to INFINITY)
			oxygen_color = "#BD0600"
		if(30 to 50)
			oxygen_color = "#D3980D"
		if(10 to 30)
			oxygen_color = "#B9B40D"
	returned_overlays += construct_overlay("bar2", oxygen_color)

	var/tox_color = "#5D9C11"
	switch(patient.getToxLoss())
		if(50 to INFINITY)
			oxygen_color = "#BD0600"
		if(30 to 50)
			oxygen_color = "#D3980D"
		if(10 to 30)
			oxygen_color = "#B9B40D"
	returned_overlays += construct_overlay("bar3", tox_color)

	return returned_overlays

/obj/machinery/computer/vitals_reader/update_overlays()
	. = ..()
	if(!active)
		return

	if(isnull(patient))
		. += get_scanning_overlays()

	else
		var/ekg_icon_state = "ekg"
		if(!patient.appears_alive())
			ekg_icon_state = "ekg_flat"
		else if(ishuman(patient))
			var/mob/living/carbon/human/human_patient = patient
			switch(human_patient.get_pretend_heart_rate())
				if(0)
					ekg_icon_state = "ekg_flat"
				if(100 to INFINITY)
					ekg_icon_state = "ekg_fast"

		var/hp_color = percent_to_color((patient.maxHealth - patient.health) / patient.maxHealth)
		. += construct_overlay(ekg_icon_state, hp_color)

		if(ishuman(patient))
			. += get_humanoid_overlays(hp_color)
		else
			. += get_simple_mob_overlays(hp_color)

	. += emissive_appearance(icon, "outline", src, alpha = src.alpha)

/// Converts a percentage to a color
/obj/machinery/computer/vitals_reader/proc/percent_to_color(percent)
	if(percent == 0)
		return "#2A72AA"

	switch(percent)
		if(0 to 0.125)
			return "#A6BD00"
		if(0.125 to 0.25)
			return "#BDA600"
		if(0.25 to 0.375)
			return "#BD7E00"
		if(0.375 to 0.5)
			return "#BD4200"

	// going over 1 is also bad
	return "#BD0600"

/obj/machinery/computer/vitals_reader/proc/construct_overlay(state_to_use, color_to_use)
	var/mutable_appearance/overlay = mutable_appearance(icon, state_to_use, alpha = src.alpha)
	overlay.appearance_flags |= RESET_COLOR
	overlay.color = color_to_use
	return overlay

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
	if(!active || !isnull(patient) || QDELETED(src))
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
		COMSIG_LIVING_HEALTH_UPDATE,
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
