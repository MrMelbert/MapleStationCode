
/datum/limb_option_datum/bodypart/lizardlike_android
	tooltip = "Unique to Lizardlike Androids."

/datum/limb_option_datum/bodypart/lizardlike_android/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/android) \
		&& prefs.read_preference(/datum/preference/choiced/android_species) == SPECIES_LIZARD

/datum/limb_option_datum/bodypart/lizardlike_android/can_be_applied(mob/living/carbon/human/apply_to)
	return istype(apply_to.dna?.species, /datum/species/android) \
		&& apply_to.dna?.features["android_species"] == SPECIES_LIZARD

/datum/limb_option_datum/bodypart/humanoid_android
	tooltip = "Unique to Humanoid Androids."

/datum/limb_option_datum/bodypart/humanoid_android/can_be_selected(datum/preferences/prefs)
	return ispath(prefs.read_preference(/datum/preference/choiced/species), /datum/species/android) \
		&& prefs.read_preference(/datum/preference/choiced/android_species) == SPECIES_HUMAN

/datum/limb_option_datum/bodypart/humanoid_android/can_be_applied(mob/living/carbon/human/apply_to)
	return is_species(apply_to, /datum/species/android) \
		&& apply_to.dna?.features["android_species"] == SPECIES_HUMAN

/datum/limb_option_datum/bodypart/humanoid_android/head
	name = "Humanoid Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/humanoid

/datum/limb_option_datum/bodypart/lizardlike_android/head
	name = "Lizardlike Cybernetic Head"
	limb_path = /obj/item/bodypart/head/robot/lizardlike

/datum/limb_option_datum/bodypart/humanoid_android/chest
	name = "Humanoid Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/humanoid

/datum/limb_option_datum/bodypart/lizardlike_android/chest
	name = "Lizardlike Cybernetic Chest"
	limb_path = /obj/item/bodypart/chest/robot/lizardlike

/datum/limb_option_datum/bodypart/humanoid_android/r_leg
	name = "Humanoid Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/humanoid

/datum/limb_option_datum/bodypart/humanoid_android/l_leg
	name = "Humanoid Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/humanoid

/datum/limb_option_datum/bodypart/humanoid_android/r_arm
	name = "Humanoid Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/humanoid

/datum/limb_option_datum/bodypart/humanoid_android/l_arm
	name = "Humanoid Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/humanoid

/datum/limb_option_datum/bodypart/lizardlike_android/r_leg
	name = "Lizardlike Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/lizardlike

/datum/limb_option_datum/bodypart/lizardlike_android/l_leg
	name = "Lizardlike Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/lizardlike

/datum/limb_option_datum/bodypart/lizardlike_android/r_arm
	name = "Lizardlike Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/lizardlike

/datum/limb_option_datum/bodypart/lizardlike_android/l_arm
	name = "Lizardlike Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/lizardlike
