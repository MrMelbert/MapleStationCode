GLOBAL_LIST_INIT(limb_loadout_options, init_loadout_limb_options())

/proc/init_loadout_limb_options()
	var/list/created = list()
	for(var/datum/limb_option_datum/to_create as anything in typesof(/datum/limb_option_datum))
		var/obj/item/limb_path = initial(to_create.limb_path)
		if(isnull(limb_path))
			continue

		created[limb_path] = new to_create()

	return created

/datum/limb_option_datum
	/// Name shown up in UI
	var/name
	/// Used in UI tooltips
	var/desc
	/// The actual item that is created and equipped to the player
	var/obj/item/limb_path

/datum/limb_option_datum/New()
	. = ..()
	if(isnull(name))
		name = capitalize(initial(limb_path.name))
	if(isnull(desc))
		desc = initial(limb_path.desc)

/// Applies the limb to the mob
/datum/limb_option_datum/proc/apply_limb(mob/living/carbon/human/apply_to)
	apply_to.del_and_replace_bodypart(new limb_path(), special = TRUE)

/datum/limb_option_datum/prosthetic_r_leg
	name = "Prosthetic Right Leg"
	limb_path = /obj/item/bodypart/leg/right/robot/surplus

/datum/limb_option_datum/prosthetic_l_leg
	name = "Prosthetic Left Leg"
	limb_path = /obj/item/bodypart/leg/left/robot/surplus

/datum/limb_option_datum/prosthetic_r_arm
	name = "Prosthetic Right Arm"
	limb_path = /obj/item/bodypart/arm/right/robot/surplus

/datum/limb_option_datum/prosthetic_l_arm
	name = "Prosthetic Left Arm"
	limb_path = /obj/item/bodypart/arm/left/robot/surplus

/datum/limb_option_datum/organ

/datum/limb_option_datum/organ/apply_limb(mob/living/carbon/human/apply_to)
	if(istype(apply_to, /mob/living/carbon/human/dummy)) // thog don't caare
		return

	var/obj/item/organ/internal/new_organ = new limb_path()
	new_organ.Insert(apply_to, special = TRUE, drop_if_replaced = FALSE)

/datum/limb_option_datum/organ/cyberheart
	name = "Cybernetic Heart"
	limb_path = /obj/item/organ/internal/heart/cybernetic

/datum/limb_option_datum/organ/eyes
	name = "Cybernetic Eyes"
	desc = "A basic pair of robotic eyeballs."
	limb_path = /obj/item/organ/internal/eyes/robotic
