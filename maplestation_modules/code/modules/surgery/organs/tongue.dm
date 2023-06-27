// Adds some modular languages to tongue languages
/obj/item/organ/internal/tongue

/obj/item/organ/internal/tongue/get_possible_languages()
	return ..() + list(
		/datum/language/ratvarian,
		/datum/language/skrell,
		/datum/language/yangyu,
	)

// Skrell Tongue. Could use a sprite.
/obj/item/organ/internal/tongue/skrell
	name = "skrellian tongue"
	desc = "The source of the Skrellian people's warbling voice."
	say_mod = "warbles"
	languages_native = /datum/language/skrell
	var/static/list/languages_possible_skrell

/obj/item/organ/internal/tongue/skrell/get_possible_languages()
	return ..() + /datum/language/skrell

// High Draconic for lizard tongues
/obj/item/organ/internal/tongue/lizard
	languages_native = list(/datum/language/draconic, /datum/language/impdraconic)

/obj/item/organ/internal/tongue/lizard/get_possible_languages()
	return ..() + /datum/language/impdraconic
