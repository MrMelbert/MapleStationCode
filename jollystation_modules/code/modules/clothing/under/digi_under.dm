
/// -- The big file that makes digitigrate pants work. --
/obj/item/clothing
	/// Whether we use the modular clothing dmi instead of the normal one.
	var/use_modular_dmi = FALSE
	/// Var to not squish digi legs on certain clothes.
	var/should_not_squish = FALSE
	/// Alt icon file to swap to
	var/alt_icon = 'jollystation_modules/icons/mob/clothing/under/digi_under.dmi'
	/// Alt greyscale config to swap to
	var/alt_greyscale_config_worn = null

/obj/item/clothing/Initialize()
	. = ..()
	if(use_modular_dmi)
		should_not_squish = TRUE

/obj/item/clothing/under/equipped(mob/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	swap_to_modular_dmi(user, slot)
	. = ..()

/obj/item/clothing/under/toggle_jumpsuit_adjust()
	. = ..()
	var/mob/living/carbon/human/wearer = loc
	if(!istype(wearer))
		return
	if(!. && use_modular_dmi && wearer.is_digitigrade())
		fitted = NO_FEMALE_UNIFORM
	else
		fitted = initial(fitted)
	wearer.update_inv_w_uniform()

/*
 * Swap our clothing item to an alternate dmi if applicable.
 *
 * user - the mob who has equipped the clothing
 * slot - the slot equipped to
 */
/obj/item/clothing/proc/swap_to_modular_dmi(mob/user, slot)
	return FALSE

/obj/item/clothing/under/swap_to_modular_dmi(mob/user, slot)
	. = ..()
	if(!user)
		return

	if(use_modular_dmi && user.is_digitigrade())
		fitted = NO_FEMALE_UNIFORM
		if(alt_greyscale_config_worn)
			greyscale_config_worn = alt_greyscale_config_worn
		else if(!greyscale_config)
			worn_icon = alt_icon
		else
			stack_trace("Greyscaled under item [src] did not have an alt_greyscale_config_worn set correctly!")
	else
		fitted = initial(fitted)
		if(alt_greyscale_config_worn)
			greyscale_config_worn = initial(greyscale_config_worn)
		else if(!greyscale_config)
			worn_icon = initial(worn_icon)

	update_greyscale()
	user.update_inv_w_uniform()
	return TRUE

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
//   - Toxicologist
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

// -- Misc. Jumpsuits --
/obj/item/clothing/under/misc
	use_modular_dmi = TRUE

/obj/item/clothing/under/abductor
	use_modular_dmi = TRUE

/obj/item/clothing/under/chameleon
	use_modular_dmi = TRUE

/obj/item/clothing/under/costume/russian_officer
	use_modular_dmi = TRUE

/obj/item/clothing/under/costume/soviet
	use_modular_dmi = TRUE

/obj/item/clothing/under/costume/redcoat
	use_modular_dmi = TRUE

/obj/item/clothing/under/costume/kilt
	use_modular_dmi = TRUE

/obj/item/clothing/under/costume/pirate
	use_modular_dmi = TRUE

/obj/item/clothing/under/costume/sailor
	use_modular_dmi = TRUE

// -- Pants --
/obj/item/clothing/under/pants
	use_modular_dmi = TRUE

// -- Suits --
/obj/item/clothing/under/suit
	use_modular_dmi = TRUE

/obj/item/clothing/under/suit/white/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/suit/black/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/suit/black_really/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/suit/teal/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/suit/henchmen
	use_modular_dmi = FALSE

// -- Syndicate --
/obj/item/clothing/under/syndicate
	use_modular_dmi = TRUE

/obj/item/clothing/under/syndicate/skirt
	use_modular_dmi = FALSE
	should_not_squish = TRUE

/obj/item/clothing/under/syndicate/tacticool/skirt
	use_modular_dmi = FALSE
	should_not_squish = TRUE

/obj/item/clothing/under/syndicate/rus_army
	use_modular_dmi = FALSE
	should_not_squish = TRUE

// -- Colored Jumpsuits --
/obj/item/clothing/under/color
	use_modular_dmi = TRUE
	alt_greyscale_config_worn = /datum/greyscale_config/jumpsuit_worn_digi

/obj/item/clothing/under/color/jumpskirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/prisoner
	alt_greyscale_config_worn = /datum/greyscale_config/jumpsuit_prison_worn_digi

/obj/item/clothing/under/color/grey/ancient
	use_modular_dmi = FALSE

// -- Civilian Jobs --
/obj/item/clothing/under/rank/civilian
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/civilian/bartender/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/chaplain/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/chef/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/head_of_personnel/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/head_of_personnel/suit/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/hydroponics/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/janitor/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/janitor/maid
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/black/skirt
	use_modular_dmi = FALSE
	should_not_squish = TRUE

/obj/item/clothing/under/rank/civilian/lawyer/female/skirt
	use_modular_dmi = FALSE
	should_not_squish = TRUE

/obj/item/clothing/under/rank/civilian/lawyer/red/skirt
	use_modular_dmi = FALSE
	should_not_squish = TRUE

/obj/item/clothing/under/rank/civilian/lawyer/blue/skirt
	use_modular_dmi = FALSE
	should_not_squish = TRUE

/obj/item/clothing/under/rank/civilian/lawyer/bluesuit/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/purpsuit/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/galaxy
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/lawyer/galaxy/red
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/cookjorts
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/mime/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/clown
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/civilian/clown/jester
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/civilian/clown/sexy
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/civilian/curator/skirt
	use_modular_dmi = FALSE

// -- Cargo --
/obj/item/clothing/under/rank/cargo
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/cargo/qm/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/cargo/tech
	use_modular_dmi = FALSE

// -- Captain --
/obj/item/clothing/under/rank/captain
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/captain/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/captain/suit/skirt
	use_modular_dmi = FALSE

// -- Engineering Jobs --
/obj/item/clothing/under/rank/engineering
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/engineering/chief_engineer/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/engineering/atmospheric_technician/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/engineering/engineer/skirt
	use_modular_dmi = FALSE

// -- Medical Jobs --
/obj/item/clothing/under/rank/medical
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/medical/chief_medical_officer/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/medical/virologist/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/medical/doctor/nurse
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/medical/doctor/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/medical/chemist/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/medical/paramedic/skirt
	use_modular_dmi = FALSE

// -- Science Jobs --
/obj/item/clothing/under/rank/rnd
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/rnd/research_director/doctor_hilbert
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/research_director/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/research_director/alt/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/research_director/turtleneck/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/scientist/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/roboticist/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/geneticist/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/toxicologist/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/rnd/xenobiologist/skirt
	use_modular_dmi = FALSE


// -- Security / Prisoner Jobs --
/obj/item/clothing/under/rank/security
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/security/officer/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/constable
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/warden/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/detective/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/detective/grey/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/head_of_security/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/head_of_security/alt/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/bridge_officer/black/skirt
	use_modular_dmi = FALSE

/obj/item/clothing/under/rank/security/officer/spacepol
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/prisoner
	use_modular_dmi = TRUE

/obj/item/clothing/under/rank/prisoner/skirt
	use_modular_dmi = FALSE

// -- Extra edits --
/obj/item/clothing/under/rank/centcom/intern
	should_not_squish = TRUE

/obj/item/clothing/suit/armor/hos/trenchcoat
	should_not_squish = TRUE

/obj/item/clothing/suit/det_suit
	should_not_squish = TRUE

/obj/item/clothing/suit/hooded/cultrobes/void
	should_not_squish = TRUE

/obj/item/clothing/suit/hooded/explorer
	should_not_squish = TRUE
