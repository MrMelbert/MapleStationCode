GLOBAL_LIST_INIT(leyline_intensities, list(
	/datum/leyline_variable/leyline_intensity/none = 200,
	/datum/leyline_variable/leyline_intensity/minimal = 8000,
	/datum/leyline_variable/leyline_intensity/extremely_low = 11000,
	/datum/leyline_variable/leyline_intensity/low = 5000,
	/datum/leyline_variable/leyline_intensity/below_average = 1000,
	/datum/leyline_variable/leyline_intensity/average = 500,
	/datum/leyline_variable/leyline_intensity/above_average = 100,
	/datum/leyline_variable/leyline_intensity/high = 2,
	/datum/leyline_variable/leyline_intensity/extreme = 1
))

// ^ Only pass integers in since its used for pickweight

/// "Intensities" that will be applied to leylines. Should influence the average capacity/recharge rate/whatever of the leyline.
/datum/leyline_variable/leyline_intensity
	var/overall_mult

/datum/leyline_variable/leyline_intensity/none
	overall_mult = 0
	name = "None"

/datum/leyline_variable/leyline_intensity/minimal
	overall_mult = 0.05
	name = "Minimal"

/datum/leyline_variable/leyline_intensity/extremely_low
	overall_mult = 0.1
	name = "Extremely Low"

/datum/leyline_variable/leyline_intensity/low
	overall_mult = 0.5
	name = "Low"

/datum/leyline_variable/leyline_intensity/below_average
	overall_mult = 0.7
	name = "Below average"

/datum/leyline_variable/leyline_intensity/average
	overall_mult = 1
	name = "Average"

/datum/leyline_variable/leyline_intensity/above_average
	overall_mult = 1.3
	name = "Above average"

/datum/leyline_variable/leyline_intensity/high
	overall_mult = 2
	name = "High"

/datum/leyline_variable/leyline_intensity/extreme
	overall_mult = 5
	name = "Extreme"

