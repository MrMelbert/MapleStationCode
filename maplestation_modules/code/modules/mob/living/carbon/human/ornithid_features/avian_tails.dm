

/obj/item/organ/external/tail/avian
	name = "avian tail"
	desc = "This tail belongs to an ornithid. Used to."
	preference = "feature_avian_tail"
	dna_block = DNA_AVIAN_TAIL_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/avian
	// I will NOT be adding wagging. for a variety of reasons, chief of which being I am NOT animating all of the sprites
	// and because with how bird tails work, this would basically just be twerking. Fuck you.

/datum/bodypart_overlay/mutant/tail/avian
	feature_key = "tail_avian"
	layers = EXTERNAL_BEHIND | EXTERNAL_FRONT
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/tail/avian/get_global_feature_list()
	return SSaccessories.tails_list_avian

/datum/bodypart_overlay/mutant/tail/avian/inherit_color(obj/item/bodypart/ownerlimb, force)
	draw_color = ownerlimb?.owner?.dna?.features["feathers"] || "#FFFFFF"
	return TRUE


/datum/sprite_accessory/tails/avian
	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

/datum/sprite_accessory/tails/avian/eagle
	name = "Eagle"
	icon_state = "eagle"

/datum/sprite_accessory/tails/avian/swallow
	name = "Swallow"
	icon_state = "swallow"

// continue additional tails from here
