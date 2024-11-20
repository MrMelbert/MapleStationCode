/datum/crafting_recipe/food/starfruit_ribs
	name = "Starfruit Glazed Ribs"
	reqs = list(
		/obj/item/food/bbqribs = 1,
		/obj/item/food/grown/starfruit = 2,
		/datum/reagent/consumable/starfruit_juice = 5,
	)
	result = /obj/item/food/starfruit_ribs
	category = CAT_MEAT

/datum/crafting_recipe/food/meat_platter
	name = "BBQ Meat Platter"
	reqs = list(
		/obj/item/food/bbqribs,
		/obj/item/food/starfruit_ribs,
		/obj/item/food/roasted_bell_pepper = 2,
	)
	result = /obj/item/food/meat_platter
	category = CAT_MEAT

/datum/crafting_recipe/food/starfruit_chicken_alfredo
	name = "Starfruit Chicken Alfredo"
	reqs = list(
		/obj/item/food/meat/slab/chicken = 1,
		/obj/item/food/grown/starfruit = 2,
		/datum/reagent/consumable/cream = 10,
		/obj/item/food/spaghetti/boiledspaghetti = 1
	)
	result = /obj/item/food/starfruit_chicken_alfredo
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/starfruit_sushi_roll
	name = "Starfruit Sushi Roll"
	reqs = list(
		/obj/item/food/seaweedsheet = 1,
		/obj/item/food/boiledrice = 1,
		/obj/item/food/starfruit_sashimi = 1,
	)
	result = /obj/item/food/starfruit_sushi_roll
	category = CAT_SEAFOOD

/datum/crafting_recipe/food/starfruit_sashimi
	name = "Starfruit Sashimi"
	reqs = list(
		/obj/item/food/fishmeat = 2,
		/datum/reagent/consumable/soysauce = 10,
		/obj/item/food/grown/starfruit = 1,
	)
	result = /obj/item/food/starfruit_sashimi
	category = CAT_SEAFOOD

/datum/crafting_recipe/food/eggplant_fry
	name = "Starfruit Eggplant Stir Fry"
	reqs = list(
		/obj/item/food/grown/eggplant = 1,
		/obj/item/food/grown/bell_pepper = 1,
		/obj/item/food/grown/cabbage = 1,
		/obj/item/food/grown/starfruit = 1,
		/obj/item/food/grown/carrot = 1,
	)
	result = /obj/item/food/eggplant_fry
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/starfruit_tofu_beef
	name = "Starfruit Tofu Beef Teriyaki"
	reqs = list(
		/obj/item/food/tofu = 1,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/spaghetti/boiledspaghetti = 1,
		/datum/reagent/consumable/starfruit_juice = 4,
		/datum/reagent/consumable/nutriment/soup/teriyaki = 5,
	)
	result = /obj/item/food/starfruit_tofu_beef
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/starfruit_noodles
	name = "Starfruit Noodles"
	reqs = list(
		/obj/item/food/meatball = 2,
		/obj/item/food/meat/cutlet = 2,
		/obj/item/food/grown/starfruit = 1,
		/obj/item/food/spaghetti/pastatomato = 1,
	)
	result = /obj/item/food/starfruit_noodles
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/starfruit_cake
	name = "Starfruit Cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/starfruit = 5
	)
	result = /obj/item/food/cake/starfruit
	category = CAT_CAKE

/datum/crafting_recipe/bottled/starfruit_jelly
	name = "Starfruit Jelly"
	reqs = list(
		/obj/item/food/grown/starfruit = 10,
		/datum/reagent/water = 25,
	)
	result = /obj/item/reagent_containers/condiment/starfruit_jelly
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/macaron/starfruit
	name = "Starfruit Macaron"
	reqs = list(
		/datum/reagent/consumable/eggwhite = 2,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/flour = 5,
		/datum/reagent/consumable/starfruit_jelly = 5,
	)
	result = /obj/item/food/cookie/macaron/starfruit
	category = CAT_PASTRY

/datum/crafting_recipe/food/starfruit_cobbler
	name = "Starfruit Cobbler"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/grown/starfruit = 2,
		/datum/reagent/consumable/starfruit_jelly = 10,
	)
	result = /obj/item/food/pie/starfruit_cobbler
	category = CAT_PASTRY

/datum/crafting_recipe/food/starfruit_toast
	name = "Starfruit Jelly Toast"
	reqs = list(
		/obj/item/food/breadslice/plain = 1,
		/datum/reagent/consumable/starfruit_jelly = 5,
	)
	result = /obj/item/food/starfruit_toast
	category = CAT_BREAD

/datum/crafting_recipe/food/starfruit_pie
	name = "Starfruit Pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/starfruit = 2,
	)
	result = /obj/item/food/pie/starfruit_pie
	category = CAT_PASTRY

/datum/crafting_recipe/food/starfruit_compote
	name = "Starfruit Compote"
	reqs = list(
		/obj/item/food/grown/starfruit = 5,
		/datum/reagent/consumable/sugar = 10,
		/datum/reagent/consumable/ethanol/cognac = 10,
	)
	result = /obj/item/food/starfruit_compote
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/starfruit_brulee
	name = "Starfruit Creme Brulee"
	reqs = list(
		/datum/reagent/consumable/starfruit_juice = 10,
		/datum/reagent/consumable/sugar = 10,
		/datum/reagent/consumable/salt = 5,
		/datum/reagent/consumable/eggyolk = 2,
		/datum/reagent/consumable/eggwhite = 4,
	)
	result = /obj/item/food/starfruit_brulee
	category = CAT_MISCFOOD

/datum/crafting_recipe/food/starfruit_cupcake
	name = "Starfruit Cupcake"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/starfruit = 2
	)
	result = /obj/item/food/starfruit_cupcake
	category = CAT_PASTRY
