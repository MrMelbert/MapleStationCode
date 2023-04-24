/// Holding place for all non-species ornithid features that are unique to it. (sprite overlays for wings, ears)
/datum/sprite_accessory/armwings
	icon = 'maplestation_modules/icons/mob/armwings.dmi'
	color_src = ORGAN_COLOR_HAIR

/datum/sprite_accessory/armwings/monochrome
	name = "Monochrome"
	icon_state = "monochrome"
	color_src = ORGAN_COLOR_HAIR

/datum/sprite_accessory/armwings/monochrome_short
	name = "Short Monochrome"
	icon_state = "monoechrome_short"

/obj/item/organ/external/wings/functional/armwings
	name = "armwings"
	desc = "aaaaa"
	sprite_accessory_override = /datum/sprite_accessory/armwings
	preference = "feature_arm_wings"
