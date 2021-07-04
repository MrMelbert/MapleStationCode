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
/// Trilingual quirk - Gives the owner a language, either random or a set one.
/datum/quirk/trilingual
	name = "Language - Trilingual"
	desc = "You're trilingual - you know another random language besides common and your native tongue."
	value = 1
	gain_text = "<span class='notice'>You understand a new language.</span>"
	lose_text = "<span class='notice'>You no longer understand a new language.</span>"
	medical_record_text = "Patient is trilingual and knows multiple languages."
	/// The language we give out. If null, just grabs a random language.
	var/datum/language/added_language

/datum/quirk/trilingual/add()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	if(!added_language)
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

/datum/quirk/trilingual/post_add()
	if(!added_language)
		to_chat(quirk_holder, span_danger("Your quirk ([name]) is not compatible with your species or job for one reason or another."))
		return

	var/mob/living/carbon/human/human_quirk_holder = quirk_holder
	if(human_quirk_holder.dna?.species?.species_language_holder)
		var/datum/language/added_language_instance = new added_language
		var/datum/language_holder/species_languages = new human_quirk_holder.dna.species.species_language_holder(quirk_holder)
		if(species_languages.has_language(added_language, TRUE))
			to_chat(quirk_holder, span_info("Thanks to your past or species, you can now speak [added_language_instance.name]. You already could speak it, but now you can double speak it. I guess."))
		else if(species_languages.has_language(added_language, FALSE))
			to_chat(quirk_holder, span_info("Thanks to your past or species, you can now speak [added_language_instance.name]. You already could understand it, but now you can speak it."))
		else
			to_chat(quirk_holder, span_info("Thanks to your past or species, you know [added_language_instance.name]. It's not guaranteed you can speak it properly, but at least you can understand it."))
		qdel(species_languages)
		qdel(added_language_instance)

/datum/quirk/trilingual/remove()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	quirk_holder_languages.remove_language(added_language, TRUE, TRUE, LANGUAGE_QUIRK)

/// High draconic language. Only works on draconic speakers.
/datum/quirk/trilingual/high_draconic
	name = "Language - High Draconic"
	desc = "You're trilingual - you know old High Draconic. (This quirk only works for species that can speak draconic!)"
	value = 1
	gain_text = "<span class='notice'>You understand High Draconic.</span>"
	lose_text = "<span class='notice'>You no longer understand High Draconic.</span>"
	medical_record_text = "Patient is trilingual and knows High Draconic."
	added_language = /datum/language/impdraconic

/datum/quirk/trilingual/high_draconic/post_add()
	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	if(!quirk_holder_languages.has_language(/datum/language/draconic, TRUE))
		added_language = null
		return
	. = ..()

/datum/quirk/no_appendix
	name = "Appendicitis Survivor"
	desc = "You had a run in with appendicitis in the past and no longer have an appendix."
	value = 2
	gain_text = "<span class='notice'>You no longer have an appendix.</span>"
	lose_text = "<span class='danger'>You miss your appendix?</span>"
	medical_record_text = "Patient had appendicitis in the past and has had their appendix surgically removed as a consequence."

/datum/quirk/no_appendix/post_add()
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder
	var/obj/item/organ/appendix/dumb_appendix = carbon_quirk_holder.getorganslot(ORGAN_SLOT_APPENDIX)
	dumb_appendix.Remove(quirk_holder, TRUE)

// Less vulnerable to pain (lower pain modifier)
/datum/quirk/pain_resistance
	name = "Hypoalgesia"
	desc = "You're more resistant to pain - Your pain naturally decreases faster and you recieve less overall."
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
