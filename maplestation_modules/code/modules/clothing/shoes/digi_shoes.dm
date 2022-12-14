// -- Shoes with digi support. Cursed --
// Some digitigrade shoe sprites ported from skyrat-tg / citadel.
/obj/item/clothing/shoes
	digitigrade_file = null // DIGITIGRADE_SHOES_FILE

/obj/item/clothing/shoes/Initialize()
	. = ..()
	if(supports_variations_flags & (CLOTHING_DIGITIGRADE_VARIATION|CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON)) // All digi support items can be equipped by digis (duhhh)
		item_flags |= IGNORE_DIGITIGRADE

/obj/item/clothing/shoes/sandal
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/shoes/digi_shoes.dmi'
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION
