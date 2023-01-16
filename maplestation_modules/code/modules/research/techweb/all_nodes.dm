/// -- Modified pre-existing or new tech nodes. --
/// Adds illegal tech requirement to phazons.
/datum/techweb_node/phazon
	prereq_id_add = list(
		"syndicate_basic",
	)

/// Adds cybernetic cat ears to cybernetic organs.
/datum/techweb_node/cyber_organs
	id_additions = list(
		"cybernetic_cat_ears",
	)

/datum/techweb_node/base
	id_additions = list(
		"fax_machine",
	)

/datum/techweb_node/exp_surgery
	id_additions = list(
		"surgery_neuter_ling",
	)

///Overrides the solaris laser tech to add in the PPC with a new name and description to accomodate the new weapon
/datum/techweb_node/mech_laser_heavy
	display_name = "Exosuit Weapons (Heavy Energy Weapons)"
	description = "Advanced pieces of mech weaponry"
	id_additions = list(
		"mech_ppc",
	)
