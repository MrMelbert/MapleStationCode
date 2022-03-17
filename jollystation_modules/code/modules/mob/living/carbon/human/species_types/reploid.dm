/randomize_human(mob/living/carbon/human/H)
	H.dna.features["reploid_antenna"] = pick(GLOB.reploid_antenna_list)
	. = ..()

/datum/species/reploid
	name = "Reploid"
	id = SPECIES_REPLOID
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,NOTRANSSTING,NO_DNA_COPY,MUTCOLORS,NOBLOOD)
	default_color = "FFFFFF"
	use_skintones = FALSE
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_NODISMEMBER,
		TRAIT_NOLIMBDISABLE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOMETABOLISM,
		TRAIT_TOXIMMUNE,
		TRAIT_RADIMMUNE,
		TRAIT_NOCLONELOSS,
		TRAIT_GENELESS,
	) //definitively not virus-immune, also their components are not space-proof nor heat-proof
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	meat = null
	mutant_bodyparts = list("ears" = "Human", "wings" = "None", "ipc_screen" = "None")
	external_organs = list(/obj/item/organ/external/reploid_antenna = "None")
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	wings_icons = list("Robotic")
	species_language_holder = /datum/language_holder/synthetic
	///Set true by prefs if they have an IPC head. Shows an IPC screen on the mob and gives the mob an action button to change their screen.
	var/ipc_screen = FALSE
	var/datum/action/innate/screen_change/screen
	///Are we currently using IPC limbs? Used for some checks here and in _bodyparts.dm
	var/ipc_limbs = FALSE

/datum/species/reploid/on_species_gain(mob/living/carbon/human/C)
	. = ..()

	if(ipc_limbs)
		use_skintones = FALSE
		var/datum/reploid_limb/limb_type = GLOB.reploid_limbs_ipc_list[value] //Located in jollystation_modules/datums/reploid_limb.dm
		if(limb_type.colorable)
			species_traits |= MUTCOLORS
		else
			species_traits -= MUTCOLORS
		limb_type.apply_limb_id(target_species)

	if(ipc_screen && !screen)
		screen = new(src)
		screen.Grant(C)

/datum/species/reploid/on_species_loss(mob/living/carbon/human/C)
	. = ..()
	if(screen)
		screen.Remove(C)
	..()

///Used for changing the screen of IPCs from a list of all screens
/datum/action/innate/screen_change
	name = "Screen Change"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/screen_change/Activate()
	var/mob/living/carbon/human/user = owner
	var/new_ipc_screen = input(usr, "Choose your character's screen:", "Monitor Display") as null|anything in GLOB.ipc_screen_list
	if(!new_ipc_screen)
		return
	user.dna.species.mutant_bodyparts["ipc_screen"] = new_ipc_screen
	user.update_body()

/obj/item/organ/external/reploid_antenna
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_REPLOID_ANTENNA
	layers = EXTERNAL_ADJACENT
	dna_block = DNA_REPLOID_ANTENNA_BLOCK
	feature_key = "reploid_antenna"
	preference = "reploid_antenna"

/obj/item/organ/external/reploid_antenna/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.head?.flags_inv & HIDEHAIR) || (human.wear_mask?.flags_inv & HIDEHAIR))
		return TRUE
	return FALSE

/obj/item/organ/external/reploid_antenna/get_global_feature_list()
	return GLOB.reploid_antenna_list
