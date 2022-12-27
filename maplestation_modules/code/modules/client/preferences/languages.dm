// -- Language preference and UI.

/// Simple define to denote no language.
#define NO_LANGUAGE "No Language"

/// List of species IDs of species's that can't get an additional language
#define BLACKLISTED_SPECIES_FROM_LANGUAGES list(SPECIES_SYNTH, SPECIES_ANDROID)

// Stores a typepath of a language, or "No language" when passed a null / invalid language.
/datum/preference/additional_language
	savefile_key = "language"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_NAMES
	can_randomize = FALSE

/datum/preference/additional_language/deserialize(input, datum/preferences/preferences)
	if(input == NO_LANGUAGE)
		return NO_LANGUAGE
	if("Trilingual" in preferences.all_quirks)
		return NO_LANGUAGE

	var/datum/language/lang_to_add = check_input_path(input)
	if(!ispath(lang_to_add, /datum/language))
		return NO_LANGUAGE

	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	var/species_id = initial(species.id)
	if(species_id in BLACKLISTED_SPECIES_FROM_LANGUAGES)
		return NO_LANGUAGE

	var/banned = initial(lang_to_add.banned_from_species_id)
	if(banned && banned == species_id)
		return NO_LANGUAGE

	var/req = initial(lang_to_add.required_species_id)
	if(req && req != species_id)
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

	target.grant_language(value, TRUE, TRUE, LANGUAGE_PREF)

/datum/language
	// Vars used in determining valid languages for the language preferences.
	/// Whether this language is available as a pref.
	var/available_as_pref = FALSE
	/// The 'base species' of the language, the lizard to the draconic.
	/// Players cannot select this language in the preferences menu if they already have this species set.
	var/banned_from_species_id
	/// The 'required species' of the language, languages that require you be a certain species to know.
	/// Players cannot select this language in the preferences menu if they do not have this species set.
	var/required_species_id

/datum/language/skrell
	available_as_pref = TRUE
	banned_from_species_id = SPECIES_SKRELL

/datum/language/draconic
	available_as_pref = TRUE
	banned_from_species_id = SPECIES_LIZARD

/datum/language/impdraconic
	available_as_pref = TRUE
	required_species_id = SPECIES_LIZARD

/datum/language/nekomimetic
	available_as_pref = TRUE
	banned_from_species_id = SPECIES_FELINE

/datum/language/moffic
	available_as_pref = TRUE
	banned_from_species_id = SPECIES_MOTH

/datum/language/uncommon
	available_as_pref = TRUE
	required_species_id = SPECIES_HUMAN

/datum/language/piratespeak
	available_as_pref = TRUE

/datum/language/yangyu
	available_as_pref = TRUE

/// TGUI for selecting languages.
/datum/language_picker
	/// The preferences our ui is linked to
	var/datum/preferences/owner_prefs
	/// Static list of all "base" languages learnable via ui
	/// (roundstart languages, languages readily available / common)
	var/static/list/base_languages
	/// Static list of all "bonus" languages learnable via ui
	/// (rarer languages, not typically available roundstart, dictated by a required_species_id)
	var/static/list/bonus_languages

/datum/language_picker/New(datum/preferences/prefs)
	owner_prefs = prefs

/datum/language_picker/Destroy()
	owner_prefs = null
	return ..()

/datum/language_picker/ui_close(mob/user)
	qdel(src)

/datum/language_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/language_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "_LanguagePicker")
		ui.open()

/datum/language_picker/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("set_language")
			var/datum/preference/additional_language/language_pref = GLOB.preference_entries[/datum/preference/additional_language]
			if(params["deselecting"])
				owner_prefs.write_preference(language_pref, NO_LANGUAGE)

			else
				var/datum/species/species = owner_prefs.read_preference(/datum/preference/choiced/species)
				var/species_id = initial(species.id)
				var/lang_path = text2path(params["lang_type"])
				var/datum/language/lang_to_add = GLOB.language_datum_instances[lang_path]
				if(!istype(lang_to_add))
					to_chat(usr, span_warning("Invalid language."))
					return
				if(!lang_to_add.available_as_pref)
					to_chat(usr, span_warning("That language is not available."))
					return

				// Sanity checking - Buttons are disabled in UI but you can never rely on that
				if(lang_to_add.banned_from_species_id && lang_to_add.banned_from_species_id == species_id)
					to_chat(usr, span_warning("Invalid language for current species."))
					return
				if(lang_to_add.required_species_id && lang_to_add.required_species_id != species_id)
					to_chat(usr, span_warning("Language requires another species."))
					return

				// Write the preference
				owner_prefs.write_preference(language_pref, lang_path)

			return TRUE

/datum/language_picker/ui_data(mob/user)
	var/list/data = list()

	var/datum/species/species = owner_prefs.read_preference(/datum/preference/choiced/species)
	data["selected_lang"] = owner_prefs.read_preference(/datum/preference/additional_language)
	data["pref_name"] = owner_prefs.read_preference(/datum/preference/name/real_name)
	data["trilingual"] = ("Trilingual" in owner_prefs.all_quirks)
	data["species"] = initial(species.id)

	return data

/datum/language_picker/ui_static_data(mob/user)
	var/list/data = list()

	if(!base_languages || !bonus_languages)
		base_languages = list()
		bonus_languages = list()

		for(var/found_language in GLOB.language_datum_instances)
			var/datum/language/found_instance = GLOB.language_datum_instances[found_language]
			if(!found_instance.available_as_pref)
				continue

			var/list/lang_data = list()
			lang_data["name"] = found_instance.name
			lang_data["type"] = found_language
			lang_data["barred_species"] = found_instance.banned_from_species_id
			lang_data["allowed_species"] = found_instance.required_species_id
			// Having a required species makes it a bonus language, otherwise it's a base language
			if(found_instance.required_species_id)
				UNTYPED_LIST_ADD(bonus_languages, lang_data)
			else
				UNTYPED_LIST_ADD(base_languages, lang_data)

	data["blacklisted_species"] = BLACKLISTED_SPECIES_FROM_LANGUAGES
	data["base_languages"] = base_languages
	data["bonus_languages"] = bonus_languages
	return data

#undef NO_LANGUAGE
#undef BLACKLISTED_SPECIES_FROM_LANGUAGES
