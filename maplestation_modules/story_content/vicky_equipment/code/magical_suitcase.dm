// Magical suitcase
// A magical suitcase that floats and has a lot of storage. Planned to deploy a small shop, similar to the chef cart.
// TODO: Add cool magical particle effects and sounds!


/obj/machinery/magic_suitcase
	name = "magical suitcase"
	desc = "A large, magical suitcase that deploys an entire alchemist cooking space."
	icon = 'maplestation_modules/story_content/vicky_equipment/icons/vickyitems.dmi'
	icon_state = "suitcase"
	density = TRUE
	anchored = FALSE
	use_power = NO_POWER_USE
	obj_flags = parent_type::obj_flags | NO_DEBRIS_AFTER_DECONSTRUCTION
	var/unpacked = FALSE
	var/obj/machinery/space_heater/improvised_chem_heater/suitcase_heater
	var/obj/structure/chem_separator/suitcase_chem_separator
	var/obj/structure/table/reinforced/suitcase_table
	var/obj/obj/effect/food_cart_stand/vicky/suitcase_tent
	var/list/packed_things



/obj/machinery/magic_suitcase/Initialize(mapload)
	. = ..()
	suitcase_heater = new(src)
	suitcase_chem_separator = new(src)
	suitcase_table = new(src)
	suitcase_tent = new(src)
	packed_things = list(suitcase_table, suitcase_chem_separator, suitcase_tent, suitcase_heater) //middle, left, left, right
	RegisterSignal(suitcase_heater, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(suitcase_chem_separator, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(suitcase_table, COMSIG_QDELETING, PROC_REF(lost_part))
	RegisterSignal(suitcase_tent, COMSIG_QDELETING, PROC_REF(lost_part))

/obj/machinery/magic_suitcase/Destroy()
	if(suitcase_heater)
		QDEL_NULL(suitcase_heater)
	if(suitcase_chem_separator)
		QDEL_NULL(suitcase_chem_separator)
	if(suitcase_table)
		QDEL_NULL(suitcase_table)
	if(suitcase_tent)
		QDEL_NULL(suitcase_tent)
	packed_things.Cut()
	return ..()

/obj/machinery/magic_suitcase/proc/pack_up()
	if(!unpacked)
		return
	visible_message(span_notice("All the equipment dissapears in a puff of smoke into [src]."))
	for(var/o in packed_things)
		var/obj/object = o
		UnregisterSignal(object, COMSIG_MOVABLE_MOVED)
		object.forceMove(src)
	set_anchored(FALSE)
	unpacked = FALSE

/obj/machinery/magic_suitcase/proc/unpack(mob/user)
	if(unpacked)
		return
	if(!check_setup_place())
		to_chat(user, span_warning("There isn't enough room to unpack here! Bad spaces were marked in red."))
		return
	visible_message(span_notice("[src] expands into a full alchemy setup."))
	set_anchored(TRUE)
	var/iteration = 1
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		var/obj/thing = packed_things[iteration]
		thing.forceMove(T)
		RegisterSignal(thing, COMSIG_MOVABLE_MOVED, PROC_REF(lost_part))
		iteration++
	unpacked = TRUE

/obj/machinery/magic_suitcase/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(machine_stat & BROKEN)
		to_chat(user, span_warning("[src] is completely busted."))
		return
	var/obj/item/card/id/id_card = user.get_idcard(hand_first = TRUE)
	to_chat(user, span_notice("You attempt to [unpacked ? "pack up" :"unpack"] [src]..."))
	if(!do_after(user, 5 SECONDS, src))
		to_chat(user, span_warning("Your [unpacked ? "" :"un"]packing of [src] was interrupted!"))
		return
	if(unpacked)
		pack_up()
	else
		unpack(user)

/obj/machinery/magic_suitcase/proc/check_setup_place()
	var/has_space = TRUE
	var/turf/grabbed_turf = get_step(get_turf(src), EAST)
	for(var/angle in list(0, -45, 45))
		var/turf/T = get_step(grabbed_turf, turn(SOUTH, angle))
		if(T && !T.density)
			new /obj/effect/temp_visual/cart_space(T)
		else
			has_space = FALSE
			new /obj/effect/temp_visual/cart_space/bad(T)
	return has_space

/obj/machinery/magic_suitcase/proc/lost_part(atom/movable/source, force)
	SIGNAL_HANDLER

	UnregisterSignal(suitcase_heater, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(suitcase_chem_separator, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(suitcase_table, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	UnregisterSignal(suitcase_tent, list(COMSIG_QDELETING, COMSIG_MOVABLE_MOVED))
	atom_break()

/obj/machinery/magic_suitcase/atom_break(damage_flag)
	. = ..()
	pack_up()
	if(!QDELETED(suitcase_heater))
		QDEL_NULL(suitcase_heater)
	if(!QDELETED(suitcase_chem_separator))
		QDEL_NULL(suitcase_chem_separator)
	if(!QDELETED(suitcase_table))
		QDEL_NULL(suitcase_table)
	if(!QDELETED(suitcase_tent))
		QDEL_NULL(suitcase_tent)

/obj/machinery/magic_suitcase/examine(mob/user)
	. = ..()
	if(!(machine_stat & BROKEN))
		. += span_notice("The suitcase's ingredient heater is intact.")
		. += span_notice("The stand's chem separator seems fine.") //didnt test to see if the chem separator can break, hah! Same with the heater.
		. += span_notice("The stand's <b>table</b> seems fine.")

/obj/effect/food_cart_stand/vicky
	name = "Alchemy tent"
	desc = "A green and purple tent above an alchemy setup! The fabric has a slight sheen to it."
	icon = 'maplestation_modules/story_content/vicky_equipment/icons/tent.dmi'
