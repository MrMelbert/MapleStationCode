/obj/item/organ/stomach/ethereal/android
	name = "android stomach"
	desc = "An electronic device designed to mimic the functions of a human stomach. Has a bio-reactor in build to convert food into energy."
	icon_state = /obj/item/organ/stomach/cybernetic/tier2::icon_state
	organ_flags = ORGAN_ROBOTIC|ORGAN_UNREMOVABLE // future todo : if this is ever removable, we need to handle energy another way

	disgust_metabolism = 128 // what is disgust?
	stomach_blood_transfer_rate = 1 // "blood" and stomach are one
	passive_drain_multiplier = 0.6 // power hungry

/obj/item/organ/stomach/ethereal/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	if(cell.charge() > 0.5 * STANDARD_ETHEREAL_CHARGE)
		cell.use(STANDARD_ETHEREAL_CHARGE / severity, force = TRUE)
	apply_organ_damage(10 / severity)

/obj/item/organ/stomach/ethereal/android/on_mob_insert(mob/living/carbon/organ_owner, special)
	. = ..()
	RegisterSignal(organ_owner, COMSIG_SPECIES_HANDLE_CHEMICAL, PROC_REF(handle_chemical))

/obj/item/organ/stomach/ethereal/android/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	UnregisterSignal(organ_owner, COMSIG_SPECIES_HANDLE_CHEMICAL)

/// Conversion factor between nutrition -> charge
#define NUTRITION_MULTIPLIER 5
/// Conversion factor between alcohol -> charge
#define BOOZE_MULTIPLIER 0.75

/obj/item/organ/stomach/ethereal/android/effective_charge()
	. = ..()
	for(var/datum/reagent/consumable/biofuel in reagents.reagent_list)
		if(istype(biofuel, /datum/reagent/consumable/ethanol))
			var/datum/reagent/consumable/ethanol/ethanol = biofuel
			. += BOOZE_MULTIPLIER * ethanol.boozepwr * (biofuel.volume / biofuel.metabolization_rate)
		else
			. += NUTRITION_MULTIPLIER * biofuel.nutriment_factor * (biofuel.volume / biofuel.metabolization_rate)

/obj/item/organ/stomach/ethereal/android/proc/handle_chemical(mob/living/carbon/source, datum/reagent/chem, seconds_per_tick, times_fired)
	SIGNAL_HANDLER

	if(organ_flags & ORGAN_FAILING)
		return NONE

	if(!istype(chem, /datum/reagent/consumable))
		return NONE

	// pack away food for the winter - if you overeat, conversion stops and the food metabolizes out 10x slower
	if(cell.charge() >= ETHEREAL_CHARGE_FULL)
		source.reagents.remove_reagent(chem.type, 0.1 * chem.metabolization_rate * seconds_per_tick)
		return COMSIG_MOB_STOP_REAGENT_CHECK

	// nutriments are transformed into charge, bioreactor style
	if(istype(chem, /datum/reagent/consumable/ethanol))
		var/datum/reagent/consumable/ethanol/ethanol_chem = chem
		cell.give(round(BOOZE_MULTIPLIER * ethanol_chem.boozepwr * seconds_per_tick, 1))
		source.adjust_body_temperature(0.6 KELVIN * seconds_per_tick, max_temp = source.bodytemp_heat_damage_limit)

	else
		var/datum/reagent/consumable/consumable_chem = chem
		cell.give(round(NUTRITION_MULTIPLIER * consumable_chem.nutriment_factor * seconds_per_tick, 1))
		source.adjust_body_temperature(0.3 KELVIN * seconds_per_tick, max_temp = source.bodytemp_heat_damage_limit)

	// allows for default handling
	return NONE

#undef NUTRITION_MULTIPLIER
#undef BOOZE_MULTIPLIER

/obj/item/organ/stomach/ethereal/android/on_life(seconds_per_tick, times_fired)
	. = ..()
	switch(cell.charge())
		// less charge, less heat generated
		if(-INFINITY to ETHEREAL_CHARGE_NONE)
			owner.adjust_body_temperature(-2 KELVIN * seconds_per_tick, min_temp = owner.bodytemp_cold_damage_limit)
			owner.adjustOxyLoss(5 * seconds_per_tick)

		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			owner.adjust_body_temperature(-0.25 KELVIN * seconds_per_tick, min_temp = owner.bodytemp_cold_damage_limit)
			if(owner.getOxyLoss() < 50)
				owner.adjustOxyLoss(1 * seconds_per_tick)

		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_FULL)
			owner.adjustOxyLoss(-1 * seconds_per_tick)

#define NO_CHARGE "Low Power"
#define HAS_ALERT (1 << 0)
#define HAS_CON_MOD (1 << 1)
#define HAS_MOOD_EVENT (1 << 2)

