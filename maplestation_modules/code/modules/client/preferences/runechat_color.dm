// Allows the player to select a runechat color.
/datum/preference/color/runechat_color
	savefile_key = "runechat_color"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_NAME_MODIFICATIONS // go after names please
	category = PREFERENCE_CATEGORY_NON_CONTEXTUAL
	nullable = TRUE

/datum/preference/color/runechat_color/create_default_value()
	return null

/datum/preference/color/runechat_color/apply_to_human(mob/living/carbon/human/target, value)
	if(isnull(value))
		return

	target.chat_color = value
	target.chat_color_darkened = value
	target.chat_color_name = target.name
	GLOB.forced_runechat_names[target.name] = value

/datum/preference/color/runechat_color/is_valid(value)
	return ..() && (isnull(value) || !is_color_dark(value))
