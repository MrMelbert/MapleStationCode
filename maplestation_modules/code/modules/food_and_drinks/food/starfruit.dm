/obj/item/food/starfruit_ribs
	name = "starfruit glazed ribs"
	desc = "Tender BBQ ribs, glazed with a sweet Starfruit sauce. Garinished with a caramelized starfruit on the side. The sweetest least vegan thing this side of the galaxy."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "glazedchops"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/bbqsauce = 5,
		/datum/reagent/consumable/starfruit_juice = 5,
	)
	tastes = list("tender meat" = 2, "sweet sauce" = 1, "sugary glaze" = 1)
	foodtypes = MEAT
	crafting_complexity = FOOD_COMPLEXITY_4

/obj/item/food/meat_platter
	name = "BBQ Meat Platter"
	desc = "An elaborate BBQ platter adorned with several BBQ favorites on this side of the galaxy. Garnished with some roasted pepper."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "meatdisc"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 30,
		/datum/reagent/consumable/nutriment/vitamin = 10,
		/datum/reagent/consumable/bbqsauce = 10,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("tender meat" = 2, "sweet sauce" = 1, "smokey BBQ" = 1, "sugary glaze" = 1)
	foodtypes = MEAT
	crafting_complexity = FOOD_COMPLEXITY_5

/obj/item/food/starfruit_chicken_alfredo
	name = "Starfruit Chicken Alfredo"
	desc = "A chicken alfredo dish with a starfruit cream sauce. Not for the faint of heart."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "alfredo"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment/protein = 15,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("sweet chicken" = 2, "creamy sauce" = 1, "cursed knowledge" = 1, "tasty noodles" = 1)
	foodtypes = MEAT | GRAIN
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_sushi_roll
	name = "starfruit sushi roll"
	desc = "A roll of simple sushi with delicious starfruit sashimi. Sliceable into pieces!"
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "sashimiroll"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	tastes = list("boiled rice" = 2, "starfruit" = 2, "fish" = 2)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_sushi_roll/make_processable()
	AddElement(/datum/element/processable, TOOL_KNIFE, /obj/item/food/starfruit_sushi_slice, 4, screentip_verb = "Chop")

/obj/item/food/starfruit_sushi_slice
	name = "starfruit sushi slice"
	desc = "A slice of starfruit sushi with rice, fish, and cradled in a seaweed sheath."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "sashimirollslice"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 1,
	)
	tastes = list("boiled rice" = 2, "starfruit" = 2, "fish" = 2)
	foodtypes = SEAFOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_sashimi
	name = "starfruit sashimi"
	desc = "Delicately sliced sashimi marinated with a starfruit reduced soy sauce."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "sashimi"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 5,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("raw fish" = 2, "sweet fish" = 1, "soy sauce" = 1)
	foodtypes = SEAFOOD
	crafting_complexity = FOOD_COMPLEXITY_2

