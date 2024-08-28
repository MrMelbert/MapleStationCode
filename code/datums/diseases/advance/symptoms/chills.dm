/** Chills
 * No change to stealth.
 * Increases resistance.
 * Increases stage speed.
 * Increases transmissibility
 * Low level
 * Bonus: Cools down your body.
 */

/datum/symptom/chills
	name = "Chills"
	desc = "The virus inhibits the body's thermoregulation, cooling the body down."
	illness = "Cold Shoulder"
	stealth = 0
	resistance = 2
	stage_speed = 3
	transmittable = 2
	level = 2
	severity = 2
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/unsafe = FALSE //over the cold threshold
	threshold_descs = list(
		"Stage Speed 5" = "Increases the intensity of the cooling; the host can fall below safe temperature levels.",
		"Stage Speed 10" = "Increases the intensity of the cooling even further."
	)

/datum/symptom/chills/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalStageSpeed() >= 5) //dangerous cold
		power = 1.5
		unsafe = TRUE
	if(A.totalStageSpeed() >= 10)
		power = 2.5

/datum/symptom/chills/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/M = A.affected_mob
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning("[pick("You feel cold.", "You shiver.")]"))
	else
		to_chat(M, span_userdanger("[pick("You feel your blood run cold.", "You feel ice in your veins.", "You feel like you can't heat up.", "You shiver violently.")]"))
	set_body_temp(A.affected_mob, A.stage)

/datum/symptom/chills/proc/set_body_temp(mob/living/affected, stage)
	var/new_level = affected.standard_body_temperature - (MODERATE_AMOUNT_KELVIN * power * stage)
	if(!unsafe)
		new_level = min(affected.bodytemp_cold_damage_limit + MODERATE_AMOUNT_KELVIN, new_level)

	affected.add_temperature_level(type, new_level, MINOR_AMOUNT_KELVIN * power)

/// Update the body temp change based on the new stage
/datum/symptom/chills/on_stage_change(datum/disease/advance/A)
	. = ..()
	if(.)
		set_body_temp(A.affected_mob, A.stage)

/// remove the body temp change when removing symptom
/datum/symptom/chills/End(datum/disease/advance/A)
	A.affected_mob?.remove_temperature_level(type)
