// Starfruit
/obj/item/seeds/starfruit
	name = "starfruit seed pack"
	desc = "These seeds grow into starfruit plants, which bear a sugary and delicious fruit."
	icon = 'maplestation_modules/icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed-starfruit"
	species = "starfruit"
	plantname = "Starfruit Plants"
	product = /obj/item/food/grown/starfruit
	lifespan = 50
	endurance = 15
	growthstages = 4
	growing_icon = 'maplestation_modules/icons/obj/hydroponics/growing.dmi'
	icon_grow = "starfruit-grow"
	icon_dead = "starfruit-dead"
	icon_harvest = "starfruit-harvest"
	genes = list(/datum/plant_gene/trait/glow/yellow, /datum/plant_gene/trait/repeated_harvest)
	reagents_add = list(
		/datum/reagent/consumable/starfruit_juice = 0.3,
		/datum/reagent/consumable/nutriment = 0.1,
	)

/obj/item/food/grown/starfruit
	seed = /obj/item/seeds/starfruit
	name = "starfruit"
	desc = "The Murian Starfruit is an omnipresent sight throughout the Aristocracy of Mu, \
		having major cultural and historical significance following it's heroic deed in saving the initial colonists of what would later become House Gilidan \
		from widespread local crop failure, and allowing them to live off the land for those crucial few autumnal and winter months."
	icon = 'maplestation_modules/icons/obj/hydroponics/harvest.dmi'
	icon_state = "starfruit"
	bite_consumption_mod = 2
	foodtypes = FRUIT | SUGAR
	juice_typepath = /datum/reagent/consumable/starfruit_juice
