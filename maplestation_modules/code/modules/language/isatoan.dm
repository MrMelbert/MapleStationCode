/datum/language/isatoa
	name = "Isatoa"
	desc = "A sophisticated language language used in the aristocratic country of Mu. Comes with a knack for fine dining and atmosphere."
	key = "a"
	flags = TONGUELESS_SPEECH
	space_chance = 25
	syllables = list(
		"ai", "ea", "io", "ou", "ui", "ye", "al", "ae", "ri", "it", "ho", "la", "o",
		"u", "y", "um", "ey", "on", "ar", "ia", "el", "an", "is", "ta", "or",
		"en", "uv", "ao", "ya", "ra", "ro", "le", "t", "mi", "re", "pu", "uz", "uv",
		"se", "lu", "xi", "th", "a", "i", "e", "za", "rn", "rk", "vo", "qu", "pi",
		"iy", "ji", "vu", "gai", "fel", "ceo", "eon", "du", "li", "ios", "ma", "miv", "ola",
		"lis", "aoi", "rin", "tav", "mu", "vel", "rx", "eri",
	)
	icon_state = "mu"
	icon = 'maplestation_modules/icons/misc/language.dmi'
	default_priority = 80

/datum/language_holder/isatoa
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/isatoa = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/isatoa = list(LANGUAGE_ATOM),
	)

/datum/language/eldritch
	name = "Ythralian"
	desc = "An ancient language spoken by only the most timeless beings. The common mortal can barely comprehend the dialect."
	key = "e"
	flags = TONGUELESS_SPEECH
	space_chance = 25
	syllables = list(
		"yt", "th", "y", "t", "ra", "li", "an", "ia", "ny", "ar", "la", "in", "ir",
		"ha", "na", "tr", "al", "yi", "ni", "ay", "ii", "ll", "ry", "xz", "yth",
		"ran", "lii", "lar", "thr", "ayl", "axl", "nal", "irn", "lah", "nax", "yth", "iar", "uv",
		"se", "lu", "xi", "th", "a", "i", "e", "za", "rn", "rk", "vo", "qu", "pi",
		"ith", "h", "r", "n", "fel", "er", "eon", "yl", "ai", "ios", "wa", "va", "mv",
		"gx", "w", "z", "ei", "eo", "vot", "pr", "us",
	)
	icon_state = "eldritch"
	icon = 'maplestation_modules/icons/misc/language.dmi'
	default_priority = 80

/datum/language_holder/eldritch
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/eldritch = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/eldritch = list(LANGUAGE_ATOM),
	)

/mob/living/translate_language(atom/movable/speaker, datum/language/language, raw_message, list/spans, list/message_mods = list())
	. = ..()
	if(. == raw_message)
		return
	if(isnull(language))
		return
	var/datum/language/dialect = GLOB.language_datum_instances[language]
	dialect.heard_by_mob_who_lacks_critical_information(src, speaker)

/datum/language/proc/heard_by_mob_who_lacks_critical_information(mob/living/listener, atom/movable/speaker)
	return

/datum/language/eldritch/heard_by_mob_who_lacks_critical_information(mob/living/listener, atom/movable/speaker)
	listener.adjustOrganLoss(ORGAN_SLOT_BRAIN, 10, 100)
	to_chat(listener, span_danger("Your mind languishes as you hear the words spoken by [speaker]!"))
