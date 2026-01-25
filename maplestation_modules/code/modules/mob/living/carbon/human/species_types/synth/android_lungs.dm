/obj/item/organ/lungs/android
	name = "android lungs"
	desc = "Electronic devices designed to mimic the functions of human lungs. Provides necessary cooling."
	icon_state = /obj/item/organ/lungs/cybernetic/tier2::icon_state
	organ_flags = ORGAN_ROBOTIC

	safe_oxygen_min = 0

	safe_oxygen_max = INFINITY
	safe_co2_max = INFINITY
	safe_plasma_max = INFINITY

	n2o_detect_min = INFINITY
	n2o_para_min = INFINITY
	n2o_sleep_min = INFINITY
	BZ_trip_balls_min = INFINITY
	BZ_brain_damage_min = INFINITY
	gas_stimulation_min = INFINITY
	healium_para_min = INFINITY
	healium_sleep_min = INFINITY
	helium_speech_min = INFINITY
	suffers_miasma = FALSE

	tritium_irradiation_moles_min = INFINITY
	tritium_irradiation_moles_max = INFINITY

	low_pressure_threshold = 0
	high_pressure_threshold = INFINITY

	organ_traits = list(
		TRAIT_RESISTCOLD,
		TRAIT_RESISTHEAT,
	)

/obj/item/organ/lungs/android/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return

	apply_organ_damage(10 / severity)

/obj/item/organ/lungs/android/heal_oxyloss_on_breath(mob/living/carbon/human/breather, datum/gas_mixture/breath)
	breather.adjustOxyLoss(-2)
