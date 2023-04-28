// -- Height preferences --

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

	// Snowflake, but otherwise the dummy in the prefs menu will be resized and you can't see anything
	if(istype(target, /mob/living/carbon/human/dummy))
		return
	// Just in case
	if(!ishuman(target))
		return

	target.transform = null

	var/resize_amount = 1
	var/y_offset = 0

	switch(value)
		if(HEIGHT_EXTREMELY_LARGE)
			resize_amount = 1.5
			y_offset = 8
		if(HEIGHT_VERY_LARGE)
			resize_amount = 1.2
			y_offset = 3
		if(HEIGHT_LARGE)
			resize_amount = 1.1
			y_offset = 2
		if(HEIGHT_SMALL)
			resize_amount = 0.9
			y_offset = -2
		if(HEIGHT_VERY_SMALL)
			resize_amount = 0.8
			y_offset = -3
		if(HEIGHT_EXTREMELY_SMALL)
			resize_amount = 0.7
			y_offset = -5

	if(resize_amount > 1.1)
		ADD_TRAIT(target, TRAIT_GIANT, ROUNDSTART_TRAIT)
	else if(resize_amount < 0.9)
		ADD_TRAIT(target, TRAIT_DWARF, ROUNDSTART_TRAIT)

	target.resize = resize_amount
	target.update_transform()
	target.base_pixel_y += y_offset
	target.pixel_y += y_offset

/datum/preference/choiced/mob_size/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	var/datum/job/fav_job = preferences.get_highest_priority_job()
	return !istype(fav_job, /datum/job/ai) && !istype(fav_job, /datum/job/cyborg)

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
	if(!..(preferences))
		return FALSE

	var/datum/job/fav_job = preferences.get_highest_priority_job()
	return !istype(fav_job, /datum/job/ai) && !istype(fav_job, /datum/job/cyborg)

/datum/preference/choiced/mob_height/create_default_value(datum/preferences/preferences)
	return DEFAULT_HEIGHT

#undef DEFAULT_HEIGHT
