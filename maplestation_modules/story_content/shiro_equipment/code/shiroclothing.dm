/obj/item/clothing/under/shirodress
	name = "Doll’s Formal Uniform"
	desc = "A custom fit uniform made from higher quality fabric. Its pockets are deeper than the a standard uniform."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "dolldress"
	worn_icon_state = "dolldress"
	supports_variations_flags = CLOTHING_NO_VARIATION

/obj/item/clothing/neck/cloak/shirocloak
	name = "Side Cape"
	desc = "It's uncertain whether this is one half of a cape or a very small cape."
	icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing_icon.dmi'
	worn_icon = 'maplestation_modules/story_content/shiro_equipment/icons/shiroclothing.dmi'
	icon_state = "dollcloak"
	worn_icon_state = "dollcloak"

// putting the stuff here, since its supposed to be able to be disabled easily.
/datum/loadout_item/under/formal/shirodress
	name = "Doll's Formal Uniform"
	item_path = /obj/item/clothing/under/shirodress

/datum/loadout_item/neck/shirocloak
	name = "Side Cape"
	item_path = /obj/item/clothing/neck/cloak/shirocloak
