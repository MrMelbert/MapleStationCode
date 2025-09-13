/// Head Slot Items (Deletes overrided items)
/datum/loadout_category/head
	category_name = "Head"
	type_to_generate = /datum/loadout_item/head
	tab_order = 1

/datum/loadout_item/head
	abstract_type = /datum/loadout_item/head
	group = "Other"

/datum/loadout_item/head/insert_path_into_outfit(datum/outfit/outfit, mob/living/carbon/human/equipper, visuals_only = FALSE, job_equipping_step = FALSE)
	if(equipper.dna?.species?.outfit_important_for_life)
		if(!visuals_only)
			to_chat(equipper, "Your loadout helmet was not equipped directly due to your species outfit.")
			LAZYADD(outfit.backpack_contents, item_path)
	else
		outfit.head = item_path

/datum/loadout_item/head/beanie
	name = "Beanie (Colorable)"
	item_path = /obj/item/clothing/head/beanie

/datum/loadout_item/head/cap/fancy
	name = "Fancy Hat (Colorable)"
	item_path = /obj/item/clothing/head/costume/fancy

/datum/loadout_item/head/greyscale_beret
	name = "Greyscale Beret"
	item_path = /obj/item/clothing/head/beret/greyscale

/datum/loadout_item/head/greyscale_beret/badge
	name = "Greyscale Beret (with badge)"
	item_path = /obj/item/clothing/head/beret/greyscale_badge

/datum/loadout_item/head/cap
	abstract_type = /datum/loadout_item/head/cap
	group = "Caps"

/datum/loadout_item/head/cap/black
	name = "Cap (Black)"
	item_path = /obj/item/clothing/head/soft/black

/datum/loadout_item/head/cap/blue
	name = "Cap (Blue)"
	item_path = /obj/item/clothing/head/soft/blue

/datum/loadout_item/head/cap/delinquent
	name = "Cap (Delinquent)"
	item_path = /obj/item/clothing/head/costume/delinquent

/datum/loadout_item/head/cap/green
	name = "Cap (Green)"
	item_path = /obj/item/clothing/head/soft/green

/datum/loadout_item/head/cap/grey
	name = "Cap (Grey)"
	item_path = /obj/item/clothing/head/soft/grey

/datum/loadout_item/head/cap/orange
	name = "Cap (Orange)"
	item_path = /obj/item/clothing/head/soft/orange

/datum/loadout_item/head/cap/purple
	name = "Cap (Purple)"
	item_path = /obj/item/clothing/head/soft/purple

/datum/loadout_item/head/cap/rainbow
	name = "Cap (Rainbow)"
	item_path = /obj/item/clothing/head/soft/rainbow

/datum/loadout_item/head/cap/red
	name = "Cap (Red)"
	item_path = /obj/item/clothing/head/soft/red

/datum/loadout_item/head/cap/brown
	name = "Cap (Brown)"
	item_path = /obj/item/clothing/head/soft

/datum/loadout_item/head/cap/yellow
	name = "Cap (Yellow)"
	item_path = /obj/item/clothing/head/soft/yellow


/datum/loadout_item/head/cap/white
	name = "Cap (White)"
	item_path = /obj/item/clothing/head/soft/mime

/datum/loadout_item/head/flatcap
	name = "Cap (Flat)"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/fedora
	abstract_type = /datum/loadout_item/head/fedora
	group = "Fedoras"

/datum/loadout_item/head/fedora/beige
	name = "Fedora (Beige)"
	item_path = /obj/item/clothing/head/fedora/beige

/datum/loadout_item/head/fedora/black
	name = "Fedora (Black)"
	item_path = /obj/item/clothing/head/fedora

/datum/loadout_item/head/fedora/white
	name = "Fedora (White)"
	item_path = /obj/item/clothing/head/fedora/white

/datum/loadout_item/head/cap/mail
	name = "Cap (Mail)"
	item_path = /obj/item/clothing/head/costume/mailman

/datum/loadout_item/head/flatcap
	name = "Flat Cap"
	item_path = /obj/item/clothing/head/flatcap

/datum/loadout_item/head/hardhat
	abstract_type = /datum/loadout_item/head/hardhat
	group = "Hardhats"

/datum/loadout_item/head/hardhat/dark_blue
	name = "Hardhat (Dark Blue)"
	item_path = /obj/item/clothing/head/utility/hardhat/dblue

/datum/loadout_item/head/hardhat/orange
	name = "Hardhat (Orange)"
	item_path = /obj/item/clothing/head/utility/hardhat/orange

/datum/loadout_item/head/hardhat/red
	name = "Hardhat (Red)"
	item_path = /obj/item/clothing/head/utility/hardhat/red

/datum/loadout_item/head/hardhat/white
	name = "Hardhat (White)"
	item_path = /obj/item/clothing/head/utility/hardhat/white

/datum/loadout_item/head/hardhat/yellow
	name = "Hardhat (Yellow)"
	item_path = /obj/item/clothing/head/utility/hardhat

