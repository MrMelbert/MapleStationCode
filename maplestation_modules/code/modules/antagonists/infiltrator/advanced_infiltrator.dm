/// -- Advanced Antag Datum for Infiltrator. --
/datum/advanced_antag_datum/traitor/infiltrator
	name = "Advanced Infiltrator"
	hijack_speed_modifier = 0.05

/datum/advanced_antag_datum/traitor/infiltrator/get_finalize_text()
	return "Finalizing will grant you an uplink implant with [get_antag_points_from_goals()] telecrystals. You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/traitor/infiltrator/greet_message(mob/antagonist)
	to_chat(antagonist, span_alertsyndie("You are an [name]!"))
	antagonist.playsound_local(get_turf(antagonist), 'maplestation_modules/sound/radiodrum.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	addtimer(CALLBACK(src, .proc/greet_message_two, antagonist), 3 SECONDS)

/datum/advanced_antag_datum/traitor/infiltrator/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are an agent sent to infiltrate [station_name()]! You can set your goals to whatever you think would make an interesting story or round. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)

/datum/advanced_antag_datum/traitor/infiltrator/podspawn
	name = "Advanced Infiltrator (Pod spawn)"

/datum/advanced_antag_datum/traitor/infiltrator/podspawn/get_finalize_text()
	return "Finalizing will grant you an uplink implant with [get_antag_points_from_goals()] telecrystals, and will drop pod you into a random maintenance room on the station. You can still edit your goals after finalizing!"

/datum/advanced_antag_datum/traitor/infiltrator/podspawn/greet_message_two(mob/antagonist)
	to_chat(antagonist, span_danger("You are an agent preparing to infiltrate [station_name()]! You can set your goals to whatever you think would make an interesting story or round. Finalizing your goals will drop you into a random maintenance room on the station. You have access to your goal panel via verb in your IC tab."))
	addtimer(CALLBACK(src, .proc/greet_message_three, antagonist), 3 SECONDS)
