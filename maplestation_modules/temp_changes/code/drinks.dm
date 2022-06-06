// Taken from https://github.com/tgstation/tgstation/pull/66538

// Drinks
/obj/item/reagent_containers/food/drinks
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/item/broken_bottle
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/projectile/bullet/reusable/champagne_cork
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/item/trash/champagne_cork
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/item/reagent_containers/borghypo/borgshaker
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/item/reagent_containers/glass/bottle/adminordrazine
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/datum/reagent
	glass_icon_file = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/item/reagent_containers/glass/beaker/unholywater
	icon = 'maplestation_modules/temp_changes/icons/drinks.dmi'

/obj/item/reagent_containers/food/drinks/ice
	icon_state = "icecup"

/obj/item/reagent_containers/food/drinks/shaker/Initialize(mapload)
	. = ..()
	if(prob(10))
		name = "\improper NanoTrasen 20th Anniversary Shaker"
		desc += " It has an emblazoned NanoTrasen logo on it."
		icon_state = "shaker_n"

/datum/reagent/consumable/ethanol/beer
	taste_description = "mild carbonated malt"

// Contraband posters
/obj/structure/sign/poster/contraband/robust_softdrinks
	name = "Robust Softdrinks"
	desc = "Robust Softdrinks: More robust than a toolbox to the head!"
	icon_state = "robust_softdrinks"

/obj/structure/sign/poster/contraband/shamblers_juice
	name = "Shambler's Juice"
	desc = "~Shake me up some of that Shambler's Juice!~"
	icon = 'maplestation_modules/temp_changes/icons/contraband.dmi'
	icon_state = "shamblers_juice"

/obj/structure/sign/poster/contraband/pwr_game
	name = "Pwr Game"
	desc = "The POWER that gamers CRAVE! In partnership with Vlad's Salad."
	icon = 'maplestation_modules/temp_changes/icons/contraband.dmi'
	icon_state = "pwr_game"

/obj/structure/sign/poster/contraband/starkist
	name = "Star-kist"
	desc = "Drink the stars!"
	icon = 'maplestation_modules/temp_changes/icons/contraband.dmi'
	icon_state = "starkist"

/obj/structure/sign/poster/contraband/space_cola
	name = "Space Cola"
	desc = "Your favorite cola, in space."
	icon = 'maplestation_modules/temp_changes/icons/contraband.dmi'
	icon_state = "space_cola"

/obj/structure/sign/poster/contraband/space_up
	name = "Space-Up!"
	desc = "Sucked out into space by the FLAVOR!"
	icon = 'maplestation_modules/temp_changes/icons/contraband.dmi'
	icon_state = "space_up"

// Crushed can
/obj/item/trash/can
	icon = 'maplestation_modules/temp_changes/icons/janitor.dmi'

/obj/item/storage/bag/chemistry
	icon_state = "bag"
