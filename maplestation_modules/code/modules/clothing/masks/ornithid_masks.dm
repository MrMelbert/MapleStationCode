/* code for ornithid masks
	these should be identical in stats and function to the breath masks all crew start with, or other easily found masks
*/

/obj/item/clothing/mask/breath/ornithid
	name = "ornithid mask"
	desc = "please report any fowl play, such as this exact mask appearing in game, to the git!" // pun intentional
	icon = 'maplestation_modules/icons/obj/clothing/masks.dmi'
	icon_state = "cardinal" // placeholder so missing icons shuts up
	worn_icon = 'maplestation_modules/icons/mob/clothing/masks.dmi'
	inhand_icon_state = null

/obj/item/clothing/mask/breath/ornithid/cardinal
	name = "cardinal mask"
	desc = "A striking red beak mask, popular among both Tengu and Izulukin alike."
	icon_state = "cardinal"

/obj/item/clothing/mask/breath/ornithid/secretary
	name = "white avian mask"
	desc = "An ivory-white beak mask. Despite its seemingly disarming appearence, it is commonly worn by those with a fierce heart."
	icon_state = "secretary"

/obj/item/clothing/mask/breath/ornithid/toucan
	name = "colorful avian mask"
	desc = "A rather unripe-looking beak mask. You would think its large beak would be cumbersome, but it's surprisingly light."
	icon_state = "toucan"

/obj/item/clothing/mask/breath/ornithid/bluejay
	name = "sky avian mask"
	desc = "A blue avian mask, with a beak and goggle set up that protects the wearer from most infectious particles. Incompatible with most NT filters. Assuming you actually used those." // filter incompatible because i don't want to directly subtype off gas mask, and because filters stink
	icon_state = "bluejay"
	visor_flags_inv = HIDEEARS|HIDEEYES|HIDEFACE|HIDEFACIALHAIR|HIDESNOUT
	w_class = WEIGHT_CLASS_NORMAL
	armor_type = /datum/armor/mask_gas
	visor_flags_cover = MASKCOVERSEYES | MASKCOVERSMOUTH  // mostly identical to the default plaguedoctor mask.
