/datum/species/human/ornithid
	// the biggest bird
	name = "\improper Ornithid"
	plural_form = "Ornithids"
	id = SPECIES_ORNITHID
	say_mod = "squawks"
	species_traits = list(MUTCOLORS, EYECOLOR, HAIR, FACEHAIR, LIPS, HAS_FLESH, HAS_BONE)
	inherent_traits = list(
		TRAIT_LIGHT_DRINKER
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	// mutant_bodyparts = list("ears" = "Avian", "legs" = "Normal Legs") // avian ears NYI
	//external_organs = list(
	//
	//	/obj/item/organ/external/tail/avian = "[-TODO-]",
	//)
	bodypart_overrides = list(
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/ornithid, // NYI
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/ornithid, // NYI
		BODY_ZONE_HEAD = /obj/item/bodypart/head/, // just because they are still *partially* human, or otherwise human resembling
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/ornithid, // NYI
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/ornithid, // NYI
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/ornithid, //NYI
	)
	payday_modifier = 0.75
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT

	species_cookie = /obj/item/food/ // [-TODO-] change this to nuts
	meat = /obj/item/food/meat/slab/chicken
	skinned_type = /obj/item/stack/sheet/animalhide/human
	disliked_food = DAIRY | CLOTH | GROSS | SUGAR
	liked_food = FRUIT | SEAFOOD | NUTS | BUGS

	inert_mutation = /datum/mutation/human/dwarfism
	species_language_holder = /datum/language_holder/lizard // maybe make this yangyu, since that's now going **mostly** unused
//	digitigrade_customization = DIGITIGRADE_OPTIONAL // Maybe, Maybe.

// defines limbs/bodyparts.
/obj/item/bodypart/arm/left/ornithid
	limb_id = SPECIES_ORNITHID
	icon_greyscale = 'maplestation_modules/icons/mob/ornithid_parts_greyscale.dmi' // NYI! THIS IS A PLACEHOLDER BECAUSE OF MAPLE MODULARITY
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'


/obj/item/bodypart/arm/right/ornithid
	limb_id = SPECIES_ORNITHID
	icon_greyscale = 'maplestation_modules/icons/mob/ornithid_parts_greyscale.dmi' // NYI! THIS IS A PLACEHOLDER BECAUSE OF MAPLE MODULARITY
	unarmed_attack_verb = "slash"
	unarmed_attack_effect = ATTACK_EFFECT_CLAW
	unarmed_attack_sound = 'sound/weapons/slice.ogg'
	unarmed_miss_sound = 'sound/weapons/slashmiss.ogg'

/obj/item/bodypart/leg/left/ornithid
	limb_id = SPECIES_ORNITHID
	icon_greyscale = 'maplestation_modules/icons/mob/ornithid_parts_greyscale.dmi'

/obj/item/bodypart/leg/right/ornithid
	limb_id = SPECIES_ORNITHID
	icon_greyscale = 'maplestation_modules/icons/mob/ornithid_parts_greyscale.dmi'

/obj/item/bodypart/chest/ornithid
	limb_id = SPECIES_ORNITHID
	icon_greyscale = 'maplestation_modules/icons/mob/ornithid_parts_greyscale.dmi'


// section for lore/perks
/datum/species/human/ornithid/get_species_lore()
	return list(
		"bird lore"
	)

/datum/species/human/ornithid/get_species_description()
	return "Ornithids are a collective group of various human descendant or otherwise resembling sentient avian beings."

/datum/species/human/ornithid/create_pref_unique_perks()
	var/list/to_add = list()

	to_add += list(
		list(
 		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
 		SPECIES_PERK_ICON = "dove",
 		SPECIES_PERK_NAME = "Airborne",
		SPECIES_PERK_DESC = "!!!!NYI!!!! Is it a bird? is it a plane? Of course its a bird you dumbass, \
		Ornithids are lightweight winged avians, and can, as a result, fly.",
		),
		list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = "wind",
		SPECIES_PERK_NAME = "Wind Elemental Alignment",
		SPECIES_PERK_DESC = "Naturally one with the skies, Ornithids enjoy higher proficiency with Wind magic. \
			However, despite their Human origins, they suffer a malus with Earth magic.",
		),
		list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = "feather",
		SPECIES_PERK_NAME = "Lightweights",
		SPECIES_PERK_DESC = "As a result of their reduced average weight, \
			Ornithids have a lower alcohol tolerance. Pansies.",
		),
	)
	return to_add

