// -- Language preference and UI.

/// Simple define to denote no language.
#define NO_LANGUAGE "No Language"

/datum/preference/choiced/language
	savefile_key = "bilingual_language"

// Stores a typepath of a language, or "No language" when passed a null / invalid language.
/datum/preference/additional_language
	savefile_key = "language"
	savefile_identifier = PREFERENCE_CHARACTER
	priority = PREFERENCE_PRIORITY_NAMES // needs to happen after species, so name works
	can_randomize = FALSE

/datum/preference/additional_language/deserialize(input, datum/preferences/preferences)
	if(input == NO_LANGUAGE)
		return NO_LANGUAGE
	if("Trilingual" in preferences.all_quirks)
		return NO_LANGUAGE
	if("Bilingual" in preferences.all_quirks)
		return NO_LANGUAGE

	var/datum/language/lang_to_add = check_input_path(input)
	if(!ispath(lang_to_add, /datum/language))
		return NO_LANGUAGE

	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	var/banned = initial(lang_to_add.banned_from_species)
	var/req = initial(lang_to_add.required_species)
	if((banned && ispath(species, banned)) || (req && !ispath(species, req)))
		return NO_LANGUAGE

	return lang_to_add

/datum/preference/additional_language/serialize(input)
	return check_input_path(input) || NO_LANGUAGE

/datum/preference/additional_language/create_default_value()
	return NO_LANGUAGE

/datum/preference/additional_language/is_valid(value)
	return !!check_input_path(value)

/// Checks if our passed input is valid
/// Returns NO LANGUAGE if passed NO LANGUAGE (truthy value)
/// Returns null if the input was invalid (falsy value)
/// Returns a language typepath if the input was a valid path (truthy value)
/datum/preference/additional_language/proc/check_input_path(input)
	if(input == NO_LANGUAGE)
		return NO_LANGUAGE

	var/path_form = istext(input) ? text2path(input) : input
	// sometimes we deserialize with a text string that is a path, as they're saved as string in our json save
	// other times we recieve a full typepath, likely from write preference
	// we need to support either case just to be inclusive, so here we are	var/path_form = istext(input) ? text2path(input) : input
	if(!ispath(path_form, /datum/language))
		return null

	var/datum/language/lang_instance = GLOB.language_datum_instances[path_form]
	// MAYBE accessed when language datums aren't created so this is just a sanity check
	if(istype(lang_instance) && !lang_instance.available_as_pref)
		return null

	return path_form

/datum/preference/additional_language/apply_to_human(mob/living/carbon/human/target, value)
	if(value == NO_LANGUAGE)
		return

	target.grant_language(value, ALL, LANGUAGE_PREF)

/datum/language
	// Vars used in determining valid languages for the language preferences.
	/// Whether this language is available as a pref.
	var/available_as_pref = FALSE
	/// The 'base species' of the language, the lizard to the draconic.
	/// Players cannot select this language in the preferences menu if they already have this species set.
	var/datum/species/banned_from_species
	/// The 'required species' of the language, languages that require you be a certain species to know.
	/// Players cannot select this language in the preferences menu if they do not have this species set.
	var/datum/species/required_species

/datum/language/skrell
	available_as_pref = TRUE
	banned_from_species = /datum/species/skrell

/datum/language/draconic
	available_as_pref = TRUE
	banned_from_species = /datum/species/lizard

/datum/language/impdraconic
	available_as_pref = TRUE
	banned_from_species = /datum/species/lizard/silverscale // already know it (though this check should be deharcoded)
	required_species = /datum/species/lizard

/datum/language/nekomimetic
	available_as_pref = TRUE
	banned_from_species = /datum/species/human/felinid

/datum/language/moffic
	available_as_pref = TRUE
	banned_from_species = /datum/species/moth

/datum/language/uncommon
	available_as_pref = TRUE

/datum/language/piratespeak
	available_as_pref = TRUE

/datum/language/yangyu
	available_as_pref = TRUE
	banned_from_species = /datum/species/ornithid

/datum/language/shadowtongue
	available_as_pref = TRUE

/datum/preference_middleware/language
	action_delegations = list(
		"set_language" = PROC_REF(set_language),
	)

/datum/preference_middleware/language/proc/set_language(list/params, mob/user)
	var/datum/preference/additional_language/language_pref = GLOB.preference_entries[/datum/preference/additional_language]
	if(params["deselecting"])
		preferences.update_preference(language_pref, NO_LANGUAGE)
		return TRUE

	var/lang_path = text2path(params["lang_type"])
	var/datum/species/current_species = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/language/lang_to_add = GLOB.language_datum_instances[lang_path]
	if(!istype(lang_to_add))
		to_chat(user, span_warning("Invalid language."))
		return TRUE
	if(!lang_to_add.available_as_pref)
		to_chat(user, span_warning("That language is not available."))
		return TRUE
	// Sanity checking - Buttons are disabled in UI but you can never rely on that
	if(lang_to_add.banned_from_species && ispath(current_species, lang_to_add.banned_from_species))
		to_chat(user, span_warning("Invalid language for current species."))
		return TRUE
	if(lang_to_add.required_species && !ispath(current_species, lang_to_add.required_species))
		to_chat(user, span_warning("Language requires another species."))
		return TRUE

	preferences.update_preference(language_pref, lang_path)
	return TRUE

/datum/preference_middleware/language/get_ui_data(mob/user)
	var/list/data = list()

	data["selected_lang"] = preferences.read_preference(/datum/preference/additional_language)
	data["selected_species"] = preferences.read_preference(/datum/preference/choiced/species)
	data["pref_name"] = preferences.read_preference(/datum/preference/name/real_name)
	data["trilingual"] = ("Trilingual" in preferences.all_quirks)
	data["bilingual"] = ("Bilingual" in preferences.all_quirks)

	return data

/datum/preference_middleware/language/get_constant_data()
	var/list/data = list()
	var/list/base_languages = list()
	var/list/bonus_languages = list()
	for(var/found_language in GLOB.language_datum_instances)
		var/datum/language/found_instance = GLOB.language_datum_instances[found_language]
		if(!found_instance.available_as_pref)
			continue

		var/list/lang_data = list()
		lang_data["name"] = found_instance.name
		lang_data["type"] = found_language

		var/datum/species/banned_species = found_instance.banned_from_species
		if(banned_species)
			lang_data["incompatible_with"] = list("name" = initial(banned_species.name), "type" = banned_species)
		var/datum/species/required_species = found_instance.required_species
		if(required_species)
			lang_data["requires"] = list("name" = initial(required_species.name), "type" = required_species)

		// Having a required species makes it a bonus language, otherwise it's a base language
		if(found_instance.required_species)
			UNTYPED_LIST_ADD(bonus_languages, lang_data)
		else
			UNTYPED_LIST_ADD(base_languages, lang_data)

	data["base_languages"] = base_languages
	data["bonus_languages"] = bonus_languages
	data["blacklisted_species"] = list()
	return data

#undef NO_LANGUAGE
