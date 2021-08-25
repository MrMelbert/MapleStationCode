/// -- Modular armor items. --
// BO Armor
/obj/item/clothing/suit/armor/vest/bridge_officer
	name = "bridge officer's armor vest"
	desc = "A somewhat flexible but stiff suit of armor. It reminds you of a simplier time."
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 15, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)

//Unused, but we're keeping it
/obj/item/clothing/suit/armor/vest/bridge_officer/large
	name = "bridge officer's large armor vest"
	desc = "A larger, yet still comfortable suit of armor worn by Bridge Officers who prefer function over form."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"

//AP Armor
/obj/item/clothing/suit/armor/vest/asset_protection
	name = "asset protection's armor vest"
	desc = "A rigid vest of armor worn by Asset Protection. Rigid and stiff, just like your attitude."
	icon_state = "bulletproof"
	inhand_icon_state = "bulletproof"
	armor = list(MELEE = 40, BULLET = 40, LASER = 40, ENERGY = 40, BOMB = 30, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)

/obj/item/clothing/suit/armor/vest/asset_protection/large
	name = "asset protection's large armor vest"
	desc = "A SUPPOSEDLY bulkier, heavier armor that Asset Protection can use when the situation calls for it. Feels identical to your other one."
	icon_state = "blueshift"
	inhand_icon_state = "blueshift"

/obj/item/clothing/suit/toggle/greyscale_parade
	name = "tailored parade jacket"
	desc = "No armor, all fashion, unfortunately."
	icon_state = "formal"
	inhand_icon_state = "labcoat"
	body_parts_covered = CHEST|GROIN|ARMS
	togglename = "buttons"
	greyscale_config = /datum/greyscale_config/parade_formal
	greyscale_config_worn = /datum/greyscale_config/parade_formal_worn
	greyscale_colors = "#DDDDDD"

/obj/item/clothing/suit/toggle/greyscale_parade/suit_toggle()
	. = ..()
	if(suittoggled)
		set_greyscale(new_config = /datum/greyscale_config/parade_formal_open, new_worn_config = /datum/greyscale_config/parade_formal_open_worn)
	else
		set_greyscale(new_config = initial(greyscale_config), new_worn_config = initial(greyscale_config_worn))
	var/mob/living/carbon/our_wearer = loc
	if(istype(our_wearer))
		our_wearer.update_inv_wear_suit()
