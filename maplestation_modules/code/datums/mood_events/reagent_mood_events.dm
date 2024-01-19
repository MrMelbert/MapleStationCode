
// Reagent moodlets
/datum/mood_event/gojuice
	description = "Feeling pumped but calm. I am the sniper bullet in flight, ready to cut through you."
	mood_change = 3

/datum/mood_event/flake
	description = "So good, so good."
	mood_change = 20

/datum/mood_event/yayo
	description = "Feeling pumped! Let's do this!"
	mood_change = 20

/datum/mood_event/psychite_tea
	description = "I drank some nice, calming psychite tea."
	mood_change = 8

/datum/mood_event/full_on_pilk
	description = "I am now full on pilk! That was some amazing bubbly goodness!"
	mood_change = 7
	timeout = 7 MINUTES

/datum/mood_event/pegged
	description = "OH YEAH, NOW I'M PEGGED!" //:uncannycat:
	mood_change = 8
	timeout = 7 MINUTES

/datum/mood_event/coffee_lover
	description = "That coffee was truly delectable!"
	mood_change = 3
	timeout = 7 MINUTES

/datum/mood_event/tea_lover
	description = "That was a most wonderful spot of tea."
	mood_change = 3
	timeout = 7 MINUTES

/datum/mood_event/energy_lover
	description = "That energy drink was the perfect mix to get you energized! Shame it only really tasted of chemicals."
	mood_change = 0
	timeout = 12 MINUTES //lasts longer but you're not really happy

// Addiction moodlets
/datum/mood_event/luciferium_light
	mood_change = -4

/datum/mood_event/luciferium_light/add_effects(drug_name)
	description = "<span class='warning'>I need [drug_name]!</span>\n"

/datum/mood_event/luciferium_medium
	mood_change = -8

/datum/mood_event/luciferium_medium/add_effects(drug_name)
	description = "<span class='boldwarning'>I'd kill for [drug_name]!</span>\n"

/datum/mood_event/luciferium_heavy
	mood_change = -12

/datum/mood_event/luciferium_heavy/add_effects(drug_name)
	description = "<span class='boldwarning'>I'll die without [drug_name]!</span>\n"

/datum/mood_event/gojuice_addiction_light
	mood_change = -6

/datum/mood_event/gojuice_addiction_light/add_effects(drug_name)
	description = "<span class='boldwarning'>I need [drug_name]!</span>\n"

/datum/mood_event/gojuice_addiction_medium
	mood_change = -8

/datum/mood_event/gojuice_addiction_medium/add_effects(drug_name)
	description = "<span class='boldwarning'>Everything's terrible without [drug_name]!</span>\n"

/datum/mood_event/gojuice_addiction_heavy
	mood_change = -10

/datum/mood_event/gojuice_addiction_heavy/add_effects(drug_name)
	description = "<span class='boldwarning'>[drug_name]! Get me some [drug_name]!</span>\n"

/datum/mood_event/psychite_addiction_light
	mood_change = -5

/datum/mood_event/psychite_addiction_light/add_effects(drug_name)
	description = "<span class='boldwarning'>I need some [drug_name]!</span>\n"

/datum/mood_event/psychite_addiction_medium
	mood_change = -10

/datum/mood_event/psychite_addiction_medium/add_effects(drug_name)
	description = "<span class='boldwarning'>The world's worse without some [drug_name]!</span>\n"

/datum/mood_event/psychite_addiction_heavy
	mood_change = -15

/datum/mood_event/psychite_addiction_heavy/add_effects(drug_name)
	description = "<span class='boldwarning'>[drug_name]s! I need any [drug_name], now!</span>\n"
