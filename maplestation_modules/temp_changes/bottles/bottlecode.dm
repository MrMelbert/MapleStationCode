/// Fixes the weird fill icons bottles have at the moment by just overriding them.

/obj/item/reagent_containers/cup/glass/bottle
	var/maple_icon = 'maplestation_modules/temp_changes/bottles/bottle.dmi'

/obj/item/reagent_containers/cup/glass/bottle/Initialize(mapload, vol)
	. = ..()
	if(src.type == /obj/item/reagent_containers/cup/glass/bottle || src.type == /obj/item/reagent_containers/cup/glass/bottle/small)
		icon = maple_icon
		fill_icon = maple_icon
