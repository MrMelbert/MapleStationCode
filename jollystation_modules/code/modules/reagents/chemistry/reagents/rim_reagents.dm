// -- Rimworld inspired reagents. --
// Luciferium. Exremely addictive, very strong pain relief
/datum/reagent/medicine/luciferium
	name = "Luciferium"
	description = "An incredibly powerful, addictive, and dangerous concoction of mechanites from the outer planets of the Spinward. \
		Drastically improves the user's bodily functions but will cause eventual death if mechanite cohesion is not sustained with continuous dosage. \
		Once used, the pressence and effects of the mechanites are irreversible, leading to the nickname \'Devil's Bargain\' by many."
	reagent_state = LIQUID
	color = "#a80008"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 12
	ph = 12.4
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/luciferium = 50) // 2 units = addiction
	pain_modifier = 0.8

/datum/reagent/medicine/luciferium/on_mob_metabolize(mob/living/carbon/user)
	. = ..()
	// Increases movement speed very slightly
	user.add_movespeed_modifier(/datum/movespeed_modifier/reagent/luciferium)
	// Helps stabilize the person / blood flow
	ADD_TRAIT(user, TRAIT_ANTICONVULSANT, type)
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, type)
	ADD_TRAIT(user, TRAIT_NOCRITDAMAGE, type)
	// Improved blood filtration (resistance to diseases)
	ADD_TRAIT(user, TRAIT_DISEASE_RESISTANT, type)
	// Slight improved vision
	ADD_TRAIT(user, TRAIT_NIGHT_VISION, type)

/datum/reagent/medicine/luciferium/on_mob_end_metabolize(mob/living/carbon/user)
	. = ..()
	user.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/luciferium)
	REMOVE_TRAIT(user, TRAIT_ANTICONVULSANT, type)
	REMOVE_TRAIT(user, TRAIT_DISEASE_RESISTANT, type)
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, type)
	REMOVE_TRAIT(user, TRAIT_NOCRITDAMAGE, type)
	REMOVE_TRAIT(user, TRAIT_NIGHT_VISION, type)

/datum/reagent/medicine/luciferium/on_mob_life(mob/living/carbon/user, delta_time, times_fired)

	// Heals pain and tons of damage (based on purity)
	user.cause_pain(BODY_ZONES_ALL, -1 * REM * delta_time)
	user.adjustCloneLoss(-8 * normalise_creation_purity() * REM * delta_time, FALSE)
	user.adjustBruteLoss(-5 * normalise_creation_purity() * REM * delta_time, FALSE)
	user.adjustFireLoss(-5 * normalise_creation_purity() * REM * delta_time, FALSE)
	user.adjustOxyLoss(-3 * normalise_creation_purity() * REM * delta_time, FALSE)
	user.adjustToxLoss(-3 * normalise_creation_purity() * REM * delta_time, FALSE, TRUE)

	// Improves / fixes eyesight
	user.adjust_blindness(-2 * normalise_creation_purity() * REM * delta_time)
	user.adjust_blurriness(-2 * normalise_creation_purity() * REM * delta_time)
	user.adjustOrganLoss(ORGAN_SLOT_EYES, -3 * normalise_creation_purity() * REM * delta_time )

	// Removes scars
	if(DT_PROB(8, delta_time))
		var/datum/scar/scar_to_remove = pick(user.all_scars)
		if(scar_to_remove)
			LAZYREMOVE(user.all_scars, scar_to_remove)

	// Can cure permanent traumas
	user.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3 * normalise_creation_purity() * REM * delta_time)
	if(DT_PROB(5, delta_time))
		var/static/list/curable_traumas = shuffle(subtypesof(/datum/brain_trauma/severe) + subtypesof(/datum/brain_trauma/mild))
		for(var/trauma in curable_traumas)
			if(user.has_trauma_type(trauma))
				user.cure_trauma_type(trauma, TRAUMA_RESILIENCE_ABSOLUTE)
				break

	// Can cure wounds, too
	if(DT_PROB(6, delta_time))
		var/list/shuffled_wounds = shuffle(user.all_wounds)
		for(var/datum/wound/wound as anything in shuffled_wounds)
			wound.remove_wound()
			break

	. = ..()
	return TRUE

/datum/reagent/medicine/penoxycyline
	name = "Penoxycyline"
	description = "A standard drug that prevents the user from catching viral or bacterial diseases or infections."
	reagent_state = LIQUID
	color = "#c4b703"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 30
	ph = 8.7

/datum/reagent/medicine/penoxycyline/on_mob_metabolize(mob/living/carbon/user)
	. = ..()
	ADD_TRAIT(user, TRAIT_DISEASE_RESISTANT, type)

/datum/reagent/medicine/penoxycyline/on_mob_end_metabolize(mob/living/carbon/user)
	. = ..()
	REMOVE_TRAIT(user, TRAIT_DISEASE_RESISTANT, type)

/datum/reagent/drug/gojuice
	name = "Go-Juice"
	description = "An effective, but addictive stimulant that blocks pain and increases the user's combat effectiveness and movement speed. \
		Addiction causes increased pain and massively reduced movement speed, but last shorter than most."
	reagent_state = LIQUID
	color = "#52bb38"
	overdose_threshold = 20
	metabolization_rate = 0.75 * REAGENTS_METABOLISM
	chemical_flags = REAGENT_CAN_BE_SYNTHESIZED
	addiction_types = list(/datum/addiction/gojuice = 30) //25-30 units = addiction
	ph = 5
	pain_modifier = 0.1

/datum/reagent/drug/gojuice/on_mob_metabolize(mob/living/carbon/user)
	. = ..()
	user.add_movespeed_modifier(/datum/movespeed_modifier/reagent/gojuice)
	SEND_SIGNAL(user, COMSIG_ADD_MOOD_EVENT, type, /datum/mood_event/gojuice)
	ADD_TRAIT(user, TRAIT_NIGHT_VISION, type)
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, type)

/datum/reagent/drug/gojuice/on_mob_end_metabolize(mob/living/user)
	. = ..()
	user.remove_movespeed_modifier(/datum/movespeed_modifier/reagent/gojuice)
	SEND_SIGNAL(user, COMSIG_CLEAR_MOOD_EVENT, type)
	REMOVE_TRAIT(user, TRAIT_NIGHT_VISION, type)
	REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, type)

/datum/reagent/drug/gojuice/on_mob_life(mob/living/carbon/user, delta_time, times_fired)
	. = ..()
	user.Jitter(4 * REM * delta_time)
	user.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 2) * REM * delta_time)
	user.drowsyness = max(user.drowsyness - (4 * normalise_creation_purity() * REM * delta_time), 0)
