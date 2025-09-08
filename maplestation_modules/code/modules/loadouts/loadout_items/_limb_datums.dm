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
	apply_to.del_and_replace_bodypart(new limb_path(), special = TRUE)

/datum/limb_option_datum/bodypart/prosthetic_r_leg
	name = "Prosthetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/surplus

/datum/limb_option_datum/bodypart/prosthetic_l_leg
	name = "Prosthetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/surplus

/datum/limb_option_datum/bodypart/prosthetic_r_arm
	name = "Prosthetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/surplus

/datum/limb_option_datum/bodypart/prosthetic_l_arm
	name = "Prosthetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/surplus

/datum/limb_option_datum/bodypart/cybernetic_r_leg
	name = "Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot

/datum/limb_option_datum/bodypart/cybernetic_r_leg/engineer
	name = "Nanotrasen Engineering Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_r_leg/security
	name = "Nanotrasen Security Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/security

/datum/limb_option_datum/bodypart/cybernetic_r_leg/mining
	name = "Nanotrasen Mining Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_r_leg/bishop
	name = "Bishop Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_r_leg/bishop/mk2
	name = "Bishop MK2 Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_r_leg/hephaestus
	name = "Hephaestus Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_r_leg/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_r_leg/mariinsky
	name = "Mariinsky Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_r_leg/mcg
	name = "MCG Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_r_leg/sgm
	name = "SGM Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_r_leg/wtm
	name = "WTM Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_r_leg/xmg
	name = "XMG Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhenkov
	name = "Zhenkov Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_r_leg/zhp
	name = "ZHP Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_r_leg/monokai
	name = "Monokai Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/monokai

/datum/limb_option_datum/bodypart/cybernetic_l_leg
	name = "Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot

/datum/limb_option_datum/bodypart/cybernetic_l_leg/engineer
	name = "Nanotrasen Engineering Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_l_leg/security
	name = "Nanotrasen Security Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/security

/datum/limb_option_datum/bodypart/cybernetic_l_leg/mining
	name = "Nanotrasen Mining Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_l_leg/bishop
	name = "Bishop Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_l_leg/bishop/mk2
	name = "Bishop MK2 Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_l_leg/hephaestus
	name = "Hephaestus Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_l_leg/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_l_leg/mariinsky
	name = "Mariinsky Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_l_leg/mcg
	name = "MCG Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_l_leg/sgm
	name = "SGM Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_l_leg/wtm
	name = "WTM Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_l_leg/xmg
	name = "XMG Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhenkov
	name = "Zhenkov Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_l_leg/zhp
	name = "ZHP Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_l_leg/monokai
	name = "Monokai Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/monokai

/datum/limb_option_datum/bodypart/cybernetic_r_arm
	name = "Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot

/datum/limb_option_datum/bodypart/cybernetic_r_arm/engineer
	name = "Nanotrasen Engineering Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_r_arm/security
	name = "Nanotrasen Security Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/security

/datum/limb_option_datum/bodypart/cybernetic_r_arm/mining
	name = "Nanotrasen Mining Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_r_arm/bishop
	name = "Bishop Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_r_arm/bishop/mk2
	name = "Bishop MK2 Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_r_arm/hephaestus
	name = "Hephaestus Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_r_arm/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_r_arm/mariinsky
	name = "Mariinsky Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_r_arm/mcg
	name = "MCG Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_r_arm/sgm
	name = "SGM Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_r_arm/wtm
	name = "WTM Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_r_arm/xmg
	name = "XMG Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_r_arm/zhenkov
	name = "Zhenkov Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_r_arm/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_r_arm/zhp
	name = "ZHP Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_r_arm/monokai
	name = "Monokai Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/monokai

/datum/limb_option_datum/bodypart/cybernetic_l_arm
	name = "Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot

/datum/limb_option_datum/bodypart/cybernetic_l_arm/engineer
	name = "Nanotrasen Engineering Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_l_arm/security
	name = "Nanotrasen Security Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/security

/datum/limb_option_datum/bodypart/cybernetic_l_arm/mining
	name = "Nanotrasen Mining Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_l_arm/bishop
	name = "Bishop Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_l_arm/bishop/mk2
	name = "Bishop MK2 Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_l_arm/hephaestus
	name = "Hephaestus Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_l_arm/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_l_arm/mariinsky
	name = "Mariinsky Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_l_arm/mcg
	name = "MCG Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_l_arm/sgm
	name = "SGM Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_l_arm/wtm
	name = "WTM Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_l_arm/xmg
	name = "XMG Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_l_arm/zhenkov
	name = "Zhenkov Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_l_arm/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_l_arm/zhp
	name = "ZHP Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_l_arm/monokai
	name = "Monokai Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/monokai

/datum/limb_option_datum/bodypart/cybernetic_head
	name = "Cybernetic Head"
	tooltip = "Unique to Synthetics."
	limb_path = /obj/item/bodypart/head/robot

/datum/limb_option_datum/bodypart/cybernetic_head/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/synth)

/datum/limb_option_datum/bodypart/cybernetic_head/can_be_applied(mob/living/carbon/human/apply_to)
	return is_species(apply_to, /datum/species/synth)

/datum/limb_option_datum/bodypart/cybernetic_head/engineer
	name = "Nanotrasen Engineering Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_head/security
	name = "Nanotrasen Security Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/security

