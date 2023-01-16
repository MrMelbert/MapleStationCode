/// -- Loadout shoes --
/obj/item/clothing/shoes/jackboots/loadout
	desc = "Tall Nanotrasen-issue combat boots for combat scenarios or combat situations. All combat, all the time. These ones come from a military surplus store and have laces."
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 75, FIRE = 0, ACID = 0)
	can_be_tied = TRUE

/obj/item/clothing/shoes/sneakers/greyscale
	name = "tailored shoes"
	desc = "A pair of custom colored tailored shoes."
	greyscale_colors = "#eeeeee#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/heels //heels
	name = "high heels"
	desc = "Shoes with tall heels. Useful for looking cool or stupid, depending on how high the heels are."
	icon = 'maplestation_modules/icons/obj/clothing/shoes/heels.dmi'
	icon_state = "heels"
	worn_icon = 'maplestation_modules/icons/mob/clothing/shoes/heels.dmi'
	flags_1 = IS_PLAYER_COLORABLE_1
	greyscale_colors = "#eeeeee"
	greyscale_config = /datum/greyscale_config/heels
	greyscale_config_worn = /datum/greyscale_config/heels_worn

/obj/item/clothing/shoes/heels/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/squeak, \
		custom_sounds = list( \
			'maplestation_modules/sound/items/highheel1.ogg' = 1, \
			'maplestation_modules/sound/items/highheel2.ogg' = 1, \
		), \
		volume_override = 55, \
		chance_override = 50, \ //50% chance just to not make people tear their ears out
	)

/obj/item/clothing/shoes/heels/fancy //the cooler heels
	name = "fancy high heels"
	desc = "Fancy high heels. Despite the looks, these weren't tailor-made for you by a fairy godmother."
	icon_state = "fancy_heels"
