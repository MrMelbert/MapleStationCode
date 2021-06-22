// -- Reagents that modify pain. --
/datum/reagent
	/// Modifier applied by this reagent to the mob's pain.
	/// This is both a multiplicative modifier to their overall recieved pain,
	/// and an additive modifier to their per tick pain decay rate.
	var/pain_modifier = -1

/datum/reagent/on_mob_metabolize(mob/living/user)
	. = ..()
	if(pain_modifier >= 0)
		user.pain_controller.set_pain_modifier("[PAIN_MOD_CHEMS]-[name]", pain_modifier)

/datum/reagent/on_mob_end_metabolize(mob/living/user)
	. = ..()
	if(pain_modifier >= 0)
		user.pain_controller.unset_pain_modifier("[PAIN_MOD_CHEMS]-[name]")

/datum/reagent/medicine/epinephrine
	pain_modifier = 0.9

/datum/reagent/medicine/atropine
	pain_modifier = 0.8

/datum/reagent/medicine/morphine
	pain_modifier = 0.5

/datum/reagent/medicine/mine_salve
	pain_modifier = 0.75

/datum/reagent/determination
	pain_modifier = 0.6

/datum/reagent/consumable/ethanol/painkiller
	pain_modifier = 0.75
