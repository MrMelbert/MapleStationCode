/// -- Modified pre-existing or new tech nodes. --
/// Adds illegal tech requirement to phazons.
/datum/techweb_node/phazon
	prereq_ids = list("adv_mecha", "weaponry" , "micro_bluespace", "syndicate_basic")

/// Adds cybernetic cat ears to cybernetic organs.
/datum/techweb_node/cyber_organs
	design_ids = list(
		"cybernetic_ears",
		"cybernetic_eyes_improved",
		"cybernetic_heart_tier2",
		"cybernetic_liver_tier2",
		"cybernetic_lungs_tier2",
		"cybernetic_stomach_tier2",
		"cybernetic_cat_ears",
	)
