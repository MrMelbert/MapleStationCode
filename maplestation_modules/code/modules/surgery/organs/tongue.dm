// -- Modular toungue stuff, mostly language --
/obj/item/organ/internal/tongue
	var/static/list/languages_possible_modular = typecacheof(list(
        /datum/language/ratvarian,
                /datum/language/skrellian,
                /datum/language/yangyu
    ))

/obj/item/organ/internal/tongue/Initialize(mapload)
	languages_possible_base |= languages_possible_modular
	. = ..()

// Skrell Tongue. Could use a sprite.
/obj/item/organ/internal/tongue/skrell
	name = "skrellian tongue"
	desc = "The source of the Skrellian people's warbling voice."
	say_mod = "warbles"
	languages_native = /datum/language/skrell
	var/static/list/languages_possible_skrell

/obj/item/organ/internal/tongue/skrell/Initialize(mapload)
	. = ..()
	if(!LAZYLEN(languages_possible_skrell))
		languages_possible_skrell = languages_possible_base.Copy()
	languages_possible_skrell |= typecacheof(/datum/language/skrell)
	languages_possible = languages_possible_skrell

/obj/item/organ/internal/tongue/lizard
	languages_native = list(/datum/language/draconic, /datum/language/impdraconic)
	var/static/list/languages_possible_lizard

/obj/item/organ/internal/tongue/lizard/Initialize(mapload)
	. = ..()
	if(!LAZYLEN(languages_possible_lizard))
		languages_possible_lizard = languages_possible_base.Copy()
	languages_possible_lizard |= typecacheof(/datum/language/impdraconic)
	languages_possible = languages_possible_lizard

/obj/item/organ/internal/tongue/ethereal/Initialize(mapload)
	. = ..()
	languages_possible_ethereal |= languages_possible_base
	languages_possible_ethereal |= typecacheof(/datum/language/voltaic)
	languages_possible = languages_possible_ethereal

/obj/item/organ/internal/tongue/bone/Initialize(mapload)
	. = ..()
	languages_possible_skeleton |= languages_possible_base
	languages_possible_skeleton |= typecacheof(/datum/language/calcic)
	languages_possible = languages_possible_skeleton

/obj/item/organ/internal/tongue/fly/Initialize(mapload)
	. = ..()
	languages_possible_fly |= languages_possible_base
	languages_possible_fly |= typecacheof(/datum/language/buzzwords)
	languages_possible = languages_possible_fly
