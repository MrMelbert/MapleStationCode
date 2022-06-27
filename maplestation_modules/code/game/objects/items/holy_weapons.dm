// LOLOLOLOLOLOLOLOLOLOLOLOLOLO
// name says enough! this is for chaplain weapons. If you want to add boring NORMAL weapons, make a new .dm (or use it if someone already made it)
/obj/item/nullrod/spear/amber_blade
	name = "amber blade"
	desc = "A rapier-like sword made from the amber of an alien root-tree."
	icon_state = "amber_blade"
	icon = 'maplestation_modules/icons/obj/weapons.dmi'
	worn_icon_state = "amber_blade"
	worn_icon = 'maplestation_modules/icons/mob/clothing/belt.dmi'
	inhand_icon_state = "amber_blade" // do you know the muffin man the muffin man the muffin man?
	lefthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'maplestation_modules/icons/mob/inhands/weapons/swords_righthand.dmi'
	sharpness = SHARP_EDGED
	attack_verb_continuous = list("stabs", "cuts", "slashes", "power attacks") // felt like it needed a 4th like its parent spear, chose power attacks from TES.
	attack_verb_simple = list("stab", "cut", "slash", "power attack") // fun fact: if the "power attack" verb rolls, there is a small chance of doing increased metaphorical damage!
	menu_description = "A blade which penetrates armor slightly. Can be worn only on the belt."
