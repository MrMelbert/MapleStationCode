/obj/item/food/pizza/spaghetti
	name = "pizzaghetti"
	desc = "A pizza filled with spaghetti on the inside. \
	Considered a delicacy in the Maple Sector, and considered a war crime against Space Italy in every other sector."
	icon = 'maplestation_modules/icons/obj/food/pizza.dmi'
	icon_state = "pizzaghetti"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 30,
		/datum/reagent/consumable/nutriment/protein = 10,
		/datum/reagent/consumable/tomatojuice = 6,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1, "meat" = 1, "spaghetti" = 2)
	foodtypes = GRAIN | VEGETABLES | DAIRY | BREAKFAST
	slice_type = /obj/item/food/pizzaslice/spaghetti
	boxtag = "Levesque's Pizzaghetti" // need to name something in quebec but have no ideas? levesque is here to help
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pizza/spaghetti/raw
	name = "raw pizzaghetti"
	icon_state = "pizzaghetti_raw"
	foodtypes = GRAIN | VEGETABLES | DAIRY | BREAKFAST | RAW
	slice_type = null

/obj/item/food/pizza/spaghetti/raw/make_bakeable()
	AddComponent(/datum/component/bakeable, /obj/item/food/pizza/spaghetti, rand(70 SECONDS, 80 SECONDS), TRUE, TRUE)

/obj/item/food/pizzaslice/spaghetti
	name = "pizzaghetti slice"
	desc = "A slice of pizza filled with spaghetti on the inside. \
	The best breakfast in the Maple Sector when eaten cold in the morning."
	icon = 'maplestation_modules/icons/obj/food/pizza.dmi'
	icon_state = "pizzaghettislice"
	tastes = list("crust" = 1, "tomato" = 1, "cheese" = 1, "meat" = 1, "spaghetti" = 2)
	foodtypes = GRAIN | VEGETABLES | DAIRY | BREAKFAST
	crafting_complexity = FOOD_COMPLEXITY_3

