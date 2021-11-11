/// -- Modified pre-existing or new tech nodes. --
/// Adds illegal tech requirement to phazons.
/datum/techweb_node/phazon
	prereq_ids = list("adv_mecha", "weaponry" , "micro_bluespace", "syndicate_basic")

/// Adds cybernetic cat ears to cybernetic organs.
/datum/techweb_node/cyber_organs
	module_designs = list(
		"cybernetic_cat_ears",
		)
