// --- baby mode dress ---
/obj/item/clothing/under/dress/nndress
	name = "blue dress"
	desc = "A small blue dress. Incredibly silky and poofy."
	icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
	worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
	icon_state = "nndress"

// --- second outfit ---
/obj/item/clothing/under/dress/nnseconddress
    name = "fancy blue dress"
    desc = "A decorated blue dress. Appears silky, but feels rough upon touching it.."
    icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
    worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
    icon_state = "nnseconddress"
    resistance_flags = INDESTRUCTIBLE
    armor = list(MELEE = 0, BULLET = -5, LASER = -10, ENERGY = -10, BOMB = 0, BIO = 0, FIRE = -30, ACID = 0)
    var/handled = FALSE

/obj/item/clothing/under/dress/nnseconddress/equipped(mob/user, slot) //gives nono her jellyfishlike traits
	. = ..()
	if(slot != ITEM_SLOT_ICLOTHING)
		return
	if(ishuman(user))
		handled = TRUE
		ADD_TRAIT(user, TRAIT_VENTCRAWLER_ALWAYS, VENTCRAWLING_TRAIT) //idk what else to put as source sry if its sloppy
		ADD_TRAIT(user, TRAIT_NOBREATH, VENTCRAWLING_TRAIT)
		ADD_TRAIT(user, TRAIT_RESISTLOWPRESSURE, VENTCRAWLING_TRAIT)
		ADD_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, VENTCRAWLING_TRAIT)
		ADD_TRAIT(user, TRAIT_CAN_USE_FLIGHT_POTION, VENTCRAWLING_TRAIT)
		ADD_TRAIT(user, TRAIT_RESISTCOLD, VENTCRAWLING_TRAIT)
		to_chat(user, "<span class='notice'>You feel your body loosen up into ribbons.</span.?>")

/obj/item/clothing/under/dress/nnseconddress/dropped(mob/user)
	. = ..()
	if(handled)
		if(ishuman(user)) //same as above
			REMOVE_TRAIT(user, TRAIT_VENTCRAWLER_ALWAYS, VENTCRAWLING_TRAIT)
			REMOVE_TRAIT(user, TRAIT_NOBREATH, VENTCRAWLING_TRAIT)
			REMOVE_TRAIT(user, TRAIT_RESISTLOWPRESSURE, VENTCRAWLING_TRAIT)
			REMOVE_TRAIT(user, TRAIT_RESISTHIGHPRESSURE, VENTCRAWLING_TRAIT)
			REMOVE_TRAIT(user, TRAIT_CAN_USE_FLIGHT_POTION, VENTCRAWLING_TRAIT)
			REMOVE_TRAIT(user, TRAIT_RESISTCOLD, VENTCRAWLING_TRAIT)
			handled = FALSE
			to_chat(user, "<span class='notice'>You feel your body sow itself back together!</span.?>")

/obj/item/clothing/shoes/nnredshoes
    name = "fake red shoes"
    desc = "Red Mary Janes with a shining texture. Gliding your finger over it, it feels like sandpaper.."
    icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
    worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
    icon_state = "nnshoes"

/obj/item/clothing/head/costume/nnbluebonnet
    name = "blue bonnet"
    desc = "A decorated bonnet with various charms."
    icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_item.dmi'
    worn_icon = 'maplestation_modules/story_content/noname_equipment/icons/nndress_worn.dmi'
    icon_state = "nnbonnet"
