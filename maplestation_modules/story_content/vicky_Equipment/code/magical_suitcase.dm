// Magical suitcase
// A magical suitcase that floats and has a lot of storage. Planned to deploy a small shop, similar to the chef cart.
//TODO: The whole thing lol


/obj/machinery/food_cart/magic_suitcase
	name = "magical suitcase"
	desc = "A large, magical suitcase that deploys an entire alchemist cooking space."
	icon = 'maplestation_modules/story_content/vicky_Equipment/icons/vickyitems.dmi'
	icon_state = "suitcase"
	req_access = null
	cart_griddle = /obj/machinery/space_heater/improvised_chem_heater
	cart_smartfridge = /obj/structure/chem_separator
	cart_table = /obj/structure/table/reinforced
	cart_tent = /obj/effect/food_cart_stand/vicky


/obj/machinery/food_cart/magic_suitcase/Initialize(mapload)
	. = ..()
	cart_griddle = new(src)
	cart_smartfridge = new(src)
	cart_table = new(src)
	cart_tent = new(src)
	packed_things = list(cart_table, cart_smartfridge, cart_tent, cart_griddle) //middle, left, left, right
	RegisterSignal(cart_griddle, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_smartfridge, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_table, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(cart_tent, COMSIG_QDELETING, PROC_REF(lost_part))


/obj/machinery/food_cart/magic_suitcase/examine(mob/user)
	. = ..()
	if(!(machine_stat & BROKEN))
		. += span_notice("The suitcase's ingredient heater is intact.")
		. += span_notice("The stand's chem separator seems fine.") //didnt test to see if the chem separator can break, hah! Same with the heater.
		. += span_notice("The stand's <b>table</b> seems fine.")

/obj/machinery/food_cart/magic_suitcase/pack_up()
	if(!unpacked)
		return
	visible_message(span_notice("[src] retracts all of it's unpacked components."))
	for(var/o in packed_things)
		var/obj/object = o
		UnregisterSignal(object, COMSIG_MOVABLE_MOVED)
		object.forceMove(src)
	set_anchored(FALSE)
	unpacked = FALSE

/obj/effect/food_cart_stand/vicky
	name = "Alchemy tent"
	desc = "A green and purple tent above an alchemy setup! The fabric has a slight sheen to it."
	icon = 'maplestation_modules/story_content/vicky_Equipment/icons/tent.dmi'
