/obj/item/organ/stomach/ethereal/android
	name = "android stomach"
	desc = "An electronic device designed to mimic the functions of a human stomach. Has a bio-reactor in build to convert food into energy."
	icon_state = /obj/item/organ/stomach/cybernetic/tier2::icon_state
	organ_flags = ORGAN_ROBOTIC|ORGAN_UNREMOVABLE // future todo : if this is ever removable, we need to handle energy another way

	disgust_metabolism = 128 // what is disgust?
	stomach_blood_transfer_rate = 1 // "blood" and stomach are one
	passive_drain_multiplier = 0.8 // power hungry

/obj/item/organ/stomach/ethereal/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	cell.use(STANDARD_ETHEREAL_CHARGE / severity, force = TRUE)

/obj/item/organ/stomach/ethereal/android/on_mob_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_SPECIES_HANDLE_CHEMICAL, PROC_REF(handle_chemical))

/obj/item/organ/stomach/ethereal/android/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_SPECIES_HANDLE_CHEMICAL)

/obj/item/organ/stomach/ethereal/android/proc/handle_chemical(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	if(organ_flags & ORGAN_FAILING)
		return NONE

	// nutriments are transformed into charge, bioreactor style
	if(istype(chem, /datum/reagent/consumable/ethanol))
		var/datum/reagent/consumable/ethanol/ethanol_chem = chem
		cell.give(round((ethanol_chem.boozepwr / 100) * seconds_per_tick, 1))

	else if(istype(chem, /datum/reagent/consumable))
		var/datum/reagent/consumable/consumable_chem = chem
		cell.give(round(consumable_chem.nutriment_factor * seconds_per_tick, 1))

	// allows for default handling
	return NONE

/obj/item/organ/stomach/ethereal/android/handle_charge(mob/living/carbon/carbon, seconds_per_tick, times_fired)
	switch(cell.charge())
		if(-INFINITY to ETHEREAL_CHARGE_NONE)
			// carbon.add_mood_event("charge", /datum/mood_event/decharged)
			carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/emptycell/ethereal)
			// if(carbon.health > 10.5)
			// 	carbon.apply_damage(0.65, TOX, null, null, carbon)
		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			// carbon.add_mood_event("charge", /datum/mood_event/decharged)
			carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/lowcell/ethereal, 3)
			// if(carbon.health > 10.5)
			// 	carbon.apply_damage(0.325 * seconds_per_tick, TOX, null, null, carbon)
		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_NORMAL)
			// carbon.add_mood_event("charge", /datum/mood_event/lowpower)
			carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/lowcell/ethereal, 2)
		if(ETHEREAL_CHARGE_ALMOSTFULL to ETHEREAL_CHARGE_FULL)
			// carbon.add_mood_event("charge", /datum/mood_event/charged)
		if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
			// carbon.add_mood_event("charge", /datum/mood_event/overcharged)
			carbon.throw_alert(ALERT_ETHEREAL_OVERCHARGE, /atom/movable/screen/alert/ethereal_overcharge, 1)
			// carbon.apply_damage(0.2, TOX, null, null, carbon)
		if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
			// carbon.add_mood_event("charge", /datum/mood_event/supercharged)
			carbon.throw_alert(ALERT_ETHEREAL_OVERCHARGE, /atom/movable/screen/alert/ethereal_overcharge, 2)
			// carbon.apply_damage(0.325 * seconds_per_tick, TOX, null, null, carbon)
			if(SPT_PROB(5, seconds_per_tick)) // 5% each seacond for ethereals to explosively release excess energy if it reaches dangerous levels
				discharge_process(carbon)
		else
			// owner.clear_mood_event("charge")
			carbon.clear_alert(ALERT_ETHEREAL_CHARGE)
			carbon.clear_alert(ALERT_ETHEREAL_OVERCHARGE)
