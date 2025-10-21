// --- Loadout item datums for exosuits / suits ---

/// Exosuit / Outersuit Slot Items (Deletes overrided items)
/datum/loadout_category/outer_suit
	category_name = "Suit"
	type_to_generate = /datum/loadout_item/suit
	tab_order = 6

/datum/loadout_item/suit
	abstract_type = /datum/loadout_item/suit

/datum/loadout_item/suit/insert_path_into_outfit(datum/outfit/outfit, list/item_details, mob/living/carbon/human/equipper, visuals_only, job_equipping_step)
	if(outfit.suit)
		LAZYADD(outfit.backpack_contents, outfit.suit)
	if(outfit.suit_store)
		if(outfit.suit_store::w_class <= WEIGHT_CLASS_NORMAL)
			LAZYADD(outfit.backpack_contents, outfit.suit_store)
		else if((!outfit.belt || (outfit.belt::w_class <= WEIGHT_CLASS_NORMAL)) && (outfit.suit_store::slot_flags & ITEM_SLOT_BELT))
			if(outfit.belt)
				LAZYADD(outfit.backpack_contents, outfit.belt)
			outfit.belt = outfit.suit_store
		else if(!outfit.r_hand)
			outfit.r_hand = outfit.suit_store
		else if(!outfit.l_hand)
			outfit.l_hand = outfit.suit_store
		// no else condition - if every check failed, we just nuke whatever was there
		// which is fine, suitstore generally contains replaceable items like pens, tanks, or weapons
		outfit.suit_store = null

	outfit.suit = item_path

/datum/loadout_item/suit/winter_coat
	name = "Winter Coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat

/datum/loadout_item/suit/winter_coat_greyscale
	name = "Greyscale Winter Coat"
	item_path = /obj/item/clothing/suit/hooded/wintercoat/custom

/datum/loadout_item/suit/parade_jacket_greyscale
	name = "Greyscale Parade Jacket"
	item_path = /obj/item/clothing/suit/greyscale_parade

/datum/loadout_item/suit/big_jacket
	name = "Greyscale Jacket Large"
	item_path = /obj/item/clothing/suit/jacket/oversized

/datum/loadout_item/suit/blazer
	name = "Greyscale Blazer"
	item_path = /obj/item/clothing/suit/jacket/blazer

/datum/loadout_item/suit/trenchcoat
	name = "Greyscale Trenchcoat"
	item_path = /obj/item/clothing/suit/toggle/jacket/trenchcoat

/datum/loadout_item/suit/fancy_jacket
	name = "Greyscale Fur Coat"
	item_path = /obj/item/clothing/suit/jacket/fancy

/datum/loadout_item/suit/sweater
	name = "Greyscale Sweater"
	item_path = /obj/item/clothing/suit/toggle/jacket/sweater

/datum/loadout_item/suit/denim_overalls
	name = "Overalls (Denim)"
	item_path = /obj/item/clothing/suit/apron/overalls

/datum/loadout_item/suit/job_overall
	name = "Overalls (Job)"
	item_path = /obj/item/clothing/suit/apron/overalls/grey
	loadout_flags = LOADOUT_FLAG_JOB_GREYSCALING
	job_greyscale_palettes = list(
		/datum/job/assistant = COLOR_JOB_DEFAULT,
		/datum/job/botanist = /obj/item/clothing/suit/apron/overalls::greyscale_colors,
		/datum/job/captain = COLOR_JOB_COMMAND_GENERIC,
		/datum/job/head_of_personnel = COLOR_JOB_COMMAND_GENERIC,
		/datum/job/head_of_security = COLOR_JOB_DEFAULT,
		/datum/job/paramedic = "#28324b",
		/datum/job/prisoner = "#ff8b00",
	)


/datum/loadout_item/suit/black_suit_jacket
	name = "Black Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/black

/datum/loadout_item/suit/blue_suit_jacket
	name = "Blue Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer

/datum/loadout_item/suit/purple_suit_jacket
	name = "Purple Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/purple

/datum/loadout_item/suit/greyscale_suit_jacket
	name = "Greyscale Suit Jacket"
	item_path = /obj/item/clothing/suit/toggle/lawyer/greyscale

