// Magical suitcase
// A magical suitcase that floats and has a lot of storage. Planned to deploy a small shop, similar to the chef cart.
// TODO: Add cool magical particle effects and sounds!


/obj/machinery/food_cart/magic_suitcase
	name = "magical suitcase"
	desc = "A large, magical suitcase that deploys an entire alchemist cooking space."
	icon = 'maplestation_modules/story_content/vicky_equipment/icons/vickyitems.dmi'
	icon_state = "suitcase"
	req_access = null
	cart_griddle = /obj/machinery/space_heater/improvised_chem_heater
	cart_smartfridge = /obj/structure/chem_separator
	cart_table = /obj/structure/table/reinforced
	cart_tent = /obj/effect/food_cart_stand/vicky


/obj/machinery/food_cart/magic_suitcase/examine(mob/user)
	. = ..()
	if(!(machine_stat & BROKEN))
		. += span_notice("The suitcase's ingredient heater is intact.")
		. += span_notice("The stand's chem separator seems fine.") //didnt test to see if the chem separator can break, hah! Same with the heater.
		. += span_notice("The stand's <b>table</b> seems fine.")

/obj/effect/food_cart_stand/vicky
	name = "Alchemy tent"
	desc = "A green and purple tent above an alchemy setup! The fabric has a slight sheen to it."
	icon = 'maplestation_modules/story_content/vicky_equipment/icons/tent.dmi'
