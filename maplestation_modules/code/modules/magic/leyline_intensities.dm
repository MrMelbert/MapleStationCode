GLOBAL_LIST_INIT(leyline_intensities, list(
	///datum/leyline_intensity/none = 0,
	/datum/leyline_intensity/minimal = 7,
	/datum/leyline_intensity/low = 3,
	/datum/leyline_intensity/below_average = 1,
	/datum/leyline_intensity/average = 0.5,
	/datum/leyline_intensity/above_average = 0.1,
	/datum/leyline_intensity/high = 0.001,
	///datum/leyline_intensity/extreme = 0
))

/datum/leyline_intensity
	var/overall_mult
	var/name = "we fucked up"

/datum/leyline_intensity/none
	overall_mult = 0
	name = "None"

/datum/leyline_intensity/minimal
	overall_mult = 0.1
	name = "Minimal"

/datum/leyline_intensity/low
	overall_mult = 0.5
	name = "Low"

/datum/leyline_intensity/below_average
	overall_mult = 0.7
	name = "Below average"

/datum/leyline_intensity/average
	overall_mult = 1
	name = "Average"

/datum/leyline_intensity/above_average
	overall_mult = 1.3
	name = "Above average"

/datum/leyline_intensity/high
	overall_mult = 2
	name = "High"

/datum/leyline_intensity/extreme
	overall_mult = 5
	name = "Extreme"

