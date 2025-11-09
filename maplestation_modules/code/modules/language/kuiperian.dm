/datum/language/kuiperian
	name = "Kuiperian"
	desc = "A language adopted by Spacers - particularly Animids. \
		While it has distant ties to Common, Uncommon, and other old Sol languages, it has diverged significantly over time and space. \
		Speakers tend to use little to no body language, given its common use in cramped spacecraft and stations."
	key = "s"
	flags = TONGUELESS_SPEECH
	syllables = list(
		"ar", "at", "ak", "al",
		"be", "bu", "ba",
		"cha", "chi", "cho", "chu", "che",
		"de", "du", "da",
		"ha", "he", "hi", "ho", "hu",
		"ke", "ku", "ka",
		"le", "li", "lo",
		"me", "mu", "ma", "mi",
		"ne", "no", "na", "ni",
		"pe", "pi", "po", "pa",
		"re", "ri", "ro", "ra",
		"se", "su", "sa", "si",
		"sha", "shi", "sho", "shu", "she",
		"te", "tu", "ta", "ti",
		"ve", "vi", "vo",
		"we", "oy", "ow",
		"ye", "yu", "ya",
	)
	special_characters = list("in", "ng")
	icon_state = "kuiperian"
	icon = 'maplestation_modules/icons/misc/language.dmi'
	default_priority = 90
	// lots of small words and more run-on sentences
	space_chance = 75
	between_word_space_chance = 75
	sentence_chance = 0

	mutual_understanding = list(
		/datum/language/common = 10,
		/datum/language/uncommon = 10,
	)

/datum/language_holder/kuiperian
	understood_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/kuiperian = list(LANGUAGE_ATOM),
	)
	spoken_languages = list(
		/datum/language/common = list(LANGUAGE_ATOM),
		/datum/language/kuiperian = list(LANGUAGE_ATOM),
	)
