/datum/limb_option_datum/organ/cyber

/datum/limb_option_datum/organ/cyber/can_be_selected(datum/preferences/prefs)
	return !ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/prefs_android)

/datum/limb_option_datum/organ/cyber/can_be_applied(mob/living/carbon/human/apply_to)
	return !is_species(apply_to, /datum/species/prefs_android)

/datum/limb_option_datum/organ/cyber/heart
	name = "Cybernetic Heart"
	tooltip = "Cannot be selected by Androids or Synthetics."
	limb_path = /obj/item/organ/heart/cybernetic

/datum/limb_option_datum/organ/cyber/liver
	name = "Cybernetic Liver"
	limb_path = /obj/item/organ/liver/cybernetic

/datum/limb_option_datum/organ/cyber/lungs
	name = "Cybernetic Lungs"
	limb_path = /obj/item/organ/lungs/cybernetic

/datum/limb_option_datum/organ/cyber/stomach
	name = "Cybernetic Stomach"
	limb_path = /obj/item/organ/stomach/cybernetic

/datum/limb_option_datum/organ/cyber/eyes
	name = "Cybernetic Eyes"
	limb_path = /obj/item/organ/eyes/robotic/basic

/datum/limb_option_datum/organ/cyber/ears
	name = "Cybernetic Ears"
	limb_path = /obj/item/organ/ears/cybernetic

/datum/limb_option_datum/organ/cyber/ears/cat
	name = "Cybernetic Cat Ears"
	limb_path = /obj/item/organ/ears/cat/cybernetic

/datum/limb_option_datum/organ/cyber/robotongue
	name = "Voicebox"
	tooltip = "Replaces the tongue. Makes you sound like a robot. Cannot be selected by Androids or Synthetics."
	limb_path = /obj/item/organ/tongue/robot

/datum/limb_option_datum/organ/lighter_implant
	name = "Lighter Implant"
	tooltip = "A lighter implanted into the tip of your finger. Light it with a snap... like a badass."
	limb_path = /obj/item/organ/cyberimp/arm/lighter
	ui_zone = BODY_ZONE_R_ARM
	pref_list_slot = ORGAN_SLOT_RIGHT_ARM_AUG

/datum/limb_option_datum/organ/lighter_implant/left
	limb_path = /obj/item/organ/cyberimp/arm/lighter/left
	ui_zone = BODY_ZONE_L_ARM
	pref_list_slot = ORGAN_SLOT_LEFT_ARM_AUG
	// Yeah you can have one in both arms if you want, don't really care
