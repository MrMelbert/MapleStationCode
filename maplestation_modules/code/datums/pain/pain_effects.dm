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
	description = "They're operating on me while I'm awake!"
	mood_change = -6
	timeout = 3 MINUTES

// Applied by some surgeries that are especially bad without anesthetics
/datum/mood_event/surgery/major
	description = "THEY'RE CUTTING ME OPEN!!"
	mood_change = -10
	timeout = 6 MINUTES

/atom/movable/screen/alert/numbed
	name = "Numbed"
	desc = "Your body is numb, painless. You're under the effect of some kind of painkiller."
	icon_state = "drugged"

/datum/mood_event/narcotic_light
	description = "I feel numb."
	mood_change = 4
	timeout = 3 MINUTES

/datum/emote/living/carbon/human/scream

/datum/emote/living/carbon/human/scream/can_run_emote(mob/living/carbon/human/user, status_check, intentional)
	if(intentional)
		return ..()

	// Cut unintentional screems if they can't feel pain at the moment
	if(!user.can_feel_pain())
		return FALSE

	return ..()

/datum/status_effect/recent_defib
	duration = 60 SECONDS
	id = "recent_defib"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null

/datum/status_effect/recent_defib/on_apply()
	owner.adjust_pain_shock(-12)
	owner.cause_pain(BODY_ZONES_ALL, -16)
	owner.add_consciousness_modifier(id, 25)
	owner.add_max_consciousness_value(id, 45)
	return TRUE

/datum/status_effect/recent_defib/on_remove()
	owner.remove_consciousness_modifier(id)
	owner.remove_max_consciousness_value(id)
