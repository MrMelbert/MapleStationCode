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
/datum/movespeed_modifier/arm_wing_flight // putting it here because this is the relevant file
	multiplicative_slowdown = -0.2
	// if there is a way to blacklist regular walking using "blacklisted_movetypes" let me know
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

/datum/bodypart_overlay/mutant/wings/arm_wings/New()
	. = ..()

/datum/bodypart_overlay/mutant/wings/arm_wings/get_global_feature_list()
	return GLOB.arm_wings_list

/datum/bodypart_overlay/mutant/wings/arm_wings/can_draw_on_bodypart(mob/living/carbon/human/human)
	if(!(human.wear_suit?.flags_inv & HIDEMUTWINGS))
		return TRUE
	return FALSE
// end armwings code
// begin ears & tail code

/obj/item/organ/external/tail/avian
	name = "tail"
	preference = "feature_avian_tail"
	dna_block = DNA_AVIAN_TAIL_BLOCK
	bodypart_overlay = /datum/bodypart_overlay/mutant/tail/avian
	// I will NOT be adding wagging. for a variety of reasons, chief of which being I am NOT animating all of the sprites
	// and because with how bird tails work, this would basically just be twerking. Fuck you.

/datum/bodypart_overlay/mutant/tail/avian
	feature_key = "tail_avian"
	layers = EXTERNAL_BEHIND | EXTERNAL_FRONT

/datum/sprite_accessory/tails/avian
	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

/datum/sprite_accessory/tails/avian/eagle
	name = "Eagle"
	icon_state = "eagle"
	color_src = HAIR

 /* /datum/sprite_accessory/tails/avian/swallow
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
	dna_block = DNA_AVIAN_EARS_BLOCK // putting this as a reminder to future c*ders, this used to be part of ears.
	bodypart_overlay = /datum/bodypart_overlay/mutant/plumage

/datum/bodypart_overlay/mutant/plumage
	feature_key = "plumage"
	layers = EXTERNAL_FRONT

/datum/sprite_accessory/plumage
	icon = 'maplestation_modules/icons/mob/ornithidfeatures.dmi'

/datum/sprite_accessory/plumage/hermes
	name = "Hermes"
	icon_state = "hermes"
	color_src = HAIR

/// YES, I GET IT. THIS SHOULD BE IN ITS OWN FILE WITH THE REST. DNM UNTIL I PUT THIS IN ITS PROPER FILE! THIS IS JUST SO I CAN HAVE EVERYTHING ALL IN ONE PLACE DURING EARLY STAGES!!!!
// code for setting preferences
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
	relevant_external_organ = /obj/item/organ/external/wings/functional/arm_wings
	should_generate_icons = TRUE

/datum/preference/choiced/ornithid_wings/init_possible_values()
	return possible_values_for_sprite_accessory_list_for_body_part(
		GLOB.arm_wings_list,
		"arm_wings",
		list("FRONT"),
		)

/datum/preference/choiced/ornithid_wings/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["arm_wings"] = value

/datum/preference/choiced/tail_avian
	savefile_key = "feature_avian_tail"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/tail/avian

/datum/preference/choiced/tail_avian/init_possible_values()
	return possible_values_for_sprite_accessory_list_for_body_part(
		GLOB.tails_list_avian,
		"tail_avian",
		list("FRONT", "BEHIND"),
		)

/datum/preference/choiced/tail_avian/init_possible_values()
	return assoc_to_keys(GLOB.tails_list_avian)

/datum/preference/choiced/tail_avian/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["tail_avian"] = value

/datum/preference/choiced/tail_avian/create_default_value()
	var/datum/sprite_accessory/tails/avian/tail = /datum/sprite_accessory/tails/avian
	return initial(tail.name)

/datum/preference/choiced/plumage
	savefile_key = "feature_avian_ears"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	relevant_external_organ = /obj/item/organ/external/plumage

/datum/preference/choiced/plumage/init_possible_values()
	return possible_values_for_sprite_accessory_list_for_body_part(
		GLOB.avian_ears_list,
		"ears_avian",
		list("FRONT"),
		)

/datum/preference/choiced/plumage/init_possible_values()
	return assoc_to_keys(GLOB.avian_ears_list)

/datum/preference/choiced/plumage/apply_to_human(mob/living/carbon/human/target, value)
	target.dna.features["ears_avian"] = value

/datum/preference/choiced/plumage/create_default_value()
	var/datum/sprite_accessory/plumage/plumage = /datum/sprite_accessory/plumage
	return initial(plumage.name)