/datum/limb_option_datum/bodypart/cybernetic_head/mining
	name = "Nanotrasen Mining Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_head/bishop
	name = "Bishop Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_head/bishop/mk2
	name = "Bishop MK2 Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_head/hephaestus
	name = "Hephaestus Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_head/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_head/mariinsky
	name = "Mariinsky Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_head/mcg
	name = "MCG Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_head/sgm
	name = "SGM Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_head/wtm
	name = "WTM Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_head/xmg
	name = "XMG Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_head/zhenkov
	name = "Zhenkov Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_head/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_head/zhp
	name = "ZHP Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/zhp

/datum/limb_option_datum/bodypart/cybernetic_chest
	name = "Cybernetic Chest"
	tooltip = "Unique to Synthetics."
	limb_path = /obj/item/bodypart/chest/robot

/datum/limb_option_datum/bodypart/cybernetic_chest/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/synth)

/datum/limb_option_datum/bodypart/cybernetic_chest/can_be_applied(mob/living/carbon/human/apply_to)
	return is_species(apply_to, /datum/species/synth)

/datum/limb_option_datum/bodypart/cybernetic_chest/engineer
	name = "Nanotrasen Engineering Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/engineer

/datum/limb_option_datum/bodypart/cybernetic_chest/security
	name = "Nanotrasen Security Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/security

/datum/limb_option_datum/bodypart/cybernetic_chest/mining
	name = "Nanotrasen Mining Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/mining

/datum/limb_option_datum/bodypart/cybernetic_chest/bishop
	name = "Bishop Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/bishop

/datum/limb_option_datum/bodypart/cybernetic_chest/bishop/mk2
	name = "Bishop MK2 Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/bishop/mk2

/datum/limb_option_datum/bodypart/cybernetic_chest/hephaestus
	name = "Hephaestus Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/hephaestus

/datum/limb_option_datum/bodypart/cybernetic_chest/hephaestus/mk2
	name = "Hephaestus MK2 Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/hephaestus/mk2

/datum/limb_option_datum/bodypart/cybernetic_chest/mariinsky
	name = "Mariinsky Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/mariinsky

/datum/limb_option_datum/bodypart/cybernetic_chest/mcg
	name = "MCG Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/mcg

/datum/limb_option_datum/bodypart/cybernetic_chest/sgm
	name = "SGM Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/sgm

/datum/limb_option_datum/bodypart/cybernetic_chest/wtm
	name = "WTM Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/wtm

/datum/limb_option_datum/bodypart/cybernetic_chest/xmg
	name = "XMG Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/xmg

/datum/limb_option_datum/bodypart/cybernetic_chest/zhenkov
	name = "Zhenkov Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/zhenkov

/datum/limb_option_datum/bodypart/cybernetic_chest/zhenkov/dark
	name = "Zhenkov (Dark) Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/zhenkov/dark

/datum/limb_option_datum/bodypart/cybernetic_chest/zhp
	name = "ZHP Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/zhp

/datum/limb_option_datum/organ

/datum/limb_option_datum/organ/New()
	. = ..()
	var/obj/item/organ/organ_path = limb_path
	if(isnull(ui_zone))
		ui_zone = deprecise_zone(initial(organ_path.zone))
	if(isnull(pref_list_slot))
		pref_list_slot = initial(organ_path.slot)

/datum/limb_option_datum/organ/apply_limb(mob/living/carbon/human/apply_to)
	if(istype(apply_to, /mob/living/carbon/human/dummy)) // thog don't caare
		return

	var/obj/item/organ/internal/new_organ = new limb_path()
	new_organ.Insert(apply_to, special = TRUE, movement_flags = DELETE_IF_REPLACED)

/datum/limb_option_datum/organ/cyberheart
	name = "Cybernetic Heart"
	limb_path = /obj/item/organ/internal/heart/cybernetic

/datum/limb_option_datum/organ/cyberliver
	name = "Cybernetic Liver"
	limb_path = /obj/item/organ/internal/liver/cybernetic

/datum/limb_option_datum/organ/cyberlungs
	name = "Cybernetic Lungs"
	limb_path = /obj/item/organ/internal/lungs/cybernetic

/datum/limb_option_datum/organ/cyberstomach
	name = "Cybernetic Stomach"
	limb_path = /obj/item/organ/internal/stomach/cybernetic

/datum/limb_option_datum/organ/cybereyes
	name = "Cybernetic Eyes"
	limb_path = /obj/item/organ/internal/eyes/robotic/basic

/datum/limb_option_datum/organ/cyberears
	name = "Cybernetic Ears"
	limb_path = /obj/item/organ/internal/ears/cybernetic

/datum/limb_option_datum/organ/cyberears/cat
	name = "Cybernetic Cat Ears"
	limb_path = /obj/item/organ/internal/ears/cat/cybernetic

/datum/limb_option_datum/organ/robotongue
	name = "Voicebox"
	tooltip = "A voice synthesizer that replaces the tongue. Makes you sound like a robot."
	limb_path = /obj/item/organ/internal/tongue/robot

/datum/limb_option_datum/organ/lighter_implant
	name = "Lighter Implant"
	tooltip = "A lighter implanted into the tip of your finger. Light it with a snap... like a badass."
	limb_path = /obj/item/organ/internal/cyberimp/arm/lighter
	ui_zone = BODY_ZONE_R_ARM
	pref_list_slot = ORGAN_SLOT_RIGHT_ARM_AUG

/datum/limb_option_datum/organ/lighter_implant/left
	limb_path = /obj/item/organ/internal/cyberimp/arm/lighter/left
	ui_zone = BODY_ZONE_L_ARM
	pref_list_slot = ORGAN_SLOT_LEFT_ARM_AUG
	// Yeah you can have one in both arms if you want, don't really care
