/// -- Loadout helmets --
/obj/item/clothing/head/helmet/gladiator/loadout
	desc = "An almost pristine gladitorial helmet inspired by those the Ash Walkers wear. It's unarmored, looks dated, and is quite heavy."

/obj/item/clothing/head/beret/greyscale
	name = "tailored beret"
	desc = "A custom made beret."
	greyscale_colors = "#ffffff"
	icon = 'icons/map_icons/clothing/head/beret.dmi'
	icon_state = "/obj/item/clothing/head/beret/greyscale"

/obj/item/clothing/head/beret/greyscale_badge
	name = "tailored emblazoned beret"
	desc = "A custom made beret, with a badge emblazoned on it."
	post_init_icon_state = "beret_badge"
	greyscale_config = /datum/greyscale_config/beret_badge
	greyscale_config_worn = /datum/greyscale_config/beret_badge/worn
	greyscale_colors = "#ffffff#afafaf"
	icon = 'icons/map_icons/clothing/head/beret.dmi'
	icon_state = "/obj/item/clothing/head/beret/greyscale_badge"
