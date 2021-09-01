// -- Rebalancing of other ling actions --

// Buffs adrenal sacs so they work like old adrenals. Increased chemical cost to compensate.
/datum/action/changeling/adrenaline
	desc = "We evolve additional sacs of adrenaline throughout our body. Costs 40 chemicals."
	chemical_cost = 40

/// MELBERT TODO; this doesn't get up instantly cause stamcrit?
/datum/action/changeling/adrenaline/sting_action(mob/living/user)
	user.adjustStaminaLoss(-75)
	user.set_resting(FALSE, instant = TRUE)
	user.SetStun(0)
	user.SetImmobilized(0)
	user.SetParalyzed(0)
	user.SetKnockdown(0)
	. = ..()

// Disables spread infestation.
/datum/action/changeling/spiders
	dna_cost = -1

// Disables transform sting.
/datum/action/changeling/sting/transformation
	dna_cost = -1
