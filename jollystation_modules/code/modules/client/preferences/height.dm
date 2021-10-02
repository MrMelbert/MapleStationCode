// -- Height preferences --

#define HEIGHT_EXTREMELY_LARGE "Extremely Large"
#define HEIGHT_VERY_LARGE "Very Large"
#define HEIGHT_LARGE "Large"
#define HEIGHT_NO_CHANGE "Average Height"
#define HEIGHT_SMALL "Small"
#define HEIGHT_VERY_SMALL "Very Small"
#define HEIGHT_EXTREMELY_SMALL "Extremely Small"

// MELBERT TODO: make it so you can input your own height
/datum/preference/choiced/height
	savefile_key = "character_height"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE

/datum/preference/choiced/height/init_possible_values()
	return list(
		HEIGHT_EXTREMELY_LARGE,
		HEIGHT_VERY_LARGE,
		HEIGHT_LARGE,
		HEIGHT_NO_CHANGE,
		HEIGHT_SMALL,
		HEIGHT_VERY_SMALL,
		HEIGHT_EXTREMELY_SMALL
	)

/datum/preference/choiced/height/apply_to_human(mob/living/carbon/human/target, value)
	if(value == HEIGHT_NO_CHANGE)
		return

	if(istype(target, /mob/living/carbon/human/dummy))
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

/datum/preference/choiced/height/is_accessible(datum/preferences/preferences)
	if(!..(preferences))
		return FALSE

	var/datum/job/fav_job = preferences.get_highest_priority_job()
	return !istype(fav_job, /datum/job/ai) || !istype(fav_job, /datum/job/cyborg)

/datum/preference/choiced/height/create_default_value(datum/preferences/preferences)
	return HEIGHT_NO_CHANGE

#undef HEIGHT_EXTREMELY_LARGE
#undef HEIGHT_VERY_LARGE
#undef HEIGHT_LARGE
#undef HEIGHT_NO_CHANGE
#undef HEIGHT_SMALL
#undef HEIGHT_VERY_SMALL
#undef HEIGHT_EXTREMELY_SMALL
