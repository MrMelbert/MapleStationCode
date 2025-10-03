// ear code here
/obj/item/organ/internal/ears/avian
	name = "avian ears"
	desc = "Senstive, much?"
	// yes, this uses the default icon. Yellow TODO: make an organ sprite for this
	damage_multiplier = 1.5 // felinids take 2x ear damage, ornithids have other things to worry about (pain increase) so they get 1.5x

	preference = "feature_avian_ears"
	dna_block = DNA_AVIAN_EARS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/plumage

// end ear code. begin plumage code, because i made the choice to make these a seperate organ back when felinid ears were turbo janky, now everything is shifting. TODO: merge these

/datum/bodypart_overlay/mutant/plumage
	feature_key = "ears_avian"
	layers = EXTERNAL_FRONT
	color_source = ORGAN_COLOR_OVERRIDE

/datum/bodypart_overlay/mutant/plumage/inherit_color(obj/item/bodypart/ownerlimb, force)
	draw_color = ownerlimb?.owner?.dna?.features["feathers"] || "#FFFFFF"
	return TRUE

/datum/bodypart_overlay/mutant/plumage/get_global_feature_list()
	return SSaccessories.avian_ears_list

/datum/bodypart_overlay/mutant/plumage/can_draw_on_bodypart(mob/living/carbon/human/human)
	return !(human.obscured_slots & HIDEHAIR)

/datum/sprite_accessory/plumage
	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

/datum/sprite_accessory/plumage/hermes
	name = "Hermes"
	icon_state = "hermes"

/datum/sprite_accessory/plumage/arched
	name = "Arched"
	icon_state = "arched"

/* /datum/sprite_accessory/plumage/kresnik // similar to tails (originally!), this is commented out for the time being.
	name = "Kresnik"
	icon_state = "kresnik" */
