/// -- Modified pre-existing or new tech nodes. --
/// Adds illegal tech requirement to phazons.
/datum/techweb_node/phazon
	prereq_id_add = list("syndicate_basic")

/// Adds cybernetic cat ears to cybernetic organs.
/datum/techweb_node/cyber_organs
	id_additions = list(
		"cybernetic_cat_ears",
		)
