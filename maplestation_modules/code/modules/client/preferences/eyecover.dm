#define BLINDFOLD_COLORED_PREFERENCE "Blindfold (Eyecolor)"
#define BLINDFOLD_BLACK_PREFERENCE "Blindfold (Black)"
#define SPECTRUM_VISION_VISOR_PREFERENCE "Spectrum Amplification Visor"
#define SUNGLASSES_PREFERENCE "Sunglasses"
#define NONE_PREFERENCE "None"

/// Preference for blind characters to choose their eyecover of choice
/datum/preference/choiced/blind_eyecover
	category = PREFERENCE_CATEGORY_MANUALLY_RENDERED
	savefile_key = "blind_eyecover"
	savefile_identifier = PREFERENCE_CHARACTER
	can_randomize = FALSE
	should_generate_icons = TRUE

/datum/preference/choiced/blind_eyecover/create_default_value()
	return BLINDFOLD_COLORED_PREFERENCE

/datum/preference/choiced/blind_eyecover/init_possible_values()
	return list(
		BLINDFOLD_COLORED_PREFERENCE,
		BLINDFOLD_BLACK_PREFERENCE,
		SPECTRUM_VISION_VISOR_PREFERENCE,
		SUNGLASSES_PREFERENCE,
		NONE_PREFERENCE,
	)

/datum/preference/choiced/blind_eyecover/icon_for(value)
	switch(value)
		if(BLINDFOLD_COLORED_PREFERENCE)
			return uni_icon(/obj/item/clothing/glasses/blindfold/white::icon, /obj/item/clothing/glasses/blindfold/white::icon_state)
		if(BLINDFOLD_BLACK_PREFERENCE)
			return uni_icon(/obj/item/clothing/glasses/blindfold::icon, /obj/item/clothing/glasses/blindfold::icon_state)
		if(SPECTRUM_VISION_VISOR_PREFERENCE)
			return uni_icon(/obj/item/clothing/glasses/blindness_visor::icon, /obj/item/clothing/glasses/blindness_visor::icon_state)
		if(SUNGLASSES_PREFERENCE)
			return uni_icon(/obj/item/clothing/glasses/sunglasses::icon, /obj/item/clothing/glasses/sunglasses::icon_state)
		if(NONE_PREFERENCE)
			return uni_icon('icons/hud/screen_gen.dmi', "x")

	return uni_icon('icons/effects/random_spawners.dmi', "questionmark")

/datum/preference/choiced/blind_eyecover/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	return /datum/quirk/item_quirk/blindness::name in preferences.all_quirks

/datum/preference/choiced/blind_eyecover/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/quirk_constant_data/blind
	associated_typepath = /datum/quirk/item_quirk/blindness
	customization_options = list(/datum/preference/choiced/blind_eyecover)

/datum/quirk/item_quirk/blindness
	desc = "You are completely blind, and very few things can counteract this."

// Overrides blindness normal add unique to do our own thing
/datum/quirk/item_quirk/blindness/add_unique(client/client_source)
	var/blindfold_type = client_source.prefs?.read_preference(/datum/preference/choiced/blind_eyecover) || NONE_PREFERENCE
	var/type_to_give
	switch(blindfold_type)
		if(BLINDFOLD_COLORED_PREFERENCE)
			type_to_give = /obj/item/clothing/glasses/blindfold/white
		if(BLINDFOLD_BLACK_PREFERENCE)
			type_to_give = /obj/item/clothing/glasses/blindfold
		if(SPECTRUM_VISION_VISOR_PREFERENCE)
			type_to_give = /obj/item/clothing/glasses/blindness_visor
		if(SUNGLASSES_PREFERENCE)
			type_to_give = /obj/item/clothing/glasses/sunglasses

	if(!type_to_give)
		return

	give_item_to_holder(type_to_give, list(LOCATION_EYES = ITEM_SLOT_EYES, LOCATION_BACKPACK = ITEM_SLOT_BACKPACK, LOCATION_HANDS = ITEM_SLOT_HANDS))

#undef BLINDFOLD_COLORED_PREFERENCE
#undef SPECTRUM_VISION_VISOR_PREFERENCE
#undef SUNGLASSES_PREFERENCE
#undef NONE_PREFERENCE
