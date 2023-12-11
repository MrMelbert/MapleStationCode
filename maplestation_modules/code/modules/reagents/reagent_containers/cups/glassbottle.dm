#define BOTTLE_KNOCKDOWN_DEFAULT_DURATION (1.3 SECONDS)

/obj/item/reagent_containers/cup/glass/bottle/blood_wine
	name = "bottle of lizard wine"
	desc = "A wine made from fermented blood originating from Tizira. Despite the name, the drink does not taste of blood."
	icon = 'maplestation_modules/icons/obj/bottles.dmi'
	icon_state = "bloodwinebottle"
	list_reagents = list(/datum/reagent/consumable/ethanol/blood_wine = 100)
	drink_type = ALCOHOL

#undef BOTTLE_KNOCKDOWN_DEFAULT_DURATION
