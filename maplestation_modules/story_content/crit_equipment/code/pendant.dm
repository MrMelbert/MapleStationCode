/obj/item/clothing/neck/annatto_pendant
	name = "orange-blue pendant"
	desc = "A orange and blue swirl pendant with a purple chain made of obsidian-like material. It seems like it can open."
	icon = 'maplestation_modules/story_content/crit_equipment/icons/greenleaf_amulet.dmi'
	icon_state = "greenleaf_amulet"
	worn_icon = 'maplestation_modules/story_content/crit_equipment/icons/greenleaf_amulet_worn.dmi'
	worn_icon_state = "greenleaf_amulet"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE // thing is built TOUGH
	var/pendant_open = FALSE

/obj/item/clothing/neck/annatto_pendant/attack_self(mob/user)
	if(!pendant_open)
		pendant_open = TRUE
		message_admins("[user] has opened the [src]. [ADMIN_FLW(src)]") // spoiler protection
		icon_state = "greenleaf_amulet-open"
	else
		pendant_open = FALSE
		icon_state = "greenleaf_amulet"
