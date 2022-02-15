// --- Loadout item datums for heads ---

/// Head Slot Items (Deletes overrided items)
GLOBAL_LIST_INIT(loadout_helmets, generate_loadout_items(/datum/loadout_item/head))

/datum/loadout_item/head
	category = LOADOUT_ITEM_HEAD

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE)
	if(isplasmaman(equipper))
		if(!visuals_only)
			to_chat(equipper, "Your loadout helmet was not equipped directly due to your envirosuit helmet.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.head = item_path

/datum/loadout_item/head/black_beanie
	name = "Black Beanie"
	item_path = /obj/item/clothing/head/beanie/black

/datum/loadout_item/head/christmas_beanie
	name = "Christmas Beanie"
	item_path = /obj/item/clothing/head/beanie/christmas

/datum/loadout_item/head/cyan_beanie
	name = "Cyan Beanie"
	item_path = /obj/item/clothing/head/beanie/cyan

/datum/loadout_item/head/dark_blue_beanie
	name = "Dark Blue Beanie"
	item_path = /obj/item/clothing/head/beanie/darkblue

/datum/loadout_item/head/green_beanie
	name = "Green Beanie"
	item_path = /obj/item/clothing/head/beanie/green

/datum/loadout_item/head/orange_beanie
	name = "Orange Beanie"
	item_path = /obj/item/clothing/head/beanie/orange

/datum/loadout_item/head/purple_beanie
	name = "Purple Beanie"
	item_path = /obj/item/clothing/head/beanie/purple

/datum/loadout_item/head/red_beanie
	name = "Red Beanie"
	item_path = /obj/item/clothing/head/beanie/red

/datum/loadout_item/head/striped_beanie
	name = "Striped Beanie"
	item_path = /obj/item/clothing/head/beanie/striped

/datum/loadout_item/head/striped_red_beanie
	name = "Striped Red Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedred

/datum/loadout_item/head/striped_blue_beanie
	name = "Striped Blue Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedblue

/datum/loadout_item/head/striped_green_beanie
	name = "Striped Green Beanie"
	item_path = /obj/item/clothing/head/beanie/stripedgreen

/datum/loadout_item/head/white_beanie
	name = "White Beanie"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/yellow_beanie
	name = "Yellow Beanie"
	item_path = /obj/item/clothing/head/beanie/yellow

/datum/loadout_item/head/greyscale_beret
	name = "Greyscale Beret"
	can_be_greyscale = TRUE
	item_path = /obj/item/clothing/head/beret/greyscale

/datum/loadout_item/head/greyscale_beret/badge
	name = "Greyscale Beret (with badge)"
	item_path = /obj/item/clothing/head/beret/greyscale

/datum/loadout_item/head/black_beret
	name = "Black Beret"
	item_path = /obj/item/clothing/head/beret/black

/datum/loadout_item/head/red_beret
	name = "Red Beret"
	item_path = /obj/item/clothing/head/beret

/datum/loadout_item/head/black_cap
	name = "Black Cap"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/blue_cap
	name = "Blue Cap"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/delinquent_cap
	name = "Delinquent Cap"
	item_path = /obj/item/clothing/head/delinquent

/datum/loadout_item/head/green_cap
	name = "Green Cap"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/grey_cap
	name = "Grey Cap"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/orange_cap
	name = "Orange Cap"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/purple_cap
	name = "Purple Cap"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/rainbow_cap
	name = "Rainbow Cap"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/red_cap
	name = "Red Cap"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/white_cap
	name = "White Cap"
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/yellow_cap
	name = "Yellow Cap"
	item_path = /obj/item/clothing/head/soft/yellow

/datum/loadout_item/head/flatcap
	name = "Flat Cap"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/beige_fedora
	name = "Beige Fedora"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/black_fedora
	name = "Black Fedora"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/white_fedora
	name = "White Fedora"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/dark_blue_hardhat
	name = "Dark Blue Hardhat"
	item_path = /obj/item/clothing/head/hardhat/dblue

/datum/loadout_item/head/orange_hardhat
	name = "Orange Hardhat"
	item_path = /obj/item/clothing/head/hardhat/orange

/datum/loadout_item/head/red_hardhat
	name = "Red Hardhat"
	item_path = /obj/item/clothing/head/hardhat/red

/datum/loadout_item/head/white_hardhat
	name = "White Hardhat"
	item_path = /obj/item/clothing/head/hardhat/white

/datum/loadout_item/head/yellow_hardhat
	name = "Yellow Hardhat"
	item_path = /obj/item/clothing/head/hardhat

/datum/loadout_item/head/gladiator_helmet
	name = "Gladiator Helmet"
	item_path = /obj/item/clothing/head/helmet/gladiator/loadout

/datum/loadout_item/head/mail_cap
	name = "Mail Cap"
	item_path = /obj/item/clothing/head/mailman

/datum/loadout_item/head/nurse_hat
	name = "Nurse Hat"
	item_path = /obj/item/clothing/head/nursehat

/datum/loadout_item/head/kitty_ears
	name = "Kitty Ears"
	item_path = /obj/item/clothing/head/kitty

/datum/loadout_item/head/rabbit_ears
	name = "Rabbit Ears"
	item_path = /obj/item/clothing/head/rabbitears

/datum/loadout_item/head/bandana
	name = "Bandana"
	item_path = /obj/item/clothing/head/bandana

/datum/loadout_item/head/rastafarian
	name = "Rastafarian Cap"
	item_path = /obj/item/clothing/head/beanie/rasta

/datum/loadout_item/head/top_hat
	name = "Top Hat"
	item_path = /obj/item/clothing/head/that

/datum/loadout_item/head/bowler_hat
	name = "Bowler Hat"
	item_path = /obj/item/clothing/head/bowler

/datum/loadout_item/head/bear_pelt
	name = "Bear Pelt"
	item_path = /obj/item/clothing/head/bearpelt

/datum/loadout_item/head/ushanka
	name ="Ushanka"
	item_path = /obj/item/clothing/head/ushanka

/datum/loadout_item/head/plague_doctor
	name = "Plague Doctor Cap"
	item_path = /obj/item/clothing/head/plaguedoctorhat

/datum/loadout_item/head/wedding_veil
	name = "Wedding Veil"
	item_path = /obj/item/clothing/head/weddingveil

/datum/loadout_item/head/poppy
	name = "Poppy"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/lily
	name = "Lily"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/geranium
	name = "Geranium"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/rose
	name = "Rose"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/sunflower
	name = "Sunflower"
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/harebell
	name = "Harebell"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/rainbow_bunch
	name = "Rainbow Bunch"
	item_path = /obj/item/food/grown/rainbow_flower
	additional_tooltip_contents = list(TOOLTIP_RANDOM_COLOR)
