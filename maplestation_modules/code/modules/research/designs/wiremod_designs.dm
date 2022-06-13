// Wiremod components are 1/4th the glass cost.
/datum/design/component
	materials = list(/datum/material/glass = 250)

// Drone shells don't cost gold.
/datum/design/drone_shell
	materials = list(
		/datum/material/glass = 2000,
		/datum/material/iron = 12000,
	)

// The module duplicate is also 1/4th the cost.
/obj/machinery/module_duplicator
	cost_per_component = 250
