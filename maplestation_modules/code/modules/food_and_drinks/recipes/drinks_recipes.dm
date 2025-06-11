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

/datum/chemical_reaction/drink/justicars_juice
	results = list(/datum/reagent/consumable/ethanol/justicars_juice = 4)
	required_reagents = list(/datum/reagent/consumable/lemonjuice = 1, /datum/reagent/consumable/ethanol/cognac = 1, /datum/reagent/iron = 1, /datum/reagent/consumable/ethanol/tequila_sunrise = 1)

/datum/chemical_reaction/drink/samogon_sonata
	results = list(/datum/reagent/consumable/ethanol/samogon_sonata = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/consumable/ethanol/black_russian = 1, /datum/reagent/consumable/ethanol/hooch = 1)

/datum/chemical_reaction/drink/pile_driver
	results = list(/datum/reagent/consumable/ethanol/piledriver = 2)
	required_reagents = list(/datum/reagent/consumable/ethanol/rum_coke = 1, /datum/reagent/consumable/ethanol/screwdrivercocktail = 1)

// block of starfruit
/datum/chemical_reaction/drink/starfruit_soda
	results = list(/datum/reagent/consumable/ethanol/starfruit_soda = 5)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 2, /datum/reagent/consumable/ethanol/rum = 2, /datum/reagent/consumable/ethanol/cognac = 1, /datum/reagent/consumable/sodawater = 1)
	mix_message = "The ingredients combine into fizzy soda."

/datum/chemical_reaction/drink/starfruit_lubricant
	results = list(/datum/reagent/consumable/ethanol/starfruit_lubricant = 2)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 1, /datum/reagent/fuel/oil = 1)
	mix_message = "The ingredients combine into an oily soda."

/datum/chemical_reaction/drink/starfruit_latte
	results = list(/datum/reagent/consumable/starfruit_latte = 2)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 1, /datum/reagent/consumable/coffee = 1)

/datum/chemical_reaction/drink/starbeam_shake
	results = list(/datum/reagent/consumable/starbeam_shake = 3)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 1, /datum/reagent/consumable/vanilla_dream = 1, /datum/reagent/consumable/ice = 1)

/datum/chemical_reaction/drink/forgotten_star
	results = list(/datum/reagent/consumable/ethanol/forgotten_star = 5)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 1, /datum/reagent/consumable/pineapplejuice = 1, /datum/reagent/consumable/ethanol/white_russian = 1, /datum/reagent/consumable/ethanol/creme_de_coconut = 1, /datum/reagent/consumable/ethanol/bitters = 1)
	mix_message = "The ingredients combine into a shooting star."

/datum/chemical_reaction/drink/astral_flame
	results = list(/datum/reagent/consumable/ethanol/astral_flame = 6)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 1, /datum/reagent/consumable/ethanol/navy_rum = 1, /datum/reagent/consumable/menthol = 1, /datum/reagent/consumable/limejuice = 1, /datum/reagent/consumable/sodawater = 1)
	mix_message = "The ingredients morph with an enticing smell."

/datum/chemical_reaction/drink/space_muse
	results = list(/datum/reagent/consumable/ethanol/space_muse = 3)
	required_reagents = list(/datum/reagent/consumable/starfruit_juice = 1, /datum/reagent/consumable/ethanol/creme_de_menthe = 1, /datum/reagent/consumable/ethanol/vodka = 1)
	mix_message = "The mixture gives a soft crackling snap."
