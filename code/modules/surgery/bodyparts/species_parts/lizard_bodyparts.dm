/obj/item/bodypart/head/lizard
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	is_dimorphic = FALSE
	head_flags = HEAD_LIPS|HEAD_EYESPRITES|HEAD_EYECOLOR|HEAD_EYEHOLES|HEAD_DEBRAIN

/obj/item/bodypart/chest/lizard
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	is_dimorphic = TRUE
	wing_types = list(/obj/item/organ/external/wings/functional/dragon)

/obj/item/bodypart/arm/left/lizard
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	unarmed_attack_verbs = list("slash", "scratch", "claw")
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/right/lizard
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD
	unarmed_attack_verbs = list("slash", "scratch", "claw")
	grappled_attack_verb = "lacerate"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slash.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/arm/left/lizard/ashwalker
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/bodypart/arm/right/lizard/ashwalker
	bodypart_traits = list(TRAIT_CHUNKYFINGERS)

/obj/item/bodypart/leg/left/lizard
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD

/obj/item/bodypart/leg/right/lizard
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = SPECIES_LIZARD

/// Checks if this mob is wearing anything that does not have a valid sprite set for digitigrade legs
/mob/living/carbon/proc/is_digitigrade_squished()
	var/obj/item/clothing/shoes/worn_shoes = get_item_by_slot(ITEM_SLOT_FEET)
	var/obj/item/clothing/under/worn_suit = get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/under/worn_uniform = get_item_by_slot(ITEM_SLOT_ICLOTHING)

	var/uniform_compatible = isnull(worn_uniform) \
		|| (worn_uniform.supports_variations_flags & DIGITIGRADE_VARIATIONS) \
		|| !(worn_uniform.body_parts_covered & LEGS) \
		|| (worn_suit?.flags_inv & HIDEJUMPSUIT) // If suit hides our jumpsuit, it doesn't matter if it squishes

	var/suit_compatible = isnull(worn_suit) \
		|| (worn_suit.supports_variations_flags & DIGITIGRADE_VARIATIONS) \
		|| !(worn_suit.body_parts_covered & LEGS)

	var/shoes_compatible = isnull(worn_shoes) \
		|| (worn_shoes.supports_variations_flags & DIGITIGRADE_VARIATIONS)

	return !uniform_compatible || !suit_compatible || !shoes_compatible

/obj/item/bodypart/leg/left/digitigrade
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = BODYPART_ID_DIGITIGRADE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_DIGITIGRADE
	footstep_type = FOOTSTEP_MOB_CLAW

/obj/item/bodypart/leg/left/digitigrade/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	var/old_id = limb_id
	limb_id = owner?.is_digitigrade_squished() ? SPECIES_LIZARD : BODYPART_ID_DIGITIGRADE
	if(old_id != limb_id)
		// Something unsquished / squished us so we need to go through and update everything that is affected
		for(var/obj/item/thing as anything in owner?.get_equipped_items())
			if(thing.supports_variations_flags & DIGITIGRADE_VARIATIONS)
				thing.update_slot_icon()

/obj/item/bodypart/leg/right/digitigrade
	icon_greyscale = 'icons/mob/human/species/lizard/bodyparts.dmi'
	limb_id = BODYPART_ID_DIGITIGRADE
	bodytype = BODYTYPE_HUMANOID | BODYTYPE_ORGANIC | BODYTYPE_DIGITIGRADE
	footstep_type = FOOTSTEP_MOB_CLAW

/obj/item/bodypart/leg/right/digitigrade/update_limb(dropping_limb = FALSE, is_creating = FALSE)
	. = ..()
	var/old_id = limb_id
	limb_id = owner?.is_digitigrade_squished() ? SPECIES_LIZARD : BODYPART_ID_DIGITIGRADE
	if(old_id != limb_id)
		// Something unsquished / squished us so we need to go through and update everything that is affected
		for(var/obj/item/thing as anything in owner?.get_equipped_items())
			if(thing.supports_variations_flags & DIGITIGRADE_VARIATIONS)
				thing.update_slot_icon()
