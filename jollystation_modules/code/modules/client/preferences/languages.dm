
#define NO_LANGUAGE "No Language"

/datum/preference/choiced/additional_language
	savefile_key = "language"
	savefile_identifier = PREFERENCE_CHARACTER
	category = PREFERENCE_CATEGORY_SECONDARY_FEATURES
	can_randomize = FALSE

/datum/preference/choiced/additional_language/init_possible_values()
	return list(NO_LANGUAGE, "Skrellian", "Nekomimetic", "Moffic", "Draconic", "High Draconic")

/datum/preference/choiced/additional_language/create_default_value()
	return NO_LANGUAGE

/datum/preference/choiced/additional_language/is_accessible(datum/preferences/preferences)
	. = ..()
	if(!.)
		return

	// Not compatible with trilingual.
	if("Trilingual" in preferences.all_quirks)
		return FALSE

	return TRUE

// We need to apply our language at the very end
/datum/preference/choiced/additional_language/apply_to_human(mob/living/carbon/human/target, value)
	return

/datum/preference/choiced/additional_language/after_apply_to_human(mob/living/carbon/human/target, datum/preferences/prefs, value)
	if(!prefs)
		CRASH("language preference after_apply_to_human called without preferences datum.")

	if(value == NO_LANGUAGE)
		return

	if("Trilingual" in prefs.all_quirks)
		prefs.write_preference(GLOB.preference_entries[type], NO_LANGUAGE)
		return

	var/datum/language/language_type
	var/datum/language/language_instance
	for(var/found_language in GLOB.language_datum_instances)
		var/datum/language/found_instance = GLOB.language_datum_instances[found_language]
		if(found_instance.name == value)
			language_type = found_language
			language_instance = found_instance
			break

	if(!language_type || !language_instance)
		CRASH("language preference after_apply_to_human could not find a corresponding [language_type ? "language instance" : "language type"]! passed value: [value]")

	var/datum/language_holder/target_languages = target.get_language_holder()

	if(language_type in target_languages.spoken_languages)
		to_chat(prefs.parent, span_notice("You already know the [value] language."))
		prefs.write_preference(GLOB.preference_entries[type], NO_LANGUAGE)
		return

	if( \
		(language_type in target_languages.blocked_languages) \
		|| (LAZYLEN(language_instance.blacklist_species_on_roundstart) && (target.dna.species in language_instance.blacklist_species_on_roundstart)) \
		|| (LAZYLEN(language_instance.whitelist_species_on_roundstart) && !(target.dna.species in language_instance.whitelist_species_on_roundstart)) \
	)
		to_chat(prefs.parent, span_notice("Your species, [target.dna.species.name], cannot learn the [value] language."))
		prefs.write_preference(GLOB.preference_entries[type], NO_LANGUAGE)
		return

	target.grant_language(language_type, TRUE, TRUE, LANGUAGE_PREF)
	to_chat(prefs.parent, span_notice("Either due to your past or species, you know the [value] language."))

#undef NO_LANGUAGE
