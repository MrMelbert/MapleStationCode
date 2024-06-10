
// Organ for synth head covers.
/obj/item/organ/external/synth_head_cover
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_EXTERNAL_SYNTH_HEAD_COVER
	dna_block = DNA_SYNTH_HEAD_COVER_BLOCK
	preference = "feature_synth_head_cover"
	bodypart_overlay = /datum/bodypart_overlay/mutant/synth_head_cover

/datum/bodypart_overlay/mutant/synth_head_cover
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT | EXTERNAL_BEHIND
	feature_key = "synth_head_cover"

/datum/bodypart_overlay/mutant/synth_head_cover/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(istype(human.head) && (human.head.flags_inv & HIDEHAIR))
		return FALSE
	if(istype(human.wear_mask) && (human.wear_mask.flags_inv & HIDEHAIR))
		return FALSE
	var/obj/item/bodypart/head/our_head = human.get_bodypart(BODY_ZONE_HEAD)
	if(!IS_ORGANIC_LIMB(our_head))
		return FALSE
	return TRUE

/datum/bodypart_overlay/mutant/synth_head_cover/get_global_feature_list()
	return GLOB.synth_head_cover_list


/// -- Snyth head cover options. --
/datum/sprite_accessory/synth_head_cover
	icon = 'maplestation_modules/icons/mob/synth_heads.dmi'

/datum/sprite_accessory/synth_head_cover/helm
	name = "Helm face cover"
	icon_state = "helm"

/datum/sprite_accessory/synth_head_cover/tv_blank
	name = "Blank TV"
	icon_state = "tv_blank"
