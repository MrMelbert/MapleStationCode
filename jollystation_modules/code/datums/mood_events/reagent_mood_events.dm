
/datum/mood_event/luciferium_light
	mood_change = -6

/datum/mood_event/luciferium_light/add_effects(drug_name)
	description = "<span class='warning'>I need [drug_name]!</span>\n"

/datum/mood_event/luciferium_medium
	mood_change = -9

/datum/mood_event/luciferium_medium/add_effects(drug_name)
	description = "<span class='boldwarning'>I'd kill for [drug_name]!</span>\n"

/datum/mood_event/luciferium_heavy
	mood_change = -12

/datum/mood_event/luciferium_heavy/add_effects(drug_name)
	description = "<span class='boldwarning'>I'll die without [drug_name]!</span>\n"

/datum/mood_event/gojuice
	description = "<span class='nicegreen'>I feel unstoppable!</span>\n"
	mood_change = 5

/datum/mood_event/gojuice_addiction_light
	mood_change = -10

/datum/mood_event/gojuice_addiction_light/add_effects(drug_name)
	description = "<span class='boldwarning'>I need [drug_name]!</span>\n"

/datum/mood_event/gojuice_addiction_medium
	mood_change = -15

/datum/mood_event/gojuice_addiction_medium/add_effects(drug_name)
	description = "<span class='boldwarning'>Everything's terrible without [drug_name]!</span>\n"

/datum/mood_event/gojuice_addiction_heavy
	mood_change = -20

/datum/mood_event/gojuice_addiction_heavy/add_effects(drug_name)
	description = "<span class='boldwarning'>[drug_name]! Get me some [drug_name]!</span>\n"
