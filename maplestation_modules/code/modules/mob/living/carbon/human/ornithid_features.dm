/// Holding place for all non-species ornithid features that are unique to it. (sprite overlays for wings, ears)
// begin armwings code
/obj/item/organ/external/wings/functional/arm_wings
	name = "Arm Wings"
	desc = "They're wings, that go on your arm. Get your chicken wings jokes out now."
	dna_block = DNA_ARM_WINGS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/arm_wings
	preference = "feature_arm_wings"
	//Yes, because this is a direct sub-type of functional wings, this means its stored on body, and yes, this means if one or both of the arms are dismembered, there will be floating feathers/wings.
	//However, there is no "both arms" storage, and having one for each arm is sort of inefficient. Leaving very few methods that could fix this, most of which are harder than what I can do or necessitate a refactor of code. Too Bad!

/obj/item/organ/external/wings/functional/arm_wings/can_fly(mob/living/carbon/human/human)
	if(HAS_TRAIT(human, TRAIT_RESTRAINED)) // prevents from flying if cuffed/restrained.
		to_chat(human, span_warning("You are restrained! You cannot fly!"))
		return FALSE
	return ..() // todo: add code for checking if arms are disabled through paralysis or damage

/datum/movespeed_modifier/arm_wing_flight // putting it here because this is the relevant file, and insular use case.
	multiplicative_slowdown = -0.2
	movetypes = FLOATING|FLYING
	// THIS SHOULD ONLY APPLY WHEN THE USER IS FLYING (or floating, because that makes sense, i guess)!!!!

/obj/item/organ/external/wings/functional/arm_wings/toggle_flight(mob/living/carbon/human/human)
	if(!HAS_TRAIT_FROM(human, TRAIT_MOVE_FLYING, SPECIES_FLIGHT_TRAIT))
		ADD_TRAIT(human, TRAIT_HANDS_BLOCKED, REF(src)) //  If someone knows how to get the crossed out markers to appear in hand, please let me know
		human.add_movespeed_modifier(/datum/movespeed_modifier/arm_wing_flight)
	else
		REMOVE_TRAIT(human, TRAIT_HANDS_BLOCKED, REF(src))
		human.remove_movespeed_modifier(/datum/movespeed_modifier/arm_wing_flight)
	return ..()

/datum/sprite_accessory/arm_wings
	icon = 'maplestation_modules/icons/mob/armwings.dmi'

/datum/sprite_accessory/arm_wings/monochrome
	name = "Monochrome"
	icon_state = "monochrome"
	color_src = HAIR

/datum/sprite_accessory/arm_wings/monochrome_short
	name = "Short Monochrome"
	icon_state = "monochrome_short"
	color_src = HAIR
/datum/bodypart_overlay/mutant/wings/arm_wings
	feature_key = "arm_wings"
	layers = EXTERNAL_FRONT
	color_source = ORGAN_COLOR_HAIR
/datum/bodypart_overlay/mutant/wings/arm_wings/get_global_feature_list()
	return GLOB.arm_wings_list

/datum/bodypart_overlay/mutant/wings/arm_wings/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.wear_suit?.flags_inv & HIDEMUTWINGS))
		return TRUE
	return FALSE
// end armwings code
// begin ears & tail code

/* /obj/item/organ/external/tail/avian
	name = "tail"
	preference = "feature_avian_tail"
	dna_block = DNA_AVIAN_TAIL_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/avian
	// I will NOT be adding wagging. for a variety of reasons, chief of which being I am NOT animating all of the sprites
	// and because with how bird tails work, this would basically just be twerking. Fuck you.

/datum/bodypart_overlay/mutant/tail/avian
	feature_key = "tail_avian"
	layers = EXTERNAL_BEHIND | EXTERNAL_FRONT
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/tail/avian/New()
	. = ..()

/datum/bodypart_overlay/mutant/tail/avian/get_global_feature_list()
	return GLOB.tails_list_avian

/datum/sprite_accessory/tails/avian
	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

/datum/sprite_accessory/tails/avian/eagle
	name = "Eagle"
	icon_state = "eagle" */ // commented this out because ultimately, I decided to keep this unused for the time being. visuals, being a pain in the ass to work with, etc.


/* /datum/sprite_accessory/tails/avian/swallow // commented this out for the time being
	name = "Swallow"
	icon_state = "swallow"
	color_src = HAIR */

// continue additional tails from here

// ear code here
/obj/item/organ/internal/ears/avian
	name = "avian ears"
	desc = "Senstive, much?"
	// yes, this uses the default icon. Yellow TODO: make an organ sprite for this
	damage_multiplier = 1.5 // felinids take 2x ear damage, ornithids have other things to worry about (pain increase) so they get 1.5x

// end ear code. begin plumage code, because external organs are significantly fucking better to work in than internals when it comes to visuals

/obj/item/organ/external/plumage
	name = "Plumage"
	desc = "Some feathers to ruffle. Seems the person who lost this definitely had theirs."
	preference = "feature_avian_ears"

	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

	dna_block = DNA_AVIAN_EARS_BLOCK // putting this as a reminder to future c*ders, this used to be part of ears.
	bodypart_overlay = /datum/bodypart_overlay/mutant/plumage
	use_mob_sprite_as_obj_sprite = TRUE

/datum/bodypart_overlay/mutant/plumage
	feature_key = "ears_avian"
	layers = EXTERNAL_FRONT
	color_source = ORGAN_COLOR_HAIR

/datum/bodypart_overlay/mutant/plumage/New()
	. = ..()

/datum/bodypart_overlay/mutant/plumage/get_global_feature_list()
	return GLOB.avian_ears_list

/datum/sprite_accessory/plumage
	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

/datum/sprite_accessory/plumage/hermes
	name = "Hermes"
	icon_state = "hermes"

/* /datum/sprite_accessory/plumage/kresnik // similar to tails, this is commented out for the time being.
	name = "Kresnik"
	icon_state = "kresnik" */
