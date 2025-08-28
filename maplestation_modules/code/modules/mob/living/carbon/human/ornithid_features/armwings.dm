// begin armwings code
/obj/item/organ/external/wings/functional/arm_wings
	name = "Arm Wings"
	desc = "They're wings, that go on your arm. Get your chicken wings jokes out now."
	dna_block = DNA_ARM_WINGS_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/wings/functional/arm_wings
	preference = "feature_arm_wings"
	//Yes, because this is a direct sub-type of functional wings, this means its stored on body, and yes, this means if one or both of the arms are dismembered, there will be floating feathers/wings.
	//However, there is no "both arms" storage, and having one for each arm is sort of inefficient. Leaving very few methods that could fix this, most of which are harder than what I can do or necessitate a refactor of code. Too Bad!

/obj/item/organ/external/wings/functional/arm_wings/can_fly(mob/living/carbon/human/human)
	if(HAS_TRAIT(human, TRAIT_RESTRAINED))
		to_chat(human, span_warning("You are restrained! You cannot fly!"))
		return FALSE
	if(human.usable_hands < 2)
		to_chat(human, span_warning("You need both of your hands to fly!"))
		return FALSE
	return ..()

/datum/movespeed_modifier/arm_wing_flight
	multiplicative_slowdown = -0.2
	movetypes = FLOATING|FLYING

/obj/item/organ/external/wings/functional/arm_wings/toggle_flight(mob/living/carbon/human/human)
	if(!HAS_TRAIT_FROM(human, TRAIT_MOVE_FLYING, SPECIES_FLIGHT_TRAIT))
		ADD_TRAIT(human, TRAIT_HANDS_BLOCKED, REF(src))
		human.add_movespeed_modifier(/datum/movespeed_modifier/arm_wing_flight)
	else
		REMOVE_TRAIT(human, TRAIT_HANDS_BLOCKED, REF(src))
		human.remove_movespeed_modifier(/datum/movespeed_modifier/arm_wing_flight)
	return ..()

/datum/sprite_accessory/arm_wings
	icon = 'maplestation_modules/icons/mob/armwings.dmi'


/datum/sprite_accessory/arm_wingsopen
	icon = 'maplestation_modules/icons/mob/armwings.dmi'

/datum/sprite_accessory/arm_wings/monochrome
	name = "Monochrome"
	icon_state = "monochrome"

/datum/sprite_accessory/arm_wings/monochrome_short
	name = "Short Monochrome"
	icon_state = "monochrome_short"

/datum/sprite_accessory/arm_wings/pursuant
	name = "Pursuant"
	icon_state = "pursuant"

/datum/sprite_accessory/arm_wingsopen/monochrome
	name = "Monochrome"
	icon_state = "monochrome"

/datum/sprite_accessory/arm_wingsopen/monochrome_short
	name = "Short Monochrome"
	icon_state = "monochrome_short"

/datum/sprite_accessory/arm_wingsopen/pursuant
	name = "Pursuant"
	icon_state = "pursuant"

/datum/bodypart_overlay/mutant/wings/functional/arm_wings
	feature_key = "arm_wings"
	layers = EXTERNAL_FRONT | EXTERNAL_ADJACENT
	color_source = ORGAN_COLOR_OVERRIDE

	///Feature render key for opened arm wings
	open_feature_key = "arm_wingsopen"

/datum/bodypart_overlay/mutant/wings/functional/arm_wings/inherit_color(obj/item/bodypart/ownerlimb, force) // overriding inherit_color directly because "override_color" for some unspeakable reason gets passed fuck all
	draw_color = ownerlimb?.owner?.dna?.features["feathers"] || "#FFFFFF"
	return TRUE

/datum/bodypart_overlay/mutant/wings/functional/arm_wings/get_global_feature_list()
	if(wings_open)
		return GLOB.arm_wingsopen_list
	else
		return GLOB.arm_wings_list

/datum/bodypart_overlay/mutant/wings/functional/arm_wings/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(human.obscured_slots & HIDEMUTWINGS)
		return FALSE
	return TRUE
