/// -- Modified pre-existing or new tech nodes. --
/// Adds illegal tech requirement to phazons.
/datum/techweb_node/mech_infiltrator
	prereq_id_add = list(
		TECHWEB_NODE_SYNDICATE_BASIC,
	)

/// Adds cybernetic cat ears to cybernetic organs.
/datum/techweb_node/cyber/cyber_organs
	id_additions = list(
		"cybernetic_cat_ears",
	)

/datum/techweb_node/office_equip
	id_additions = list(
		"ashtray",
		"fax_machine_deluxe",
	)

/datum/techweb_node/bio_scan
	id_additions = list(
		"scanning_pad",
		"triage_zone_projector",
		"vitals_monitor",
	)

/datum/techweb_node/medbay_equip_adv
	id_additions = list(
		"auto_cpr_device",
		"vitals_monitor_advanced",
	)

/datum/techweb_node/cryostasis
	id_additions = list(
		"stasis_bodybag",
	)

/datum/techweb_node/surgery_exp
	id_additions = list(
		"surgery_neuter_ling",
	)

/datum/techweb_node/mech_energy_guns
	display_name = "Light Mech Energy Weapons"
	description = "Scaled-up versions of energy weapons optimized for mech deployment."
	id_additions = list(
		"mech_pulsedlaser",
	)
	id_removals = list(
		"mech_laser_heavy",
	)

/// Splits energy guns into light and heavy, since it seems a bit unwieldy as is
/datum/techweb_node/mech_energy_guns_heavy
	id = "mech_energy_guns_heavy"
	display_name = "Heavy Mech Energy Weapons"
	description = "Energy weapons scaled-up even further, in case regular lasers just weren't enough."
	prereq_ids = list(TECHWEB_NODE_MECH_ENERGY_GUNS)
	design_ids = list(
		"mech_laser_heavy",
		"mech_ppc",
		"mech_erlargelaser",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)

/datum/techweb_node/mech_firearms
	id_additions = list(
		"mech_ac5",
		"mech_ac10",
		"mech_ac20",
		"mech_ac5_ammo",
		"mech_ac10_ammo",
		"mech_ac20_ammo",
	)

/datum/techweb_node/mech_gauss
	id = "mech_gauss"
	display_name = "Gauss Mech Weapons"
	description = "These weren't actually designed by us and instead stolen from mercenary companies. They're going to be very angry if they notice, buyer beware."
	prereq_ids = list(TECHWEB_NODE_MECH_ENERGY_GUNS)
	design_ids = list(
		"mech_gauss",
		"mech_gauss_ammo",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_5_POINTS)

/datum/techweb_node/circuit_shells
	id_additions = list(
		"headset_shell",
	)

/datum/techweb_node/hud
	id_additions = list(
		"antiblindnessvisor",
	)
