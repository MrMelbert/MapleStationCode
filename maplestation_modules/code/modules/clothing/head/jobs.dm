/// -- Head clothing items for modular jobs --
//BO Beret
/obj/item/clothing/head/beret/black/bridge_officer
	name = "bridge officer's beret"
	desc = "A stylish beret used by deck officers whom man the bridge. Reminiscent of an older time."
	icon = 'maplestation_modules/icons/obj/clothing/hats.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/head.dmi'
	icon_state = "boberetblack"
	greyscale_config = null
	greyscale_config_worn = null

//AP Beret
/obj/item/clothing/head/beret/black/asset_protection
	name = "asset protection officer's beret"
	desc = "A black beret, armored and padded for protection, complete with a red insignia emblazoned on the center to dignify the wearer as an asset protection officer."
	icon = 'maplestation_modules/icons/obj/clothing/hats.dmi'
	worn_icon = 'maplestation_modules/icons/mob/clothing/head.dmi'
	icon_state = "apberetblack"
	greyscale_config = null
	greyscale_config_worn = null
	armor_type = /datum/armor/ap_hat

/datum/armor/ap_hat
	melee = 40
	bullet = 30
	laser = 30
	energy = 40
	bomb = 25
	bio = 0
	fire = 20
	acid = 50
	wound = 5
