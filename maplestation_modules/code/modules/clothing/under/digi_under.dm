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
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/under/digi_under.dmi'

/obj/item/clothing/under/Initialize(mapload)
	. = ..()
	// Things that don't cover the legs (skirts)
	if(!(body_parts_covered & LEGS))
		should_not_squish = TRUE
		has_digi_support = FALSE

	// Female uniforms (skirts)
	if(fitted == FEMALE_UNIFORM_TOP)
		should_not_squish = TRUE
		has_digi_support = FALSE

/obj/item/clothing/under/toggle_jumpsuit_adjust()
	. = ..()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return
	if(!. && has_digi_support && wearer.is_digitigrade())
		fitted = NO_FEMALE_UNIFORM
	else
		fitted = initial(fitted)
	wearer.update_inv_w_uniform()

/obj/item/clothing/under/swap_digitigrade_dmi(mob/user)
	. = ..()
	if(!.)
		return

	if(user.is_digitigrade())
		fitted = NO_FEMALE_UNIFORM
	else
		fitted = initial(fitted)

// -- Misc. Jumpsuits --
/obj/item/clothing/under/misc
	has_digi_support = TRUE

/obj/item/clothing/under/abductor
	has_digi_support = TRUE

/obj/item/clothing/under/chameleon
	has_digi_support = TRUE

/obj/item/clothing/under/costume/russian_officer
	has_digi_support = TRUE

/obj/item/clothing/under/costume/soviet
	has_digi_support = TRUE

/obj/item/clothing/under/costume/redcoat
	has_digi_support = TRUE

/obj/item/clothing/under/costume/kilt
	has_digi_support = TRUE

/obj/item/clothing/under/costume/pirate
	has_digi_support = TRUE

/obj/item/clothing/under/costume/sailor
	has_digi_support = TRUE

// -- Pants --
/obj/item/clothing/under/pants
	has_digi_support = TRUE

// -- Suits --
/obj/item/clothing/under/suit
	has_digi_support = TRUE

/obj/item/clothing/under/suit/henchmen
	has_digi_support = FALSE

// -- Syndicate --
/obj/item/clothing/under/syndicate
	has_digi_support = TRUE

/obj/item/clothing/under/syndicate/rus_army
	has_digi_support = FALSE
	should_not_squish = TRUE

// -- Colored Jumpsuits --
/obj/item/clothing/under/color
	has_digi_support = TRUE
	digitigrade_greyscale_config_worn = /datum/greyscale_config/jumpsuit_worn_digi

/obj/item/clothing/under/color/jumpskirt
	has_digi_support = FALSE

/obj/item/clothing/under/rank/prisoner
	digitigrade_greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn_digi

/obj/item/clothing/under/color/grey/ancient
	has_digi_support = FALSE

// -- Civilian Jobs --
/obj/item/clothing/under/rank/civilian
	has_digi_support = TRUE

/obj/item/clothing/under/rank/civilian/janitor/maid
	has_digi_support = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/galaxy
	has_digi_support = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/galaxy/red
	has_digi_support = FALSE

/obj/item/clothing/under/rank/civilian/cookjorts
	has_digi_support = FALSE


/obj/item/clothing/under/rank/civilian/clown
	has_digi_support = FALSE

/obj/item/clothing/under/rank/civilian/clown/jester
	has_digi_support = TRUE

/obj/item/clothing/under/rank/civilian/clown/sexy
	has_digi_support = TRUE


// -- Cargo --
/obj/item/clothing/under/rank/cargo
	has_digi_support = TRUE

/obj/item/clothing/under/rank/cargo/tech
	has_digi_support = FALSE

// -- Captain --
/obj/item/clothing/under/rank/captain
	has_digi_support = TRUE

// -- Engineering Jobs --
/obj/item/clothing/under/rank/engineering
	has_digi_support = TRUE

// -- Medical Jobs --
/obj/item/clothing/under/rank/medical
	has_digi_support = TRUE

/obj/item/clothing/under/rank/medical/doctor/nurse
	has_digi_support = FALSE

// -- Science Jobs --
/obj/item/clothing/under/rank/rnd
	has_digi_support = TRUE

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert
	has_digi_support = FALSE

// -- Security / Prisoner Jobs --
/obj/item/clothing/under/rank/security
	has_digi_support = TRUE


/obj/item/clothing/under/rank/security/constable
	has_digi_support = FALSE


/obj/item/clothing/under/rank/security/officer/spacepol
	has_digi_support = TRUE

/obj/item/clothing/under/rank/prisoner
	has_digi_support = TRUE

// -- Extra edits --
/obj/item/clothing/under/rank/centcom/intern
	should_not_squish = TRUE
