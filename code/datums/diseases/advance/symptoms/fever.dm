/**Fever
 * No change to stealth
 * Increases resistance considerably
 * Increases stage speed considerably
 * Increases transmissibility
 * Low level
 * Bonus: Heats up your body
 */

/datum/symptom/fever
	name = "Fever"
	desc = "The virus causes a febrile response from the host, raising its body temperature."
	illness = "Burning Desire"
	stealth = 0
	resistance = 3
	stage_speed = 3
	transmittable = 2
	level = 2
	severity = 2
	base_message_chance = 20
	symptom_delay_min = 10
	symptom_delay_max = 30
	var/unsafe = FALSE //over the heat threshold
	threshold_descs = list(
		"Resistance 5" = "Increases fever intensity, fever can overheat and harm the host.",
		"Resistance 10" = "Further increases fever intensity.",
	)

/datum/symptom/fever/Start(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	if(A.totalResistance() >= 5) //dangerous fever
		power = 1.5
		unsafe = TRUE
	if(A.totalResistance() >= 10)
		power = 2.5

/datum/symptom/fever/Activate(datum/disease/advance/A)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/M = A.affected_mob
	if(!unsafe || A.stage < 4)
		to_chat(M, span_warning("[pick("You feel hot.", "You feel like you're burning.")]"))
	else
		to_chat(M, span_userdanger("[pick("You feel too hot.", "You feel like your blood is boiling.")]"))
	set_body_temp(A.affected_mob, A.stage)

/datum/symptom/fever/proc/set_body_temp(mob/living/affected, stage)
	var/new_level = affected.standard_body_temperature + (MODERATE_AMOUNT_KELVIN * power * stage)
	if(!unsafe)
		new_level = min(affected.bodytemp_heat_damage_limit - MODERATE_AMOUNT_KELVIN, new_level)

	affected.add_temperature_level(type, new_level, MINOR_AMOUNT_KELVIN * power)

/// Update the body temp change based on the new stage
/datum/symptom/fever/on_stage_change(datum/disease/advance/A)
	. = ..()
	if(.)
		set_body_temp(A.affected_mob, A.stage)

/// remove the body temp change when removing symptom
/datum/symptom/fever/End(datum/disease/advance/A)
	A.affected_mob?.remove_temperature_level(type)