/obj/item/food/eggplant_fry
	name = "starfruit eggplant stir fry"
	desc = "Eggplant stir fry with a reduced starfruit sauce, carrot, peppers, and cabbage. The starfruit has absolutely covered the dish."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "eggplantfry"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("eggplant" = 2, "simmered starfruit" = 1, "sautaed vegetables" = 1)
	foodtypes = VEGETABLES
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_tofu_beef
	name = "starfruit eggplant stir fry"
	desc = "Eggplant stir fry with a reduced starfruit sauce, carrot, peppers, and cabbage. The starfruit has absolutely covered the dish."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "tofubeef"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("eggplant" = 2, "simmered starfruit" = 1, "sautaed vegetables" = 1)
	foodtypes = VEGETABLES | MEAT | GRAIN
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_noodles
	name = "starfruit noddles"
	desc = "Savory boiled pasta with a rich and creamy reduced starfruit meat sauce."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starfruitplate"
	w_class = WEIGHT_CLASS_NORMAL
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 10,
		/datum/reagent/consumable/nutriment/vitamin = 5,
		/datum/reagent/consumable/starfruit_juice = 10,
	)
	tastes = list("eggplant" = 2, "simmered starfruit" = 1, "sautaed vegetables" = 1)
	foodtypes = GRAIN | MEAT
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/cake/starfruit
	name = "starfruit cake"
	desc = "An elaborately decorated cake with a starfruit filling. Pairs well with a starlit latte."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starcake"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 20,
		/datum/reagent/consumable/nutriment/vitamin = 10,
	)
	tastes = list("cake" = 3, "sweetness" = 2, "unbearable longing" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	slice_type = /obj/item/food/cakeslice/starfruit
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/cakeslice/starfruit
	name = "starfruit cake slice"
	desc = "A slice of starfruit cake, you got a slice with extra frosting! Lucky you!"
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starcake_slice"
	tastes = list("cake" = 3, "astral sweetness" = 2, "unbearable longing" = 2)
	foodtypes = GRAIN | DAIRY | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/reagent_containers/condiment/starfruit_jelly
	name = "starfruit jelly"
	desc = "A jar of super-sweet starfruit jelly."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "spacejam"
	list_reagents = list(/datum/reagent/consumable/starfruit_jelly = 50)
	fill_icon_thresholds = null

/obj/item/food/cookie/macaron/starfruit
	name = "starfruit macaron"
	desc = "A sandwich-like confectionary with a soft cookie shell and a creamy starfruit jelly meringue center."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "macaron_4"
	tastes = list("wafer" = 2, "sweet starfruit" = 2, "creamy meringue" = 3)
	randomize_icon_state = FALSE

/obj/item/food/pie/starfruit_cobbler
	name = "starfruit cobbler"
	desc = "A tasty cobbler packed with sweet starfruit in a buttery pastry crust. Topped with a small amount of sweet cream."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "cobbler"
	bite_consumption = 3
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 3,
		/datum/reagent/consumable/nutriment/vitamin = 5,
	)
	tastes = list("pie" = 1, "sugar" = 2, "starfruit" = 1, "cosmic longing" = 1)
	foodtypes = GRAIN | FRUIT

/obj/item/food/starfruit_toast
	name = "starfruit jellied toast"
	desc = "A slice of toast covered with delicious starfruit jam."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "spacejamtoast"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 8,
		/datum/reagent/consumable/nutriment/vitamin = 4,
	)
	bite_consumption = 3
	tastes = list("toast" = 1, "jelly" = 1, "starfruit jelly" = 1)
	foodtypes = GRAIN | BREAKFAST
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pie/starfruit_pie
	name = "starfruit pie"
	desc = "Deceptively simple, yet flavor intensive."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starfruitpie"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 14,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("starfruit" = 1, "pie" = 1, "cosmic longing" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	slice_type = /obj/item/food/pieslice/starfruit_pie
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/pieslice/starfruit_pie
	name = "starfruit pie slice"
	desc = "Takes you on a journey though space!"
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "starfruitpie_slice"
	tastes = list("pie" = 1, "starfruit" = 1, "cosmic longing" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_compote
	name = "starfruit compote"
	desc = "An irresistibly sweet dish of starfruit boiled down in cognac and sugar."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "compote"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 12,
		/datum/reagent/consumable/nutriment/vitamin = 6,
	)
	tastes = list("starfruit" = 1, "sweet sugar" = 1, "cognac spice" = 1)
	bite_consumption = 3
	foodtypes = FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_brulee
	name = "starfruit creme brulee"
	desc = "A delightful pudding dish made from primarily caramel and egg whites."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "cremebrulee"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("starfruit" = 1, "caramel" = 1, "subtle cream" = 1)
	foodtypes = FRUIT | SUGAR
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3

/obj/item/food/starfruit_cupcake
	name = "starfruit cupcake"
	desc = "A sweet cupcake with a starfruit frosting."
	icon = 'maplestation_modules/icons/obj/food/starfruit.dmi'
	icon_state = "cupcakestar"
	food_reagents = list(
		/datum/reagent/consumable/nutriment = 6,
		/datum/reagent/consumable/nutriment/vitamin = 2,
	)
	tastes = list("cake" = 3, "starfruit" = 1)
	foodtypes = GRAIN | FRUIT | SUGAR
	food_flags = FOOD_FINGER_FOOD
	w_class = WEIGHT_CLASS_SMALL
	crafting_complexity = FOOD_COMPLEXITY_3
