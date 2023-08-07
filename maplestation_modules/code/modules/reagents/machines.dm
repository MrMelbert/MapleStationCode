/obj/machinery/chem_dispenser/drinks/Initialize(mapload)
	. = ..()
	upgrade_reagents |= list(
	/datum/reagent/consumable/green_tea
	)
