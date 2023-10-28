/obj/structure/table/optable
	/// Internals tank clamped onto the table.
	/// Allows an operating computer to easily attach it to the mob and use it for anesthesia.
	VAR_FINAL/obj/item/tank/internals/attached_tank
	/// World time when the patient was set onto the tank
	VAR_FINAL/patient_set_at = -1
	/// Time after which the anesthesia will be automatically disabled
	/// Can be set to INFINITY to never auto-disable
	var/failsafe_time = 6 MINUTES

/obj/structure/table/optable/examine(mob/user)
	. = ..()
	if(isnull(attached_tank))
		. += span_notice("It has a clamp on the side for attaching a breath tank.")
	else
		. += span_notice("It has \a [attached_tank] attached to it.")

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


/obj/structure/table/optable/deconstruct(disassembled, wrench_disassembly)
	attached_tank.forceMove(drop_location())
	return ..()

/obj/structure/table/optable/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == attached_tank)
		disable_anesthesia(patient)
		attached_tank = null

/obj/structure/table/optable/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tank/internals))
		if(isnull(attached_tank))
			if(user.transferItemToLoc(I, src))
				attached_tank = I
				balloon_alert_to_viewers("tank attached")
				playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			else
				balloon_alert(user, "can't attach tank!")
		else
			balloon_alert(user, "already has a tank!")
		return TRUE

	return ..()

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

/// Disables the patient from breathing out of the attached tank.
/obj/structure/table/optable/proc/disable_anesthesia(mob/living/carbon/old_patient)
	PRIVATE_PROC(TRUE)
	if(isnull(attached_tank) || old_patient?.external != attached_tank)
		return

	old_patient.close_externals()
	patient_set_at = -1

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

/obj/machinery/computer/operating

/obj/machinery/computer/operating/emag_act(mob/user, obj/item/card/emag/emag_card)
	. = ..()
	if(obj_flags & EMAGGED)
		return
	if(!is_operational)
		return

	obj_flags |= EMAGGED
	balloon_alert(user, "safeties overridden")
	playsound(src, 'sound/machines/terminal_alert.ogg', 50, FALSE, SHORT_RANGE_SOUND_EXTRARANGE)
	playsound(src, SFX_SPARKS, 100, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)

/obj/machinery/computer/operating/on_set_is_operational(old_value)
	if(is_operational)
		return
	// Losing power / getting broken will auto disable anesthesia
	table.safety_disable()

/obj/machinery/computer/operating/ui_data(mob/user)
	var/list/data = ..()
	if(isnull(table))
		return data

	var/tank_exists = !isnull(table.attached_tank)
	data["anesthesia"] = list(
		"has_tank" = tank_exists,
		"open" = tank_exists && table.patient?.external == table.attached_tank,
		"can_open_tank" = tank_exists && table.can_have_tank_opened(table.patient),
		"failsafe" = table.failsafe_time == INFINITY ? -1 : (table.failsafe_time / 10),
	)

	if(isnull(table.patient))
		return data

	var/obj/item/organ/patient_brain = table.patient.get_organ_slot(ORGAN_SLOT_BRAIN)
	data["patient"]["brain"] = isnull(patient_brain) ? 0 : ((patient_brain.damage / patient_brain.maxHealth) * 100)
	// We can also show pain and stuff here if we want.

	return data

/obj/machinery/computer/operating/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(. || isnull(table))
		return

	switch(action)
		if("toggle_anesthesia")
			if(iscarbon(usr))
				var/mob/living/carbon/toggler = usr
				if(toggler == table.patient && toggler.external != table.attached_tank && table.failsafe_time >= 5 MINUTES)
					to_chat(toggler, span_warning("You feel as if you know better than to do that."))
					return FALSE

			table.toggle_anesthesia()
			return TRUE

		if("set_failsafe")
			table.failsafe_time = clamp(text2num(params["new_failsafe_time"]) * 10, 5 SECONDS, 10 MINUTES)
			return TRUE

		if("disable_failsafe")
			table.failsafe_time = INFINITY
			return TRUE
