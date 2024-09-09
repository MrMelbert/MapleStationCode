// -- Reagents that modify pain. --
/datum/reagent
	/// Modifier applied by this reagent to the mob's pain.
	/// This is both a multiplicative modifier to their overall received pain,
	/// and an additive modifier to their per tick pain decay rate.
	var/pain_modifier = null

/datum/reagent/on_mob_metabolize(mob/living/carbon/user)
	. = ..()
	if(isnum(pain_modifier))
		user.set_pain_mod("[PAIN_MOD_CHEMS]-[name]", pain_modifier)

/datum/reagent/on_mob_end_metabolize(mob/living/carbon/user)
	. = ..()
	if(isnum(pain_modifier))
		user.unset_pain_mod("[PAIN_MOD_CHEMS]-[name]")

// Muscle stimulant is functionally morphine without downsides (it's rare)
/datum/reagent/medicine/muscle_stimulant
	pain_modifier = 0.5

// Epinephrine helps pain very very slightly and helps against shock
/datum/reagent/medicine/epinephrine
	pain_modifier = 0.9

/datum/reagent/medicine/epinephrine/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	ADD_TRAIT(M, TRAIT_ABATES_SHOCK, type)
	ADD_TRAIT(M, TRAIT_NOCRITDAMAGE, type)

/datum/reagent/medicine/epinephrine/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_ABATES_SHOCK, type)
	REMOVE_TRAIT(M, TRAIT_NOCRITDAMAGE, type)
	. = ..()

/datum/reagent/medicine/epinephrine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_pain_shock(-0.25 * REM * seconds_per_tick)

// Atropine fills a simliar niche to epinephrine
/datum/reagent/medicine/atropine
	pain_modifier = 0.8

/datum/reagent/medicine/atropine/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	ADD_TRAIT(M, TRAIT_ABATES_SHOCK, type)
	ADD_TRAIT(M, TRAIT_NOCRITDAMAGE, type)

/datum/reagent/medicine/atropine/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_ABATES_SHOCK, type)
	REMOVE_TRAIT(M, TRAIT_NOCRITDAMAGE, type)
	. = ..()

/datum/reagent/medicine/atropine/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_pain_shock(-0.5 * REM * seconds_per_tick)

// Miner's salve is described as a good painkiller
/datum/reagent/medicine/mine_salve
	pain_modifier = 0.66

// Drugs reduce pain
/datum/reagent/drug/space_drugs
	pain_modifier = 0.8

/datum/reagent/toxin/fentanyl
	pain_modifier = 0.5

//Alcohol reduces pain based on boozepwr
/datum/reagent/consumable/ethanol/New()
	if(boozepwr && isnull(pain_modifier))
		var/new_pain_modifier = 12 / (boozepwr * 0.2)
		if(new_pain_modifier < 1)
			pain_modifier = new_pain_modifier
	return ..()

/datum/reagent/consumable/ethanol/painkiller
	pain_modifier = 0.75

// Abductor chem sets pain mod to 0 so abductors can do their surgeries
/datum/reagent/medicine/cordiolis_hepatico
	pain_modifier = 0

// Healium functions as an anesthetic
/datum/reagent/healium
	pain_modifier = 0.75

/datum/reagent/healium/on_mob_metabolize(mob/living/breather)
	. = ..()
	breather.apply_status_effect(/datum/status_effect/grouped/anesthetic, name)

/datum/reagent/healium/on_mob_end_metabolize(mob/living/breather)
	. = ..()
	breather.remove_status_effect(/datum/status_effect/grouped/anesthetic, name)

// Saline glucose helps shock
/datum/reagent/medicine/salglu_solution/on_mob_life(mob/living/carbon/affected_mob, seconds_per_tick, times_fired)
	. = ..()
	affected_mob.adjust_pain_shock(-0.2 * REM * seconds_per_tick)

/datum/reagent/medicine/salglu_solution/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	ADD_TRAIT(M, TRAIT_ABATES_SHOCK, type)

/datum/reagent/medicine/salglu_solution/on_mob_end_metabolize(mob/living/carbon/M)
	REMOVE_TRAIT(M, TRAIT_ABATES_SHOCK, type)
	return ..()

// Combat stimulants help against pain
/datum/reagent/medicine/stimulants
	pain_modifier = 0.5

/datum/reagent/medicine/changelingadrenaline
	pain_modifier = 0.5

// Diphenhydrame helps against disgust slightly
/datum/reagent/medicine/diphenhydramine/on_mob_life(mob/living/carbon/M, seconds_per_tick, times_fired)
	. = ..()
	M.adjust_disgust(-3 * REM * seconds_per_tick )

/datum/reagent/consumable/laughter/on_mob_metabolize(mob/living/carbon/user)
	pain_modifier = pick(0.8, 1, 1, 1, 1, 1.2)
	return ..()
