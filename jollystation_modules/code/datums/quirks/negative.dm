// -- Bad modular quirks. --

// Rebalance of existing quirks
/datum/quirk/nearsighted
	value = -2

/datum/quirk/bad_touch
	value = -2

// Modular quirks
// More vulnerabile to pain (increased pain modifier)
/datum/quirk/pain_vulnerability
	name = "Hyperalgesia"
	desc = "You're less resistant to pain - Your pain naturally decreases slower and you recieve more overall."
	value = -6
	gain_text = "<span class='danger'>You feel sharper.</span>"
	lose_text = "<span class='notice'>You feel duller.</span>"
	medical_record_text = "Patient has Hyperalgesia, and is more susceptible to pain stimuli than most."

/datum/quirk/pain_vulnerability/add()
	quirk_holder.pain_controller?.set_pain_modifier(PAIN_MOD_QUIRK, 1.15)

/datum/quirk/pain_vulnerability/remove()
	quirk_holder.pain_controller?.unset_pain_modifier(PAIN_MOD_QUIRK)

// More vulnerable to pain + get pain from more actions (Glass bones and paper skin)
/datum/quirk/allodynia
	name = "Allodynia"
	desc = "Your nerves are extremely sensitive - you may recieve pain from things that wouldn't normally be painful, such as hugs."
	value = -8
	gain_text = "<span class='danger'>You feel fragile.</span>"
	lose_text = "<span class='notice'>You feel less delicate.</span>"
	medical_record_text = "Patient has Allodynia, and is extremely sensitive to touch, pain, and similar stimuli."
	COOLDOWN_DECLARE(time_since_last_touch)

/datum/quirk/allodynia/add()
	quirk_holder.pain_controller?.set_pain_modifier(PAIN_MOD_QUIRK, 1.2)
	ADD_TRAIT(quirk_holder, TRAIT_EXTRA_PAIN, ROUNDSTART_TRAIT)
	RegisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HUGGED), .proc/cause_chest_pain)
	RegisterSignal(quirk_holder, COMSIG_CARBON_HEADPAT, .proc/cause_head_pain)

/datum/quirk/allodynia/remove()
	quirk_holder.pain_controller?.unset_pain_modifier(PAIN_MOD_QUIRK)
	REMOVE_TRAIT(quirk_holder, TRAIT_EXTRA_PAIN, ROUNDSTART_TRAIT)
	UnregisterSignal(quirk_holder, list(COMSIG_LIVING_GET_PULLED, COMSIG_CARBON_HUGGED, COMSIG_CARBON_HEADPAT))

/datum/quirk/allodynia/proc/cause_chest_pain(datum/source, mob/living/toucher)
	SIGNAL_HANDLER

	if(!COOLDOWN_FINISHED(src, time_since_last_touch))
		return

	to_chat(quirk_holder, span_danger("[toucher] touches you, causing a wave of sharp pain throughout your body!"))
	quirk_holder.pain_controller?.adjust_bodypart_pain(BODY_ZONE_CHEST, 12)
	COOLDOWN_START(src, time_since_last_touch, 30 SECONDS)

/datum/quirk/allodynia/proc/cause_head_pain(datum/source, mob/living/toucher)
	SIGNAL_HANDLER

	if(!COOLDOWN_FINISHED(src, time_since_last_touch))
		return

	to_chat(quirk_holder, span_danger("[toucher] taps your head, causing a sensation of pain!"))
	quirk_holder.pain_controller?.adjust_bodypart_pain(BODY_ZONE_HEAD, 10)
	COOLDOWN_START(src, time_since_last_touch, 30 SECONDS)
