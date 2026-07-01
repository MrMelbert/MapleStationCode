/obj/structure/table/optable
	/// Internals tank clamped onto the table.
	/// Allows an operating computer to easily attach it to the mob and use it for anesthesia.
	VAR_FINAL/obj/item/attached_anesthetic
	/// World time when the patient was set onto the tank
	VAR_FINAL/patient_set_at = -1
	/// Time after which the anesthesia will be automatically disabled
	/// Can be set to INFINITY to never auto-disable
	var/failsafe_time = 6 MINUTES

/obj/structure/table/optable/examine(mob/user)
	. = ..()
	if(isnull(attached_anesthetic))
		. += span_notice("It has a clamp on the side for attaching a breath tank.")
	else
		. += span_notice("It has \a [attached_anesthetic] attached to it.")

/obj/structure/table/optable/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/table/optable/update_overlays()
	. = ..()
	if(istype(attached_anesthetic, /obj/item/tank/internals))
		. += mutable_appearance(
			icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
			icon_state = "surgery_[attached_anesthetic.icon_state]",
			alpha = src.alpha,
		)
	else if(istype(attached_anesthetic, /obj/item/surgery_neural_suppressor))
		. += mutable_appearance(
			icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
			icon_state = "suppressor_[computer?.is_operational ? (patient_set_at == -1 ? "idle" : "active") : "nopower"]",
			alpha = src.alpha,
		)
		if(computer?.is_operational)
			. += emissive_appearance(
				icon = 'maplestation_modules/icons/obj/surgery_table_overlay.dmi',
				icon_state = "suppressor_emissive",
				offset_spokesman = src,
				alpha = src.alpha,
			)

	if(isnull(computer) || !computer.is_operational)
		return

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

	if(isnull(attached_anesthetic))
		if(istype(held_item, /obj/item/tank/internals) || istype(held_item, /obj/item/surgery_neural_suppressor))
			context[SCREENTIP_CONTEXT_LMB] = "Attach [LOWER_TEXT(held_item.name)]"
			. = CONTEXTUAL_SCREENTIP_SET
	else
		if(isnull(held_item))
			context[SCREENTIP_CONTEXT_RMB] = "Remove [LOWER_TEXT(attached_anesthetic.name)]"
			. = CONTEXTUAL_SCREENTIP_SET


/obj/structure/table/optable/atom_deconstruct(disassembled, wrench_disassembly)
	attached_anesthetic?.forceMove(drop_location())
	return ..()

/obj/structure/table/optable/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == attached_anesthetic)
		disable_anesthesia(patient)
		attached_anesthetic = null
		if(!QDELING(src))
			update_appearance(UPDATE_OVERLAYS)

/obj/structure/table/optable/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, /obj/item/tank/internals))
		if(!isnull(attached_anesthetic))
			balloon_alert(user, "already has \a [attached_anesthetic]!")
			return ITEM_INTERACT_BLOCKING
		if(user.transferItemToLoc(tool, src, silent = FALSE))
			attached_anesthetic = tool
			update_appearance(UPDATE_OVERLAYS)
			balloon_alert_to_viewers("tank attached")
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "can't attach tank!")
		return ITEM_INTERACT_BLOCKING

	if(istype(tool, /obj/item/surgery_neural_suppressor))
		if(!isnull(attached_anesthetic))
			balloon_alert(user, "already has \a [attached_anesthetic]!")
			return ITEM_INTERACT_BLOCKING
		if(user.transferItemToLoc(tool, src, silent = FALSE))
			attached_anesthetic = tool
			update_appearance(UPDATE_OVERLAYS)
			balloon_alert_to_viewers("neural suppressor attached")
			playsound(src, 'sound/machines/click.ogg', 50, TRUE)
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "can't attach neural suppressor!")
		return ITEM_INTERACT_BLOCKING

	return NONE

/obj/structure/table/optable/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return .
	if(isnull(attached_anesthetic))
		return .

	user.put_in_hands(attached_anesthetic)
	balloon_alert(user, "[LOWER_TEXT(attached_anesthetic.name)] removed")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/table/optable/recheck_patient(mob/living/carbon/potential_patient)
	var/mob/living/carbon/old_patient = patient
	. = ..()
	update_appearance(UPDATE_OVERLAYS)
	if(patient == potential_patient && patient != old_patient)
		return

	if(old_patient == potential_patient)
		disable_anesthesia(old_patient)

/obj/structure/table/optable/process(seconds_per_tick)
	if(isnull(patient) || isnull(attached_anesthetic))
		return PROCESS_KILL
	if(!can_have_anesthetic(patient))
		disable_anesthesia(patient)
		return // PROCESS_KILL // this happens anyways
	if(computer?.is_operational && patient_set_at + failsafe_time < world.time)
		safety_disable()
		return // PROCESS_KILL // this happens anyways

/// Checks if the passed mob is in a valid state to start breathing out of the attached tank.
/obj/structure/table/optable/proc/can_have_tank_opened(mob/living/carbon/who)
	if(!isnull(who.external) && who.external != attached_anesthetic)
		return FALSE
	if(who.internal)
		return FALSE
	if(!istype(who.wear_mask) || !(who.wear_mask.clothing_flags & MASKINTERNALS))
		return FALSE
	return TRUE

