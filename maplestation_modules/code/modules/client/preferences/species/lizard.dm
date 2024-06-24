// -- Toggle that lets people play (dios mio) hair lizards --
/datum/preference/toggle/hair_lizard
	savefile_key = "hair_lizard"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_NAMES
	can_randomize = FALSE
	default_value = FALSE

/datum/preference/toggle/hair_lizard/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/preference/toggle/hair_lizard/apply_to_human(mob/living/carbon/human/target, value)
	if(!islizard(target))
		return

	var/obj/item/bodypart/head/head = target.get_bodypart(BODY_ZONE_HEAD)
	// Adding directly here is primarily so the dummy updates
	if(value)
		head.head_flags |= (HEAD_HAIR|HEAD_FACIAL_HAIR)
	else
		head.head_flags &= ~(HEAD_HAIR|HEAD_FACIAL_HAIR)

	// Hate using dna features but it's really convenient to stick things
	// No I'm not adding it to genetics, don't even ask
	target.dna.features["lizard_has_hair"] = value
	target.update_body_parts()

// Manually adding the hair related preferences to the lizard features list
/datum/species/lizard/get_features()
	return ..() | list(
		"hair_color",
		"hairstyle_name",
		"hair_gradient",
		"hair_gradient_color",
		"facial_style_name",
		"facial_hair_color",
		"facial_hair_gradient",
		"facial_hair_gradient_color",
	)

// -- Allows modification of hissssss length --
/datum/preference/numeric/hiss_length
	savefile_key = "hiss_length"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_NAMES
	can_randomize = FALSE
	minimum = 2
	maximum = 6

/datum/preference/numeric/hiss_length/create_default_value()
	return 3

/datum/preference/numeric/hiss_length/is_accessible(datum/preferences/preferences)
	return ..() && ispath(preferences.read_preference(/datum/preference/choiced/species), /datum/species/lizard)

/datum/preference/numeric/hiss_length/apply_to_human(mob/living/carbon/human/target, value)
	var/obj/item/organ/internal/tongue/lizard/tongue = target.get_organ_slot(ORGAN_SLOT_TONGUE)
	if(!istype(tongue))
		return
	tongue.draw_length = value

// -- Allows lizard horns to be colorable --
// (Because some choices are greyscaled)
/datum/preference/choiced/lizard_horns
	relevant_external_organ = /obj/item/organ/external/horns

/datum/preference/choiced/lizard_horns/compile_constant_data()
	var/list/data = ..()
	data[SUPPLEMENTAL_FEATURE_KEY] = "feature_lizard_horn_color"
	return data

// Makes the bodypart update correctly
/datum/bodypart_overlay/mutant/horns
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/horns/inherit_color(obj/item/bodypart/bodypart_owner, force)
	draw_color = bodypart_owner?.owner?.dna?.features["lizard_horn_color"] || "#FFFFFF"
	return TRUE

// The actual preference
/datum/preference/color/horn_color
	savefile_key = "feature_lizard_horn_color"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SUPPLEMENTAL_FEATURES
	relevant_external_organ = /obj/item/organ/external/horns
	can_randomize = FALSE

/datum/preference/color/horn_color/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["lizard_horn_color"] = value

/datum/preference/color/horn_color/create_default_value()
	return "#FFFFFF"