/datum/loadout_item/suit/suspenders_greyscale
	name = "Suspenders"
	item_path = /obj/item/clothing/suit/toggle/suspenders/greyscale

/datum/loadout_item/suit/white_dress
	name = "White Dress"
	item_path = /obj/item/clothing/suit/costume/whitedress

/datum/loadout_item/suit/labcoat
	name = "Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat

/datum/loadout_item/suit/labcoat_green
	name = "Green Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/mad

/datum/loadout_item/suit/ce
	name = "CE Labcoat"
	item_path = /obj/item/clothing/suit/toggle/labcoat/ce


/datum/loadout_item/suit/goliath_cloak
	name = "Heirloom Goliath Cloak"
	item_path = /obj/item/clothing/suit/hooded/cloak/goliath/heirloom

/datum/loadout_item/suit/goliath_cloak/get_item_information()
	. = ..()
	.[FA_ICON_VR_CARDBOARD] = "Cosmetic"

/datum/loadout_item/suit/poncho
	name = "Poncho"
	item_path = /obj/item/clothing/suit/costume/poncho

/datum/loadout_item/suit/poncho_green
	name = "Green Poncho"
	item_path = /obj/item/clothing/suit/costume/poncho/green

/datum/loadout_item/suit/poncho_red
	name = "Red Poncho"
	item_path = /obj/item/clothing/suit/costume/poncho/red

/datum/loadout_item/suit/wawaiian_shirt
	name = "Hawaiian Shirt"
	item_path = /obj/item/clothing/suit/costume/hawaiian

/datum/loadout_item/suit/bomber_jacket
	name = "Bomber Jacket"
	item_path = /obj/item/clothing/suit/jacket/bomber

/datum/loadout_item/suit/military_jacket
	name = "Military Jacket"
	item_path = /obj/item/clothing/suit/jacket/miljacket

/datum/loadout_item/suit/puffer_jacket
	name = "Puffer Jacket"
	item_path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_item/suit/puffer_vest
	name = "Puffer Vest"
	item_path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_item/suit/leather_jacket
	name = "Leather Jacket"
	item_path = /obj/item/clothing/suit/jacket/leather

/datum/loadout_item/suit/leather_coat
	name = "Leather Coat"
	item_path = /obj/item/clothing/suit/jacket/leather/biker

/datum/loadout_item/suit/brown_letterman
	name = "Brown Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman

/datum/loadout_item/suit/red_letterman
	name = "Red Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman_red

/datum/loadout_item/suit/blue_letterman
	name = "Blue Letterman"
	item_path = /obj/item/clothing/suit/jacket/letterman_nanotrasen

/datum/loadout_item/suit/bee
	name = "Bee Outfit"
	item_path = /obj/item/clothing/suit/hooded/bee_costume

/datum/loadout_item/suit/plague_doctor
	name = "Plague Doctor Suit"
	item_path = /obj/item/clothing/suit/bio_suit/plaguedoctorsuit

/datum/loadout_item/suit/grass_skirt
	name = "Grass Skirt"
	item_path = /obj/item/clothing/suit/grasskirt

/datum/loadout_item/suit/ethereal_cloak
	name = "Ethereal Cloak"
	item_path = /obj/item/clothing/suit/hooded/ethereal_raincoat

/datum/loadout_item/suit/moth_cloak
	name = "Mothic Cloak"
	item_path = /obj/item/clothing/suit/mothcoat

/datum/loadout_item/suit/moth_cloak_winter
	name = "Mothic Winter Cloak"
	item_path = /obj/item/clothing/suit/mothcoat/winter

/datum/loadout_item/suit/flannel_jacket
	name = "Flannel Jacket"
	item_path = /obj/item/clothing/suit/toggle/flannel

/datum/loadout_item/suit/chesed_jacket
	name = "Well-Kept Jacket"
	item_path = /obj/item/clothing/suit/toggle/chesedjacket

/datum/loadout_item/suit/wellworn_shirt
	name = "Well-Worn Shirt" // No, I'm not adding the dirty alt
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt

/datum/loadout_item/suit/wellworn_shirt/graphic
	name = "Well-Worn Graphic Shirt"
	item_path = /obj/item/clothing/suit/costume/wellworn_shirt/graphic
