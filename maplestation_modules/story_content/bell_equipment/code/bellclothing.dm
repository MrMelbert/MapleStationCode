// --- regular outfit ---

/obj/item/clothing/under/jumpsuit/belli
	name = "modified nun uniform"
	desc = "A heavily modified nun uniform tinted pink with white lace and red ribbons. Stomp out cultists with style!"
	icon = 'maplestation_modules/story_content/bell_equipment/icons/bellclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/bell_equipment/icons/bellclothing_worn.dmi'
	icon_state = "nundress"
	resistance_flags = INDESTRUCTIBLE
	alternate_worn_layer = ABOVE_SHOES_LAYER

/datum/loadout_item/under/jumpsuit/belli
	name = "Modified Nun Uniform"
	item_path = /obj/item/clothing/under/jumpsuit/belli

/datum/loadout_item/under/jumpsuit/belli/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/head/costume/hat/belli
	name = "pink nun veil"
	desc = "A pink nun veil with just enough space to let your hair hang out."
	icon = 'maplestation_modules/story_content/bell_equipment/icons/bellclothing_item.dmi'
	worn_icon = 'maplestation_modules/story_content/bell_equipment/icons/bellclothing_worn.dmi'
	icon_state = "nunveil"

/datum/loadout_item/head/belli
	name = "Modified Nun Veil"
	item_path = /obj/item/clothing/head/costume/hat/belli

/datum/loadout_item/head/belli/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
