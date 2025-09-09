/// -- Loadout shoes --
/obj/item/clothing/shoes/jackboots/loadout
	desc = /obj/item/clothing/shoes/jackboots::desc + " These ones come from a military surplus store, and have laces."
	armor_type = /datum/armor/loadout_jackboots
	can_be_tied = TRUE

/datum/armor/loadout_jackboots
	bio = 75

/obj/item/clothing/shoes/sneakers/greyscale
	name = "tailored shoes"
	desc = "A pair of custom colored tailored shoes."
	greyscale_colors = "#eeeeee#ffffff"
	flags_1 = IS_PLAYER_COLORABLE_1

/obj/item/clothing/shoes/heels //heels
	name = "high heels"
	desc = "Shoes with tall heels. Useful for looking cool or stupid, depending on how high the heels are."
	icon = 'icon/map_icons/obj/clothing/shoes/_shoes.dmi'
	icon_state = "/obj/item/clothing/shoes/heels"
	post_init_icon_state = "heels"
	flags_1 = IS_PLAYER_COLORABLE_1 | NO_NEW_GAGS_PREVIEW_1
	greyscale_colors = "#eeeeee"
	greyscale_config = /datum/greyscale_config/heels
	greyscale_config_worn = /datum/greyscale_config/heels_worn

/obj/item/clothing/shoes/heels/Initialize(mapload)
	. = ..()
	AddComponent( \
		/datum/component/shoe_footstep, \
		sounds = list( \
			'maplestation_modules/sound/items/highheel1.ogg', \
			'maplestation_modules/sound/items/highheel2.ogg', \
		), \
		volume = 55, \
		chance_per_play = 50, \
		can_tape = TRUE, \
	)

/obj/item/clothing/shoes/heels/fancy //the cooler heels
	name = "fancy high heels"
	desc = "Fancy high heels. Despite the looks, these weren't tailor-made for you by a fairy godmother."
	icon_state = "/obj/item/clothing/shoes/heels/fancy"
	post_init_icon_state = "fancy_heels"
