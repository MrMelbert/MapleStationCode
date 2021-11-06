// -- Overrides and extensions for language holders. --
/datum/language_holder/synthetic/New(atom/_owner)
	understood_languages |= list(/datum/language/skrell = list(LANGUAGE_ATOM), /datum/language/impdraconic = list(LANGUAGE_ATOM))
	spoken_languages |= list(/datum/language/skrell = list(LANGUAGE_ATOM), /datum/language/impdraconic = list(LANGUAGE_ATOM))
	return ..()
