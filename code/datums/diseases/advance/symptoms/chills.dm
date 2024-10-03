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
	threshold_descs = list(
		"Stage Speed 5" = "Increases the intensity of the cooling; the host can fall below safe temperature levels.",
		"Stage Speed 10" = "Increases the intensity of the cooling even further."
	)
	var/cold_cap = -10 KELVIN

/datum/symptom/chills/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalStageSpeed() >= 5)
		cold_cap = -30 KELVIN
		power = 2
	if(A.totalStageSpeed() >= 10)
		cold_cap = -60 KELVIN
		power = 4

/datum/symptom/chills/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/M = A.affected_mob
	if(cold_cap >= -10 KELVIN || A.stage < 4)
		to_chat(M, span_warning("[pick("You feel cold.", "You shiver.")]"))
	else
		to_chat(M, span_userdanger("[pick("You feel your blood run cold.", "You feel ice in your veins.", "You feel like you can't heat up.", "You shiver violently.")]"))
	set_body_temp(A)

/datum/symptom/chills/proc/set_body_temp(datum/disease/advance/disease)
	var/mob/living/affected = disease.affected_mob
	var/new_level = affected.standard_body_temperature + (cold_cap * (disease.stage / disease.max_stages))
	affected.add_homeostasis_level(type, new_level, 0.25 KELVIN * power)

/// Update the body temp change based on the new stage
/datum/symptom/chills/on_stage_change(datum/disease/advance/A)
	. = ..()
	if(.)
		set_body_temp(A)

/// remove the body temp change when removing symptom
/datum/symptom/chills/End(datum/disease/advance/A)
	A.affected_mob?.remove_homeostasis_level(type)
