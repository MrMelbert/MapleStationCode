/// -- PDA extension and additions. --
/// This proc adds modular PDAs into the PDA painter. Don't forget to update it or else you can't paint added PDAs.
/proc/get_modular_PDA_regions()
	return list(
		/obj/item/modular_computer/tablet/pda/heads/asset_protection = list(REGION_COMMAND),
		/obj/item/modular_computer/tablet/pda/heads/bridge_officer = list(REGION_COMMAND),
		/obj/item/modular_computer/tablet/pda/ordnance = list(REGION_RESEARCH),
		/obj/item/modular_computer/tablet/pda/xenobiologist = list(REGION_RESEARCH),
	)

// Bridge Officer PDA.
/obj/item/modular_computer/tablet/pda/heads/bridge_officer
	name = "bridge officer PDA"
	greyscale_config = /datum/greyscale_config/tablet/head
	greyscale_colors = "#99ccff#000099"
	starting_programs = list(
		// Probably will get involved with cargo a bit
		/datum/computer_file/program/budgetorders,
		// Keep up with the crew employment
		/datum/computer_file/program/crew_manifest,
		// You are the guy who has the records
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/records/security,
		// Summon servents to the bridge
		/datum/computer_file/program/robocontrol,
	)

// Asset Protection PDA.
/obj/item/modular_computer/tablet/pda/heads/asset_protection
	name = "asset protection PDA"
	greyscale_config = /datum/greyscale_config/tablet/head
	greyscale_colors = "#d91a40#3F1514"
	starting_programs = list(
		// Pretty much a seccie
		/datum/computer_file/program/crew_manifest,
		// The other guy who has all the records
		/datum/computer_file/program/records/medical,
		/datum/computer_file/program/records/security,
		// Beepsky control
		/datum/computer_file/program/robocontrol,
		// "OH GOD WE'RE ALL GOING TO DIE"
		/datum/computer_file/program/status,
	)

/// ordnance technician PDA
/obj/item/modular_computer/tablet/pda/ordnance
	name = "ordnance technician PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_two_color
	greyscale_colors = "#e2e2e2#000099#40e0d0#9e00ea"
	starting_programs = list(
		// This is just what scientists have because they're a scientist
		/datum/computer_file/program/atmosscan,
		/datum/computer_file/program/signal_commander,
	)

/// Xenobiologist PDA
/obj/item/modular_computer/tablet/pda/xenobiologist
	name = "xenobiologist PDA"
	greyscale_config = /datum/greyscale_config/tablet/stripe_two_color
	greyscale_colors = "#e2e2e2#000099#6eaec8#9e00ea"
	starting_programs = list(
		// Lesser scientist but at least you can scan stuff
		/datum/computer_file/program/phys_scanner/chemistry,
	)
