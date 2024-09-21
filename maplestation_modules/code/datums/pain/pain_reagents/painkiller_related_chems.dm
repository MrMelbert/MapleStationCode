// These chems are related to painkillers tangentially

// Component in ibuprofen.
/datum/reagent/propionic_acid
	name = "Propionic Acid"
	description = "A pungent liquid that's often used in preservatives and synthesizing of other chemicals."
	reagent_state = LIQUID
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	color = "#c7a9c9"
	ph = 7

// Diphenhydramine can be upgraded into Dimenhydrinate, less good against allergens but better against nausea
/datum/reagent/medicine/dimenhydrinate
	name = "Dimenhydrinate"
	description = "Helps combat nausea and motion sickness."
	reagent_state = LIQUID
	color = "#98ffee"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	ph = 10.6
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/dimenhydrinate/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	. = ..()
	M.adjust_disgust(-8 * REM * seconds_per_tick)
	if(M.nutrition > NUTRITION_LEVEL_FULL - 25) // Boosts hunger to a bit, assuming you've been vomiting
		M.adjust_nutrition(2 * HUNGER_FACTOR * REM * seconds_per_tick)

// Naloxone helps with opioid addiction
/datum/reagent/medicine/naloxone
	name = "Naloxone"
	description = "An opioid antagonist which helps opioid overdoses and addiction."
	reagent_state = LIQUID
	color = "#ff9900"
	ph = 7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/naloxone/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	// Purges anything remotely opioid-related
	for(var/datum/reagent/other_opioid as anything in affected_mob.reagents.reagent_list)
		if(other_opioid.addiction_types?[/datum/addiction/opioids])
			affected_mob.reagents.remove_reagent(other_opioid.type, 3 * REM * seconds_per_tick)

	affected_mob.mind?.remove_addiction_points(/datum/addiction/opioids, 5 * normalise_creation_purity() * REM * seconds_per_tick)
	affected_mob.adjust_disgust(1 * REM * seconds_per_tick)

// Buproprion helps with stimulant and nicotine addiction
/datum/reagent/medicine/buproprion
	name = "Buproprion"
	description = "A medication that can help with stimulant and nicotine addiction."
	reagent_state = LIQUID
	color = "#9ff1ff"
	ph = 7
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED

/datum/reagent/medicine/buproprion/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	// I don't want this to be a major purger of relevant chems, primarily just to stem addiction
	for(var/datum/reagent/other_opioid as anything in affected_mob.reagents.reagent_list)
		if(other_opioid.addiction_types?[/datum/addiction/nicotine] || other_opioid.addiction_types?[/datum/addiction/stimulants])
			affected_mob.reagents.remove_reagent(other_opioid.type, 1 * REM * seconds_per_tick)

	affected_mob.mind?.remove_addiction_points(/datum/addiction/nicotine, 5 * normalise_creation_purity() * REM * seconds_per_tick)
	affected_mob.mind?.remove_addiction_points(/datum/addiction/stimulants, 5 * normalise_creation_purity() * REM * seconds_per_tick)
	affected_mob.adjust_disgust(1 * REM * seconds_per_tick)

/datum/reagent/medicine/buproprion/on_mob_metabolize(mob/living/carbon/user)
	. = ..()
	user.add_mood_event(type, /datum/mood_event/buproprion)

/datum/reagent/medicine/buproprion/on_mob_end_metabolize(mob/living/carbon/user)
	. = ..()
	user.clear_mood_event(type)
	user.add_mood_event(type, /datum/mood_event/buproprion/timeout, current_cycle)

/datum/mood_event/buproprion
	description = "I feel a bit better than usual."
	mood_change = 4

/datum/mood_event/buproprion/timeout
	mood_change = 2
	timeout = 20 SECONDS

/datum/mood_event/buproprion/timeout/add_effects(cycles_metabolized = 10)
	timeout = max(cycles_metabolized * 0.5 SECONDS, 1 SECONDS)

// Antihol also helps alcohol addiction
/datum/reagent/medicine/antihol/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.mind?.remove_addiction_points(/datum/addiction/alcohol, 5 * normalise_creation_purity() * REM * seconds_per_tick)
