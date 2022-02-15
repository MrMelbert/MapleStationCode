/// -- Extra extended/modular knowledge for advanced heretics --
/// "No ascending allowed" knowledge added by advanced heretics.
/datum/heretic_knowledge/no_ascension
	name = "The Faithless Oath"
	desc = "Gives up your ability to ascend in favor of going about other objectives."
	gain_text = "I took an oath to my gods not to ascend beyond, as the powers were better utilized elsewhere."

/datum/heretic_knowledge/no_ascension/New()
	. = ..()
	banned_knowledge = subtypesof(/datum/heretic_knowledge/final)
