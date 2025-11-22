// -- Good Modular quirks. --

// Rebalance of existing quirks
/datum/quirk/jolly
	value = 3

// New quirks
/*
/// Trilingual quirk - Gives the owner a language.
/datum/quirk/trilingual
	name = "Trilingual"
	desc = "You're trilingual (or bilingual if you're a human) - \
		you know another completely random language besides common and your native tongue. \
		(If you take this quirk, you cannot pick a language via the Language Picker.)"
	icon = FA_ICON_GLOBE
	value = 1
	gain_text = span_notice("You understand a new language.")
	lose_text = span_notice("You no longer understand a new language.")
	medical_record_text = "Patient is trilingual and knows multiple languages."
	mail_goodies = list(/obj/item/taperecorder)
	/// The language we added with this quirk.
	var/datum/language/added_language

/datum/quirk/trilingual/add()
	var/list/possible_languages = GLOB.all_languages.Copy() - list(
		/datum/language/common,
		/datum/language/eldritch,
		/datum/language/isatoa,
		/datum/language/narsie,
		/datum/language/ratvarian,
		/datum/language/uncommon,
		/datum/language/xenocommon,
	)

	var/datum/language_holder/quirk_holder_languages = quirk_holder.get_language_holder()
	added_language = pick(possible_languages)
	var/attempts = 1
	/// Try to find a language this mob doesn't already have.
	while(quirk_holder_languages.has_language(added_language))
		added_language = pick(possible_languages)
		attempts++
		//If we can't find a language after a dozen or two times, give up.
		if(attempts > length(possible_languages))
			added_language = null
			return

	quirk_holder_languages.grant_language(added_language, ALL, LANGUAGE_QUIRK)

	if(quirk_holder_languages.has_language(added_language, ALL))
		to_chat(quirk_holder, span_info("You know the [initial(added_language.name)] \
			language[quirk_holder_languages.can_speak_language(added_language) ? "" : ", though you may not be able to speak it with your tongue"]."))

/datum/quirk/trilingual/remove()
	if(added_language && !QDELETED(quirk_holder))
		quirk_holder.get_language_holder().remove_language(added_language, ALL, LANGUAGE_QUIRK)
*/

/datum/quirk/no_appendix
	name = "Appendicitis Survivor"
	desc = "You had a run in with appendicitis in the past and no longer have an appendix."
	icon = FA_ICON_NOTES_MEDICAL
	value = 2
	gain_text = "<span class='notice'>You no longer have an appendix.</span>"
	lose_text = "<span class='danger'>You miss your appendix?</span>"
	medical_record_text = "Patient had appendicitis in the past and has had their appendix surgically removed as a consequence."
	mail_goodies = list(/obj/item/stack/medical/gauze)

/datum/quirk/no_appendix/post_add()
	var/mob/living/carbon/carbon_quirk_holder = quirk_holder
	var/obj/item/organ/appendix/dumb_appendix = carbon_quirk_holder.get_organ_slot(ORGAN_SLOT_APPENDIX)
	dumb_appendix?.Remove(quirk_holder, TRUE)

// Less vulnerable to pain (lower pain modifier)
/datum/quirk/pain_resistance
	name = "Hypoalgesia"
	desc = "You're more resistant to pain - Your pain naturally decreases faster and you receive less overall."
	icon = FA_ICON_FIST_RAISED
	value = 8
	gain_text = "<span class='notice'>You feel duller.</span>"
	lose_text = "<span class='danger'>You feel sharper.</span>"
	medical_record_text = "Patient has Hypoalgesia, and is less susceptible to pain stimuli than most."
	mail_goodies = list(/obj/item/temperature_pack/heat)

/datum/quirk/pain_resistance/add()
	var/mob/living/carbon/carbon_holder = quirk_holder
	if(istype(carbon_holder))
		carbon_holder.set_pain_mod(PAIN_MOD_QUIRK, 0.9)

/datum/quirk/pain_resistance/remove()
	var/mob/living/carbon/carbon_holder = quirk_holder
	if(istype(carbon_holder))
		carbon_holder.unset_pain_mod(PAIN_MOD_QUIRK)

/datum/quirk/prosthetic_organ
	icon = FA_ICON_HEART_BROKEN

/// You can sprint for longer
/// (Maybe tie this to the mob's lungs? An idea)
/datum/quirk/marthon_runner
	name = "Marathon Runner"
	desc = "You can run for longer without getting tired."
	icon = FA_ICON_LUNGS
	value = 6
	gain_text = span_notice("You feel like you can run for miles (or kilometers).")
	lose_text = span_danger("You feel winded.")
	medical_record_text = "Patient can run for longer than most."

/datum/quirk/marthon_runner/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(istype(human_holder))
		human_holder.sprint_length_max *= 1.5
		human_holder.sprint_length = human_holder.sprint_length_max

/datum/quirk/marthon_runner/remove(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder
	if(istype(human_holder))
		human_holder.sprint_length_max /= 1.5
		human_holder.sprint_length = human_holder.sprint_length_max

/datum/quirk/power_granting/psionic
	name = "Psionic"
	desc = "You are able to manipulate and control the flow of mana with your mind."
	icon = FA_ICON_BRAIN
	value = 2
	mob_trait = TRAIT_FULL_PSIONIC
	gain_text = span_notice("You feel as if you can see a form of light you've never seen before.")
	lose_text = span_danger("You feel as if a part of your being was ripped from you.")
	medical_record_text = "Patient displays provable extrasensory perception."
	action_type = /datum/action/cooldown/spell/touch/mana_tap