/datum/loadout_item/head/gladiator_helmet
	name = "Gladiator Helmet"
	item_path = /obj/item/clothing/head/helmet/gladiator/loadout

/datum/loadout_item/head/cap/mail
	name = "Cap (Mail)"
	item_path = /obj/item/clothing/head/costume/mailman

/datum/loadout_item/head/nurse_hat
	name = "Nurse Hat"
	item_path = /obj/item/clothing/head/costume/nursehat

/datum/loadout_item/head/kitty_ears
	name = "Kitty Ears"
	item_path = /obj/item/clothing/head/costume/kitty

/datum/loadout_item/head/rabbit_ears
	name = "Rabbit Ears"
	item_path = /obj/item/clothing/head/costume/rabbitears

/datum/loadout_item/head/bandana
	name = "Bandana Thin"
	item_path = /obj/item/clothing/head/costume/tmc

/datum/loadout_item/head/rastafarian
	name = "Rastacap"
	item_path = /obj/item/clothing/head/rasta

/datum/loadout_item/head/top_hat
	name = "Top Hat"
	item_path = /obj/item/clothing/head/hats/tophat

/datum/loadout_item/head/bowler_hat
	name = "Bowler Hat"
	item_path = /obj/item/clothing/head/hats/bowler

/datum/loadout_item/head/bear_pelt
	name = "Bear Pelt"
	item_path = /obj/item/clothing/head/costume/bearpelt

/datum/loadout_item/head/ushanka
	name ="Ushanka"
	item_path = /obj/item/clothing/head/costume/ushanka

/datum/loadout_item/head/plague_doctor
	name = "Plague Doctor hat"
	item_path = /obj/item/clothing/head/bio_hood/plague

/datum/loadout_item/head/wedding_veil
	name = "Wedding Veil"
	item_path = /obj/item/clothing/head/costume/weddingveil

/datum/loadout_item/head/flower
	abstract_type = /datum/loadout_item/head/flower
	group = "Single Flowers"

/datum/loadout_item/head/flower/poppy
	name = "Poppy"
	item_path = /obj/item/food/grown/poppy

/datum/loadout_item/head/flower/lily
	name = "Lily"
	item_path = /obj/item/food/grown/poppy/lily

/datum/loadout_item/head/flower/geranium
	name = "Geranium"
	item_path = /obj/item/food/grown/poppy/geranium

/datum/loadout_item/head/flower/rose
	name = "Rose"
	item_path = /obj/item/food/grown/rose

/datum/loadout_item/head/flower/sunflower
	name = "Sunflower"
	item_path = /obj/item/food/grown/sunflower

/datum/loadout_item/head/flower/harebell
	name = "Harebell"
	item_path = /obj/item/food/grown/harebell

/datum/loadout_item/head/flower/rainbow_bunch
	name = "Random Rainbow Bunch"
	item_path = /obj/item/food/grown/rainbow_flower

/datum/loadout_item/head/wig
	name = "Natural Wig"
	item_path = /obj/item/clothing/head/wig/natural

/datum/loadout_item/head/cowboy
	name = "Cowboy Hat (Brown)"
	item_path = /obj/item/clothing/head/cowboy/brown
	group = "Cowboy Hats"

/datum/loadout_item/head/cowboy/black
	name = "Cowboy Hat (Black)"
	item_path = /obj/item/clothing/head/cowboy/black

/datum/loadout_item/head/cowboy/white
	name = "Cowboy Hat (White)"
	item_path = /obj/item/clothing/head/cowboy/white

/datum/loadout_item/head/cowboy/grey
	name = "Cowboy Hat (Grey)"
	item_path = /obj/item/clothing/head/cowboy/grey

/datum/loadout_item/head/cowboy/red
	name = "Cowboy Hat (Red)"
	item_path = /obj/item/clothing/head/cowboy/red

/datum/loadout_item/head/propeller_hat
	name = "Propeller Hat"
	item_path = /obj/item/clothing/head/soft/propeller_hat

/datum/loadout_item/head/garland
	name = "Garland"
	item_path = /obj/item/clothing/head/costume/garland
	group = "Garlands"

/datum/loadout_item/head/garland/rainbowbunch
	name = "Rainbow Flower Crown"
	item_path = /obj/item/clothing/head/costume/garland/rainbowbunch

/datum/loadout_item/head/garland/sunflower
	name = "Sunflower Crown"
	item_path = /obj/item/clothing/head/costume/garland/sunflower

/datum/loadout_item/head/garland/poppy
	name = "Poppy Crown"
	item_path = /obj/item/clothing/head/costume/garland/poppy

/datum/loadout_item/head/garland/lily
	name = "Lily Crown"
	item_path = /obj/item/clothing/head/costume/garland/lily

/datum/loadout_item/head/santa
	name = "Santa Hat"
	item_path = /obj/item/clothing/head/costume/santa/gags
	required_holiday = FESTIVE_SEASON
