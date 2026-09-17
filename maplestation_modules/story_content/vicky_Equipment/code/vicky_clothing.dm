//Vicky's dress
//A fancy looking dress that is out of a hodgepodge of different frilly fabrics.
/obj/item/clothing/under/uniquedress
	name = "Unique Dress"
	desc = "A fancy, well worn, yet taken care of dress."
	icon = 'maplestation_modules/story_content/vicky_Equipment/icons/vickyclothing.dmi'
	worn_icon = 'maplestation_modules/story_content/vicky_Equipment/icons/vickyclothing.dmi'
	icon_state = "vickydress"
	worn_icon_state = "vickydress"
	body_parts_covered = CHEST|GROIN
	can_adjust = FALSE
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/datum/loadout_item/under/formal/uniquedress
	name = "Unique Dress"
	item_path = /obj/item/clothing/under/uniquedress

/datum/loadout_item/under/formal/uniquedress/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"

/obj/item/clothing/neck/cloak/uniquecape
	name = "Unique Side Cape"
	desc = "A green side cape that covers half the back. It has a big tuft of green feathers on the shoulder."
	icon = 'maplestation_modules/story_content/vicky_Equipment/icons/vickyclothing.dmi'
	worn_icon = 'maplestation_modules/story_content/vicky_Equipment/icons/vickyclothing.dmi'
	icon_state = "vickycloak"
	worn_icon_state = "vickycloak"
	body_parts_covered = CHEST|GROIN|ARMS

/datum/loadout_item/neck/uniquecape
	name = "Unique Side Cape"
	item_path = /obj/item/clothing/neck/cloak/uniquecape

/datum/loadout_item/neck/uniquecape/get_item_information()
	. = ..()
	.[FA_ICON_MASKS_THEATER] = "Character item"
