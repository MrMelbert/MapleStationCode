// -- Shoes with digi support. Cursed --
// Some digitigrade pants sprites ported from skyrat-tg / citadel.
/obj/item/clothing/shoes
	digitigrade_file = 'maplestation_modules/icons/mob/clothing/shoes/digi_shoes.dmi'

/obj/item/clothing/shoes/Initialize()
	. = ..()
	if(has_digi_support) // All digi support items can be equipped by digis (duhhh)
		item_flags |= IGNORE_DIGITIGRADE

/obj/item/clothing/shoes/sandal
	has_digi_support = TRUE
