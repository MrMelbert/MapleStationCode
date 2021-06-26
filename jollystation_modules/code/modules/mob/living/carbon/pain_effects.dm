// -- Pain effects - mood, modifiers, statuses. --

/atom/movable/screen/fullscreen/pain
	icon = 'jollystation_modules/icons/hud/screen_full.dmi'
	icon_state = "painoverlay"
	layer = UI_DAMAGE_LAYER

/mob/living/carbon/proc/flash_pain_overlay(severity = 1, time = 10)
	overlay_fullscreen("pain", /atom/movable/screen/fullscreen/pain, severity)
	clear_fullscreen("pain", time)

/atom/movable/screen/alert/status_effect/limp/pain
	name = "Pained Limping"
	desc = "The pain in your legs is unbearable, forcing you to limp!"

/datum/status_effect/limp/pain
	id = "limp_pain"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/limp/pain

/datum/status_effect/limp/pain/on_apply()
	. = ..()
	if(!.)
		return

	RegisterSignal(owner, list(COMSIG_CARBON_PAIN_GAINED, COMSIG_CARBON_PAIN_LOST), .proc/update_limp)

/datum/status_effect/limp/pain/on_remove()
	. = ..()
	UnregisterSignal(owner, list(COMSIG_CARBON_PAIN_GAINED, COMSIG_CARBON_PAIN_LOST))
	to_chat(owner, span_green("Your pained limp stops!"))

/datum/status_effect/limp/pain/update_limp()
	var/mob/living/carbon/limping_carbon = owner
	left = limping_carbon.get_bodypart(BODY_ZONE_L_LEG)
	right = limping_carbon.get_bodypart(BODY_ZONE_R_LEG)

	if(!left && !right)
		limping_carbon.remove_status_effect(src)
		return

	slowdown_left = 0
	slowdown_right = 0

	if(left?.pain >= 20)
		slowdown_left = (left.pain / 10) * limping_carbon.pain_controller.pain_modifier * left.bodypart_pain_modifier

	if(right?.pain >= 20)
		slowdown_left = (right.pain / 10) * limping_carbon.pain_controller.pain_modifier * left.bodypart_pain_modifier

	// this handles losing your leg with the limp and the other one being in good shape as well
	if(!slowdown_left && !slowdown_right)
		limping_carbon.remove_status_effect(src)

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
	description = "<span class='warning'>Everything aches.</span>\n"
	mood_change = -3

/datum/mood_event/med_pain
	description = "<span class='warning'>Everything feels sore.</span>\n"
	mood_change = -6

/datum/mood_event/heavy_pain
	description = "<span class='warning'>Everything hurts!</span>\n"
	mood_change = -10

/datum/mood_event/crippling_pain
	description = "<span class='boldwarning'>STOP THE PAIN!</span>\n"
	mood_change = -15

/datum/mood_event/anesthetic
	description = "<span class='nicegreen'>Thank science for modern medicine.</span>\n"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/surgery
	mood_change = -6
	timeout = 2 MINUTES

/datum/mood_event/surgery/major
	mood_change = -9
