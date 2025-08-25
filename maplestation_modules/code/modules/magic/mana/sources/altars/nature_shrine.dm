// nature shrine, consumes flowers to generate mana.
// this lists of flowers based on the amount of mana generated

/datum/mana_pool/magic_altar/nature
	maximum_mana_capacity = 750
	softcap = 500
	amount = 0
	max_donation_rate_per_second = 2

/obj/structure/magic_altar/nature
	name = "The Stump Which Watches"
	desc = "A peculiar stump. It feels like the hole in the center is looking at you. It appears you can cover its gaze with some flowers, though."
	icon_state = "magicstump_base"

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

/obj/structure/magic_altar/nature/item_interaction( mob/living/user, obj/item/sacrifice, list/modifiers)
	..()
	if (is_type_in_typecache(sacrifice, nature_shrine_mana_high)) // todo: add feedback to the player for this
		mana_pool.amount += nature_shrine_mana_high_count
		QDEL_NULL(sacrifice)
		return
	if (is_type_in_typecache(sacrifice, nature_shrine_mana_med))
		mana_pool.amount += nature_shrine_mana_med_count
		QDEL_NULL(sacrifice)
		return
	if (is_type_in_typecache(sacrifice, nature_shrine_mana_low))
		mana_pool.amount += nature_shrine_mana_low_count
		QDEL_NULL(sacrifice)
		return
