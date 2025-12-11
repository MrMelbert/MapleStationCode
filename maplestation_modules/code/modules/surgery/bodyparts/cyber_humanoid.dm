#define LIMB_ID_HUMAN_LIKE "human_like"
// Cybernetic, but looks like a human. Sprites ported from Effigy
/obj/item/bodypart/chest/robot/humanoid
	name = "humanoid cybernetic chest"
	icon = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	is_dimorphic = TRUE
	limb_id = LIMB_ID_HUMAN_LIKE
	icon_state = "human_like_chest_m"
	should_draw_greyscale = TRUE

/obj/item/bodypart/chest/robot/humanoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_USES_SKINTONES, INNATE_TRAIT)

/obj/item/bodypart/head/robot/humanoid
	name = "humanoid cybernetic head"
	icon = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	is_dimorphic = TRUE
	limb_id = LIMB_ID_HUMAN_LIKE
	icon_state = "human_like_head_m"
	should_draw_greyscale = TRUE

	head_flags = HEAD_ALL_HAIR_FLAGS | HEAD_EYESPRITES | HEAD_EYECOLOR

/obj/item/bodypart/head/robot/humanoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_USES_SKINTONES, INNATE_TRAIT)

/obj/item/bodypart/arm/right/robot/humanoid
	name = "humanoid cybernetic right arm"
	icon = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	limb_id = LIMB_ID_HUMAN_LIKE
	icon_state = "human_like_r_arm"
	should_draw_greyscale = TRUE

/obj/item/bodypart/arm/right/robot/humanoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_USES_SKINTONES, INNATE_TRAIT)

/obj/item/bodypart/arm/left/robot/humanoid
	name = "humanoid cybernetic left arm"
	icon = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	limb_id = LIMB_ID_HUMAN_LIKE
	icon_state = "human_like_l_arm"
	should_draw_greyscale = TRUE

/obj/item/bodypart/arm/left/robot/humanoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_USES_SKINTONES, INNATE_TRAIT)

/obj/item/bodypart/leg/right/robot/humanoid
	name = "humanoid cybernetic right leg"
	icon = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	limb_id = LIMB_ID_HUMAN_LIKE
	icon_state = "human_like_r_leg"
	should_draw_greyscale = TRUE

/obj/item/bodypart/leg/right/robot/humanoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_USES_SKINTONES, INNATE_TRAIT)

/obj/item/bodypart/leg/left/robot/humanoid
	name = "humanoid cybernetic left leg"
	icon = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/humanoid.dmi'
	limb_id = LIMB_ID_HUMAN_LIKE
	icon_state = "human_like_l_leg"
	should_draw_greyscale = TRUE

/obj/item/bodypart/leg/left/robot/humanoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_USES_SKINTONES, INNATE_TRAIT)

#define LIMB_ID_LIZARD_LIKE "synth_lizard"

// Cybernetic, lizardlike appearance. Sprites ported from Effigy
/obj/item/bodypart/chest/robot/lizardlike
	name = "lizardlike cybernetic chest"
	icon = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	is_dimorphic = TRUE
	limb_id = LIMB_ID_LIZARD_LIKE
	icon_state = "synth_lizard_chest_m"
	should_draw_greyscale = TRUE

/obj/item/bodypart/chest/robot/lizardlike/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MUTANT_COLORS, INNATE_TRAIT)

/obj/item/bodypart/head/robot/lizardlike
	name = "lizardlike cybernetic head"
	icon = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	limb_id = LIMB_ID_LIZARD_LIKE
	icon_state = "synth_lizard_head"
	should_draw_greyscale = TRUE

	head_flags = HEAD_ALL_HAIR_FLAGS | HEAD_EYESPRITES | HEAD_EYECOLOR

/obj/item/bodypart/head/robot/lizardlike/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MUTANT_COLORS, INNATE_TRAIT)

/obj/item/bodypart/arm/right/robot/lizardlike
	name = "lizardlike cybernetic right arm"
	icon = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	limb_id = LIMB_ID_LIZARD_LIKE
	icon_state = "synth_lizard_r_arm"
	should_draw_greyscale = TRUE

/obj/item/bodypart/arm/right/robot/lizardlike/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MUTANT_COLORS, INNATE_TRAIT)

/obj/item/bodypart/arm/left/robot/lizardlike
	name = "lizardlike cybernetic left arm"
	icon = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	limb_id = LIMB_ID_LIZARD_LIKE
	icon_state = "synth_lizard_l_arm"
	should_draw_greyscale = TRUE

/obj/item/bodypart/arm/left/robot/lizardlike/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MUTANT_COLORS, INNATE_TRAIT)

/obj/item/bodypart/leg/right/robot/lizardlike
	name = "lizardlike cybernetic right leg"
	icon = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	limb_id = LIMB_ID_LIZARD_LIKE
	icon_state = "synth_lizard_r_leg"
	should_draw_greyscale = TRUE

/obj/item/bodypart/leg/right/robot/lizardlike/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MUTANT_COLORS, INNATE_TRAIT)

/obj/item/bodypart/leg/left/robot/lizardlike
	name = "lizardlike cybernetic left leg"
	icon = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_static = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	icon_greyscale = 'maplestation_modules/icons/mob/augmentation/lizardly.dmi'
	limb_id = LIMB_ID_LIZARD_LIKE
	icon_state = "synth_lizard_l_leg"
	should_draw_greyscale = TRUE

/obj/item/bodypart/leg/left/robot/lizardlike/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_MUTANT_COLORS, INNATE_TRAIT)
