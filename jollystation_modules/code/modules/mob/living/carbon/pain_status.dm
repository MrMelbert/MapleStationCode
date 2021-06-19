// -- Pain status effects. --
/atom/movable/screen/alert/status_effect/limp/pain
	name = "Pained Limping"
	desc = "The pain in your legs is unbearable, forcing you to limp!"

/datum/status_effect/limp/pain
	id = "limp_pain"
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
		slowdown_left = left.pain / 10

	if(right?.pain >= 20)
		slowdown_left = right.pain / 10

	// this handles losing your leg with the limp and the other one being in good shape as well
	if(!slowdown_left && !slowdown_right)
		limping_carbon.remove_status_effect(src)
		return

/datum/movespeed_modifier/pain

/datum/actionspeed_modifier/pain
