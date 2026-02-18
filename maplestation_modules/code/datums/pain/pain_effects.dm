// -- Pain effects - mood and modifiers. --

/atom/movable/screen/fullscreen/pain
	icon = 'maplestation_modules/icons/hud/screen_full.dmi'
	icon_state = "painoverlay"
	layer = UI_DAMAGE_LAYER

/mob/living/proc/flash_pain_overlay(severity = 1, time = 1 SECONDS)
	if(screens["pain"])
		return
	overlay_fullscreen("pain", /atom/movable/screen/fullscreen/pain, severity)
	clear_fullscreen("pain", time)

/datum/movespeed_modifier/pain
	id = MOVESPEED_ID_PAIN
	movetypes = GROUND

// >= 100 total pain
/datum/movespeed_modifier/pain/light
	multiplicative_slowdown = 0.1

// >= 200 total pain
/datum/movespeed_modifier/pain/medium
	multiplicative_slowdown = 0.2

// >= 300 total pain
/datum/movespeed_modifier/pain/heavy
	multiplicative_slowdown = 0.35

// >= 400 total pain
/datum/movespeed_modifier/pain/crippling
	multiplicative_slowdown = 0.5

/datum/actionspeed_modifier/pain
	id = ACTIONSPEED_ID_PAIN

// >= 100 total pain
/datum/actionspeed_modifier/pain/light
	multiplicative_slowdown = 0.2

// >= 200 total pain
/datum/actionspeed_modifier/pain/medium
	multiplicative_slowdown = 0.2

// >= 300 total pain
/datum/actionspeed_modifier/pain/heavy
	multiplicative_slowdown = 0.35

// >= 400 total pain
/datum/actionspeed_modifier/pain/crippling
	multiplicative_slowdown = 0.5

/datum/mood_event/light_pain
	description = "It aches."
	mood_change = -3

/datum/mood_event/med_pain
	description = "I feel very sore."
	mood_change = -6

/datum/mood_event/heavy_pain
	description = "It hurts!"
	mood_change = -10

/datum/mood_event/crippling_pain
	description = "STOP THE PAIN!"
	mood_change = -15

// Applied when you go under the knife with anesthesia
/datum/mood_event/anesthetic
	description = "Thank science for modern medicine."
	mood_change = 2
	timeout = 6 MINUTES

// Applied by most surgeries if you get operated on without anesthetics
/datum/mood_event/surgery
	description = "Wait, they're operating on me while I'm awake!"
	mood_change = -6
	timeout = 3 MINUTES

/datum/mood_event/surgery/be_replaced(datum/mood/home, datum/mood_event/new_event, ...)
	return (new_event.mood_change > src.mood_change) ? ALLOW_NEW_MOOD : BLOCK_NEW_MOOD

/datum/mood_event/surgery/minor
	description = "Aren't they supposed to use anesthetic for this?"
	mood_change = -4
	timeout = 3 MINUTES

// Applied by some surgeries that are especially bad without anesthetics
/datum/mood_event/surgery/major
	description = "THEY'RE CUTTING ME OPEN!!"
	mood_change = -10
	timeout = 6 MINUTES

/**
 * Obviousnly not all ailments of a mob are treatable while dead,
 * so we need to apply a "buffer" status effect post-revival
 * to offset some the consciousness penalties of these ailments while they are treated
 *
 * This is only applied via defibbing, not via other methods of revival.
 */
/datum/status_effect/recent_defib
	duration = 60 SECONDS
	id = "recent_defib"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	remove_on_fullheal = TRUE
	/// Base amount of consciousness / max consciousness to give the patient
	var/base_con = 15

/datum/status_effect/recent_defib/on_apply()
	owner.add_consciousness_modifier(id, base_con)
	owner.add_max_consciousness_value(id, base_con)
	return TRUE

/datum/status_effect/recent_defib/on_remove()
	if(QDELING(owner))
		return
	owner.remove_consciousness_modifier(id)
	owner.remove_max_consciousness_value(id)
	owner.apply_status_effect(/datum/status_effect/revival_sickess)

/datum/status_effect/recent_defib/tick(seconds_between_ticks)
	var/deciseconds_remaining = duration - world.time
	if(deciseconds_remaining <= 0)
		return
	var/seconds_elapsed = round((initial(duration) - deciseconds_remaining) / (1 SECONDS), 1)

	// Bonus for being defibbed decays over time
	owner.add_consciousness_modifier(id, base_con - (seconds_elapsed * 0.25))
	// Consciousness returns over time
	owner.add_max_consciousness_value(id, base_con + (seconds_elapsed))

/datum/mood_event/revival_sickess
	description = "Back from the beyond the brink..."
	mood_change = -3

/datum/mood_event/revival_sickess/add_effects(mob/living/adder)
	if(HAS_PERSONALITY(owner, /datum/personality/apathetic))
		mood_change = 0

