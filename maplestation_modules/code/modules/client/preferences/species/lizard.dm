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

#define HAIR_PREFERENCES list( \
	/datum/preference/choiced/facial_hair_gradient::savefile_key, \
	/datum/preference/choiced/facial_hairstyle::savefile_key, \
	/datum/preference/choiced/hair_gradient::savefile_key, \
	/datum/preference/choiced/hairstyle::savefile_key, \
	/datum/preference/color/facial_hair_color::savefile_key, \
	/datum/preference/color/facial_hair_gradient::savefile_key, \
	/datum/preference/color/hair_color::savefile_key, \
	/datum/preference/color/hair_gradient::savefile_key, \
)

// Manually adding the hair related preferences to the lizard features list
/datum/species/lizard/get_features()
	return ..() | HAIR_PREFERENCES

/datum/species/lizard/get_filtered_features_per_prefs(datum/preferences/prefs)
	return prefs.read_preference(/datum/preference/toggle/hair_lizard) ? list() : HAIR_PREFERENCES

#undef HAIR_PREFERENCES

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
	draw_color = bodypart_owner?.owner?.dna?.features["lizard_horn_color"] || "#dddddd"
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
	return "#dddddd"

// -- Lizard Horn Layer selection --
// Makes it actually work
/datum/bodypart_overlay/mutant/horns/get_image(image_layer, obj/item/bodypart/limb)
	var/new_layer = limb.owner?.dna?.features["lizard_horn_layer"] || BODY_ADJ_LAYER
	if(new_layer == BODY_ADJ_LAYER)
		return ..()

	var/mutable_appearance/appearance = ..()
	appearance.layer = -1 * new_layer
	return appearance

// The preference
/datum/preference/choiced/lizard_horn_layer
	savefile_key = "feature_lizard_horn_layer"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/horns
	/// Map of player-readable-text to layer value
	var/list/layer_to_layer = list(
		"Default" = BODY_ADJ_LAYER,
		"Above Hair" = FACEMASK_LAYER,
		"Above Helmets" = BODY_FRONT_LAYER,
	)

/datum/preference/choiced/lizard_horn_layer/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["lizard_horn_layer"] = layer_to_layer[value]

/datum/preference/choiced/lizard_horn_layer/create_default_value()
	return "Default"

/datum/preference/choiced/lizard_horn_layer/init_possible_values()
	return layer_to_layer

// -- Lets you change layer of lizard frills --
// Makes the bodypart update correctly
/datum/bodypart_overlay/mutant/frills/get_image(image_layer, obj/item/bodypart/limb)
	var/new_layer = limb.owner?.dna?.features["lizard_frill_layer"] || BODY_ADJ_LAYER
	if(new_layer == BODY_ADJ_LAYER)
		return ..()

	var/mutable_appearance/appearance = ..()
	appearance.layer = -1 * new_layer
	return appearance

/datum/preference/choiced/lizard_frill_layer
	savefile_key = "feature_lizard_frill_layer"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/frills
	/// Map of player-readable-text to layer value
	var/list/layer_to_layer = list(
		"Default" = BODY_ADJ_LAYER,
		"Above Hair" = FACEMASK_LAYER,
		"Above Helmets" = BODY_FRONT_LAYER,
	)

/datum/preference/choiced/lizard_frill_layer/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["lizard_frill_layer"] = layer_to_layer[value]

/datum/preference/choiced/lizard_frill_layer/create_default_value()
	return "Default"

/datum/preference/choiced/lizard_frill_layer/init_possible_values()
	return layer_to_layer
