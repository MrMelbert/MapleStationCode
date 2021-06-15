// -- Mood effects from pain. --
/datum/mood_event/pain
	description = "<span class='warning'>It hurts!</span>\n"
	mood_change = -6
	timeout = 2 MINUTES

/datum/mood_event/anesthetic
	description = "<span class='nicegreen'>Thank science for modern medicine.</span>\n"
	mood_change = 2
	timeout = 5 MINUTES

/datum/mood_event/surgery
	mood_change = -6
	timeout = 2 MINUTES

/datum/mood_event/surgery/major
	mood_change = -9
