/**Basic plumbing object.
* It doesn't really hold anything special, YET.
* Objects that are plumbing but not a subtype are as of writing liquid pumps and the reagent_dispenser tank
* Also please note that the plumbing component is toggled on and off by the component using a signal from default_unfasten_wrench, so dont worry about it
*/
/obj/machinery/plumbing
	name = "pipe thing"
	icon = 'icons/obj/pipes_n_cables/hydrochem/plumbers.dmi'
	icon_state = "pump"
	density = TRUE
	processing_flags = START_PROCESSING_MANUALLY
	active_power_usage = BASE_MACHINE_ACTIVE_CONSUMPTION * 2.75
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	interaction_flags_machine = parent_type::interaction_flags_machine | INTERACT_MACHINE_OFFLINE

	///Plumbing machinery is always gonna need reagents, so we might aswell put it here
	var/buffer = 50
	///Flags for reagents, like INJECTABLE, TRANSPARENT bla bla everything thats in DEFINES/reagents.dm
	var/reagent_flags = TRANSPARENT

/obj/machinery/plumbing/Initialize(mapload, bolt = TRUE)
	. = ..()
	set_anchored(bolt)
	create_reagents(buffer, reagent_flags)
	AddComponent(/datum/component/simple_rotation)
	register_context()

/obj/machinery/plumbing/add_context(atom/source, list/context, obj/item/held_item, mob/user)
	. = NONE
	if(isnull(held_item))
		return

	if(held_item.tool_behaviour == TOOL_WRENCH)
		context[SCREENTIP_CONTEXT_LMB] = "[anchored ? "Un" : ""]Anchor"
		return CONTEXTUAL_SCREENTIP_SET
	else if(held_item.tool_behaviour == TOOL_WELDER && !anchored)
		context[SCREENTIP_CONTEXT_LMB] = "Deconstruct"
		return CONTEXTUAL_SCREENTIP_SET
	else if(istype(held_item, /obj/item/plunger))
		context[SCREENTIP_CONTEXT_LMB] = "Flush"
		return CONTEXTUAL_SCREENTIP_SET

/obj/machinery/plumbing/examine(mob/user)
	. = ..()
	if(isobserver(user) || !in_range(src, user))
		return

	. += span_notice("The maximum volume display reads: <b>[reagents.maximum_volume]u capacity</b>. Contains:")
	if(reagents.total_volume)
		for(var/datum/reagent/reg as anything in reagents.reagent_list)
			. += span_notice("[round(reg.volume, CHEMICAL_VOLUME_ROUNDING)]u of [reg.name]")
	else
		. += span_notice("Nothing.")

	if(anchored)
		. += span_notice("It's [EXAMINE_HINT("anchored")] in place.")
	else
		. += span_warning("Needs to be [EXAMINE_HINT("anchored")] to start operations.")
		. += span_notice("It can be [EXAMINE_HINT("welded")] apart.")

	. += span_notice("An [EXAMINE_HINT("plunger")] can be used to flush out reagents.")


/obj/machinery/plumbing/wrench_act(mob/living/user, obj/item/tool)
	if(user.combat_mode)
		return NONE

	. = ITEM_INTERACT_BLOCKING
	if(default_unfasten_wrench(user, tool) == SUCCESSFUL_UNFASTEN)
		if(anchored)
			begin_processing()
		else
			end_processing()
		return ITEM_INTERACT_SUCCESS

/obj/machinery/plumbing/welder_act(mob/living/user, obj/item/I)
	if(user.combat_mode)
		return NONE

	if(anchored)
		balloon_alert(user, "unanchor first!")
		return ITEM_INTERACT_BLOCKING

	if(I.tool_start_check(user, amount = 1))
		to_chat(user, span_notice("You start slicing the [name] apart."))
		if(I.use_tool(src, user, 1.5 SECONDS, volume = 50))
			deconstruct(TRUE)
			to_chat(user, span_notice("You slice the [name] apart."))
			return ITEM_INTERACT_SUCCESS

	return ITEM_INTERACT_BLOCKING

/obj/machinery/plumbing/plunger_act(obj/item/plunger/P, mob/living/user, reinforced)
	user.balloon_alert_to_viewers("furiously plunging...")
	if(do_after(user, 3 SECONDS, target = src))
		user.balloon_alert_to_viewers("finished plunging")
		reagents.expose(get_turf(src), TOUCH) //splash on the floor
		reagents.clear_reagents()

///We can empty beakers in here and everything
/obj/machinery/plumbing/input
	name = "input gate"
	desc = "Can be manually filled with reagents from containers."
	icon_state = "pipe_input"
	pass_flags_self = PASSMACHINE | LETPASSTHROW // Small
	reagent_flags = TRANSPARENT | REFILLABLE


/obj/machinery/plumbing/input/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_supply, bolt, layer)

///We can fill beakers in here and everything. we dont inheret from input because it has nothing that we need
/obj/machinery/plumbing/output
	name = "output gate"
	desc = "A manual output for plumbing systems, for taking reagents directly into containers."
	icon_state = "pipe_output"
	pass_flags_self = PASSMACHINE | LETPASSTHROW // Small
	reagent_flags = TRANSPARENT | DRAINABLE

/obj/machinery/plumbing/output/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/simple_demand, bolt, layer)

/obj/machinery/plumbing/output/tap
	name = "drinking tap"
	desc = "A manual output for plumbing systems, for taking drinks directly into glasses."
	icon_state = "tap_output"

/obj/machinery/plumbing/tank
	name = "chemical tank"
	desc = "A massive chemical holding tank."
	icon_state = "tank"
	buffer = 400

/obj/machinery/plumbing/tank/Initialize(mapload, bolt, layer)
	. = ..()
	AddComponent(/datum/component/plumbing/tank, bolt, layer)

///Layer manifold machine that connects a bunch of layers
/obj/machinery/plumbing/layer_manifold
	name = "layer manifold"
	desc = "A plumbing manifold for layers."
	icon_state = "manifold"
	density = FALSE

/obj/machinery/plumbing/layer_manifold/Initialize(mapload, bolt, layer)
	. = ..()

	AddComponent(/datum/component/plumbing/manifold, bolt, FIRST_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, bolt, SECOND_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, bolt, THIRD_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, bolt, FOURTH_DUCT_LAYER)
	AddComponent(/datum/component/plumbing/manifold, bolt, FIFTH_DUCT_LAYER)
