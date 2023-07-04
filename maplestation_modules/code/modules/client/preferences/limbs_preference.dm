/datum/preference/limbs
	savefile_key = "limb_list"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	can_randomize = FALSE

// Loadouts are applied with job equip code.
/datum/preference/limbs/apply_to_human(mob/living/carbon/human/target, value)
	for(var/limb_zone in value)
		var/obj/item/bodypart/limb_path = value[limb_zone]
		var/datum/limb_option_datum/equipping = GLOB.limb_loadout_options[limb_path]
		if(isnull(equipping))
			stack_trace("Invalid limb path in limb loadout preference: [limb_path]")
			continue

		equipping.apply_limb(target)

/datum/preference/limbs/deserialize(input, datum/preferences/preferences)
	var/list/corrected_list = list()
	for(var/limb_zone in input)
		var/obj/item/bodypart/limb_path_as_text = input[limb_zone]
		if(istext(limb_path_as_text))
			// Loading from json loads as text rather than paths we love
			limb_path_as_text = text2path(limb_path_as_text)

		if(!ispath(limb_path_as_text, /obj/item/bodypart))
			continue
		if(isnull(GLOB.limb_loadout_options[limb_path_as_text]))
			continue

		corrected_list[limb_zone] = limb_path_as_text

	return corrected_list

// Default value is NULL - the loadout list is a lazylist
/datum/preference/limbs/create_default_value(datum/preferences/preferences)
	return null

/datum/preference/limbs/is_valid(value)
	return isnull(value) || islist(value)
