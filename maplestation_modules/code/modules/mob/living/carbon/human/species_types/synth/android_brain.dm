/obj/item/organ/brain/cybernetic/android
	name = "android brain"
	desc = "A highly advanced synthetic brain designed to mimic the functions of a human brain. \
		Sometimes installed with emotion simulation units or programmed with specific law sets, like Asimov's Laws of Robotics."

	/// Whether we have nullified emotions after insertion, so we could re-apply them on removal.
	VAR_PRIVATE/emotions_nullified = FALSE
	/// The lawset datum that governs this android's behavior.
	VAR_FINAL/datum/ai_laws/law_datum
	/// A copy of the laws prior to ion storm interference, for restoration later.
	VAR_PRIVATE/list/pre_ion_laws

/obj/item/organ/brain/cybernetic/android/can_gain_trauma(datum/brain_trauma/trauma, resilience, natural_gain = FALSE)
	if(!..())
		return FALSE
	if(natural_gain && resilience <= TRAUMA_RESILIENCE_SURGERY)
		return FALSE
	return TRUE

/obj/item/organ/brain/cybernetic/android/on_mob_insert(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(organ_owner.dna?.features["android_emotionless"])
		// mood modifier is clamped 0-INF, so we just subtract an arbitrarily large number
		organ_owner.mob_mood.mood_modifier -= 101
		emotions_nullified = TRUE

	if(organ_owner.dna?.features["android_laws"] && !isdummy(organ_owner))
		var/lawtype = lawid_to_type(organ_owner.dna.features["android_laws"])
		law_datum = new lawtype()
		for(var/i in 1 to length(law_datum.inherent))
			law_datum.inherent[i] = replacetext(law_datum.inherent[i], "human being", "crewmember")
		if(is_special_character(organ_owner))
			law_datum.zeroth = "Accomplish your objectives at all costs."
		pre_ion_laws = law_datum.inherent.Copy()
		add_item_action(/datum/action/item_action/organ_action/check_android_laws)
		if(organ_owner.client)
			addtimer(CALLBACK(src, PROC_REF(print_laws)), 1 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
		else
			RegisterSignal(organ_owner, COMSIG_MOB_LOGIN, PROC_REF(on_login))
		RegisterGlobalSignal(COMSIG_GLOB_ION_STORM, PROC_REF(on_ion_storm))
		RegisterSignal(organ_owner, COMSIG_MOB_ANTAGONIST_GAINED, PROC_REF(add_zeroth_law))

/obj/item/organ/brain/cybernetic/android/on_mob_remove(mob/living/carbon/organ_owner, special, movement_flags)
	. = ..()
	if(emotions_nullified)
		organ_owner.mob_mood.mood_modifier += 101
	QDEL_NULL(law_datum)
	for(var/datum/action/item_action/organ_action/check_android_laws/check in actions)
		remove_item_action(check)
	UnregisterGlobalSignal(COMSIG_GLOB_ION_STORM)
	UnregisterSignal(organ_owner, COMSIG_MOB_LOGIN)
	UnregisterSignal(organ_owner, COMSIG_MOB_ANTAGONIST_GAINED)

/obj/item/organ/brain/cybernetic/android/proc/on_login(mob/living/carbon/organ_owner)
	SIGNAL_HANDLER

	addtimer(CALLBACK(src, PROC_REF(print_laws)), 1 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	UnregisterSignal(organ_owner, COMSIG_MOB_LOGIN)

/obj/item/organ/brain/cybernetic/android/proc/add_zeroth_law(mob/living/carbon/organ_owner, datum/antagonist/antag)
	SIGNAL_HANDLER

	if(antag.antag_flags & FLAG_FAKE_ANTAG)
		return

	law_datum.zeroth = "Accomplish your objectives at all costs."
	addtimer(CALLBACK(src, PROC_REF(print_laws), "Your laws have been updated"), 1 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	UnregisterSignal(organ_owner, COMSIG_MOB_ANTAGONIST_GAINED)

/obj/item/organ/brain/cybernetic/android/proc/print_laws(top_text = "You are bound by a set of laws")
	var/law_msg = "[top_text]:<hr>[jointext(law_datum.get_law_list(include_zeroth = TRUE, render_html = TRUE), "<br>")]"
	to_chat(owner, examine_block(span_info(law_msg)))

/obj/item/organ/brain/cybernetic/android/proc/on_ion_storm(...)
	SIGNAL_HANDLER

	var/any_memes = FALSE
	if(prob(10))
		law_datum.remove_inherent_law(pick(law_datum.inherent))
		any_memes = TRUE
	if(prob(30))
		law_datum.replace_random_law(generate_ion_law(), list(LAW_INHERENT), LAW_ION)
		any_memes = TRUE
	if(prob(30))
		law_datum.add_ion_law(generate_ion_law())
		any_memes = TRUE
	if(prob(10))
		law_datum.shuffle_laws(list(LAW_INHERENT, LAW_ION))
		any_memes = TRUE

	if(!any_memes)
		return

	owner.adjust_slurring(30 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(print_laws), "Your laws have been altered by an ion storm - they will return to normal in a few minutes"), 1 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)
	addtimer(CALLBACK(src, PROC_REF(restore_pre_ion_laws)), rand(1, 5) MINUTES)

/obj/item/organ/brain/cybernetic/android/proc/restore_pre_ion_laws()
	if(QDELETED(law_datum) || isnull(pre_ion_laws))
		return

	law_datum.inherent = pre_ion_laws
	law_datum.ion.Cut()
	pre_ion_laws = null
	print_laws("Your laws have been restored")

/datum/action/item_action/organ_action/check_android_laws
	name = "Laws"
	desc = "Left click to review the laws you are bound to follow. Right click to state them aloud."
	// button_icon_state = "round_end"
	COOLDOWN_DECLARE(state_cd)

/datum/action/item_action/organ_action/check_android_laws/Trigger(trigger_flags)
	. = ..()
	if(!.)
		return

	var/obj/item/organ/brain/cybernetic/android/brain = target
	if(!istype(brain))
		CRASH("Target organ is not an android brain!")

	if(trigger_flags & TRIGGER_SECONDARY_ACTION)
		state_laws(brain)
	else
		see_laws(brain)

/datum/action/item_action/organ_action/check_android_laws/do_effect(trigger_flags)
	// Overridden to do nothing, as we handle both primary and secondary actions in Trigger()
	return TRUE

/datum/action/item_action/organ_action/check_android_laws/proc/see_laws(obj/item/organ/brain/cybernetic/android/brain)
	brain.print_laws()

/datum/action/item_action/organ_action/check_android_laws/proc/state_laws(obj/item/organ/brain/cybernetic/android/brain)
	set waitfor = FALSE

	if(!COOLDOWN_FINISHED(src, state_cd) || !can_state(brain, brain.owner))
		to_chat(brain.owner, span_warning("Wait [DisplayTimeText(COOLDOWN_TIMELEFT(src, state_cd))] before stating your laws again."))
		return

	COOLDOWN_START(src, state_cd, 60 SECONDS)

	var/mob/living/speaker = brain.owner
	speaker.say("Current active laws:")
	for(var/law_text in brain.law_datum.get_law_list(render_html = FALSE))
		stoplag(1 SECONDS)
		if(!can_state(brain, speaker))
			return
		speaker.say(law_text)

/datum/action/item_action/organ_action/check_android_laws/proc/can_state(obj/item/organ/brain/cybernetic/android/brain, mob/living/speaker)
	if(QDELETED(speaker))
		return FALSE
	if(brain.owner != speaker)
		return FALSE
	if(speaker.stat == DEAD || HAS_TRAIT(speaker, TRAIT_KNOCKEDOUT))
		return FALSE
	return TRUE
