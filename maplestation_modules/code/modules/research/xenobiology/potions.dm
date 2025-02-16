/obj/item/slimepotion/Initialize(mapload)
	. = ..()
	// Because for some reason each child individually declares it instead of inheriting from parent and I don't wanna copy-paste every potion
	icon = 'maplestation_modules/icons/obj/chemical.dmi'

/obj/item/slimepotion/extract_cloner
	icon_state = "potgold"

/obj/item/slimepotion/spaceproof
	icon_state = "potblack"

/obj/item/slimepotion/enhancer/max
	icon_state = "potcerulean"

/obj/item/slimepotion/lavaproof
	icon_state = "potyellow"

/obj/item/slimepotion/slime_reviver
	icon_state = "potgrey"

/obj/item/slimepotion/speed
	icon_state = "potred"

/obj/item/slimepotion/genderchange
	icon_state = "potrainbow"

/obj/item/slimepotion/slime/renaming
	icon_state = "potbrown"

/obj/item/slimepotion/slime/slimeradio
	icon_state = "potbluespace"
