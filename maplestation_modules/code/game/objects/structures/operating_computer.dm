/obj/machinery/computer/operating

/obj/machinery/computer/operating/attackby(obj/item/weapon, mob/living/user, params)
	if(!istype(user) || user.combat_mode)
		return ..()
	if(weapon.item_flags & SURGICAL_TOOL)
		// You can open it while doing surgery
		return interact(user)
	return ..()

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
	data["patient"]["brain"] = isnull(patient_brain) ? 100 : ((patient_brain.damage / patient_brain.maxHealth) * 100)
	data["patient"]["bloodVolumePercent"] = round((table.patient.blood_volume / BLOOD_VOLUME_NORMAL) * 100)
	data["patient"]["heartRate"] = table.patient.get_pretend_heart_rate()
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
				if(toggler == table.patient && table.patient_set_at == -1 && table.failsafe_time >= 5 MINUTES)
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

/// I fully intend on adding real heart rate eventually, but now we fake it
/// This also serves as a nice way to collect things which should affect heart rate later.
/mob/living/carbon/proc/get_pretend_heart_rate()
	if(stat == DEAD)
		return 0

	var/obj/item/organ/internal/heart/heart = get_organ_slot(ORGAN_SLOT_HEART)
	if(isnull(heart) || !heart.is_beating())
		return 0

	var/base_amount = 0

	if(has_status_effect(/datum/status_effect/jitter))
		base_amount = 100 + rand(0, 25)
	else if(stat == SOFT_CRIT || stat == HARD_CRIT)
		base_amount = 60 + rand(-15, -10)
	else
		base_amount = 90 + rand(-10, 10)

	switch(pain_controller?.get_average_pain()) // pain raises it a bit
		if(25 to 50)
			base_amount += 5
		if(50 to 75)
			base_amount += 10
		if(75 to INFINITY)
			base_amount += 15

	switch(pain_controller?.pain_modifier) // numbness lowers it a bit
		if(0.25 to 0.5)
			base_amount -= 15
		if(0.5 to 0.75)
			base_amount -= 10
		if(0.75 to 1)
			base_amount -= 5

	if(has_status_effect(/datum/status_effect/determined)) // adrenaline
		base_amount += 10

	if(has_reagent(/datum/reagent/consumable/coffee)) // funny
		base_amount += 10

	return round(base_amount * clamp(1.5 * ((heart.maxHealth - heart.damage) / heart.maxHealth), 0.5, 1)) // heart damage puts a multiplier on it
