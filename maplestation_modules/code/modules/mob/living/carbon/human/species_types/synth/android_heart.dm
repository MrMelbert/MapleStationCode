/obj/item/organ/heart/android
	name = "android heart"
	desc = "An electronic device designed to mimic the functions of a human heart. Pumps fuel throughout the body."
	icon_state = /obj/item/organ/heart/cybernetic/tier2::icon_state
	organ_flags = ORGAN_ROBOTIC|ORGAN_UNREMOVABLE // future todo : if this is ever removable, we need to handle blood another way

/obj/item/organ/heart/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	apply_organ_damage(10 / severity)

/obj/item/organ/heart/android/on_mob_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_HUMAN_ON_HANDLE_BLOOD, PROC_REF(handle_blood))
	RegisterSignal(organ_owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))

/obj/item/organ/heart/android/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_HUMAN_ON_HANDLE_BLOOD)
	UnregisterSignal(organ_owner, COMSIG_MOVABLE_MOVED)

// /obj/item/organ/heart/android/get_heart_rate()
// 	return 2 // static heart rate

/obj/item/organ/heart/android/on_life(seconds_per_tick, times_fired)
	. = ..()
	// melbert todo : scale temp use based on oil in body?
	owner.adjust_body_temperature(0.25 KELVIN, max_temp = owner.bodytemp_heat_damage_limit * 1.5)

/obj/item/organ/heart/android/proc/handle_blood(mob/living/carbon/source, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	switch(source.blood_volume)
		if(BLOOD_VOLUME_MAX_LETHAL to INFINITY)
			EMPTY_BLOCK_GUARD // melbert todo : make you leak blood constantly
		if(BLOOD_VOLUME_EXCESS to BLOOD_VOLUME_MAX_LETHAL)
			EMPTY_BLOCK_GUARD // melbert todo : make you leak blood constantly
		if(BLOOD_VOLUME_MAXIMUM to BLOOD_VOLUME_EXCESS)
			EMPTY_BLOCK_GUARD // melbert todo : make you bleed more if wounded
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			EMPTY_BLOCK_GUARD
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			source.add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.9)
			source.add_consciousness_modifier(BLOOD_LOSS, -10)
			if(source.getOxyLoss() < 100)
				source.adjustOxyLoss(2)
			if(SPT_PROB(2.5, seconds_per_tick))
				source.set_eye_blur_if_lower(12 SECONDS)
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			source.add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.6)
			source.add_consciousness_modifier(BLOOD_LOSS, -20)
			if(source.getOxyLoss() < 150)
				source.adjustOxyLoss(3)
			source.set_eye_blur_if_lower(6 SECONDS)
		if(-INFINITY to BLOOD_VOLUME_SURVIVE)
			source.add_max_consciousness_value(BLOOD_LOSS, CONSCIOUSNESS_MAX * 0.2)
			source.add_consciousness_modifier(BLOOD_LOSS, -50)
			source.set_eye_blur_if_lower(20 SECONDS)
			var/how_screwed_are_we = 1 - ((BLOOD_VOLUME_SURVIVE - source.blood_volume) / BLOOD_VOLUME_SURVIVE)
			source.adjustOxyLoss(max(5, 50 * how_screwed_are_we))

	if(source.blood_volume > BLOOD_VOLUME_OKAY)
		source.remove_max_consciousness_value(BLOOD_LOSS)
		source.remove_consciousness_modifier(BLOOD_LOSS)

	return HANDLE_BLOOD_HANDLED

/obj/item/organ/heart/android/proc/on_moved(mob/living/carbon/source, atom/from_loc, movement_dir, ...)
	SIGNAL_HANDLER

	// melbert todo : won't work without mech changes
	if(source.blood_volume > BLOOD_VOLUME_EXCESS)
		source.make_blood_trail(get_turf(source), from_loc, source.dir, movement_dir)
