/obj/structure/table/optable
	/// Internals tank clamped onto the table.
	/// Allows an operating computer to easily attach it to the mob and use it for anesthesia.
	VAR_FINAL/obj/item/tank/internals/attached_tank
	/// World time when the patient was set onto the tank
	VAR_FINAL/patient_set_at = -1
	/// Time after which the anesthesia will be automatically disabled
	/// Can be set to INFINITY to never auto-disable
	var/failsafe_time = 6 MINUTES

/obj/structure/table/optable/Initialize(mapload)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/table/optable/examine(mob/user)
	. = ..()
	if(isnull(attached_tank))
		. += span_notice("It has a clamp on the side for attaching a breath tank.")
	else
		. += span_notice("It has \a [attached_tank] attached to it.")

/obj/structure/table/optable/update_overlays()
	. = ..()
	if(!isnull(attached_tank))
		. += mutable_appearance(
			icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
			icon_state = "surgery_[attached_tank.icon_state]",
			alpha = src.alpha,
		)

	. += mutable_appearance(
		icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
		icon_state = "patient_light_[patient ? "on" : "off"]",
		alpha = src.alpha,
	)

	. += mutable_appearance(
		icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
		icon_state = "anesthesia_light_[patient_set_at == -1 ? "off" : "on"]",
		alpha = src.alpha,
	)

	. += emissive_appearance(
		icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
		icon_state = "emissive",
		offset_spokesman = src,
		alpha = src.alpha,
	)

/obj/structure/table/optable/add_context(atom/source, list/context, obj/item/held_item, mob/living/user)
	. = ..()

	if(isnull(attached_tank))
		if(istype(held_item, /obj/item/tank/internals))
			context[SCREENTIP_CONTEXT_LMB] = "Attach tank"
			. = CONTEXTUAL_SCREENTIP_SET
	else
		if(isnull(held_item))
			context[SCREENTIP_CONTEXT_RMB] = "Remove tank"
			. = CONTEXTUAL_SCREENTIP_SET


/obj/structure/table/optable/atom_deconstruct(disassembled, wrench_disassembly)
	attached_tank?.forceMove(drop_location())
	return ..()

/obj/structure/table/optable/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == attached_tank)
		disable_anesthesia(patient)
		attached_tank = null
		if(!QDELING(src))
			update_appearance(UPDATE_OVERLAYS)

/obj/structure/table/optable/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/tank/internals))
		return ITEM_INTERACT_BLOCKING
	else if(!isnull(attached_tank))
		balloon_alert(user, "already has a tank!")
		return ITEM_INTERACT_BLOCKING
	else if(user.transferItemToLoc(tool, src, silent = FALSE))
		attached_tank = tool
		update_appearance(UPDATE_OVERLAYS)
		balloon_alert_to_viewers("tank attached")
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		return ITEM_INTERACT_SUCCESS
	balloon_alert(user, "can't attach tank!")
	return ITEM_INTERACT_BLOCKING

/obj/structure/table/optable/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .
	if(isnull(attached_tank))
		return .

	user.put_in_hands(attached_tank)
	balloon_alert(user, "tank removed")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/table/optable/recheck_patient(mob/living/carbon/potential_patient)
	var/mob/living/carbon/old_patient = patient
	. = ..()
	update_appearance(UPDATE_OVERLAYS)
	if(patient == potential_patient && patient != old_patient)
		START_PROCESSING(SSobj, src)
		return

	STOP_PROCESSING(SSobj, src)
	if(old_patient == potential_patient)
		disable_anesthesia(old_patient)

/obj/structure/table/optable/process(seconds_per_tick)
	if(isnull(patient))
		return PROCESS_KILL
	if(isnull(attached_tank))
		return
	if(!can_have_tank_opened(patient))
		disable_anesthesia(patient)
		return
	if(computer?.is_operational && patient_set_at + failsafe_time < world.time)
		safety_disable()
		return

/// Checks if the passed mob is in a valid state to start breathing out of the attached tank.
/obj/structure/table/optable/proc/can_have_tank_opened(mob/living/carbon/who)
	if(!isnull(who.external) && who.external != attached_tank)
		return FALSE
	if(who.internal)
		return FALSE
	if(!istype(who.wear_mask) || !(who.wear_mask.clothing_flags & MASKINTERNALS))
		return FALSE
	if(!who.is_mouth_covered())
		return FALSE // Must have an internals mask + mouth covered
	return TRUE

/// Called when the safety triggers and attempts to unhook the patient from the tank.
/obj/structure/table/optable/proc/safety_disable()
	if(isnull(attached_tank) || patient.external != attached_tank)
		return
	if(computer?.obj_flags & EMAGGED)
		return
	disable_anesthesia(patient)
	balloon_alert_to_viewers("anesthesia safety activated")
	playsound(src, 'sound/machines/cryo_warning.ogg', 50, vary = TRUE, frequency = 0.75)
	playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)

/// Enables the patient to start breathing out of the attached tank.
/obj/structure/table/optable/proc/enable_anesthesia(mob/living/carbon/new_patient)
	PRIVATE_PROC(TRUE)
	if(isnull(attached_tank) || !can_have_tank_opened(new_patient))
		return

	new_patient.open_internals(attached_tank, TRUE)
	patient_set_at = world.time
	update_appearance(UPDATE_OVERLAYS)

/// Disables the patient from breathing out of the attached tank.
/obj/structure/table/optable/proc/disable_anesthesia(mob/living/carbon/old_patient)
	PRIVATE_PROC(TRUE)
	if(isnull(attached_tank) || old_patient?.external != attached_tank)
		return

	old_patient.close_externals()
	patient_set_at = -1
	update_appearance(UPDATE_OVERLAYS)

/// Toggles the tank on and off, playing a sound as well.
/obj/structure/table/optable/proc/toggle_anesthesia()
	if(isnull(patient) || isnull(attached_tank))
		return

	if(patient.external == attached_tank)
		disable_anesthesia(patient)
		playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)

	else if(isnull(patient.external))
		enable_anesthesia(patient)
		playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)
		playsound(src, 'sound/machines/hiss.ogg', 25, vary = TRUE, frequency = 1.5)