/// Check if the passed mob can have the attached anesthetic, whether it's a tank or a neural suppressor.
/obj/structure/table/optable/proc/can_have_anesthetic(mob/living/carbon/who)
	if(istype(attached_anesthetic, /obj/item/tank/internals))
		return can_have_tank_opened(who)
	if(istype(attached_anesthetic, /obj/item/surgery_neural_suppressor))
		return computer?.is_operational
	return FALSE

/// Called when the safety triggers and attempts to unhook the patient from the tank.
/obj/structure/table/optable/proc/safety_disable()
	if(isnull(attached_anesthetic))
		return
	if(istype(attached_anesthetic, /obj/item/tank/internals) && patient?.external != attached_anesthetic)
		return
	if(computer?.obj_flags & EMAGGED)
		return
	disable_anesthesia(patient)
	balloon_alert_to_viewers("anesthesia safety activated")
	playsound(src, 'sound/machines/cryo_warning.ogg', 50, vary = TRUE, frequency = 0.75)
	playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)

/// Enables the patient to start breathing out of the attached tank.
/obj/structure/table/optable/proc/enable_anesthesia(mob/living/carbon/new_patient, mob/living/toggler)
	PRIVATE_PROC(TRUE)
	if(isnull(attached_anesthetic) || !can_have_anesthetic(new_patient))
		return

	if(istype(attached_anesthetic, /obj/item/tank/internals))
		ASSERT(istype(new_patient.wear_mask))
		if (new_patient.wear_mask.up)
			new_patient.wear_mask.adjust_visor(toggler)
		new_patient.open_internals(attached_anesthetic, TRUE)

	if(istype(attached_anesthetic, /obj/item/surgery_neural_suppressor))
		computer?.update_use_power(ACTIVE_POWER_USE)
		new_patient.add_traits(list(
			TRAIT_BLOCK_HEADSET_USE,
			TRAIT_IMMOBILIZED,
			TRAIT_HANDS_BLOCKED,
			TRAIT_SOFTSPOKEN,
		), REF(src))
		new_patient.set_pain_mod(REF(src), 0.1)
		new_patient.add_max_consciousness_value(REF(src), 40)
		to_chat(new_patient, span_notice("You feel your body go completely numb and non-responsive!"))

	patient_set_at = world.time
	update_appearance(UPDATE_OVERLAYS)
	START_PROCESSING(SSobj, src)

/// Disables the patient from breathing out of the attached tank.
/obj/structure/table/optable/proc/disable_anesthesia(mob/living/carbon/old_patient)
	PRIVATE_PROC(TRUE)
	if(isnull(attached_anesthetic))
		return

	if(!isnull(old_patient))
		if(istype(attached_anesthetic, /obj/item/tank/internals) && old_patient.external == attached_anesthetic)
			old_patient.close_externals()

		if(istype(attached_anesthetic, /obj/item/surgery_neural_suppressor))
			computer?.update_use_power(IDLE_POWER_USE)
			REMOVE_TRAITS_IN(old_patient, REF(src))
			old_patient.unset_pain_mod(REF(src))
			old_patient.remove_max_consciousness_value(REF(src))
			to_chat(old_patient, span_notice("You feel sensation return to your body."))

	patient_set_at = -1
	update_appearance(UPDATE_OVERLAYS)
	STOP_PROCESSING(SSobj, src)

/// Toggles the tank on and off, playing a sound as well.
/obj/structure/table/optable/proc/toggle_anesthesia(mob/living/toggler)
	if(isnull(patient) || isnull(attached_anesthetic))
		return

	if(istype(attached_anesthetic, /obj/item/tank/internals))
		if(patient.external == attached_anesthetic)
			disable_anesthesia(patient)
			playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)

		else if(isnull(patient.external))
			enable_anesthesia(patient, toggler)
			playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)
			playsound(src, 'sound/machines/hiss.ogg', 25, vary = TRUE, frequency = 1.5)

	if(istype(attached_anesthetic, /obj/item/surgery_neural_suppressor))
		if(patient_set_at == -1)
			enable_anesthesia(patient, toggler)
		else
			disable_anesthesia(patient)
		playsound(src, 'sound/machines/doorclick.ogg', 50, vary = FALSE)

/obj/item/surgery_neural_suppressor
	name = "neural suppressor"
	desc = "A device designed to shut down a patient's nervous system. \
		Designed as a more modern replacement for traditional anesthesia in surgical operations."
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	icon = 'icons/obj/devices/artefacts.dmi'
	icon_state = "prototype2"
	drop_sound = 'sound/items/handling/multitool_drop.ogg'
	pickup_sound = 'sound/items/handling/multitool_pickup.ogg'
	custom_materials = list(
		/datum/material/iron = SHEET_MATERIAL_AMOUNT,
		/datum/material/silver = SMALL_MATERIAL_AMOUNT,
		/datum/material/gold = SMALL_MATERIAL_AMOUNT,
	)

/obj/item/surgery_neural_suppressor/examine(mob/user)
	. = ..()
	. += span_info("When attached to an operating table, functions as an alternative to anesthetic, requiring nothing but power to use.")
