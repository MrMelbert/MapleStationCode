/// Holding place for all non-species ornithid features that are unique to it. (sprite overlays for wings, ears)
/datum/sprite_accessory/arm_wings
	icon = 'maplestation_modules/icons/mob/armwings.dmi'

/datum/sprite_accessory/arm_wings/monochrome
	name = "Monochrome"
	icon_state = "monochrome"
	color_src = ORGAN_COLOR_HAIR

/datum/sprite_accessory/arm_wings/monochrome_short
	name = "Short Monochrome"
	icon_state = "monochrome_short"
	color_src = ORGAN_COLOR_HAIR

/obj/item/organ/external/wings/arm_wings
	name = "Arm Wings"
	desc = "aaaaa" // filler
	dna_block = DNA_ARM_WINGS_BLOCK

	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/arm_wings
	preference = "feature_arm_wings"

/datum/bodypart_overlay/mutant/wings/arm_wings
	feature_key = "arm_wings"
	color_source = ORGAN_COLOR_HAIR
	layers = EXTERNAL_ADJACENT | EXTERNAL_BEHIND | EXTERNAL_FRONT

/datum/bodypart_overlay/mutant/wings/arm_wings/New()
	. = ..()

/datum/bodypart_overlay/mutant/wings/arm_wings/get_global_feature_list()
	return GLOB.arm_wings_list

/datum/bodypart_overlay/mutant/wings/arm_wings/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.wear_suit?.flags_inv & HIDEMUTWINGS))
		return TRUE
	return FALSE


/// YES, I GET IT. THIS SHOULD BE IN ITS OWN FILE WITH THE REST. DNM UNTIL I PUT THIS IN ITS PROPER FILE! THIS IS JUST SO I CAN HAVE EVERYTHING ALL IN ONE PLACE DURING EARLY STAGES!!!!

/proc/generate_ornithid_side_shots(list/sprite_accessories, key, list/sides)
	var/list/values = list()

	var/icon/ornithid = icon('icons/mob/species/human/human_face.dmi', "head", EAST)
	var/icon/eyes = icon('icons/mob/species/human/human_face.dmi', "eyes", EAST)
	eyes.Blend(COLOR_CLAIREN_RED, ICON_MULTIPLY)

	ornithid.Blend(eyes, ICON_OVERLAY)

	for (var/name in sprite_accessories)
		var/datum/sprite_accessory/sprite_accessory = sprite_accessories[name]

		var/icon/final_icon = icon(ornithid)

		if (sprite_accessory.icon_state != "none")
			for(var/side in sides)
				var/icon/accessory_icon = icon(sprite_accessory.icon, "m_[key]_[sprite_accessory.icon_state]_[side]", EAST)
				final_icon.Blend(accessory_icon, ICON_OVERLAY)

		final_icon.Crop(11, 20, 23, 32)
		final_icon.Scale(32, 32)
		final_icon.Blend(COLOR_BLUE_GRAY, ICON_MULTIPLY)

		values[name] = final_icon

	return values

/datum/preference/choiced/ornithid_wings
	savefile_key = "feature_arm_wings"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_FEATURES
	main_feature_name = "Arm Wings"
	should_generate_icons = TRUE

/datum/preference/choiced/ornithid_wings/init_possible_values()
	return possible_values_for_sprite_accessory_list_for_body_part(
		GLOB.arm_wings_list,
		"arm_wings",
		list( "BEHIND", "FRONT", "ADJ"),
		)

/datum/preference/choiced/ornithid_wings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arm_wings"] = value