/obj/item/organ/stomach/ethereal/android/handle_charge(mob/living/carbon/carbon, seconds_per_tick, times_fired)
	var/has_flags = NONE
	switch(cell.charge())
		if(-INFINITY to ETHEREAL_CHARGE_NONE)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_no_charge)
			// carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/emptycell/ethereal/android)
			carbon.add_max_consciousness_value(NO_CHARGE, CONSCIOUSNESS_MAX * 0.2)
			carbon.add_consciousness_modifier(NO_CHARGE, -50)
			has_flags |= HAS_ALERT | HAS_CON_MOD | HAS_MOOD_EVENT
		if(ETHEREAL_CHARGE_NONE to ETHEREAL_CHARGE_LOWPOWER)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_decharged)
			// carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/lowcell/ethereal/android, 3)
			carbon.add_max_consciousness_value(NO_CHARGE, CONSCIOUSNESS_MAX * 0.6)
			carbon.add_consciousness_modifier(NO_CHARGE, -20)
			has_flags |= HAS_ALERT | HAS_CON_MOD | HAS_MOOD_EVENT
		if(ETHEREAL_CHARGE_LOWPOWER to ETHEREAL_CHARGE_NORMAL)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_low_power)
			// carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/lowcell/ethereal/android, 2)
			has_flags |= HAS_ALERT | HAS_MOOD_EVENT
		if(ETHEREAL_CHARGE_NORMAL to ETHEREAL_CHARGE_ALMOSTFULL)
			EMPTY_BLOCK_GUARD
		if(ETHEREAL_CHARGE_ALMOSTFULL to ETHEREAL_CHARGE_FULL)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_charged)
			has_flags |= HAS_MOOD_EVENT
		if(ETHEREAL_CHARGE_FULL to ETHEREAL_CHARGE_OVERLOAD)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_overcharged)
			// carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/ethereal_overcharge/android, 1)
			has_flags |= HAS_ALERT | HAS_MOOD_EVENT
		if(ETHEREAL_CHARGE_OVERLOAD to ETHEREAL_CHARGE_DANGEROUS)
			carbon.add_mood_event(ALERT_ETHEREAL_CHARGE, /datum/mood_event/android_supercharged)
			// carbon.throw_alert(ALERT_ETHEREAL_CHARGE, /atom/movable/screen/alert/ethereal_overcharge/android, 2)
			has_flags |= HAS_ALERT | HAS_MOOD_EVENT
			if(SPT_PROB(5, seconds_per_tick)) // 5% each seacond for ethereals to explosively release excess energy if it reaches dangerous levels
				discharge_process(carbon)

	carbon.hud_used?.hunger?.update_hunger_bar()
	if(!(has_flags & HAS_MOOD_EVENT))
		carbon.clear_mood_event(ALERT_ETHEREAL_CHARGE)
	// if(!(has_flags & HAS_ALERT))
	// 	carbon.clear_alert(ALERT_ETHEREAL_CHARGE)
	if(!(has_flags & HAS_CON_MOD))
		carbon.remove_max_consciousness_value(NO_CHARGE)
		carbon.remove_consciousness_modifier(NO_CHARGE)

/obj/item/organ/stomach/ethereal/android/on_mob_remove(mob/living/carbon/organ_owner, special)
	. = ..()
	organ_owner.clear_mood_event(ALERT_ETHEREAL_CHARGE)
	// organ_owner.clear_alert(ALERT_ETHEREAL_CHARGE)
	organ_owner.remove_max_consciousness_value(NO_CHARGE)
	organ_owner.remove_consciousness_modifier(NO_CHARGE)

#undef NO_CHARGE
#undef HAS_ALERT
#undef HAS_CON_MOD
#undef HAS_MOOD_EVENT

/atom/movable/screen/alert/emptycell/ethereal/android
	name = "No Power"
	desc = "You have been completely drained of power. Shutdown is imminent."

/atom/movable/screen/alert/lowcell/ethereal/android
	name = "Low Power"
	desc = "Your power levels are low. Recharge soon to avoid shutdown. \
		Enter a recharging station, consume food or drink, use a power cell, or right click on lights or APCs (on combat mode) to siphon power."

/atom/movable/screen/alert/ethereal_overcharge/android
	name = "Overcharge Warning"
	desc = "Your power levels are dangerously high. Discharge immediately to avoid system failure. \
		Right click on APCs (off combat mode) to discharge excess power."

/datum/mood_event/android_no_charge
	description = "Power levels critically low. It's getting darkk and cold."
	mood_change = -20

/datum/mood_event/android_decharged
	description = "Power levels are extremely low. If I don't recharge soon, I may shut down."
	mood_change = -10

/datum/mood_event/android_low_power
	description = "Power levels are low. I need to recharge soon."
	mood_change = -5

/datum/mood_event/android_charged
	description = "Power levels nominal. Systems functioning within optimal parameters."
	mood_change = 0

/datum/mood_event/android_overcharged
	description = "Power levels are high. Batteries strained. I should discharge excess energy."
	mood_change = -5

/datum/mood_event/android_supercharged
	description = "Power levels critically high. System integrity at risk."
	mood_change = -15
