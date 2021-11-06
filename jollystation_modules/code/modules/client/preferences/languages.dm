// -- Language preference and UI.

/// Simple define to denote no language.
#define NO_LANGUAGE "No Language"

/// List of species IDs of species's that can't get an additional language
#define BLACKLISTED_SPECIES_FROM_LANGUAGES list(SPECIES_SYNTH_MILITARY, SPECIES_SYNTH, SPECIES_ANDROID)

// Stores a typepath of a language, or "No language" when passed a null / invalid language.
/datum/preference/additional_language
	savefile_key = "language"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	priority = PREFERENCE_PRIORITY_NAMES
	can_randomize = FALSE

/datum/preference/additional_language/deserialize(input, datum/preferences/preferences)
	var/datum/species/species = preferences.read_preference(/datum/preference/choiced/species)
	var/datum/language/lang_to_add = input
	var/species_id = initial(species.id)

	if(species_id in BLACKLISTED_SPECIES_FROM_LANGUAGES)
		return NO_LANGUAGE
	if(!ispath(lang_to_add))
		return NO_LANGUAGE
	if(initial(lang_to_add.base_species) && initial(lang_to_add.base_species) == species_id)
		return NO_LANGUAGE
	if(initial(lang_to_add.req_species) && initial(lang_to_add.req_species) != species_id)
		return NO_LANGUAGE
	if("Trilingual" in preferences.all_quirks)
		return NO_LANGUAGE

	return input

/datum/preference/additional_language/serialize(input)
	return ispath(input) ? input : NO_LANGUAGE

/datum/preference/additional_language/create_default_value()
	return NO_LANGUAGE

/datum/preference/additional_language/is_valid(value)
	return ispath(value) || value == NO_LANGUAGE

/datum/preference/additional_language/apply_to_human(mob/living/carbon/human/target, value)
	if(value == NO_LANGUAGE)
		return

	target.grant_language(value, TRUE, TRUE, LANGUAGE_PREF)

/datum/language
	// Vars used in determining valid languages for the language preferences.
	/// The 'base species' of the language, the lizard to the draconic.
	var/base_species
	/// The 'required species' of the language, languages that require you be a certain species to know.
	var/req_species

/datum/language/skrell
	base_species = SPECIES_SKRELL

/datum/language/draconic
	base_species = SPECIES_LIZARD

/datum/language/impdraconic
	req_species = SPECIES_LIZARD

/datum/language/nekomimetic
	base_species = SPECIES_FELINE

/datum/language/moffic
	base_species = SPECIES_MOTH


/// TGUI for selecting languages.
/datum/language_picker
	/// The preferences our ui is linked to
	var/datum/preferences/owner_prefs

/datum/language_picker/New(datum/preferences/prefs)
	owner_prefs = prefs

/datum/language_picker/ui_close(mob/user)
	owner_prefs = null
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
			if(params["deselecting"])
				owner_prefs.write_preference(GLOB.preference_entries[/datum/preference/additional_language], NO_LANGUAGE)

			else
				var/datum/species/species = owner_prefs.read_preference(/datum/preference/choiced/species)
				var/species_id = initial(species.id)
				var/lang_path = text2path(params["langType"])
				var/datum/language/lang_to_add = GLOB.language_datum_instances[lang_path]
				if(!lang_to_add)
					return

				// Sanity checking
				if(lang_to_add.base_species && lang_to_add.base_species == species_id)
					to_chat(usr, span_warning("Invalid language for current species."))
					return

				if(lang_to_add.req_species && lang_to_add.req_species != species_id)
					to_chat(usr, span_warning("Language requires another species."))
					return

				// Write the preference
				owner_prefs.write_preference(GLOB.preference_entries[/datum/preference/additional_language], lang_path)

			return TRUE

/datum/language_picker/ui_data(mob/user)
	var/list/data = list()

	var/datum/species/species = owner_prefs.read_preference(/datum/preference/choiced/species)
	data["species"] = initial(species.id)
	data["selected_lang"] = owner_prefs.read_preference(/datum/preference/additional_language)
	data["trilingual"] = ("Trilingual" in owner_prefs.all_quirks)
	data["pref_name"] = owner_prefs.read_preference(/datum/preference/name/real_name)

	return data

/datum/language_picker/ui_static_data(mob/user)
	var/list/data = list()

	data["blacklisted_species"] = BLACKLISTED_SPECIES_FROM_LANGUAGES
	data["base_languages"] = list()
	data["bonus_languages"] = list()

	for(var/found_language in GLOB.language_datum_instances)
		var/datum/language/found_instance = GLOB.language_datum_instances[found_language]
		var/list/lang_data = list()
		lang_data["name"] = found_instance.name
		lang_data["type"] = found_language

		if(found_instance.base_species)
			lang_data["barred_species"] = found_instance.base_species
			data["base_languages"] += list(lang_data)

		if(found_instance.req_species)
			lang_data["allowed_species"] = found_instance.req_species
			data["bonus_languages"] += list(lang_data)

	return data

#undef NO_LANGUAGE
#undef BLACKLISTED_SPECIES_FROM_LANGUAGES
