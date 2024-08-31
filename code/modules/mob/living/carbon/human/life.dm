

//NOTE: Breathing happens once per FOUR TICKS, unless the last breath fails. In which case it happens once per ONE TICK! So oxyloss healing is done once per 4 ticks while oxyloss damage is applied once per tick!

// bitflags for the percentual amount of protection a piece of clothing which covers the body part offers.
// Used with human/proc/get_heat_protection() and human/proc/get_cold_protection()
// The values here should add up to 1.
// Hands and feet have 2.5%, arms and legs 7.5%, each of the torso parts has 15% and the head has 30%
#define THERMAL_PROTECTION_HEAD 0.3
#define THERMAL_PROTECTION_CHEST 0.2
#define THERMAL_PROTECTION_GROIN 0.10
#define THERMAL_PROTECTION_LEG (0.075 * 2)
#define THERMAL_PROTECTION_FOOT (0.025 * 2)
#define THERMAL_PROTECTION_ARM (0.075 * 2)
#define THERMAL_PROTECTION_HAND (0.025 * 2)

/mob/living/carbon/human/Life(seconds_per_tick = SSMOBS_DT, times_fired)
	if(HAS_TRAIT(src, TRAIT_NO_TRANSFORM))
		return

	. = ..()
	if(QDELETED(src))
		return FALSE

	if(!HAS_TRAIT(src, TRAIT_STASIS))
		if(stat != DEAD)
			//handle active mutations
			for(var/datum/mutation/human/human_mutation as anything in dna.mutations)
				human_mutation.on_life(seconds_per_tick, times_fired)
			//heart attack stuff
			// handle_heart(seconds_per_tick, times_fired) // NON-MODULE CHANGE
			//handles liver failure effects, if we lack a liver
			handle_liver(seconds_per_tick, times_fired)

		// for special species interactions
		dna.species.spec_life(src, seconds_per_tick, times_fired)
	else
		for(var/datum/wound/iter_wound as anything in all_wounds)
			iter_wound.on_stasis(seconds_per_tick, times_fired)

	//Update our name based on whether our face is obscured/disfigured
	name = get_visible_name()

	if(stat != DEAD)
		return TRUE


/mob/living/carbon/human/calculate_affecting_pressure(pressure)
	var/chest_covered = FALSE
	var/head_covered = FALSE
	for(var/obj/item/clothing/equipped in get_equipped_items())
		if((equipped.body_parts_covered & CHEST) && (equipped.clothing_flags & STOPSPRESSUREDAMAGE))
			chest_covered = TRUE
		if((equipped.body_parts_covered & HEAD) && (equipped.clothing_flags & STOPSPRESSUREDAMAGE))
			head_covered = TRUE

	if(chest_covered && head_covered)
		return ONE_ATMOSPHERE
	if(ismovable(loc))
		/// If we're in a space with 0.5 content pressure protection, it averages the values, for example.
		var/atom/movable/occupied_space = loc
		return (occupied_space.contents_pressure_protection * ONE_ATMOSPHERE + (1 - occupied_space.contents_pressure_protection) * pressure)
	return pressure

/mob/living/carbon/human/breathe()
	if(!HAS_TRAIT(src, TRAIT_NOBREATH))
		return ..()

/mob/living/carbon/human/check_breath(datum/gas_mixture/breath)
	var/obj/item/organ/internal/lungs/human_lungs = get_organ_slot(ORGAN_SLOT_LUNGS)
	if(human_lungs)
		return human_lungs.check_breath(breath, src)

	if(health >= crit_threshold)
		adjustOxyLoss(HUMAN_MAX_OXYLOSS + 1)
	else if(!HAS_TRAIT(src, TRAIT_NOCRITDAMAGE))
		adjustOxyLoss(HUMAN_CRIT_MAX_OXYLOSS)

	failed_last_breath = TRUE

	var/datum/species/human_species = dna.species

	switch(human_species.breathid)
		if(GAS_O2)
			throw_alert(ALERT_NOT_ENOUGH_OXYGEN, /atom/movable/screen/alert/not_enough_oxy)
		if(GAS_PLASMA)
			throw_alert(ALERT_NOT_ENOUGH_PLASMA, /atom/movable/screen/alert/not_enough_plas)
		if(GAS_CO2)
			throw_alert(ALERT_NOT_ENOUGH_CO2, /atom/movable/screen/alert/not_enough_co2)
		if(GAS_N2)
			throw_alert(ALERT_NOT_ENOUGH_NITRO, /atom/movable/screen/alert/not_enough_nitro)
	return FALSE

