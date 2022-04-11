/// -- PDA extension and additions. --
/// This proc adds modular PDAs into the PDA painter. Don't forget to update it or else you can't paint added PDAs.
/proc/get_modular_PDA_regions()
	return list(
		/obj/item/pda/heads/asset_protection = list(REGION_COMMAND),
		/obj/item/pda/heads/bridge_officer = list(REGION_COMMAND),
		/obj/item/pda/science/toxocologist = list(REGION_RESEARCH),
		/obj/item/pda/science/xenobiologist = list(REGION_RESEARCH),)

// Bridge Officer PDA.
/obj/item/pda/heads/bridge_officer
	name = "bridge officer PDA"
	default_cartridge = /obj/item/cartridge/hop
	greyscale_config = /datum/greyscale_config/pda/head
	greyscale_colors = "#99ccff#000099"

// Asset Protection PDA.
/obj/item/pda/heads/asset_protection
	name = "asset protection PDA"
	default_cartridge = /obj/item/cartridge/hos
	greyscale_config = /datum/greyscale_config/pda/head
	greyscale_colors = "#d91a40#3F1514"

/// QM PDA, with head of staff stripe.
/obj/item/pda/quartermaster
	greyscale_config = /datum/greyscale_config/pda/stripe_thick/head
	greyscale_colors = "#e39751#a92323#a23e3e"

/// Scientist PDA, tone reset
/obj/item/pda/science
	ttone = "beep"

/// ordnance technician PDA
/obj/item/pda/science/toxocologist
	name = "ordnance technician PDA"
	greyscale_config = /datum/greyscale_config/pda/stripe_two_color
	greyscale_colors = "#e2e2e2#000099#40e0d0#9e00ea"
	ttone = "boom"

/// Xenobiologist PDA
/obj/item/pda/science/xenobiologist
	name = "xenobiologist PDA"
	greyscale_config = /datum/greyscale_config/pda/stripe_two_color
	greyscale_colors = "#e2e2e2#000099#6eaec8#9e00ea"
	ttone = "glomp"
