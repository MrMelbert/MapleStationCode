// Prosthetic
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

// Cyber
/datum/limb_option_datum/bodypart/cybernetic_chest
	name = "Cybernetic Chest"
	tooltip = "Unique to Androids and Synthetics."
	limb_path = /obj/item/bodypart/chest/robot

/datum/limb_option_datum/bodypart/cybernetic_chest/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/android)

/datum/limb_option_datum/bodypart/cybernetic_chest/can_be_applied(mob/living/carbon/human/apply_to)
	return is_species(apply_to, /datum/species/android)

/datum/limb_option_datum/bodypart/cybernetic_head
	name = "Cybernetic Head"
	tooltip = "Unique to Androids and Synthetics."
	limb_path = /obj/item/bodypart/head/robot

/datum/limb_option_datum/bodypart/cybernetic_head/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/android)

/datum/limb_option_datum/bodypart/cybernetic_head/can_be_applied(mob/living/carbon/human/apply_to)
	return is_species(apply_to, /datum/species/android)

/datum/limb_option_datum/bodypart/cybernetic_r_leg
	name = "Cybernetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot

/datum/limb_option_datum/bodypart/cybernetic_l_leg
	name = "Cybernetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot

/datum/limb_option_datum/bodypart/cybernetic_r_arm
	name = "Cybernetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot

/datum/limb_option_datum/bodypart/cybernetic_l_arm
	name = "Cybernetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot

// Removes the corresponding limb instead of replacing whatever's there
/datum/limb_option_datum/bodypart/amputated
	ui_icon = 'icons/mob/landmarks.dmi'
	ui_icon_state = "x"

/datum/limb_option_datum/bodypart/amputated/apply_limb(mob/living/carbon/human/apply_to)
	var/obj/item/bodypart/corresponding_limb = limb_path
	var/obj/item/bodypart/removing = apply_to.get_bodypart(corresponding_limb::body_zone)
	if(isnull(removing))
		return

	removing.drop_limb(special = TRUE, dismembered = FALSE)
	qdel(removing)

/datum/limb_option_datum/bodypart/amputated/right_arm
	name = "Amputated Right Arm"
	limb_path = /obj/item/bodypart/arm/right // placeholder

/datum/limb_option_datum/bodypart/amputated/left_arm
	name = "Amputated Left Arm"
	limb_path = /obj/item/bodypart/arm/left // placeholder

/datum/limb_option_datum/bodypart/amputated/right_leg
	name = "Amputated Right Leg"
	limb_path = /obj/item/bodypart/leg/right // placeholder

/datum/limb_option_datum/bodypart/amputated/left_leg
	name = "Amputated Left Leg"
	limb_path = /obj/item/bodypart/leg/left // placeholder
