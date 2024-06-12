//I JUST WANNA GRILL FOR GOD'S SAKE

#define GRILL_FUELUSAGE_IDLE 0.5
#define GRILL_FUELUSAGE_ACTIVE 5

/obj/machinery/grill
	name = "grill"
	desc = "Just like the old days."
	icon = 'icons/obj/machines/kitchen.dmi'
	icon_state = "grill_open"
	density = TRUE
	pass_flags_self = PASSMACHINE | LETPASSTHROW
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/grill_fuel = 0
	var/obj/item/food/grilled_item
	var/grill_time = 0
	var/datum/looping_sound/grill/grill_loop

/obj/machinery/grill/Initialize(mapload)
	. = ..()
	grill_loop = new(src, FALSE)

/obj/machinery/grill/Destroy()
	grilled_item = null
	QDEL_NULL(grill_loop)
	return ..()

/obj/machinery/grill/update_icon_state()
	if(grilled_item)
		icon_state = "grill"
		return ..()
	if(grill_fuel > 0)
		icon_state = "grill_on"
		return ..()
	icon_state = "grill_open"
	return ..()

/obj/machinery/grill/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/stack/sheet/mineral/coal) || istype(I, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/S = I
		var/stackamount = S.get_amount()
		to_chat(user, span_notice("You put [stackamount] [I]s in [src]."))
		if(istype(I, /obj/item/stack/sheet/mineral/coal))
			grill_fuel += (500 * stackamount)
		else
			grill_fuel += (50 * stackamount)
		S.use(stackamount)
		update_appearance()
		return
	if(I.resistance_flags & INDESTRUCTIBLE)
		to_chat(user, span_warning("You don't feel it would be wise to grill [I]..."))
		return ..()
	if(istype(I, /obj/item/reagent_containers/cup/glass))
		if(I.reagents.has_reagent(/datum/reagent/consumable/monkey_energy))
			grill_fuel += (20 * (I.reagents.get_reagent_amount(/datum/reagent/consumable/monkey_energy)))
			to_chat(user, span_notice("You pour the Monkey Energy in [src]."))
			I.reagents.remove_reagent(/datum/reagent/consumable/monkey_energy, I.reagents.get_reagent_amount(/datum/reagent/consumable/monkey_energy))
			update_appearance()
			return
	else if(IS_EDIBLE(I))
		if(HAS_TRAIT(I, TRAIT_NODROP) || (I.item_flags & (ABSTRACT | DROPDEL)))
			return ..()
		else if(HAS_TRAIT(I, TRAIT_FOOD_GRILLED))
			to_chat(user, span_notice("[I] has already been grilled!"))
			return
		else if(grill_fuel <= 0)
			to_chat(user, span_warning("There is not enough fuel!"))
			return
		else if(!grilled_item && user.transferItemToLoc(I, src))
			grilled_item = I
			RegisterSignal(grilled_item, COMSIG_ITEM_GRILLED, PROC_REF(GrillCompleted))
			to_chat(user, span_notice("You put the [grilled_item] on [src]."))
			update_appearance()
			grill_loop.start()
			return

	..()

/obj/machinery/grill/process(seconds_per_tick)
	..()
	update_appearance()
	if(grill_fuel <= 0)
		return
	else
		grill_fuel -= GRILL_FUELUSAGE_IDLE * seconds_per_tick
		if(SPT_PROB(0.5, seconds_per_tick))
			var/datum/effect_system/fluid_spread/smoke/bad/smoke = new
			smoke.set_up(1, holder = src, location = loc)
			smoke.start()
	if(grilled_item)
		SEND_SIGNAL(grilled_item, COMSIG_ITEM_GRILL_PROCESS, src, seconds_per_tick)
		grill_time += seconds_per_tick
		grilled_item.reagents.add_reagent(/datum/reagent/consumable/char, 0.5 * seconds_per_tick)
		grill_fuel -= GRILL_FUELUSAGE_ACTIVE * seconds_per_tick
		grilled_item.AddComponent(/datum/component/sizzle)

/obj/machinery/grill/Exited(atom/movable/gone, direction)
	. = ..()
	if(gone == grilled_item)
		finish_grill()
		grilled_item = null

/obj/machinery/grill/wrench_act(mob/living/user, obj/item/I)
	. = ..()
	if(default_unfasten_wrench(user, I) != CANT_UNFASTEN)
		return TRUE

/obj/machinery/grill/deconstruct(disassembled = TRUE)
	if(grilled_item)
		finish_grill()
	if(!(obj_flags & NO_DECONSTRUCTION))
		new /obj/item/stack/sheet/iron(loc, 5)
		new /obj/item/stack/rods(loc, 5)
	..()

/obj/machinery/grill/attack_ai(mob/user)
	return


/// Makes grill fuel from a unit of stack
/obj/machinery/grill/proc/burn_stack()
	PRIVATE_PROC(TRUE)

	//compute boost from wood or coal
	var/boost
	for(var/obj/item/stack in contents)
		boost = 5 * (GRILL_FUELUSAGE_IDLE + GRILL_FUELUSAGE_ACTIVE)
		if(istype(stack, /obj/item/stack/sheet/mineral/coal))
			boost *= 2
		if(stack.use(1))
			grill_fuel += boost
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/grill/item_interaction(mob/living/user, obj/item/weapon, list/modifiers)
	if(user.combat_mode || (weapon.item_flags & ABSTRACT) || (weapon.flags_1 & HOLOGRAM_1) || (weapon.resistance_flags & INDESTRUCTIBLE))
		return NONE

	if(istype(weapon, /obj/item/stack/sheet/mineral/coal) || istype(weapon, /obj/item/stack/sheet/mineral/wood))
		if(!QDELETED(grilled_item))
			return NONE
		if(!anchored)
			balloon_alert(user, "anchor it first!")
			return ITEM_INTERACT_BLOCKING

		//required for amount subtypes
		var/target_type
		if(istype(weapon, /obj/item/stack/sheet/mineral/coal))
			target_type = /obj/item/stack/sheet/mineral/coal
		else
			target_type = /obj/item/stack/sheet/mineral/wood

		//transfer or merge stacks if we have enough space
		var/merged = FALSE
		var/obj/item/stack/target = weapon
		for(var/obj/item/stack/stored in contents)
			if(!istype(stored, target_type))
				continue
			if(stored.amount == MAX_STACK_SIZE)
				balloon_alert(user, "no space!")
				return ITEM_INTERACT_BLOCKING
			target.merge(stored)
			merged = TRUE
			break
		if(!merged)
			weapon.forceMove(src)

		to_chat(user, span_notice("You add [src] to the fuel stack."))
		if(!grill_fuel)
			burn_stack()
			begin_processing()
		return ITEM_INTERACT_SUCCESS

	if(is_reagent_container(weapon) && weapon.is_open_container())
		var/obj/item/reagent_containers/container = weapon
		if(!QDELETED(grilled_item))
			return NONE
		if(!anchored)
			balloon_alert(user, "anchor it first!")
			return ITEM_INTERACT_BLOCKING

		var/transfered_amount = weapon.reagents.trans_to(src, container.amount_per_transfer_from_this)
		if(transfered_amount)
			//reagents & their effects on fuel
			var/static/list/fuel_map = list(
				/datum/reagent/consumable/monkey_energy = 4,
				/datum/reagent/fuel/oil = 3,
				/datum/reagent/fuel = 2,
				/datum/reagent/consumable/ethanol = 1
			)

			//compute extra fuel to be obtained from everything transfered
			var/boost
			var/additional_fuel = 0
			for(var/datum/reagent/stored as anything in reagents.reagent_list)
				boost = fuel_map[stored.type]
				if(!boost) //anything we don't recognize as fuel has inverse effects
					boost = -1
				boost = boost * stored.volume * (GRILL_FUELUSAGE_IDLE + GRILL_FUELUSAGE_ACTIVE)
				additional_fuel += boost

			//add to fuel source
			reagents.clear_reagents()
			grill_fuel += additional_fuel
			if(grill_fuel <= 0) //can happen if you put water or something
				grill_fuel = 0
			else
				begin_processing()
			update_appearance(UPDATE_ICON_STATE)

			//feedback
			to_chat(user, span_notice("You transfer [transfered_amount]u to the fuel source."))
			return ITEM_INTERACT_SUCCESS

		balloon_alert(user, "no fuel transfered!")
		return ITEM_INTERACT_BLOCKING

	if(IS_EDIBLE(weapon))
		//sanity checks
		if(!anchored)
			balloon_alert(user, "anchor first!")
			return ITEM_INTERACT_BLOCKING
		if(HAS_TRAIT(weapon, TRAIT_NODROP))
			return ..()
		if(!QDELETED(grilled_item))
			balloon_alert(user, "remove item first!")
			return ITEM_INTERACT_BLOCKING
		if(grill_fuel <= 0)
			balloon_alert(user, "no fuel!")
			return ITEM_INTERACT_BLOCKING
		if(!user.transferItemToLoc(weapon, src))
			balloon_alert(user, "[weapon] is stuck in your hand!")
			return ITEM_INTERACT_BLOCKING

		//add the item on the grill
		grill_time = 0
		grilled_item = weapon
		var/datum/component/sizzle/sizzle = grilled_item.GetComponent(/datum/component/sizzle)
		if(!isnull(sizzle))
			grill_time = sizzle.time_elapsed()
		to_chat(user, span_notice("You put the [grilled_item] on [src]."))
		update_appearance(UPDATE_ICON_STATE)
		grill_loop.start()
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/machinery/grill/proc/finish_grill()
	if(!QDELETED(grilled_item))
		if(grill_time >= 20)
			grilled_item.AddElement(/datum/element/grilled_item, grill_time)
		UnregisterSignal(grilled_item, COMSIG_ITEM_GRILLED)
	grill_time = 0
	grill_loop.stop()

///Called when a food is transformed by the grillable component
/obj/machinery/grill/proc/GrillCompleted(obj/item/source, atom/grilled_result)
	SIGNAL_HANDLER
	grilled_item = grilled_result //use the new item!!

/obj/machinery/grill/unwrenched
	anchored = FALSE

#undef GRILL_FUELUSAGE_IDLE
#undef GRILL_FUELUSAGE_ACTIVE
