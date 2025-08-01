//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild
	abstract_type = /datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "Hallucinations"
	desc = "Patient suffers constant hallucinations."
	scan_desc = "schizophrenia"
	gain_text = span_warning("You feel your grip on reality slipping...")
	lose_text = span_notice("You feel more grounded.")
	/// Whether the hallucinations we give are uncapped, ie all the wacky ones
	var/uncapped = FALSE

/datum/brain_trauma/mild/hallucinations/on_life(seconds_per_tick, times_fired)
	if(owner.stat >= UNCONSCIOUS)
		return
	if(HAS_TRAIT(owner, TRAIT_RDS_SUPPRESSED))
		owner.adjust_hallucinations(-10 SECONDS * seconds_per_tick)
		return

	owner.adjust_hallucinations_up_to(((uncapped ? 12 SECONDS : 5 SECONDS) * seconds_per_tick), (uncapped ? 240 SECONDS : 60 SECONDS))

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.remove_status_effect(/datum/status_effect/hallucination)
	return ..()

/datum/brain_trauma/mild/stuttering
	name = "Stuttering"
	desc = "Patient can't speak properly."
	scan_desc = "reduced mouth coordination"
	gain_text = span_warning("Speaking clearly is getting harder.")
	lose_text = span_notice("You feel in control of your speech.")

/datum/brain_trauma/mild/stuttering/on_life(seconds_per_tick, times_fired)
	owner.adjust_stutter_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.remove_status_effect(/datum/status_effect/speech/stutter)
	return ..()

/datum/brain_trauma/mild/dumbness
	name = "Dumbness"
	desc = "Patient has reduced brain activity, making them less intelligent."
	scan_desc = "reduced brain activity"
	gain_text = span_warning("You feel dumber.")
	lose_text = span_notice("You feel smart again.")

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.add_mood_event("dumb", /datum/mood_event/oblivious)
	return ..()

/datum/brain_trauma/mild/dumbness/on_life(seconds_per_tick, times_fired)
	owner.adjust_derpspeech_up_to(5 SECONDS * seconds_per_tick, 50 SECONDS)
	if(SPT_PROB(1.5, seconds_per_tick))
		owner.emote("drool")
	// else if(owner.stat == CONSCIOUS && SPT_PROB(1.5, seconds_per_tick)) // NON-MODULE CHANGE
	// 	owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage", filterproof = TRUE) // NON-MODULE CHANGE

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.remove_status_effect(/datum/status_effect/speech/stutter/derpspeech)
	owner.clear_mood_event("dumb")
	return ..()

/datum/brain_trauma/mild/speech_impediment
	name = "Speech Impediment"
	desc = "Patient is unable to form coherent sentences."
	scan_desc = "communication disorder"
	gain_text = span_danger("You can't seem to form any coherent thoughts!")
	lose_text = span_danger("Your mind feels more clear.")

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "Concussion"
	desc = "Patient's brain is concussed."
	scan_desc = "concussion"
	gain_text = span_warning("Your head hurts!")
	lose_text = span_notice("The pressure inside your head starts fading.")

/datum/brain_trauma/mild/concussion/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(2.5, seconds_per_tick))
		switch(rand(1,11))
			if(1)
				owner.vomit(VOMIT_CATEGORY_DEFAULT)
			if(2,3)
				owner.adjust_dizzy(20 SECONDS)
			if(4,5)
				owner.adjust_confusion(10 SECONDS)
				owner.set_eye_blur_if_lower(20 SECONDS)
			if(6 to 9)
				owner.adjust_slurring(1 MINUTES)
			if(10)
				to_chat(owner, span_notice("You forget for a moment what you were doing."))
				owner.Stun(20)
			if(11)
				to_chat(owner, span_warning("You faint."))
				owner.Unconscious(80)
	if(SPT_PROB(1, seconds_per_tick))
		owner.cause_pain(BODY_ZONE_HEAD, 10)
	return ..()

/datum/brain_trauma/mild/healthy
	name = "Anosognosia"
	desc = "Patient always feels healthy, regardless of their condition."
	scan_desc = "self-awareness deficit"
	gain_text = span_notice("You feel great!")
	lose_text = span_warning("You no longer feel perfectly healthy.")

/datum/brain_trauma/mild/healthy/on_gain()
	owner.apply_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	return ..()

/datum/brain_trauma/mild/healthy/on_life(seconds_per_tick, times_fired)
	owner.adjustStaminaLoss(-7.5 * seconds_per_tick) //no pain, no fatigue

/datum/brain_trauma/mild/healthy/on_lose()
	owner.remove_status_effect(/datum/status_effect/grouped/screwy_hud/fake_healthy, type)
	return ..()

/datum/brain_trauma/mild/muscle_weakness
	name = "Muscle Weakness"
	desc = "Patient experiences occasional bouts of muscle weakness."
	scan_desc = "weak motor nerve signal"
	gain_text = span_warning("Your muscles feel oddly faint.")
	lose_text = span_notice("You feel in control of your muscles again.")

