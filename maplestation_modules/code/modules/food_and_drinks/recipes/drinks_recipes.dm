//Recipes for modular drinks.

/datum/chemical_reaction/drink/tea // This tea recipe is replaced with /datum/chemical_reaction/drink/green_tea.
	required_reagents = list()

/datum/chemical_reaction/drink/ice_greentea
	results = list(/datum/reagent/consumable/ice_greentea = 4)
	required_reagents = list(/datum/reagent/consumable/ice = 1, /datum/reagent/consumable/green_tea = 3)

/datum/chemical_reaction/drink/icetea
	results = list(/datum/reagent/consumable/icetea = 4)
	required_reagents = list(/datum/reagent/consumable/ice = 1, /datum/reagent/consumable/tea = 3)

/datum/chemical_reaction/drink/green_hill_tea
	results = list(/datum/reagent/consumable/green_hill_tea = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/sugar_rush = 1, /datum/reagent/consumable/ice_greentea = 1) //despite containing alcohol, the resulting beverage is non-alcoholic

/datum/chemical_reaction/drink/green_tea
	results = list(/datum/reagent/consumable/green_tea = 5)
	required_reagents = list(/datum/reagent/toxin/teapowder = 1, /datum/reagent/water = 5) //tea powder is obtained from tea plants.

/datum/chemical_reaction/drink/pilk
	results = list(/datum/reagent/consumable/pilk = 2)
	required_reagents = list(/datum/reagent/consumable/milk = 1, /datum/reagent/consumable/space_cola = 1)

/datum/chemical_reaction/drink/pilk/peg_nog
	results = list(/datum/reagent/consumable/ethanol/peg_nog = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/eggnog = 1, /datum/reagent/consumable/space_cola = 1)
