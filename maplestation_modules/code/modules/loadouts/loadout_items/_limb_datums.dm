GLOBAL_LIST_INIT(limb_loadout_options, init_loadout_limb_options())

/proc/init_loadout_limb_options()
	var/list/created = list()
	for(var/datum/limb_option_datum/to_create as anything in typesof(/datum/limb_option_datum))
		var/obj/item/bodypart/limb_path = initial(to_create.limb_path)
		if(isnull(limb_path) || isnull(initial(limb_path.plaintext_zone)))
			continue

		created[limb_path] = new to_create()

	return created

/datum/limb_option_datum
	var/name
	/// Used in tooltips
	var/desc
	var/obj/item/bodypart/limb_path

/datum/limb_option_datum/New()
	. = ..()
	if(isnull(name))
		name = capitalize(initial(limb_path.name))
	if(isnull(desc))
		desc = initial(limb_path.desc)

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
