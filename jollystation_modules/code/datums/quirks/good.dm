// -- Good Modular quirks. --

/// Blacklist for the random language quirk. We won't give these languages out.
#define LANGUAGE_QUIRK_RANDOM_BLACKLIST list( \
	/datum/language/uncommon, \
	/datum/language/common, \
	/datum/language/narsie, \
	/datum/language/xenocommon )

// Rebalance of existing quirks
/datum/quirk/jolly //haha
	value = 3

// New quirks
/// Trilingual quirk - Gives the owner a language.
/datum/quirk/trilingual
	name = "Trilingual"
	desc = "You're trilingual - you know another random language besides common and your native tongue. (If you take this quirk, you cannot select an additional language.)"
	icon = "globe"
	value = 1
	gain_text = "<span class='notice'>You understand a new language.</span>"
	lose_text = "<span class='notice'>You no longer understand a new language.</span>"
	medical_record_text = "Patient is trilingual and knows multiple languages."
	/// The language we added with this quirk.
	var/added_language

/datum/quirk/trilingual/add()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	added_language = pick(GLOB.all_languages - LANGUAGE_QUIRK_RANDOM_BLACKLIST)
	var/attempts = 1
	/// Try to find a language this mob doesn't already have.
	while(quirk_holder_languages.has_language(added_language))
		added_language = pick(GLOB.all_languages - LANGUAGE_QUIRK_RANDOM_BLACKLIST)
		attempts++
		//If we can't find a language after a dozen or two times, give up.
		if(attempts > GLOB.all_languages.len)
			added_language = null
			return

	quirk_holder_languages.grant_language(added_language, TRUE, TRUE, LANGUAGE_QUIRK)

	var/datum/language/added_language_instance = GLOB.language_datum_instances[added_language]
	if(quirk_holder_languages.has_language(added_language, TRUE))
		// We understand and speak the added language
		to_chat(quirk_holder, span_info("You know the [added_language_instance.name] language."))
	else if(quirk_holder_languages.has_language(added_language, FALSE))
		// We understand but may not be able to speak the added language
		to_chat(quirk_holder, span_info("You understand the [added_language_instance.name] language, but may not be able to speak it with your tongue."))

/datum/quirk/trilingual/remove()
	if(added_language)
		var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
		quirk_holder_languages.remove_language(added_language, TRUE, TRUE, LANGUAGE_QUIRK)

/datum/quirk/no_appendix
	name = "Appendicitis Survivor"
	desc = "You had a run in with appendicitis in the past and no longer have an appendix."
	icon = "notes-medical"
	value = 2
	gain_text = "<span class='notice'>You no longer have an appendix.</span>"
	lose_text = "<span class='danger'>You miss your appendix?</span>"
	medical_record_text = "Patient had appendicitis in the past and has had their appendix surgically removed as a consequence."

/datum/quirk/no_appendix/post_add()
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder
	var/obj/item/organ/appendix/dumb_appendix = carbon_quirk_holder.getorganslot(ORGAN_SLOT_APPENDIX)
	dumb_appendix?.Remove(quirk_holder, TRUE)

// Less vulnerable to pain (lower pain modifier)
/datum/quirk/pain_resistance
	name = "Hypoalgesia"
	desc = "You're more resistant to pain - Your pain naturally decreases faster and you receive less overall."
	icon = "fist-raised"
	value = 8
	gain_text = "<span class='notice'>You feel duller.</span>"
	lose_text = "<span class='danger'>You feel sharper.</span>"
	medical_record_text = "Patient has Hypoalgesia, and is less susceptible to pain stimuli than most."

/datum/quirk/pain_resistance/add()
	var/mob/living/carbon/carbon_holder = quirk_holder
	if(istype(carbon_holder))
		carbon_holder.set_pain_mod(PAIN_MOD_QUIRK, 0.9)

/datum/quirk/pain_resistance/remove()
	var/mob/living/carbon/carbon_holder = quirk_holder
	if(istype(carbon_holder))
		carbon_holder.unset_pain_mod(PAIN_MOD_QUIRK)

#undef LANGUAGE_QUIRK_RANDOM_BLACKLIST
