/// -- The big file that makes digitigrate pants work. --
// Some digitigrade pants sprites ported from skyrat-tg / citadel.

// Included:
// - Misc. Jumpsuits
// - All Pants
// - All Suits
// - Syndicate Turtlenecks
// - Basic Colored Jumpsuits
// - Civilian
//   - Bartender (And Alt suits)
//   - Botanist (And Durathread)
//   - Chaplain
//   - Curator (Treature Hunter)
//   - Chef
//   - Head of Personnel
//   - Janitor
//   - Lawyer (And Alt Suits)
//   - Mime (And Sexy Outfit)
//   - Clown (Only Jester and Sexyclown)
// - Cargo
//   - Quartermaster
//   - Miner (Explorer and Old Miner)
// - Captain
// - Engineering
//   - Station Engineer (Normal and Hazard)
//   - Atmospheric Technician
//   - Chief Engineer
// - Medical
//   - Medical Doctor (And Scrubs)
//   - Paramedic
//   - Virologist
//   - Chemist
//   - Chief Medical Officer (and Turtleneck)
// - Science
//   - Scientist
//   - Xenobiologist
//   - Ordnance Tech
//   - Roboticist
//   - Geneticist
//   - Research Director (Turtleneck, Vest, and Suit)
// - Security
//   - Detective (Tan and Grey)
//   - Security Officer (Formal, Tan/Blue, and Alt outfits)
//   - Warden (Formal and Tan/Blue)
//   - Head of Security (Turtleneck, Tan/Blue, Parade, and Alt)
//   - Prisoner

// Not Included, but in the DMI:
// - Some Costumes (costume.dm)
// - Centcom Outfits (centcom.dm)
// - Plasmaman Outfit
// - Trek Outfits (trek.dm)
// - Shorts (shorts.dm)
// - Normal Clown Outfit

// Included, but needs edits:
// - Amish Suit
// - Tuxedo
// - Beige Suit

/obj/item/clothing/under
	digitigrade_file = DIGITIGRADE_UNIFORM_FILE

/obj/item/clothing/under/abductor
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/chameleon
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/russian_officer
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/soviet
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/redcoat
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/kilt
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/pirate
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/costume/sailor
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// -- Pants --
/obj/item/clothing/under/pants
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// -- Suits --
/obj/item/clothing/under/suit
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/suit/henchmen
	supports_variations_flags = CLOTHING_NO_VARIATION

// -- Syndicate --
/obj/item/clothing/under/syndicate
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/syndicate/rus_army
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

// -- Colored Jumpsuits --
/obj/item/clothing/under/color
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
	digitigrade_greyscale_config_worn = /datum/greyscale_config/jumpsuit_worn_digi

/obj/item/clothing/under/color/jumpskirt
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/prisoner
	digitigrade_greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn_digi

/obj/item/clothing/under/color/grey/ancient
	supports_variations_flags = CLOTHING_NO_VARIATION

// -- Civilian Jobs --
/obj/item/clothing/under/rank/civilian
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/civilian/janitor/maid
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/under/rank/civilian/lawyer/galaxy
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/under/rank/civilian/lawyer/galaxy/red
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/under/rank/civilian/cookjorts
	supports_variations_flags = CLOTHING_NO_VARIATION


/obj/item/clothing/under/rank/civilian/clown
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/under/rank/civilian/clown/jester
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/civilian/clown/sexy
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// -- Cargo --
/obj/item/clothing/under/rank/cargo
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/cargo/tech
	// actually has its own already

// -- Captain --
/obj/item/clothing/under/rank/captain
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// -- Engineering Jobs --
/obj/item/clothing/under/rank/engineering
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// -- Medical Jobs --
/obj/item/clothing/under/rank/medical
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/medical/doctor/nurse
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

// -- Science Jobs --
/obj/item/clothing/under/rank/rnd
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert
	supports_variations_flags = CLOTHING_NO_VARIATION

// -- Security / Prisoner Jobs --
/obj/item/clothing/under/rank/security
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/security/constable
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/under/rank/security/officer/spacepol
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

/obj/item/clothing/under/rank/prisoner
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION

// -- Extra edits --
/obj/item/clothing/under/rank/centcom/intern
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