/**
 * For a period after revival, you suffer from res sickness, gotta get back on your feet.
 */
/datum/status_effect/revival_sickess
	duration = 5 MINUTES
	id = "revival_sickess"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	tick_interval = -1
	remove_on_fullheal = TRUE
	/// Tracks how much max consciousness penalty to give the patient
	var/max_con = 75

/datum/status_effect/revival_sickess/on_apply()
	if(owner.stat == DEAD)
		return FALSE

	owner.add_mood_event(id, /datum/mood_event/revival_sickess, owner)
	owner.add_max_consciousness_value(id, max_con)
	addtimer(CALLBACK(src, PROC_REF(improve)), 1 MINUTES, TIMER_DELETE_ME)
	RegisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(died_again))
	return TRUE

/datum/status_effect/revival_sickess/on_remove()
	if(QDELING(owner))
		return
	owner.clear_mood_event(id)
	owner.remove_max_consciousness_value(id)
	UnregisterSignal(owner, COMSIG_LIVING_DEATH, PROC_REF(died_again))

/datum/status_effect/revival_sickess/proc/improve()
	if(max_con >= 100)
		qdel(src)
		return

	max_con += 5
	owner.add_max_consciousness_value(id, max_con)
	addtimer(CALLBACK(src, PROC_REF(improve)), 1 MINUTES, TIMER_DELETE_ME)

/datum/status_effect/revival_sickess/proc/died_again(...)
	SIGNAL_HANDLER
	qdel(src)

/datum/mood_event/compound_fracture
	description = "I'm pretty sure that bone is not supposed to be there!"
	mood_change = -8

/mob/living/carbon/proc/bleed_rate_changed()
	var/sum_blood_flow = get_total_bleed_rate()
	if(HAS_MIND_TRAIT(src, TRAIT_MORBID))
		sum_blood_flow *= 0.25
	if(HAS_PERSONALITY(src, /datum/personality/apathetic) || HAS_PERSONALITY(src, /datum/personality/brave))
		sum_blood_flow *= 0.5
	if(HAS_PERSONALITY(src, /datum/personality/paranoid) || HAS_PERSONALITY(src, /datum/personality/cowardly))
		sum_blood_flow *= 2

	switch(sum_blood_flow)
		if(-INFINITY to 0)
			clear_mood_event("bleeding")
		if(0 to 1)
			mob_mood?.add_mood_event("bleeding", /datum/mood_event/bleeding/low)
		if(1 to 3)
			mob_mood?.add_mood_event("bleeding", /datum/mood_event/bleeding/med)
		if(3 to 5)
			mob_mood?.add_mood_event("bleeding", /datum/mood_event/bleeding/high)
		if(5 to 7)
			mob_mood?.add_mood_event("bleeding", /datum/mood_event/bleeding/vhigh)
		if(7 to INFINITY)
			mob_mood?.add_mood_event("bleeding", /datum/mood_event/bleeding/critical)

/datum/mood_event/bleeding
	var/downgrade_description = ""
	var/upgrade_description = ""

/datum/mood_event/bleeding/be_replaced(datum/mood/home, datum/mood_event/new_event, ...)
	if(istype(new_event, /datum/mood_event/bleeding))
		var/datum/mood_event/bleeding/new_bleeding_event = new_event
		new_bleeding_event.replacing(src)
		return ALLOW_NEW_MOOD
	return BLOCK_NEW_MOOD

/datum/mood_event/bleeding/proc/replacing(datum/mood_event/bleeding/existing_event)
	if(existing_event.mood_change < mood_change) // inverted because more negative = worse
		description = downgrade_description
	if(existing_event.mood_change > mood_change) // inverted because less negative = better
		description = upgrade_description
	if(!description)
		stack_trace("[existing_event.type] to [type] has no description set!")
		description = initial(description)

/datum/mood_event/bleeding/low
	description = "Just a scrape."
	downgrade_description = "Phew, bleeding's almost stopped."
	mood_change = -1

/datum/mood_event/bleeding/med
	description = "I'm bleeding..."
	downgrade_description = "I think the bleeding's slowing down."
	upgrade_description = "I think i'm bleeding more than I thought."
	mood_change = -3

/datum/mood_event/bleeding/high
	description = "I'm bleeding a lot!"
	downgrade_description = "The bleeding is getting better, but I'm still losing a lot of blood."
	upgrade_description = "The bleeding is getting worse, I need to stop it!"
	mood_change = -6

/datum/mood_event/bleeding/vhigh
	description = "The blood won't stop!"
	downgrade_description = "The bleeding is getting better, but I'm still losing a dangerous amount of blood."
	upgrade_description = "The bleeding is getting worse, I need to stop it fast!"
	mood_change = -8

/datum/mood_event/bleeding/critical
	description = "I'm losing so much blood!!"
	upgrade_description = "The bleeding can't get any worse, I need to stop it immediately!"
	mood_change = -12
