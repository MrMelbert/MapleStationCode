/// -- Skrell language --
/datum/language/skrell
	name = "Skrellian"
	desc = "A set of warbles and hums, the language itself a complex mesh of both melodic and rhythmic components, exceptionally capable of conveying intent and emotion of the speaker."
	//speech_verb = "warbles"
	//ask_verb = "warbles"
	//exclaim_verb = "sings"
	//whisper_verb = "hums"
	key = "w"
	space_chance = 30
	syllables = list("qr","qrr","xuq","qil","quum","xuqm","vol","xrim","zaoo","qu-uu","qix","qoo","zix")
	default_priority = 90
	icon = 'maplestation_modules/icons/misc/language.dmi'
	icon_state = "skrell"

/datum/language_holder/skrell
	understood_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
								/datum/language/skrell = list(LANGUAGE_ATOM))
	spoken_languages = list(/datum/language/common = list(LANGUAGE_ATOM),
							/datum/language/skrell = list(LANGUAGE_ATOM))
