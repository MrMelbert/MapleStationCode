/datum/status_effect/low_blood_pressure
	id = "low_blood_pressure"
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/low_blood_pressure

/datum/status_effect/low_blood_pressure/on_apply()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod *= 0.75
	return TRUE

/datum/status_effect/low_blood_pressure/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.physiology.bleed_mod /= 0.75

/datum/status_effect/low_blood_pressure/tick(seconds_between_ticks)
	if(owner.stat == DEAD)
		return
	if(!HAS_TRAIT(owner, TRAIT_STASIS))
		if(SPT_PROB(20, seconds_between_ticks))
			owner.adjust_jitter_up_to(5 SECONDS, 60 SECONDS)
		if(SPT_PROB(10, seconds_between_ticks))
			owner.adjust_dizzy_up_to(5 SECONDS, 60 SECONDS)
	if(SPT_PROB(10, seconds_between_ticks))
		owner.adjust_eye_blur_up_to(5 SECONDS, 60 SECONDS)

/atom/movable/screen/alert/status_effect/low_blood_pressure
	name = "Low blood pressure"
	desc = "Your blood pressure is low right now. Your organs aren't getting enough blood."
	icon_state = "highbloodpressure"
