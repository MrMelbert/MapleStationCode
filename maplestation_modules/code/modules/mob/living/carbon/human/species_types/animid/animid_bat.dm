/datum/animalid_type/bat
	id = "Bat"
	components = list(
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/bat,
		BODY_ZONE_HEAD  = /obj/item/bodypart/head/bat,
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/bat,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/bat,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/bat,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/bat,
		MUTANT_ORGANS = list(/obj/item/organ/wings/bat_wings = "Normal"),
		ORGAN_SLOT_EARS = /obj/item/organ/ears/bat,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/bat,
	)

	name = "Chiropteranid"
	icon = FA_ICON_DROPLET

/datum/animalid_type/bat/pre_species_gain(datum/species/human/animid/species, mob/living/carbon/human/new_animid)
	species.exotic_bloodtype = /datum/blood_type/universal

/datum/animalid_type/bat/get_extra_perks()
	var/list/to_add = list()

	to_add += list(
		list(
			SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_DROPLET_SLASH,
			SPECIES_PERK_NAME = "Dracula's Blessing",
			SPECIES_PERK_DESC = "[name] can replenish blood by drinking it rather than via IV drip. \
				They also have a Universal blood type, capable of accepting from (but not donating to) everyone, including non-humans.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
			SPECIES_PERK_ICON = FA_ICON_WIND,
			SPECIES_PERK_NAME = "Wings",
			SPECIES_PERK_DESC = "[name] wings are partially functional, negating fall damage from low heights. \
				However, concealing them may be difficult.",
		),
		list(
			SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
			SPECIES_PERK_ICON = FA_ICON_BONE,
			SPECIES_PERK_NAME = "Fragile Frame",
			SPECIES_PERK_DESC = "[name]s have weak and fragile limbs, sustaining more brute damage from attacks. \
				and dealing less unarmed damage.",
		),
	)

	return to_add

// Bat ear organ
/obj/item/organ/ears/bat
	name = "bat ears"
	desc = "A pair of large, pointed ears belonging to a bat."
	visual = TRUE
	damage_multiplier = 2

	bodypart_overlay = /datum/bodypart_overlay/mutant/ears/bat

	eavesdrop_bonus = 3

// Bat ear bodypart overlay
/datum/bodypart_overlay/mutant/ears/bat
	feature_key = "bat_ears"

/datum/bodypart_overlay/mutant/ears/bat/get_global_feature_list()
	return SSaccessories.bat_ears_list

// Bat ear sprite accessory - sprites ported from https://github.com/Skyrat-SS13/Skyrat13/commit/25e426ddd0aa69b80df6a764f76370781c66d2bc
/datum/sprite_accessory/ears_bat
	icon = 'maplestation_modules/icons/mob/ears/bat.dmi'
	em_block = TRUE

/datum/sprite_accessory/ears_bat/simple
	name = "Simple"
	icon_state = "simple"

// Bat ear preference
/datum/preference/choiced/bat_ears
	savefile_key = "feature_bat_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/ears/bat
	should_generate_icons = TRUE

/datum/preference/choiced/bat_ears/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["bat_ears"] = value

/datum/preference/choiced/bat_ears/create_default_value()
	return /datum/sprite_accessory/ears_bat/simple::name

/datum/preference/choiced/bat_ears/init_possible_values()
	return assoc_to_keys_features(SSaccessories.bat_ears_list)

/datum/preference/choiced/bat_ears/icon_for(value)
	return GENERATE_HEAD_ICON(value, SSaccessories.bat_ears_list)

// Bat wing organ
/obj/item/organ/wings/bat_wings
	name = "bat wings"
	desc = "Wings from a bat, not particularly strong enough to lift a human though."

	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/bat

// Bat wing bodypart overlay
/datum/bodypart_overlay/mutant/wings/bat
	feature_key = "bat_wings"
	layers = EXTERNAL_BEHIND | EXTERNAL_FRONT
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/wings/bat/get_global_feature_list()
	return SSaccessories.bat_wings_list

/datum/bodypart_overlay/mutant/wings/bat/can_draw_on_bodypart(obj/item/bodypart/bodypart_owner)
	return !(bodypart_owner.owner?.obscured_slots & HIDEMUTWINGS)

// Bat wing sprite accessory - sprites ported from Effigy, https://github.com/Skyrat-SS13/Skyrat13/commit/25e426ddd0aa69b80df6a764f76370781c66d2bc
/datum/sprite_accessory/wings_bat
	icon = 'maplestation_modules/icons/mob/bat_wings.dmi'
	em_block = TRUE

/datum/sprite_accessory/wings_bat/normal
	name = "Normal"
	icon_state = "normal"

/datum/sprite_accessory/wings_bat/small
	name = "Small"
	icon_state = "small"

/datum/sprite_accessory/wings_bat/tiny
	name = "Tiny"
	icon_state = "tiny"

// Bat wing preference
/datum/preference/choiced/bat_wings
	savefile_key = "feature_bat_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	relevant_external_organ = /obj/item/organ/wings/bat_wings
	should_generate_icons = TRUE

/datum/preference/choiced/bat_wings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["bat_wings"] = value

/datum/preference/choiced/bat_wings/create_default_value()
	return /datum/sprite_accessory/wings_bat/normal::name

/datum/preference/choiced/bat_wings/init_possible_values()
	return assoc_to_keys_features(SSaccessories.bat_wings_list)

/datum/preference/choiced/bat_wings/icon_for(value)
	var/datum/sprite_accessory/the_accessory = SSaccessories.bat_wings_list[value]
	var/datum/universal_icon/body_icon = generate_body_icon(
		bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/arm/left, /obj/item/bodypart/arm/right),
	)
	if(the_accessory.icon_state != SPRITE_ACCESSORY_NONE)
		var/datum/universal_icon/wing_icon = uni_icon(the_accessory.icon, "m_bat_wings_[the_accessory.icon_state]_BEHIND", dir = SOUTH)
		wing_icon.blend_color(COLOR_BROWNER_BROWN, ICON_MULTIPLY)
		body_icon.blend_icon(wing_icon, ICON_OVERLAY)
	body_icon.scale(48, 48)
	body_icon.crop_32x32(8, 8)
	return body_icon

// Bat tongue
/obj/item/organ/tongue/bat
	name = "bat tongue"
	desc = "A long, thin tongue that might belong to a bat. Not the wooden kind."

	liked_foodtypes = FRUIT | BUGS // likes eating fruit and bugs, does not mind raw or gore
	disliked_foodtypes = GROSS | CLOTH | VEGETABLES | JUNKFOOD | FRIED
	organ_traits = list(TRAIT_DRINKS_BLOOD)

// Bat bodyparts
/obj/item/bodypart/leg/left/bat
	name = "chiropteranid left leg"
	brute_modifier = 1.33
	unarmed_damage_low = 6
	unarmed_damage_high = 12

/obj/item/bodypart/leg/right/bat
	name = "chiropteranid right leg"
	brute_modifier = 1.33
	unarmed_damage_low = 6
	unarmed_damage_high = 12

/obj/item/bodypart/arm/left/bat
	name = "chiropteranid left arm"
	brute_modifier = 1.33
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_damage_low = 4
	unarmed_damage_high = 8

/obj/item/bodypart/arm/right/bat
	name = "chiropteranid right arm"
	brute_modifier = 1.33
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_damage_low = 4
	unarmed_damage_high = 8

/obj/item/bodypart/chest/bat
	name = "chiropteranid chest"
	brute_modifier = 1.33

/obj/item/bodypart/head/bat
	name = "chiropteranid head"
	brute_modifier = 1.33
