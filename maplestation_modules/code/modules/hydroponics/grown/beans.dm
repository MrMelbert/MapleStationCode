// -- Modular grown food --
// you wanted leema beens, you're getting leema beens.
/obj/item/seeds/leemabeens
	name = "pack of leemabeen seeds"
	desc = "These seeds grow into something called leema beans?"
	icon_state = "seed-soybean"
	species = "soybean"
	plantname = "Leemabeen Plants"
	product = /obj/item/food/grown/leemabeens
	maturation = 4
	production = 4
	potency = 15
	growthstages = 4
	growing_icon = 'icons/obj/hydroponics/growing_vegetables.dmi'
	icon_grow = "soybean-grow"
	icon_dead = "soybean-dead"
	genes = list(/datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(/datum/reagent/consumable/nutriment/vitamin = 0.04, /datum/reagent/consumable/nutriment = 0.05)

/obj/item/food/grown/leemabeens
	seed = /obj/item/seeds/leemabeens
	name = "leema beens"
	desc = "What exactly are these supposed to be, anyway?"
	gender = PLURAL
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "gas_alt"
	bite_consumption_mod = 2
	foodtypes = VEGETABLES
	tastes = list("mapper frustration" = 1)
	wine_power = 20

// Added to vending machines
/obj/machinery/vending/hydroseeds
	added_products = list(/obj/item/seeds/leemabeens = 3)
