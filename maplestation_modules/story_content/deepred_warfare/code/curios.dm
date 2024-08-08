/obj/item/starblight_soot
	name = "sealed soot jar"
	desc = "A small jar filled with a fine, sparkling purple powder. It's sealed tight, and the label reads Starblight. The jar's glass just the faintest tinted blue and feels heavy in your hand."

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

	icon = 'maplestation_modules/story_content/deepred_warfare/icons/curios.dmi'
	icon_state = "starblight_soot"

	inhand_icon_state = "beaker"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	drop_sound = 'maplestation_modules/sound/items/drop/glass_small.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/glass_small.ogg'

/obj/item/suspicious_scrap
	name = "suspicious scrap"
	desc = "A small chunk of componentry that looks like part of a larger device. Despite this, it's not immediately clear what it's from or what it does."

	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

	icon = 'maplestation_modules/story_content/deepred_warfare/icons/curios.dmi'
	icon_state = "scrap"

	// vvv Change Later vvv
	inhand_icon_state = "reverse_bear_trap"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	drop_sound = 'maplestation_modules/sound/items/drop/metal_drop.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/device.ogg'

/obj/item/suspicious_scrap/alt
	icon_state = "scrap_alt"
	drop_sound = 'maplestation_modules/sound/items/drop/card.ogg'
	pickup_sound = 'maplestation_modules/sound/items/pickup/card.ogg'
