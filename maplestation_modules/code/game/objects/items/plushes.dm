// -- plush business. --
/obj/item/toy/plush/lizard_plushie
	icon = 'maplestation_modules/icons/obj/plushes.dmi'

/obj/item/toy/plush/lizard_plushie/space
	icon = 'icons/obj/toys/plushes.dmi'

/obj/item/toy/plush/peepy
	name = "peepy"
	desc = "After committing a dangerous and disrespectful crime, Peepy is out on bail and ready to come to your house."
	icon = 'maplestation_modules/icons/obj/plushes.dmi'
	icon_state = "peepy"

/obj/item/toy/plush/peepy/examine(mob/user)
	. = ..()
	. += span_notice("A tag on the back says: \"This is a collectible artwork and not a toy. Do not give to children under 12 years old or pets.\"")
