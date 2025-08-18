// -- Height preferences --

#define SIZE_PREF_PRIORITY PREFERENCE_PRIORITY_BODY_TYPE
#define HEIGHT_PREF_PRIORITY SIZE_PREF_PRIORITY - 1

#define HEIGHT_EXTREMELY_LARGE "Extremely Large"
#define HEIGHT_VERY_LARGE "Very Large"
#define HEIGHT_LARGE "Large"
#define HEIGHT_NO_CHANGE "Average Size (Default)"
#define HEIGHT_SMALL "Small"
#define HEIGHT_VERY_SMALL "Very Small"
#define HEIGHT_EXTREMELY_SMALL "Extremely Small"

/datum/preference/choiced/mob_size
	// This is legacy "character height". Now "character size". They key remains because I don't want to migrate preferences.
	savefile_key = "character_height"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	priority = SIZE_PREF_PRIORITY // throw this last

/datum/preference/choiced/mob_size/init_possible_values()
	return list(
		HEIGHT_EXTREMELY_LARGE,
		HEIGHT_VERY_LARGE,
		HEIGHT_LARGE,
		HEIGHT_NO_CHANGE,
		HEIGHT_SMALL,
		HEIGHT_VERY_SMALL,
		HEIGHT_EXTREMELY_SMALL
	)

/datum/preference/choiced/mob_size/apply_to_human(mob/living/carbon/human/target, value)
	if(value == HEIGHT_NO_CHANGE)
		return
	if(target.get_mob_height() != HUMAN_HEIGHT_MEDIUM) // not compatible, nope
		return

	// Snowflake, but otherwise the dummy in the prefs menu will be resized and you can't see anything
	if(isdummy(target))
		return
	// Just in case
	if(!ishuman(target))
		return

	target.transform = null
	var/resize_amount = 1

	switch(value)
		if(HEIGHT_EXTREMELY_LARGE)
			resize_amount = 1.5
		if(HEIGHT_VERY_LARGE)
			resize_amount = 1.2
		if(HEIGHT_LARGE)
			resize_amount = 1.1
		if(HEIGHT_SMALL)
			resize_amount = 0.9
		if(HEIGHT_VERY_SMALL)
			resize_amount = 0.8
		if(HEIGHT_EXTREMELY_SMALL)
			resize_amount = 0.7

	if(value >= HEIGHT_VERY_LARGE)
		ADD_TRAIT(target, TRAIT_GIANT, ROUNDSTART_TRAIT)
	else if(value <= HEIGHT_VERY_SMALL)
		ADD_TRAIT(target, TRAIT_DWARF, ROUNDSTART_TRAIT)

	target.update_transform(resize_amount)

/datum/preference/choiced/mob_size/is_accessible(datum/preferences/preferences)
	return ..() && !has_silicon_prioritized(preferences)

/datum/preference/choiced/mob_size/create_default_value(datum/preferences/preferences)
	return HEIGHT_NO_CHANGE


#undef HEIGHT_EXTREMELY_LARGE
#undef HEIGHT_VERY_LARGE
#undef HEIGHT_LARGE
#undef HEIGHT_NO_CHANGE
#undef HEIGHT_SMALL
#undef HEIGHT_VERY_SMALL
#undef HEIGHT_EXTREMELY_SMALL

#define DEFAULT_HEIGHT "Medium (Default)"

/datum/preference/choiced/mob_height
	savefile_key = "character_height_modern"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE
	priority = HEIGHT_PREF_PRIORITY
	var/list/height_to_actual = list(
		"Shortest" = HUMAN_HEIGHT_SHORTEST,
		"Short" = HUMAN_HEIGHT_SHORT,
		DEFAULT_HEIGHT = HUMAN_HEIGHT_MEDIUM,
		"Tall" = HUMAN_HEIGHT_TALL,
		"Tallest" = HUMAN_HEIGHT_TALLEST,
	)

/datum/preference/choiced/mob_height/init_possible_values()
	return assoc_to_keys(height_to_actual)

/datum/preference/choiced/mob_height/apply_to_human(mob/living/carbon/human/target, value)
	// Just in case
	if(!ishuman(target))
		return

	var/height_actual = height_to_actual[value]
	if(isnull(height_actual))
		stack_trace("Invalid height for [type], [value]!")
		return

	target.set_mob_height(height_actual)

/datum/preference/choiced/mob_height/is_accessible(datum/preferences/preferences)
	return ..() && !has_silicon_prioritized(preferences)

/datum/preference/choiced/mob_height/create_default_value(datum/preferences/preferences)
	return DEFAULT_HEIGHT

#undef DEFAULT_HEIGHT

#undef SIZE_PREF_PRIORITY
#undef HEIGHT_PREF_PRIORITY

// To speed up the preference menu, we apply 1 filter to the entire mob
/mob/living/carbon/human/dummy/regenerate_icons()
	. = ..()
	apply_height_filters(src, TRUE)

/mob/living/carbon/human/dummy/apply_height_filters(image/appearance, only_apply_in_prefs = FALSE)
	if(only_apply_in_prefs)
		return ..()

// Not necessary with above
/mob/living/carbon/human/dummy/apply_height_offsets(image/appearance, upper_torso)
	return

/mob/living/carbon/human/get_mob_height()
	// If you have roundstart dwarfism (IE: resized), it'll just return normal mob height, so no filters are applied
	if(HAS_TRAIT_FROM_ONLY(src, TRAIT_DWARF, ROUNDSTART_TRAIT))
		return mob_height

	return ..()

/mob/living/carbon/human/on_dwarf_trait(datum/source)
	// If you have roundstart dwarfism (IE: resized), don't bother regenning icons or toggling passtable
	if(HAS_TRAIT_FROM_ONLY(src, TRAIT_DWARF, ROUNDSTART_TRAIT))
		return

	return ..()

/datum/preference/proc/has_silicon_prioritized(datum/preferences/preferences)
	// If you have a silicon job, don't show the height preference
	var/datum/job/fav_job = preferences.get_highest_priority_job()
	return istype(fav_job, /datum/job/ai) || istype(fav_job, /datum/job/cyborg)
