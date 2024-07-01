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
		"fax_machine_deluxe",
	)

/datum/techweb_node/mod_advanced
	id_additions = list(
		"mod_helmet_desync",
	)

/datum/techweb_node/biotech
	id_additions = list(
		"scanning_pad",
		"triage_zone_projector",
		"vitals_monitor",
	)

/datum/techweb_node/adv_biotech
	id_additions = list(
		"auto_cpr_device",
		"vitals_monitor_advanced",
	)

/datum/techweb_node/cryotech
	id_additions = list(
		"stasis_bodybag",
	)

/datum/techweb_node/exp_surgery
	id_additions = list(
		"surgery_neuter_ling",
	)

/datum/techweb_node/mech_laser
	display_name = "Exosuit Weapons (Light Energy Weapons)"
	description = "Mech weapons that use small amounts of energy to do large amounts of damage."
	id_additions = list(
		"mech_pulsedlaser",
	)

/// Overrides the heavy laser tech to add in the PPC and ERLL with a new name and description to accomodate the new weapons
/datum/techweb_node/mech_laser_heavy
	display_name = "Exosuit Weapons (Heavy Energy Weapons)"
	description = "Advanced mech energy weapons, in case regular lasers just weren't enough."
	id_additions = list(
		"mech_ppc",
		"mech_erlargelaser",
	)

/// Overrides the Ultra AC/2 tech to contain all of the autocannons
/datum/techweb_node/mech_lmg
	display_name = "Exosuit Weapons (Autocannons)"
	description = "All sorts of autocannons, straight from Discount Dan!"
	id_additions = list(
		"mech_ac5",
		"mech_ac10",
		"mech_ac20",
		"mech_ac5_ammo",
		"mech_ac10_ammo",
		"mech_ac20_ammo",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 5000)

/datum/techweb_node/mech_gauss
	id = "mech_gauss"
	display_name = "Exosuit Weapon (Gauss Rifle)"
	description = "These weren't actually designed by us and instead stolen from mercenary companies. They're going to be very angry if they notice, buyer beware."
	prereq_ids = list("adv_mecha")
	design_ids = list(
		"mech_gauss",
		"mech_gauss_ammo",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = 2500)
