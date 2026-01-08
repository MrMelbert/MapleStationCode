// nature shrine, consumes flowers to generate mana.
// this lists of flowers based on the amount of mana generated

/datum/mana_pool/magic_altar/nature
	maximum_mana_capacity = 750
	softcap = 500
	amount = 0
	max_donation_rate_per_second = 4

/obj/structure/magic_altar/nature
	name = "The Stump Which Watches"
	desc = "A peculiar stump. It feels like the hole in the center is looking at you. It appears you can cover its gaze with some flowers, though."
	icon_state = "magicstump_base"
	var/drop_amount = 3

	var/static/list/nature_shrine_mana_low = typecacheof(list(
		/obj/item/food/grown/poppy,
		/obj/item/food/grown/sunflower
	))
	var/nature_shrine_mana_low_count = 10
	var/static/list/nature_shrine_mana_med = typecacheof(list(
		/obj/item/food/grown/poppy/lily,
		/obj/item/food/grown/poppy/geranium,
		/obj/item/food/grown/moonflower,
	))
	var/nature_shrine_mana_med_count = 20
	var/static/list/nature_shrine_mana_high = typecacheof(list(
	/obj/item/food/grown/poppy/geranium/fraxinella,
	/obj/item/food/grown/trumpet,
	/obj/item/grown/novaflower,
	))
	var/nature_shrine_mana_high_count = 30

/obj/structure/magic_altar/nature/get_initial_mana_pool_type()
	return /datum/mana_pool/magic_altar/nature

/obj/structure/magic_altar/nature/Initialize(mapload)
	. = ..()

	var/static/list/tool_behaviors
	if(!tool_behaviors)
		tool_behaviors = string_assoc_nested_list(list(
			TOOL_CROWBAR = list(
				SCREENTIP_CONTEXT_RMB = "Deconstruct",
			),

			TOOL_WRENCH = list(
				SCREENTIP_CONTEXT_RMB = "Anchor/Unanchor",
			),
		))
	AddElement(/datum/element/contextual_screentip_tools, tool_behaviors)

/obj/structure/magic_altar/nature/item_interaction(mob/living/user, obj/item/sacrifice, list/modifiers)
	..()
	if (is_type_in_typecache(sacrifice, nature_shrine_mana_high)) // todo: add feedback to the player for this
		accept_sacrifice(sacrifice, nature_shrine_mana_high)
		return
	if (is_type_in_typecache(sacrifice, nature_shrine_mana_med))
		accept_sacrifice(sacrifice, nature_shrine_mana_med)
		return
	if (is_type_in_typecache(sacrifice, nature_shrine_mana_low))
		accept_sacrifice(sacrifice, nature_shrine_mana_low)
		return

/obj/structure/magic_altar/nature/proc/accept_sacrifice(obj/item/sacrifice, mana_value)
	QDEL_NULL(sacrifice)
	mana_pool.amount += mana_value

/obj/structure/magic_altar/nature/crowbar_act(mob/living/user, obj/item/tool)
	balloon_alert(user, "deconstructing stump...")
	if(!tool.use_tool(src, user, 5 SECONDS, volume=50))
		return
	balloon_alert(user, "stump deconstructed")
	tool.play_tool_sound(src)
	new /obj/item/stack/sheet/mineral/wood(get_turf(src), drop_amount)
	new /obj/item/mana_battery/mana_crystal/standard(get_turf(src), 1)
	qdel(src)
	return ITEM_INTERACT_SUCCESS

/obj/structure/magic_altar/nature/wrench_act(mob/living/user, obj/item/tool)
	. = ..()
	switch(default_unfasten_wrench(user, tool, 4 SECONDS))
		if(SUCCESSFUL_UNFASTEN)
			return ITEM_INTERACT_SUCCESS
		if(FAILED_UNFASTEN)
			return ITEM_INTERACT_BLOCKING
	return .