/datum/brain_trauma/mild/muscle_weakness/on_life(seconds_per_tick, times_fired)
	var/fall_chance = 1
	if(owner.move_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(SPT_PROB(0.5 * fall_chance, seconds_per_tick) && owner.body_position == STANDING_UP && !owner.buckled)
		to_chat(owner, span_warning("Your leg gives out!"))
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(SPT_PROB(0.5 * drop_chance, seconds_per_tick) && owner.dropItemToGround(I))
			to_chat(owner, span_warning("You drop [I]!"))

	else if(SPT_PROB(1.5, seconds_per_tick) && owner.getStaminaLoss() < 100)
		to_chat(owner, span_warning("You feel a sudden weakness in your muscles!"))
		owner.apply_damage(25, STAMINA, BODY_ZONE_L_LEG)
		owner.apply_damage(25, STAMINA, BODY_ZONE_R_LEG)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "Muscle Spasms"
	desc = "Patient has occasional muscle spasms, causing them to move unintentionally."
	scan_desc = "nervous fits"
	gain_text = span_warning("Your muscles feel oddly faint.")
	lose_text = span_notice("You feel in control of your muscles again.")

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(/datum/status_effect/spasms)
	..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(/datum/status_effect/spasms)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "Nervous Cough"
	desc = "Patient feels a constant need to cough."
	scan_desc = "nervous cough"
	gain_text = span_warning("Your throat itches incessantly...")
	lose_text = span_notice("Your throat stops itching.")

/datum/brain_trauma/mild/nervous_cough/on_life(seconds_per_tick, times_fired)
	if(SPT_PROB(6, seconds_per_tick) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		if(prob(5))
			to_chat(owner, span_warning("[pick("You have a coughing fit!", "You can't stop coughing!")]"))
			owner.Immobilize(20)
			owner.emote("cough")
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/, emote), "cough"), 0.6 SECONDS)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/, emote), "cough"), 1.2 SECONDS)
		owner.emote("cough")
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "Expressive Aphasia"
	desc = "Patient is affected by partial loss of speech leading to a reduced vocabulary."
	scan_desc = "inability to form complex sentences"
	gain_text = span_warning("You lose your grasp on complex words.")
	lose_text = span_notice("You feel your vocabulary returning to normal again.")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = ""
			var/suffix_foundon = 0
			for(var/potential_suffix in list("." , "," , ";" , "!" , ":" , "?"))
				suffix_foundon = findtext(word, potential_suffix, -length(potential_suffix))
				if(suffix_foundon)
					suffix = potential_suffix
					break

			if(suffix_foundon)
				word = copytext(word, 1, suffix_foundon)
			word = html_decode(word)

			if(GLOB.most_common_words[lowertext(word)])
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("uh","erm")
					break
				else
					var/list/charlist = text2charlist(word)
					charlist.len = round(charlist.len * 0.5, 1)
					shuffle_inplace(charlist)
					new_message += jointext(charlist, "") + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/brain_trauma/mild/mind_echo
	name = "Mind Echo"
	desc = "Patient's language neurons do not terminate properly, causing previous speech patterns to occasionally resurface spontaneously."
	scan_desc = "looping neural pattern"
	gain_text = span_warning("You feel a faint echo of your thoughts...")
	lose_text = span_notice("The faint echo fades away.")
	var/list/hear_dejavu = list()
	var/list/speak_dejavu = list()

/datum/brain_trauma/mild/mind_echo/handle_hearing(datum/source, list/hearing_args)
	if(!owner.can_hear() || owner == hearing_args[HEARING_SPEAKER])
		return

	if(hear_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(hear_dejavu)
			var/static/regex/quoted_spoken_message = regex("\".+\"", "gi")
			hearing_args[HEARING_RAW_MESSAGE] = quoted_spoken_message.Replace(hearing_args[HEARING_RAW_MESSAGE], "\"[deja_vu]\"") //Quotes included to avoid cases where someone says part of their name
			return
	if(hear_dejavu.len >= 15)
		if(prob(50))
			popleft(hear_dejavu) //Remove the oldest
			hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]
	else
		hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]

/datum/brain_trauma/mild/mind_echo/handle_speech(datum/source, list/speech_args)
	if(speak_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(speak_dejavu)
			speech_args[SPEECH_MESSAGE] = deja_vu
			return
	if(speak_dejavu.len >= 15)
		if(prob(50))
			popleft(speak_dejavu) //Remove the oldest
			speak_dejavu += speech_args[SPEECH_MESSAGE]
	else
		speak_dejavu += speech_args[SPEECH_MESSAGE]

/datum/brain_trauma/mild/color_blindness
	name = "Achromatopsia"
	desc = "Patient's occipital lobe is unable to recognize and interpret color, rendering the patient completely colorblind."
	scan_desc = "colorblindness"
	gain_text = span_warning("The world around you seems to lose its color.")
	lose_text = span_notice("The world feels bright and colorful again.")

/datum/brain_trauma/mild/color_blindness/on_gain()
	owner.add_client_colour(/datum/client_colour/monochrome/colorblind)
	return ..()

/datum/brain_trauma/mild/color_blindness/on_lose(silent)
	owner.remove_client_colour(/datum/client_colour/monochrome/colorblind)
	return ..()
