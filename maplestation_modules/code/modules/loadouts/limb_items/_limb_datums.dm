/// An assoc list of [limb typepath] to [singleton limb datum]s used in the limb manager
GLOBAL_LIST_INIT(limb_loadout_options, init_loadout_limb_options())

/// Inits the limb manager global list
/proc/init_loadout_limb_options()
	var/list/created = list()
	for(var/datum/limb_option_datum/to_create as anything in typesof(/datum/limb_option_datum))
		var/obj/item/limb_path = initial(to_create.limb_path)
		if(isnull(limb_path))
			continue

		created[limb_path] = new to_create()

	return created

/**
 * Used as holders for paths to be used in the limb editor menu
 *
 * Similar to loadout datums but, for limbs and organs that one can start roundstart with
 *
 * I could've just tied this into loadout datums (they're pretty much the same thing)
 * but I would rather keep the typepaths separate for ease of use
 */
/datum/limb_option_datum
	/// Name shown up in UI
	var/name
	/// Used in UI tooltips
	var/tooltip
	/// The actual item that is created and equipped to the player
	var/obj/item/limb_path
	/// Determines what body zone this is slotted into in the UI
	/// Uses the following limb body zones:
	/// [BODY_ZONE_HEAD], [BODY_ZONE_CHEST], [BODY_ZONE_R_ARM], [BODY_ZONE_L_ARM], [BODY_ZONE_R_LEG], [BODY_ZONE_L_LEG]
	var/ui_zone
	/// Determines what key the path of this is slotted into in the assoc list of preferences
	/// A bodypart might use their body zone while an organ may use their organ slot
	/// This essently determines what other datums this datum is incompatible with
	var/pref_list_slot
	/// Icon used in the UI
	var/ui_icon
	/// Icon state used in the UI
	var/ui_icon_state

/datum/limb_option_datum/New()
	. = ..()
	if(isnull(name))
		name = capitalize(initial(limb_path.name))
	if(isnull(ui_icon))
		ui_icon = initial(limb_path.icon)
	if(isnull(ui_icon_state))
		ui_icon_state = replacetext(initial(limb_path.icon_state), "borg", BODYPART_ID_ROBOTIC)

/*
 * Can this datum be selected by the user?
 *
 * Return TRUE if the user can select this datum
 * Return FALSE if the user cannot select this datum
 */
/datum/limb_option_datum/proc/can_be_selected(datum/preferences/prefs)
	return TRUE

/// Can this datum be applied to the mob?
/datum/limb_option_datum/proc/can_be_applied(mob/living/carbon/human/apply_to)
	return TRUE

/// Applies the datum to the mob.
/datum/limb_option_datum/proc/apply_limb(mob/living/carbon/human/apply_to)
	return

/datum/limb_option_datum/bodypart

/datum/limb_option_datum/bodypart/New()
	. = ..()
	var/obj/item/bodypart/part_path = limb_path
	if(isnull(ui_zone))
		ui_zone = initial(part_path.body_zone)
	if(isnull(pref_list_slot))
		pref_list_slot = initial(part_path.body_zone)

/datum/limb_option_datum/bodypart/apply_limb(mob/living/carbon/human/apply_to)
	var/obj/item/bodypart/new_limb = new limb_path()
	new_limb.change_exempt_flags &= ~BP_BLOCK_CHANGE_SPECIES
	apply_to.del_and_replace_bodypart(new_limb, special = TRUE)

/datum/limb_option_datum/bodypart/proc/digi_prefs_check(datum/preferences/prefs)
	return length(GLOB.species_prototypes[prefs.read_preference(/datum/preference/choiced/species)].digitigrade_legs)

/datum/limb_option_datum/bodypart/proc/digi_mob_check(mob/living/carbon/human/check_mob)
	return length(check_mob.dna?.species?.digitigrade_legs)

/datum/limb_option_datum/organ

/datum/limb_option_datum/organ/New()
	. = ..()
	var/obj/item/organ/organ_path = limb_path
	if(isnull(ui_zone))
		ui_zone = deprecise_zone(initial(organ_path.zone))
	if(isnull(pref_list_slot))
		pref_list_slot = initial(organ_path.slot)

/datum/limb_option_datum/organ/apply_limb(mob/living/carbon/human/apply_to)
	if(istype(apply_to, /mob/living/carbon/human/dummy))
		var/obj/item/organ/organ_path = limb_path
		if(!organ_path::visual)
			return

	var/obj/item/organ/new_organ = new limb_path()
	new_organ.Insert(apply_to, special = TRUE, movement_flags = DELETE_IF_REPLACED)