/mob/living/carbon/human/get_heat_protection(temperature)
	var/thermal_protection_flags = NONE
	for(var/obj/item/worn in get_equipped_items())
		if(worn.max_heat_protection_temperature && worn.max_heat_protection_temperature >= temperature)
			thermal_protection_flags |= worn.heat_protection

	var/thermal_protection = heat_protection

	// Apply clothing items protection
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & (LEG_LEFT|LEG_RIGHT))
			thermal_protection += THERMAL_PROTECTION_LEG
		if(thermal_protection_flags & (FOOT_LEFT|FOOT_RIGHT))
			thermal_protection += THERMAL_PROTECTION_FOOT
		if(thermal_protection_flags & (ARM_LEFT|ARM_RIGHT))
			thermal_protection += THERMAL_PROTECTION_ARM
		if(thermal_protection_flags & (HAND_LEFT|HAND_RIGHT))
			thermal_protection += THERMAL_PROTECTION_HAND

	return min(1, thermal_protection)

/mob/living/carbon/human/get_cold_protection(temperature)
	// There is an occasional bug where the temperature is miscalculated in areas with small amounts of gas.
	// This is necessary to ensure that does not affect this calculation.
	// Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	temperature = max(temperature, 2.7)

	var/thermal_protection_flags = NONE
	for(var/obj/item/worn in get_equipped_items())
		if(worn.min_cold_protection_temperature && worn.min_cold_protection_temperature <= temperature)
			thermal_protection_flags |= worn.cold_protection

	var/thermal_protection = cold_protection

	// Apply clothing items protection
	if(thermal_protection_flags)
		if(thermal_protection_flags & HEAD)
			thermal_protection += THERMAL_PROTECTION_HEAD
		if(thermal_protection_flags & CHEST)
			thermal_protection += THERMAL_PROTECTION_CHEST
		if(thermal_protection_flags & GROIN)
			thermal_protection += THERMAL_PROTECTION_GROIN
		if(thermal_protection_flags & (LEG_LEFT|LEG_RIGHT))
			thermal_protection += THERMAL_PROTECTION_LEG
		if(thermal_protection_flags & (FOOT_LEFT|FOOT_RIGHT))
			thermal_protection += THERMAL_PROTECTION_FOOT
		if(thermal_protection_flags & (ARM_LEFT|ARM_RIGHT))
			thermal_protection += THERMAL_PROTECTION_ARM
		if(thermal_protection_flags & (HAND_LEFT|HAND_RIGHT))
			thermal_protection += THERMAL_PROTECTION_HAND

	return min(1, thermal_protection)

/mob/living/carbon/human/handle_random_events(seconds_per_tick, times_fired)
	//Puke if toxloss is too high
	if(stat)
		return
	if(getToxLoss() < 45 || nutrition <= 20)
		return

	lastpuke += SPT_PROB(30, seconds_per_tick)
	if(lastpuke >= 50) // about 25 second delay I guess // This is actually closer to 150 seconds
		vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)
		lastpuke = 0


/mob/living/carbon/human/has_smoke_protection()
	if(isclothing(wear_mask))
		if(wear_mask.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(isclothing(glasses))
		if(glasses.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	if(isclothing(head))
		var/obj/item/clothing/CH = head
		if(CH.clothing_flags & BLOCK_GAS_SMOKE_EFFECT)
			return TRUE
	return ..()

/mob/living/carbon/human/proc/handle_heart(seconds_per_tick, times_fired)
	var/we_breath = !HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT)

	if(!undergoing_cardiac_arrest())
		return

	if(we_breath)
		adjustOxyLoss(4 * seconds_per_tick)
		Unconscious(80)
	// Tissues die without blood circulation
	adjustBruteLoss(1 * seconds_per_tick)

#undef THERMAL_PROTECTION_HEAD
#undef THERMAL_PROTECTION_CHEST
#undef THERMAL_PROTECTION_GROIN
#undef THERMAL_PROTECTION_LEG
#undef THERMAL_PROTECTION_FOOT
#undef THERMAL_PROTECTION_ARM
#undef THERMAL_PROTECTION_HAND
